# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake pam

DESCRIPTION="A tool to test PAM applications and PAM modules"
HOMEPAGE="https://cwrap.org/pam_wrapper.html"

if [[ "${PV}" == 9999 ]] ; then
        inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/cwrap/pam_wrapper.git"
else
	SRC_URI="https://ftp.samba.org/pub/cwrap/${PN}-${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="sys-libs/pam
	dev-lang/python"

DEPEND="${RDEPEND}
	test? ( dev-util/cmocka )"

S="${WORKDIR}/${PN}-${PV}"

src_configure() {
        local mycmakeargs=(
                -DUNIT_TESTING=$(usex test true false)
        )
        cmake_src_configure
}

src_test() {
	if use test; then
		cmake_src_test
	fi
}
