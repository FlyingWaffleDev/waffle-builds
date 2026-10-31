# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Local profile agent for managing eSIMs on eUICC cards"
HOMEPAGE="https://github.com/estkme-group/lpac"
SRC_URI="https://github.com/estkme-group/lpac/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3 LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mbim +pcsc qmi qrtr"
REQUIRED_USE="qrtr? ( qmi )"

DEPEND="
	net-misc/curl[ssl]
	mbim? ( net-libs/libmbim:= )
	pcsc? ( sys-apps/pcsc-lite )
	qmi? ( >=net-libs/libqmi-1.35.5:= )
	qrtr? ( net-libs/libqrtr-glib:= )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-2.3.0-release-version.patch" )

DOCS=( README.md docs/{ENVVARS,FAQ,USAGE}.md )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
		-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=OFF
		-DCMAKE_SKIP_RPATH=ON
		-DLPAC_DYNAMIC_DRIVERS=OFF
		-DLPAC_DYNAMIC_LIBEUICC=OFF
		-DLPAC_WITH_APDU_AT=ON
		-DLPAC_WITH_APDU_GBINDER=OFF
		-DLPAC_WITH_APDU_MBIM=$(usex mbim)
		-DLPAC_WITH_APDU_PCSC=$(usex pcsc)
		-DLPAC_WITH_APDU_QMI=$(usex qmi)
		-DLPAC_WITH_APDU_QMI_QRTR=$(usex qrtr)
		-DLPAC_WITH_HTTP_CURL=ON
	)
	cmake_src_configure
}

pkg_postinst() {
	if use pcsc ; then
		elog "For PC/SC card readers, install the appropriate reader driver (usually"
		elog "app-crypt/ccid) and start the pcscd service before using lpac."
	fi
}
