# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Official ProtonVPN Linux app (CLI)"
HOMEPAGE="https://protonvpn.com https://github.com/ProtonVPN/linux-cli"
SRC_URI="https://github.com/ProtonVPN/linux-cli/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE="gui systemd"
RESTRICT="primaryuri"

RDEPEND="
	gui? ( net-vpn/protonvpn-gui )
	dev-python/pythondialog
	net-vpn/protonvpn-nm-lib
	systemd? ( dev-python/python-systemd )
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/linux-cli-${PV}"

DOCS=( README.md )
