# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

ELECTRON_VERSION=42.2.0

DESCRIPTION="Official IVPN desktop GUI"
HOMEPAGE="https://www.ivpn.net/ https://github.com/ivpn/desktop-app"
SRC_URI="https://github.com/ivpn/desktop-app/archive/v${PV}.tar.gz -> ivpn-${PV}.tar.gz
	https://github.com/FlyingWaffleDev/gentoo-ivpn-deps/releases/download/ivpn-${PV}/${P}-npm-deps.tar.xz
	amd64? ( https://github.com/electron/electron/releases/download/v${ELECTRON_VERSION}/electron-v${ELECTRON_VERSION}-linux-x64.zip )"
S="${WORKDIR}/desktop-app-${PV}/ui"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

RDEPEND="!net-vpn/ivpn-ui-bin
	~net-vpn/ivpn-${PV}
	app-accessibility/at-spi2-core:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	virtual/libudev
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango"
BDEPEND="app-arch/unzip
	>=net-libs/nodejs-22.12.0[npm]"

QA_PREBUILT="opt/ivpn/ui/bin/*"

src_unpack() {
	unpack "ivpn-${PV}.tar.gz" "${P}-npm-deps.tar.xz"
}

src_compile() {
	local electron_dist="${T}/electron-dist"
	local npm_args=(
		--audit=false
		--color=false
		--fund=false
		--ignore-scripts
		--offline
		--progress=false
		--cache "${WORKDIR}/npm-cache"
	)
	export ELECTRON_BUILDER_CACHE="${T}/electron-builder-cache"
	export NO_UPDATE_NOTIFIER=1
	export npm_config_cache="${WORKDIR}/npm-cache"
	export npm_config_offline=true
	export npm_config_update_notifier=false

	npm ci "${npm_args[@]}" || die "npm ci failed"
	npm run build || die "UI compilation failed"

	mkdir "${electron_dist}" || die
	cp "${DISTDIR}/electron-v${ELECTRON_VERSION}-linux-x64.zip" \
		"${electron_dist}/" || die

	./node_modules/.bin/electron-builder \
		--linux dir \
		--x64 \
		--config electron-builder.config.js \
		--config.electronDist="${electron_dist}" \
		--publish never || die "Electron packaging failed"
}

src_install() {
	insinto /opt/ivpn/ui/bin
	doins -r dist/linux-unpacked/.
	fperms 0755 /opt/ivpn/ui/bin/{ivpn-ui,chrome-sandbox,chrome_crashpad_handler}

	insinto /opt/ivpn/ui
	doins References/Linux/ui/ivpnicon.svg
	domenu References/Linux/ui/IVPN.desktop
}
