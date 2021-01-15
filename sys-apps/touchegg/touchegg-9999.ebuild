# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Linux multi-touch gesture recognizer"
HOMEPAGE="https://github.com/JoseExposito/touchegg"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/JoseExposito/touchegg.git"
else
	SRC_URI="https://github.com/JoseExposito/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+gtk"
RESTRICT="primaryuri"

RDEPEND="|| ( sys-apps/systemd sys-fs/eudev sys-fs/udev )
	dev-libs/libinput
	dev-libs/pugixml
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXrandr
	x11-libs/libXi
	gtk? ( x11-libs/gtk+:3 )
	"

DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DAUTO_COLORS="$(usex gtk)"
	)

	cmake_src_configure
}

pkg_postinst() {
	elog "On update run: 'systemctl daemon-reload && systemctl restart touchegg'"
	elog "Configuration: https://github.com/JoseExposito/touchegg#configuration"
	elog "Copy config from '/usr/share/${PN}/${PN}.conf' to '~/.config/${PN}'"
}
