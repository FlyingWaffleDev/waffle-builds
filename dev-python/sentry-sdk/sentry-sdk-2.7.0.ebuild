EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit python-r1 distutils-r1

DESCRIPTION="Sentry SDK for Python"
HOMEPAGE="https://sentry.io/ https://github.com/getsentry/sentry-python/"
SRC_URI="https://files.pythonhosted.org/packages/source/s/sentry-sdk/sentry_sdk-${PV}.tar.gz"
S="${WORKDIR}/sentry_sdk-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
    dev-python/urllib3[${PYTHON_USEDEP}]
    dev-python/certifi[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
