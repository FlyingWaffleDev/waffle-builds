#!/usr/bin/env python3
"""
Upstream version checker for Gentoo overlay ebuilds.
Scans repository ebuilds, checks upstream sources (GitHub / GitLab),
and manages GitHub issues to alert maintainers about available updates.
"""

from __future__ import annotations

import argparse
from functools import cmp_to_key
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET

# Attempt to load tomllib (Python 3.11+) or tomli fallback
try:
    import tomllib
except ImportError:
    try:
        import tomli as tomllib  # type: ignore
    except ImportError:
        tomllib = None  # type: ignore

# Gentoo PMS (section 3.2) version comparison regexes and values
VER_REGEXP = re.compile(
    r"^(\d+)((\.\d+)*)([a-z]?)((_(pre|p|beta|alpha|rc)\d*)*)(-r(\d+))?$"
)
SUFFIX_REGEXP = re.compile(r"^(alpha|beta|rc|pre|p)(\d*)$")
SUFFIX_VALUE = {"pre": -2, "p": 0, "alpha": -4, "beta": -3, "rc": -1}
EBUILD_PKG_RE = re.compile(
    r"^(?P<pn>[a-zA-Z0-9+_.-]+?)-(?P<ver>(?:\d+(?:\.\d+)*[a-z]?(?:_(?:pre|p|beta|alpha|rc)\d*)*(?:-r\d+)?)|9999)\.ebuild$"
)


def vercmp(ver1: str, ver2: str) -> int:
    """Compare two Gentoo version strings according to PMS rules."""
    if ver1 == ver2:
        return 0
    m1 = VER_REGEXP.match(ver1)
    m2 = VER_REGEXP.match(ver2)
    if not m1 or not m2:
        return 0 if ver1 == ver2 else (1 if ver1 > ver2 else -1)

    list1 = [int(m1.group(1))]
    list2 = [int(m2.group(1))]

    if m1.group(2) or m2.group(2):
        vlist1 = m1.group(2)[1:].split(".") if m1.group(2) else []
        vlist2 = m2.group(2)[1:].split(".") if m2.group(2) else []
        for i in range(max(len(vlist1), len(vlist2))):
            if len(vlist1) <= i or len(vlist1[i]) == 0:
                list1.append(-1)
                list2.append(int(vlist2[i]))
            elif len(vlist2) <= i or len(vlist2[i]) == 0:
                list1.append(int(vlist1[i]))
                list2.append(-1)
            elif vlist1[i][0] != "0" and vlist2[i][0] != "0":
                list1.append(int(vlist1[i]))
                list2.append(int(vlist2[i]))
            else:
                max_len = max(len(vlist1[i]), len(vlist2[i]))
                list1.append(int(vlist1[i].ljust(max_len, "0")))
                list2.append(int(vlist2[i].ljust(max_len, "0")))

    if m1.group(4):
        list1.append(ord(m1.group(4)))
    if m2.group(4):
        list2.append(ord(m2.group(4)))

    for i in range(max(len(list1), len(list2))):
        if len(list1) <= i:
            return -1
        if len(list2) <= i:
            return 1
        if list1[i] != list2[i]:
            return (list1[i] > list2[i]) - (list1[i] < list2[i])

    s_list1 = m1.group(5).split("_")[1:] if m1.group(5) else []
    s_list2 = m2.group(5).split("_")[1:] if m2.group(5) else []
    for i in range(max(len(s_list1), len(s_list2))):
        s1 = (
            ("p", "-1")
            if len(s_list1) <= i
            else SUFFIX_REGEXP.match(s_list1[i]).groups()
        )
        s2 = (
            ("p", "-1")
            if len(s_list2) <= i
            else SUFFIX_REGEXP.match(s_list2[i]).groups()
        )
        if s1[0] != s2[0]:
            return (SUFFIX_VALUE[s1[0]] > SUFFIX_VALUE[s2[0]]) - (
                SUFFIX_VALUE[s1[0]] < SUFFIX_VALUE[s2[0]]
            )
        if s1[1] != s2[1]:
            r1 = int(s1[1]) if s1[1] else 0
            r2 = int(s2[1]) if s2[1] else 0
            if r1 != r2:
                return (r1 > r2) - (r1 < r2)

    r1 = int(m1.group(9)) if m1.group(9) else 0
    r2 = int(m2.group(9)) if m2.group(9) else 0
    return (r1 > r2) - (r1 < r2)


