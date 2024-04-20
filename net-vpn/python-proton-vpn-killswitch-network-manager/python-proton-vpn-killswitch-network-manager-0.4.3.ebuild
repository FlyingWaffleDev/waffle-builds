# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Implements the ProtonVPN killswitch using NetworkManager"
HOMEPAGE="https://protonvpn.com https://github.com/ProtonVPN/${PN}"
SRC_URI="https://github.com/ProtonVPN/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+networkmanager"
RESTRICT="test primaryuri"

RDEPEND="
	net-vpn/python-proton-vpn-killswitch[${PYTHON_USEDEP}]
	net-vpn/python-proton-vpn-logger[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	networkmanager? ( net-misc/networkmanager )
"

BDEPEND="${RDEPEND}"

DEPEND="${RDEPEND}"

