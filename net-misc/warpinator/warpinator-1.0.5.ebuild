# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit meson

DESCRIPTION="Local network filesharing utility from Linux Mint"
HOMEPAGE="https://linuxmint.com https://github.com/linuxmint/warpinator"
SRC_URI="https://github.com/linuxmint/warpinator/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND=">=dev-python/grpcio-1.16.0
	>=dev-python/xapp-1.6.0
	dev-python/pygobject
	dev-python/cryptography
	dev-python/pynacl
	dev-python/zeroconf
	dev-python/setproctitle
	x11-libs/gtk+
	dev-python/protobuf-python"

DEPEND=">=dev-python/grpcio-tools-1.14.0
	>=dev-libs/protobuf-3.6.1
	>=dev-python/protobuf-python-3.6.1
	dev-libs/gobject-introspection"

S="${WORKDIR}/${PN}-${PV}"

#src_prepare() {
#	eapply_user
#	cd "${S}"
#	# Fix hard-coded libexec dir
#	sed -i 's/libexec/lib/g' \
#		"bin/${pkgname%-git}" \
#		install-scripts/meson_generate_and_install_protobuf_files.py
#}

DOCS=( README.md )