def make_http_request(url: str, headers: dict[str, str] | None = None) -> tuple[int, bytes]:
    """Execute HTTP GET request using urllib."""
    req_headers = {
        "User-Agent": "waffle-builds-version-checker",
        "Accept": "application/json",
    }
    if headers:
        req_headers.update(headers)

    req = urllib.request.Request(url, headers=req_headers)
    try:
        with urllib.request.urlopen(req, timeout=20) as resp:
            return resp.status, resp.read()
    except urllib.error.HTTPError as e:
        return e.code, e.read()
    except Exception as e:
        return -1, str(e).encode()


def clean_version(
    raw_tag: str,
    prefix: str = "v",
    pattern: str | None = None,
    replacement: str | None = None,
) -> str:
    """Extract a clean Gentoo-compatible version string from raw tag."""
    tag = raw_tag.strip()
    if pattern and replacement is not None:
        tag = re.sub(pattern, replacement, tag)
    elif prefix and tag.startswith(prefix):
        tag = tag[len(prefix) :]

    # Strip any leading 'v' or 'release-' if still present
    tag = re.sub(r"^(?:v|release[-_])", "", tag)
    return tag


def is_prerelease(tag: str) -> bool:
    """Check if tag contains pre-release markers."""
    return re.search(r"[-._](?:alpha|beta|rc|dev|pre)", tag, re.IGNORECASE) is not None


