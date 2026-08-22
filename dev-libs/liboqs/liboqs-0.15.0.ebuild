# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C library for quantum-resistant cryptographic algorithms"
HOMEPAGE="https://openquantumsafe.org/ https://github.com/open-quantum-safe/liboqs"
SRC_URI="https://github.com/open-quantum-safe/liboqs/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT public-domain || ( CC0-1.0 Apache-2.0 )"
SLOT="0/9"
KEYWORDS="~amd64"
RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DOQS_BUILD_ONLY_LIB=ON
		-DOQS_DIST_BUILD=ON
		-DOQS_MINIMAL_BUILD="KEM_kyber_1024;KEM_classic_mceliece_348864"
		-DOQS_USE_OPENSSL=OFF
	)

	cmake_src_configure
}
