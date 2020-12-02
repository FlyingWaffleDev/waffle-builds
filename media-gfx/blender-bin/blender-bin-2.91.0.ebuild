# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="http://www.blender.org/"

SRC_URI="https://builder.blender.org/download/blender-${PV}-linux64.tar.xz -> ${P}.tar.xz"

LICENSE="|| ( GPL-2 BL )"
SLOT="2.91"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

QA_PREBUILT="
	/opt/blender-bin/blender-bin
	/opt/blender-bin/$SLOT/python/lib/python3.7/lib-dynload/*.so
	/opt/blender-bin/$SLOT/python/lib/python3.7/site-packages/libextern_draco.so
	/opt/blender-bin/$SLOT/python/lib/python3.7/site-packages/numpy/fft/*.so
	/opt/blender-bin/$SLOT/python/lib/python3.7/site-packages/numpy/core/*.so
	/opt/blender-bin/$SLOT/python/lib/python3.7/site-packages/numpy/linalg/*.so
	/opt/blender-bin/$SLOT/python/lib/python3.7/site-packages/numpy/random/*.so
	/opt/blender-bin/$SLOT/scripts/addons/cycles/lib/*.cubin
	"

S="${WORKDIR}/blender-${PV}-linux64"

src_prepare() {
	default
	sed -e 's|Exec=blender|Exec=/opt/blender-bin/blender-bin|' -i ${S}/blender.desktop || die
	mv ${S}/blender ${S}/blender-bin
	mv ${S}/blender.desktop ${S}/blender-bin.desktop
}

src_install() {
	insinto /opt/blender-bin
	doins -r ${S}/*
	exeinto /opt/blender-bin
	doexe ${S}/blender-bin
	domenu ${S}/blender-bin.desktop
	newicon ${S}/blender.svg blender
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}

