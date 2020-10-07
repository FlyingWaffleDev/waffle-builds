# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

MY_PN="melonDS"

DESCRIPTION="NintendoDS emulator, sorta. Also 1st quality melon."
HOMEPAGE="http://melonds.kuribo64.net"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Arisotura/${MY_PN}"
else
	MY_P="${MY_PN}-${PV}"
	SRC_URI="https://github.com/Arisotura/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	media-libs/libsdl2[sound,video]
	net-libs/libpcap
	net-misc/curl
	x11-libs/cairo
	dev-qt/qtcore
	dev-qt/qtdeclarative
	net-libs/libslirp
	x11-libs/gtk+:3"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_install() {
	cmake_src_install
	domenu net.kuribo64.melonDS.desktop
	for size in 16 32 48 64 128 256; do
		newicon -s ${size} icon/melon_${size}x${size}.png net.kuribo64.${PN}.png
	done
}

pkg_postinst() {
	xdg_pkg_postinst
	echo
	elog "You need DS/DSi BIOS and firmware in order to run melonDS:"
	elog "NDS:"
	elog "- bios7.bin"
	elog "- bios9.bin"
	elog "- firmware.bin"
	elog "DSi:"
	elog "- biosdsi7.bin"
	elog "- biosdsi9.bin"
	elog "- dsifirmware.bin"
	elog "- dsinand.bin"
	elog "Place them in ~/.config/melonDS"
	elog "These files can easily be found somewhere in the internet."
	echo
}
