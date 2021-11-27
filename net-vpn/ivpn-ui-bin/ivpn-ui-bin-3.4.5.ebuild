# Copyright 1999-2021 Gentoo Authors
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

RDEPEND="net-vpn/ivpn"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	mkdir -p "${D}/opt/ivpn/ui/bin" || die

	into "opt/ivpn/ui"
	insinto "opt/ivpn/ui"
	doins -r "${S}/opt/ivpn/ui/bin"
	dobin "${S}/opt/ivpn/ui/bin/ivpn-ui"

	doins "${S}/opt/ivpn/ui/IVPN.desktop"
	doins "${S}/opt/ivpn/ui/ivpnicon.svg"

	domenu "${S}/opt/ivpn/ui/IVPN.desktop"
}
