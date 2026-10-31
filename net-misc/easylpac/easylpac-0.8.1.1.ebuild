# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop go-module xdg

MY_PN="EasyLPAC"

DESCRIPTION="Graphical frontend for lpac eSIM management"
HOMEPAGE="https://github.com/creamlike1024/EasyLPAC"
SRC_URI="https://github.com/creamlike1024/EasyLPAC/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

# Pinned go.mod dependencies, using the Go proxy's case-escaped module paths.
# Fetch these as regular distfiles so building needs neither network access
# nor a separately hosted dependency tarball.
EASYLPAC_MODULES=(
	"fyne.io/fyne/v2@v2.7.3"
	"fyne.io/systray@v1.12.0"
	"github.com/!burnt!sushi/toml@v1.6.0"
	"github.com/!the!titanrain/w32@v0.0.0-20200114052255-2654d97dbd3d"
	"github.com/!xuanwo/go-locale@v1.1.3"
	"github.com/alecthomas/participle/v2@v2.1.4"
	"github.com/clipperhouse/uax29/v2@v2.7.0"
	"github.com/davecgh/go-spew@v1.1.1"
	"github.com/fredbi/uri@v1.1.1"
	"github.com/fsnotify/fsnotify@v1.9.0"
	"github.com/fullpipe/icu-mf@v1.0.1"
	"github.com/fyne-io/gl-js@v0.2.0"
	"github.com/fyne-io/glfw-js@v0.3.0"
	"github.com/fyne-io/image@v0.1.1"
	"github.com/fyne-io/oksvg@v0.2.0"
	"github.com/go-gl/gl@v0.0.0-20260331235117-4566fea9a276"
	"github.com/go-gl/glfw/v3.3/glfw@v0.0.0-20260406072232-3ac4aa2bb164"
	"github.com/go-text/render@v0.2.1"
	"github.com/go-text/typesetting@v0.3.4"
	"github.com/godbus/dbus/v5@v5.2.2"
	"github.com/hack-pad/go-indexeddb@v0.3.2"
	"github.com/hack-pad/safejs@v0.1.1"
	"github.com/jeandeaual/go-locale@v0.0.0-20250612000132-0ef82f21eade"
	"github.com/jsummers/gobmp@v0.0.0-20230614200233-a9de23ed2e25"
	"github.com/kr/text@v0.2.0"
	"github.com/makiuchi-d/gozxing@v0.1.1"
	"github.com/mattn/go-runewidth@v0.0.23"
	"github.com/nfnt/resize@v0.0.0-20180221191011-83c6a9932646"
	"github.com/nicksnyder/go-i18n/v2@v2.6.1"
	"github.com/pkg/errors@v0.9.1"
	"github.com/pmezard/go-difflib@v1.0.0"
	"github.com/rymdport/portal@v0.4.2"
	"github.com/sqweek/dialog@v0.0.0-20260123140253-64c163d53aac"
	"github.com/srwiley/oksvg@v0.0.0-20221011165216-be6e8873101c"
	"github.com/srwiley/rasterx@v0.0.0-20220730225603-2ab79fcdd4ef"
	"github.com/stretchr/testify@v1.11.1"
	"github.com/yuin/goldmark@v1.8.2"
	"golang.design/x/clipboard@v0.7.1"
	"golang.org/x/exp/shiny@v0.0.0-20260410095643-746e56fc9e2f"
	"golang.org/x/exp@v0.0.0-20260410095643-746e56fc9e2f"
	"golang.org/x/image@v0.41.0"
	"golang.org/x/mobile@v0.0.0-20260410095206-2cfb76559b7b"
	"golang.org/x/net@v0.55.0"
	"golang.org/x/sys@v0.45.0"
	"golang.org/x/text@v0.37.0"
	"golang.org/x/xerrors@v0.0.0-20240903120638-7835f813f4da"
	"gopkg.in/yaml.v3@v3.0.1"
)

# Metadata-only entries in go.sum needed to load older dependency graphs.
EASYLPAC_MODFILES=(
	"github.com/!the!titanrain/w32@v0.0.0-20180517000239-4f5cfb03fabf"
	"github.com/creack/pty@v1.1.9"
	"gopkg.in/check.v1@v0.0.0-20161208181325-20d25e280405"
)

for module in "${EASYLPAC_MODULES[@]}" ; do
	for ext in mod zip ; do
		SRC_URI+=" https://proxy.golang.org/${module%@*}/@v/${module##*@}.${ext} -> ${module//\//%2F}.${ext}"
	done
done
for module in "${EASYLPAC_MODFILES[@]}" ; do
	SRC_URI+=" https://proxy.golang.org/${module%@*}/@v/${module##*@}.mod -> ${module//\//%2F}.mod"
done
unset module ext

# Includes the statically linked Go dependencies and embedded fonts.
LICENSE="MIT BSD BSD-2 Apache-2.0 ISC ZLIB BitstreamVera OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	virtual/opengl
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXxf86vm
"
RDEPEND="
	${DEPEND}
	>=net-misc/lpac-2.3.0
"
DEPEND+=" x11-base/xorg-proto"
BDEPEND="
	>=dev-lang/go-1.25.0
	virtual/pkgconfig
"

DOCS=( README.md )

# All module files are fetched and Manifest-verified by Portage. Go also
# verifies them against upstream's go.sum while populating its module cache.
export GOPROXY=off GOSUMDB=off GOTOOLCHAIN=local

src_unpack() {
	unpack "${P}.tar.gz"

	local module ext cache_dir
	for module in "${EASYLPAC_MODULES[@]}" ; do
		cache_dir="${GOMODCACHE}/cache/download/${module%@*}/@v"
		mkdir -p "${cache_dir}" || die
		for ext in mod zip ; do
			cp "${DISTDIR}/${module//\//%2F}.${ext}" \
				"${cache_dir}/${module##*@}.${ext}" || die
		done
		# Only the version is needed; proxy .info responses may change metadata.
		printf '{"Version":"%s"}\n' "${module##*@}" \
			> "${cache_dir}/${module##*@}.info" || die
	done
	for module in "${EASYLPAC_MODFILES[@]}" ; do
		cache_dir="${GOMODCACHE}/cache/download/${module%@*}/@v"
		mkdir -p "${cache_dir}" || die
		cp "${DISTDIR}/${module//\//%2F}.mod" \
			"${cache_dir}/${module##*@}.mod" || die
	done

	cd "${S}" || die
	ego mod download
	ego mod verify
}

src_prepare() {
	default
	sed -i "s/const Version = \"development\"/const Version = \"${PV}\"/" main.go || die
}

src_configure() {
	export CGO_ENABLED=1
	go-module_src_configure
}

src_compile() {
	ego build -mod=readonly -trimpath -o EasyLPAC .
}

src_test() {
	# Fyne's CI driver allows running upstream's tests without a display.
	XDG_CONFIG_HOME="${T}/config" XDG_CACHE_HOME="${T}/cache" \
		ego test -mod=readonly -tags ci -count=1 ./...
}

src_install() {
	dobin EasyLPAC
	dosym EasyLPAC /usr/bin/easylpac

	newicon -s 128 assets/icon128.png easylpac.png
	make_desktop_entry EasyLPAC EasyLPAC easylpac "Network;"

	einstalldocs
}