class UpstreamChecker:
    def __init__(self, repo_dir: Path, config_file: Path | None = None, token: str | None = None):
        self.repo_dir = repo_dir
        self.config = self._load_config(config_file)
        self.token = token or os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")

    def _load_config(self, config_file: Path | None) -> dict:
        if config_file and config_file.exists():
            if tomllib:
                with open(config_file, "rb") as f:
                    return tomllib.load(f)
            else:
                print("Warning: tomllib not available, skipping TOML config", file=sys.stderr)
        return {}

    def scan_overlay(self) -> dict[str, dict]:
        """Scan overlay for all packages and their latest versions."""
        packages = {}
        for root, _, files in os.walk(self.repo_dir):
            ebuilds = [f for f in files if f.endswith(".ebuild")]
            if not ebuilds:
                continue

            rel_path = Path(root).relative_to(self.repo_dir).as_posix()
            # Ignore hidden or non-category dirs (like .git)
            if rel_path.startswith(".") or "/" not in rel_path:
                continue

            versioned = []
            has_live = False

            for eb in ebuilds:
                m = EBUILD_PKG_RE.match(eb)
                if not m:
                    continue
                v = m.group("ver")
                if v == "9999":
                    has_live = True
                else:
                    versioned.append(v)

            sorted_vers = sorted(versioned, key=cmp_to_key(vercmp))
            latest_version = sorted_vers[-1] if sorted_vers else ("9999" if has_live else None)

            packages[rel_path] = {
                "latest_version": latest_version,
                "has_live": has_live,
                "all_versions": sorted_vers,
                "dir": Path(root),
            }

        return packages

    def resolve_upstream(self, pkg_name: str, pkg_info: dict) -> dict | None:
        """Resolve upstream source definition from config or package files."""
        # 1. Check explicit config
        if pkg_name in self.config:
            cfg = self.config[pkg_name]
            if cfg.get("ignore", False):
                return {"type": "ignored", "notes": cfg.get("notes", "")}
            return cfg

        # 2. Check metadata.xml
        meta_xml = pkg_info["dir"] / "metadata.xml"
        if meta_xml.exists():
            try:
                tree = ET.parse(meta_xml)
                for r in tree.findall(".//remote-id"):
                    rtype = r.get("type", "")
                    rtext = r.text.strip() if r.text else ""
                    if not rtext:
                        continue
                    if rtype == "github":
                        return {"source": "github", "repo": rtext, "tag_prefix": "v"}
                    elif rtype == "freedesktop-gitlab":
                        return {"source": "gitlab", "host": "gitlab.freedesktop.org", "project": rtext, "tag_prefix": "v"}
                    elif rtype == "gnome-gitlab":
                        return {"source": "gitlab", "host": "gitlab.gnome.org", "project": rtext, "tag_prefix": "v"}
                    elif rtype == "gitlab":
                        return {"source": "gitlab", "host": "gitlab.com", "project": rtext, "tag_prefix": "v"}
            except Exception:
                pass

        # 3. Check ebuild hints
        for eb in pkg_info["dir"].glob("*.ebuild"):
            try:
                content = eb.read_text(errors="ignore")
                gh_match = re.search(r"https?://github\.com/([a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+)", content)
                if gh_match:
                    repo = gh_match.group(1).rstrip(".git").rstrip("/")
                    return {"source": "github", "repo": repo, "tag_prefix": "v"}
            except Exception:
                pass

        return None

    def query_github(self, repo: str, check_mode: str = "release", prefix: str = "v",
                     pattern: str | None = None, replacement: str | None = None,
                     ignore_pre: bool = True, tag_filter: str | None = None
                     ) -> tuple[str | None, str | None, str | None, bool]:
        """
        Query GitHub for latest release or tag.
        Returns (version, raw_tag, url, has_error).
        """
        headers = {}
        if self.token:
            headers["Authorization"] = f"Bearer {self.token}"

        filter_re = re.compile(tag_filter) if tag_filter else None

        candidates = []
        excluded_tags = set()
        if check_mode == "release":
            url = f"https://api.github.com/repos/{repo}/releases?per_page=30"
            status, body = make_http_request(url, headers)
            if status != 200:
                return None, None, None, True
            if status == 200:
                data = json.loads(body.decode("utf-8"))
                for r in data:
                    tag_name = r.get("tag_name", "")
                    is_pre = r.get("prerelease", False) or is_prerelease(tag_name)
                    if ignore_pre and is_pre:
                        excluded_tags.add(tag_name)
                        continue
                    if filter_re and not filter_re.search(tag_name):
                        continue
                    v = clean_version(tag_name, prefix, pattern, replacement)
                    if ignore_pre and is_prerelease(v):
                        excluded_tags.add(tag_name)
                        continue
                    if VER_REGEXP.match(v):
                        html_url = r.get("html_url", f"https://github.com/{repo}/releases/tag/{tag_name}")
                        candidates.append((v, tag_name, html_url))

                if candidates:
                    candidates.sort(key=lambda item: cmp_to_key(vercmp)(item[0]))
                    best_ver, best_tag, best_url = candidates[-1]
                    return best_ver, best_tag, best_url, False

        # Fall back to /tags
        url = f"https://api.github.com/repos/{repo}/tags?per_page=30"
        status, body = make_http_request(url, headers)
        if status == 200:
            tags = json.loads(body.decode("utf-8"))
            candidate_tags = []
            for t in tags:
                raw_tag = t.get("name", "")
                if raw_tag in excluded_tags:
                    continue
                if filter_re and not filter_re.search(raw_tag):
                    continue
                if ignore_pre and is_prerelease(raw_tag):
                    continue
                v = clean_version(raw_tag, prefix, pattern, replacement)
                if ignore_pre and is_prerelease(v):
                    continue
                if VER_REGEXP.match(v):
                    candidate_tags.append((v, raw_tag))

            if candidate_tags:
                candidate_tags.sort(key=lambda item: cmp_to_key(vercmp)(item[0]))
                best_ver, best_tag = candidate_tags[-1]
                html_url = f"https://github.com/{repo}/releases/tag/{best_tag}"
                return best_ver, best_tag, html_url, False
            # 200 OK, but no matching tags
            return None, None, None, False

        # Status != 200
        return None, None, None, True

    def query_gitlab(self, host: str, project: str, prefix: str = "v",
                     pattern: str | None = None, replacement: str | None = None,
                     ignore_pre: bool = True, tag_filter: str | None = None
                     ) -> tuple[str | None, str | None, str | None, bool]:
        """
        Query GitLab for latest release or tag.
        Returns (version, raw_tag, url, has_error).
        """
        encoded = urllib.parse.quote_plus(project)
        filter_re = re.compile(tag_filter) if tag_filter else None

        # Check releases
        rel_url = f"https://{host}/api/v4/projects/{encoded}/releases?per_page=30"
        status, body = make_http_request(rel_url)
        if status != 200:
            return None, None, None, True
        if status == 200:
            releases = json.loads(body.decode("utf-8"))
            candidates = []
            for r in releases:
                tag_name = r.get("tag_name", "")
                if filter_re and not filter_re.search(tag_name):
                    continue
                if ignore_pre and is_prerelease(tag_name):
                    continue
                v = clean_version(tag_name, prefix, pattern, replacement)
                if ignore_pre and is_prerelease(v):
                    continue
                if VER_REGEXP.match(v):
                    html_url = f"https://{host}/{project}/-/releases/{tag_name}"
                    candidates.append((v, tag_name, html_url))

            if candidates:
                candidates.sort(key=lambda item: cmp_to_key(vercmp)(item[0]))
                best_ver, best_tag, best_url = candidates[-1]
                return best_ver, best_tag, best_url, False

        # Fall back to tags
        tag_url = f"https://{host}/api/v4/projects/{encoded}/repository/tags"
        status, body = make_http_request(tag_url)
        if status == 200:
            tags = json.loads(body.decode("utf-8"))
            candidate_tags = []
            for t in tags:
                raw_tag = t.get("name", "")
                if filter_re and not filter_re.search(raw_tag):
                    continue
                if ignore_pre and is_prerelease(raw_tag):
                    continue
                v = clean_version(raw_tag, prefix, pattern, replacement)
                if ignore_pre and is_prerelease(v):
                    continue
                if VER_REGEXP.match(v):
                    candidate_tags.append((v, raw_tag))

            if candidate_tags:
                candidate_tags.sort(key=lambda item: cmp_to_key(vercmp)(item[0]))
                best_ver, best_tag = candidate_tags[-1]
                html_url = f"https://{host}/{project}/-/tags/{best_tag}"
                return best_ver, best_tag, html_url, False
            # 200 OK, but no matching tags
            return None, None, None, False

        return None, None, None, True

    def check_package(self, pkg_name: str, pkg_info: dict) -> dict:
        """Check a single package against its upstream source."""
        upstream = self.resolve_upstream(pkg_name, pkg_info)
        overlay_ver = pkg_info["latest_version"]
        has_live = pkg_info["has_live"]

        res = {
            "package": pkg_name,
            "overlay_version": overlay_ver,
            "has_live": has_live,
            "upstream_version": None,
            "upstream_tag": None,
            "release_url": None,
            "status": "unknown",
            "message": "",
        }

        if not upstream:
            res["status"] = "no_upstream"
            res["message"] = "No upstream source detected"
            return res

        if upstream.get("type") == "ignored":
            res["status"] = "ignored"
            res["message"] = upstream.get("notes", "Ignored by configuration")
            return res

        source = upstream.get("source")
        prefix = upstream.get("tag_prefix", "v")
        pattern = upstream.get("version_pattern")
        replacement = upstream.get("version_replace")
        defaults = self.config.get("defaults", {})
        check_mode = upstream.get("check", defaults.get("github_check", "release"))
        ignore_pre = upstream.get("ignore_prereleases", defaults.get("ignore_prereleases", True))
        tag_filter = upstream.get("tag_filter")

        up_ver, up_tag, url, has_error = None, None, None, False
        if source == "github":
            repo = upstream.get("repo")
            if not repo:
                res["status"] = "config_error"
                res["message"] = "Missing GitHub repository name"
                return res
            up_ver, up_tag, url, has_error = self.query_github(
                repo, check_mode=check_mode, prefix=prefix,
                pattern=pattern, replacement=replacement, ignore_pre=ignore_pre,
                tag_filter=tag_filter
            )
        elif source == "gitlab":
            host = upstream.get("host", "gitlab.com")
            project = upstream.get("project")
            if not project:
                res["status"] = "config_error"
                res["message"] = "Missing GitLab project name"
                return res
            up_ver, up_tag, url, has_error = self.query_gitlab(
                host, project, prefix=prefix, pattern=pattern,
                replacement=replacement, ignore_pre=ignore_pre,
                tag_filter=tag_filter
            )
        else:
            res["status"] = "unsupported_source"
            res["message"] = f"Unsupported source type: {source}"
            return res

        res["upstream_version"] = up_ver
        res["upstream_tag"] = up_tag
        res["release_url"] = url

        if has_error:
            res["status"] = "fetch_failed"
            res["message"] = "Failed to fetch upstream releases/tags (network or API error)"
            return res

        if not up_ver:
            if overlay_ver == "9999":
                res["status"] = "up_to_date"
                res["message"] = "Live package, no upstream releases tagged yet"
            else:
                res["status"] = "no_upstream"
                res["message"] = "No upstream releases or tags found"
            return res

        # Evaluation
        if overlay_ver == "9999":
            # Live package with tagged release
            res["status"] = "new_release"
            res["message"] = f"Release {up_ver} available (currently live-only)"
        else:
            diff = vercmp(up_ver, overlay_ver)
            if diff > 0:
                res["status"] = "update_available"
                res["message"] = f"Update available: {overlay_ver} -> {up_ver}"
            else:
                res["status"] = "up_to_date"
                res["message"] = "Up to date"

        return res


