# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm xdg-utils

DESCRIPTION="Serves ProtonMail to IMAP/SMTP clients"
HOMEPAGE="https://protonmail.com/bridge/"
SRC_URI="https://protonmail.com/download/bridge/${P/-bin/}-1.x86_64.rpm"

RESTRICT="bindist primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="pass keyring"

DEPEND=""
RDEPEND="
	media-libs/libglvnd
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtmultimedia:5
	dev-qt/qtsvg:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtquickcontrols2:5
	sys-libs/glibc
	dev-libs/glib:2
	media-fonts/dejavu
	pass? ( app-admin/pass )
	keyring? ( gnome-base/gnome-keyring )
"
S="${WORKDIR}"

QA_PREBUILT="*"

src_prepare() {
	# Some bogus files got into package.
	rm -rf usr/lib/.build-id
	rm -rf usr/share/doc/protonmail

	default
}

src_install() {
	# Using doins -r would strip executable bits from all binaries
	cp -pPR usr "${D}"/ || die "Failed to copy files"

	dosym "protonmail-bridge" "/usr/bin/${PN}"

	insinto /etc/revdep-rebuild
	newins - "50-${PN}" <<-EOF
		SEARCH_DIRS_MASK="/usr/lib*/protonmail/bridge"
	EOF
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
