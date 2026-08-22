# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop rpm

DESCRIPTION="Official IVPN desktop GUI binary"
HOMEPAGE="https://www.ivpn.net/ https://github.com/ivpn/desktop-app"
SRC_URI="https://repo.ivpn.net/stable/pool/ivpn-ui-${PV}-1.x86_64.rpm"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="~net-vpn/ivpn-${PV}
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

QA_PREBUILT="opt/ivpn/ui/bin/*"

src_install() {
	insinto /opt/ivpn/ui
	doins -r opt/ivpn/ui/.
	fperms 0755 /opt/ivpn/ui/bin/{ivpn-ui,chrome-sandbox,chrome_crashpad_handler}

	domenu opt/ivpn/ui/IVPN.desktop
}
