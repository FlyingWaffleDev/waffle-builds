# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Modern Text User Interface framework"
HOMEPAGE="
	https://textual.textualize.io/
	https://github.com/Textualize/textual
	https://pypi.org/project/textual/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# The test suite requires circular dependencies on textual-dev and
# pytest-textual-snapshot, which are not available in Gentoo.
RESTRICT="test"

RDEPEND="
	dev-python/linkify-it-py[${PYTHON_USEDEP}]
	>=dev-python/markdown-it-py-2.1.0[${PYTHON_USEDEP}]
	dev-python/mdit-py-plugins[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.6.0[${PYTHON_USEDEP}]
	<dev-python/platformdirs-5[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.19.2[${PYTHON_USEDEP}]
	<dev-python/pygments-3[${PYTHON_USEDEP}]
	>=dev-python/rich-14.2.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.4.0[${PYTHON_USEDEP}]
	<dev-python/typing-extensions-5[${PYTHON_USEDEP}]
"
