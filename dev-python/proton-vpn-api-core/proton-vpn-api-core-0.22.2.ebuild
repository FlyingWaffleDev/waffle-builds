EAPI=8
PYTHON_COMPAT=( python3_{10..13} )
inherit python-r1 distutils-r1 git-r3
DESCRIPTION="Proton VPN API Core"
HOMEPAGE="https://github.com/ProtonVPN/python-proton-vpn-api-core"
EGIT_REPO_URI="https://github.com/ProtonVPN/python-proton-vpn-api-core.git"
EGIT_COMMIT="v0.22.2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
    dev-python/requests[${PYTHON_USEDEP}]
    dev-python/jinja2[${PYTHON_USEDEP}]
    dev-python/pynacl[${PYTHON_USEDEP}]
    dev-python/distro[${PYTHON_USEDEP}]
    dev-python/sentry-sdk[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
