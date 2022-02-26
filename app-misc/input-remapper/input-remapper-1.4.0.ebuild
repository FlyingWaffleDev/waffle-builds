# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="An easy to use tool to change the mapping of your input device buttons."
HOMEPAGE="https://github.com/sezanzeb/key-mapper"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sezanzeb/key-mapper.git"
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/sezanzeb/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="primaryuri test"

DISTUTILS_USE_SETUPTOOLS=rdepend

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/pydbus[${PYTHON_USEDEP}]
		dev-python/python-evdev[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
	')
	x11-libs/gtk+:3
	x11-libs/gtksourceview:4
"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

DOCS=( "README.md" "LICENSE" )

