# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="http://www.blender.org/"

SRC_URI="https://mirror.clarkson.edu/blender/release/Blender2.93/blender-${PV}-linux-x64.tar.xz"

LICENSE="|| ( GPL-2 BL )"
SLOT="2.93"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist primaryuri strip"

DEPEND="sys-libs/ncurses-compat"

QA_PREBUILT="*"

S="${WORKDIR}/blender-${PV}-linux-x64"

src_prepare() {
	default
	sed -e 's|Exec=blender|Exec=blender-bin|' -i ${S}/blender.desktop || die
	mv ${S}/blender.desktop ${S}/blender-bin.desktop
}

src_install() {
	dodir /opt/blender
	cp -pPR ${S}/* ${D}/opt/blender || die "Failed to copy files"

	domenu ${S}/blender-bin.desktop
	newicon -s scalable ${S}/blender.svg blender
	dosym ../blender/blender /opt/bin/${PN}
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

