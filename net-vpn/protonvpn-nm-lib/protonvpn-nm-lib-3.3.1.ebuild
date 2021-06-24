# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="ProtonVPN NetworkManager library"
HOMEPAGE="https://protonvpn.com https://github.com/ProtonVPN/protonvpn-nm-lib"
SRC_URI="https://github.com/ProtonVPN/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
RESTRICT="primaryuri"

RDEPEND="
	net-misc/networkmanager
	net-vpn/networkmanager-openvpn
	net-vpn/openvpn
	dev-python/pyxdg
	dev-python/keyring
	dev-python/jinja
	dev-python/distro
	dev-python/proton-client
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

DOCS=( README.md )
