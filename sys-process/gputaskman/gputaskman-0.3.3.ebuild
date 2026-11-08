# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="GPU task manager with per-process VRAM, GPU load, and LLM memory insights"
HOMEPAGE="https://github.com/shanselman/gputaskman"
SRC_URI="https://github.com/shanselman/gputaskman/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="video_cards_nvidia"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/psutil-7.2.2[${PYTHON_USEDEP}]
		>=dev-python/textual-8.2.8[${PYTHON_USEDEP}]
		video_cards_nvidia? ( >=dev-python/nvidia-ml-py-13.615.71[${PYTHON_USEDEP}] )
	')
"

distutils_enable_tests unittest

python_prepare_all() {
	# Allow Gentoo's newer uv-build backend.
	sed -i -e 's/uv_build>=0.9.26,<0.10.0/uv_build>=0.9.26/' \
		pyproject.toml || die

	# AMD monitoring works without NVML or NVIDIA drivers.
	if ! use video_cards_nvidia; then
		sed -i -e '/"nvidia-ml-py>=13.615.71",/d' pyproject.toml || die
	fi

	distutils-r1_python_prepare_all
}

python_test() {
	eunittest -s tests
}