def generate_issue_body(pkg_name: str, current_ver: str, upstream_ver: str, tag: str, url: str) -> str:
    """Generate markdown body for an update alert issue."""
    return f"""<!-- package:{pkg_name} -->
## Upstream version update available: `{pkg_name}`

| Item | Value |
|---|---|
| **Package** | `{pkg_name}` |
| **Overlay Version** | `{current_ver}` |
| **Upstream Version** | `{upstream_ver}` |
| **Release Details** | [{tag or upstream_ver}]({url}) |

### Maintenance checklist
- [ ] Create `{pkg_name.split('/')[-1]}-{upstream_ver}.ebuild`
- [ ] Update Manifest (`pkgdev manifest` or `ebuild ... manifest`)
- [ ] Test package build (`emerge -1 ={pkg_name}-{upstream_ver}`)
- [ ] Run QA checks (`pkgcheck scan {pkg_name}`)

---
*Generated automatically by GitHub Actions upstream checker.*
"""


def manage_github_issues(results: list[dict], dry_run: bool = False) -> bool:
    """Create or close GitHub issues, returning whether all operations succeeded."""
    import shutil

    gh_bin = shutil.which("gh")
    if not gh_bin:
        print("GitHub CLI ('gh') not found in PATH.", file=sys.stderr)
        if not dry_run:
            print("Cannot manage issues without 'gh'. Skipping issue management.", file=sys.stderr)
            return False

    label_name = "upstream-update"

    existing_issues = []
    if gh_bin:
        try:
            proc = subprocess.run(
                [gh_bin, "issue", "list", "--state", "open", "--label", label_name, "--json", "number,title,body"],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
            )
            existing_issues = json.loads(proc.stdout)
        except Exception as e:
            print(f"Error fetching existing GitHub issues: {e}", file=sys.stderr)
            return False

    def run_gh(arguments: list[str]) -> bool:
        try:
            subprocess.run([gh_bin, *arguments], check=True)
        except (subprocess.CalledProcessError, OSError) as e:
            print(f"GitHub CLI operation failed: {e}", file=sys.stderr)
            return False
        return True

    if gh_bin and not dry_run:
        if not run_gh([
            "label", "create", label_name, "--color", "0e8a16",
            "--description", "Upstream update alert", "--force",
        ]):
            return False

    # Map package name -> issue data
    pkg_to_issue = {}
    for issue in existing_issues:
        body = issue.get("body", "")
        m = re.search(r"<!-- package:([a-zA-Z0-9+_.-]+/[a-zA-Z0-9+_.-]+) -->", body)
        if m:
            pkg_to_issue[m.group(1)] = issue
        else:
            # Fall back to title match
            title = issue.get("title", "")
            title_match = re.search(r"(?:Update available|New release available):\s*([a-zA-Z0-9+_.-]+/[a-zA-Z0-9+_.-]+)", title)
            if title_match:
                pkg_to_issue[title_match.group(1)] = issue

    success = True
    for res in results:
        pkg = res["package"]
        status = res["status"]
        overlay_ver = res["overlay_version"]
        upstream_ver = res["upstream_version"]
        url = res["release_url"] or ""
        tag = res["upstream_tag"] or ""

        existing = pkg_to_issue.get(pkg)

        if status in ("update_available", "new_release"):
            title = (
                f"Update available: {pkg} ({overlay_ver} -> {upstream_ver})"
                if status == "update_available"
                else f"New release available: {pkg} ({upstream_ver})"
            )
            body = generate_issue_body(pkg, overlay_ver, upstream_ver, tag, url)

            if existing:
                num = existing["number"]
                if existing["title"] != title:
                    print(f"Updating issue #{num} for {pkg} to {upstream_ver}")
                    if not dry_run and gh_bin:
                        if not run_gh(["issue", "edit", str(num), "--title", title, "--body", body]):
                            success = False
                else:
                    print(f"Issue #{num} for {pkg} is already open and up to date")
            else:
                print(f"Creating issue for {pkg}: {title}")
                if not dry_run and gh_bin:
                    if not run_gh(["issue", "create", "--title", title, "--body", body, "--label", label_name]):
                        success = False

        elif status == "up_to_date" and existing:
            # Close existing issue as resolved
            num = existing["number"]
            comment = f"Resolved: {pkg} is now up to date in the overlay at version {overlay_ver}."
            print(f"Closing resolved issue #{num} for {pkg}")
            if not dry_run and gh_bin:
                if not run_gh(["issue", "close", str(num), "--comment", comment]):
                    success = False

    return success


