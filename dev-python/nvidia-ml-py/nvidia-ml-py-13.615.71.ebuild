# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN//-/_}
PYTHON_COMPAT=( python3_{12..15} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="Python bindings to the NVIDIA Management Library"
HOMEPAGE="https://pypi.org/project/nvidia-ml-py/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND="x11-drivers/nvidia-drivers"

python_prepare_all() {
	# Install the example as documentation only when requested.
	sed -i -e "s/, 'example'//g" setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc example.py
	fi
}
