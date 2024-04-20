# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 desktop

DESCRIPTION="Official ProtonVPN Linux app"
HOMEPAGE="https://protonvpn.com https://github.com/ProtonVPN/${PN}"
SRC_URI="https://github.com/ProtonVPN/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+networkmanager"
RESTRICT="test primaryuri" # only has dummy tests anyway

RDEPEND="
	net-vpn/python-proton-core[${PYTHON_USEDEP}]
	net-vpn/python-proton-keyring-linux[${PYTHON_USEDEP}]
	net-vpn/python-proton-keyring-linux-secretservice[${PYTHON_USEDEP}]
	net-vpn/python-proton-vpn-api-core[${PYTHON_USEDEP}]
	net-vpn/python-proton-vpn-connection[${PYTHON_USEDEP}]
	net-vpn/python-proton-vpn-killswitch[${PYTHON_USEDEP}]
	net-vpn/python-proton-vpn-killswitch-network-manager[${PYTHON_USEDEP},networkmanager]
	net-vpn/python-proton-vpn-logger[${PYTHON_USEDEP}]
	net-vpn/python-proton-vpn-network-manager[${PYTHON_USEDEP},networkmanager]
	net-vpn/python-proton-vpn-network-manager-openvpn[${PYTHON_USEDEP},networkmanager]
	net-vpn/python-proton-vpn-session[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/bcrypt[${PYTHON_USEDEP}]
	dev-python/python-gnupg[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pynacl[${PYTHON_USEDEP}]
	dev-python/sentry-sdk[${PYTHON_USEDEP}]
	dev-python/secretstorage[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
"

BDEPEND="${RDEPEND}"

DEPEND="${RDEPEND}"

src_install() {
	default
	distutils-r1_src_install

	rm "${D}/usr/version.py"
	rm "${D}/usr/versions.yml"

	domenu "${WORKDIR}/${P}/rpmbuild/SOURCES/protonvpn-app.desktop"
	doicon "${WORKDIR}/${P}/rpmbuild/SOURCES/proton-vpn-logo.svg"
}

