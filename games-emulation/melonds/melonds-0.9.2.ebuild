# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

MY_PN="melonDS"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="NintendoDS emulator, sorta. Also 1st quality melon."
HOMEPAGE="http://melonds.kuribo64.net https://github.com/Arisotura/melonDS"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Arisotura/${MY_PN}.git"
else
	MY_P="${MY_PN}-${PV}"
	RESTRICT="primaryuri"
	SRC_URI="https://github.com/Arisotura/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD-2 GPL-2 GPL-3 Unlicense"
SLOT="0"

DEPEND="
	app-arch/libarchive
	media-libs/libsdl2[sound,video]
	media-libs/libepoxy
	net-libs/libpcap
	net-libs/libslirp
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	"

RDEPEND="${DEPEND}"

# used for JIT recompiler
QA_EXECSTACK="usr/bin/melonDS"

BUILD_DIR="${S}/build"

src_prepare() {
	cmake_src_prepare
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