def write_step_summary(results: list[dict], summary_file: Path):
    """Write GitHub Actions step summary markdown table."""
    lines = [
        "## Upstream version check results\n",
        "| Package | Overlay version | Upstream version | Status | Release |",
        "|---|---|---|---|---|",
    ]

    status_icons = {
        "update_available": "⚠️ Update available",
        "new_release": "🚀 New release (live-only)",
        "up_to_date": "✅ Up to date",
        "ignored": "⏸️ Ignored",
        "no_upstream": "❓ No upstream found",
        "fetch_failed": "❌ Fetch failed",
    }

    for r in results:
        status = status_icons.get(r["status"], r["status"])
        url_link = f"[Release]({r['release_url']})" if r["release_url"] else "-"
        up_v = r["upstream_version"] or "-"
        lines.append(f"| `{r['package']}` | `{r['overlay_version']}` | `{up_v}` | {status} | {url_link} |")

    lines.append("")
    with open(summary_file, "a", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser(description="Check Gentoo overlay for upstream version updates")
    parser.add_argument("--repo-dir", type=Path, default=Path.cwd(), help="Path to overlay repository root")
    parser.add_argument("--config", type=Path, default=None, help="Path to upstream.toml configuration")
    parser.add_argument("--manage-issues", action="store_true", help="Automatically create/close GitHub issues")
    parser.add_argument("--dry-run", action="store_true", help="Do not make modifications to GitHub issues")
    args = parser.parse_args()

    repo_dir = args.repo_dir.resolve()
    config_file = (args.config or (repo_dir / ".github" / "upstream.toml")).resolve()

    checker = UpstreamChecker(repo_dir=repo_dir, config_file=config_file)
    packages = checker.scan_overlay()

    print(f"Discovered {len(packages)} packages in overlay.")
    results = []
    for pkg_name, pkg_info in sorted(packages.items()):
        res = checker.check_package(pkg_name, pkg_info)
        results.append(res)
        print(f"[{res['status']}] {pkg_name}: overlay={res['overlay_version']}, upstream={res['upstream_version']} ({res['message']})")

    # Step summary for GitHub Actions
    summary_path = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary_path:
        write_step_summary(results, Path(summary_path))

    failed = any(r["status"] in {"fetch_failed", "config_error", "unsupported_source"} for r in results)

    # Issue management
    if args.manage_issues:
        if not manage_github_issues(results, dry_run=args.dry_run):
            failed = True

    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
