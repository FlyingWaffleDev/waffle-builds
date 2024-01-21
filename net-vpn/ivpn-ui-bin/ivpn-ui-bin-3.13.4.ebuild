# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm desktop

DESCRIPTION="IVPN Desktop app GUI - binary because of npm and Electron difficulties"
HOMEPAGE="https://www.ivpn.net/ https://github.com/ivpn"
SRC_URI="https://repo.ivpn.net/stable/pool/ivpn-ui-${PV}-1.x86_64.rpm"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
RESTRICT="primaryuri"

RDEPEND="=net-vpn/ivpn-${PV}"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	mkdir -p "${D}/opt/ivpn/ui/bin" || die

	into "opt/ivpn/ui"
	insinto "opt/ivpn/ui"
	doins -r "${S}/opt/ivpn/ui/bin"
	dobin "${S}/opt/ivpn/ui/bin/ivpn-ui"
	dobin "${S}/opt/ivpn/ui/bin/chrome-sandbox"
	dobin "${S}/opt/ivpn/ui/bin/chrome_crashpad_handler"
	dolib.so "${S}/opt/ivpn/ui/bin/libEGL.so"
	dolib.so "${S}/opt/ivpn/ui/bin/libGLESv2.so"
	dolib.so "${S}/opt/ivpn/ui/bin/libffmpeg.so"
	dolib.so "${S}/opt/ivpn/ui/bin/libvulkan.so.1"
	dolib.so "${S}/opt/ivpn/ui/bin/libvk_swiftshader.so"

	fperms 0777 "/opt/ivpn/ui/bin/resources/public.pem"

	doins "${S}/opt/ivpn/ui/IVPN.desktop"
	doins "${S}/opt/ivpn/ui/ivpnicon.svg"

	domenu "${S}/opt/ivpn/ui/IVPN.desktop"
}
