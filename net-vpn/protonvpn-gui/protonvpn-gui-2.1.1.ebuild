# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="GUI wrapper for their command-line tool from ProtonVPN"
HOMEPAGE="https://protonvpn.com https://github.com/ProtonVPN/linux-gui"
SRC_URI="https://github.com/ProtonVPN/linux-gui/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="x11-libs/gtk+
	x11-libs/libnotify
	dev-libs/libappindicator
	dev-python/pygobject[${PYTHON_USEDEP}]
	>=dev-python/requests-2.23.0[${PYTHON_USEDEP}]
	>=dev-python/configparser-4.0.2
	>=net-vpn/protonvpn-cli-2.2.2"
DEPEND="${RDEPEND}"

S="${WORKDIR}/linux-gui-${PV}"

DOCS=( README.md )
