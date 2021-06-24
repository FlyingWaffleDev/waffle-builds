# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Proton account login backend"
HOMEPAGE="https://protonvpn.com https://protonmail.com https://github.com/ProtonMail/proton-python-client"
SRC_URI="https://github.com/ProtonMail/proton-python-client/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
RESTRICT="primaryuri"

RDEPEND="
	dev-python/requests
	dev-python/bcrypt
	dev-python/python-gnupg
	dev-python/pyopenssl
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/proton-python-client-${PV}"

DOCS=( README.md )
