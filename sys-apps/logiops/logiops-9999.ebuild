# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Unofficial driver for Logitech mice and keyboards - live version"
HOMEPAGE="https://github.com/PixlOne/logiops"

if [[ "${PV}" == 9999 ]] ; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/PixlOne/logiops.git"
	S="${WORKDIR}/${PN}-${PV}"
else
    SRC_URI="https://github.com/PixlOne/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/libevdev
    dev-libs/libconfig
    || ( sys-apps/systemd sys-fs/eudev )"

DEPEND="${RDEPEND}"

pkg_postinst() {
    elog "NOTE: The installed systemd daemon is called 'logid'."
	elog "WARNING: No configuration file is included!"
	elog "See https://github.com/PixlOne/logiops/wiki/Configuration"
}
