# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 desktop

DESCRIPTION="Official ProtonVPN Linux app"
HOMEPAGE="https://protonvpn.com https://github.com/ProtonVPN/proton-vpn-gtk-app"
SRC_URI="https://github.com/ProtonVPN/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ProtonVPN/python-proton-vpn-connection/archive/refs/tags/0.11.0.tar.gz -> ppv-connection-0.11.0.tar.gz
	https://github.com/ProtonVPN/python-proton-vpn-network-manager/archive/refs/tags/0.3.0.tar.gz -> ppv-network-manager-0.3.0.tar.gz
	https://github.com/ProtonVPN/python-proton-vpn-network-manager-openvpn/archive/refs/tags/0.0.4.tar.gz -> ppv-network-manager-openvpn-0.0.4.tar.gz
	https://github.com/ProtonVPN/python-proton-vpn-api-core/archive/refs/tags/0.20.1.tar.gz -> ppv-api-core-0.20.1.tar.gz
	https://github.com/ProtonVPN/python-proton-vpn-session/archive/refs/tags/0.6.2.tar.gz -> ppv-session-0.6.2.tar.gz
	https://github.com/ProtonVPN/python-proton-keyring-linux/archive/refs/tags/0.0.1.tar.gz -> pp-keyring-linux-0.0.1.tar.gz
	https://github.com/ProtonVPN/python-proton-keyring-linux-secretservice/archive/refs/tags/0.0.1.tar.gz -> pp-keyring-linux-secretservice-0.0.1.tar.gz
	https://github.com/ProtonVPN/python-proton-vpn-killswitch-network-manager/archive/refs/tags/0.2.0.tar.gz -> ppv-killswitch-network-manager-0.2.0.tar.gz
	https://github.com/ProtonVPN/python-proton-vpn-killswitch/archive/refs/tags/0.2.0.tar.gz -> ppv-killswitch-0.2.0.tar.gz
	https://github.com/ProtonVPN/python-proton-vpn-logger/archive/refs/tags/0.2.1.tar.gz -> ppv-logger-0.2.1.tar.gz
	https://github.com/ProtonVPN/python-proton-core/archive/refs/tags/0.1.15.tar.gz -> pp-core-0.1.15.tar.gz
"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""
RESTRICT="test primaryuri" # only has dummy tests anyway

RDEPEND="
	dev-python/python-gnupg[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/pynacl[${PYTHON_USEDEP}]
	dev-python/bcrypt[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_compile() {
	for d in "${S}"/*; do
		if [ -d "$d" ]; then
			cd "$d" || return
			distutils-r1_src_compile
		fi
	done
}

src_install() {
	for d in "${S}"/*; do
		if [[ "$d" == *"build-python"* ]]; then
			continue
		fi
		if [ -d "$d" ]; then
			cd "$d" || return
			distutils-r1_src_install
		fi
	done

	domenu "${S}/${P}/rpmbuild/SOURCES/protonvpn-app.desktop"
	doicon "${S}/${P}/rpmbuild/SOURCES/proton-vpn-logo.svg"
}


#DOCS=( README.md )
