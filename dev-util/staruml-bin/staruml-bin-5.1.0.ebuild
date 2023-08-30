# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm xdg-utils

DESCRIPTION="A sophisticated software modeler"
HOMEPAGE="http://staruml.io/"
#SRC_URI="https://staruml.io/download/releases-v5/StarUML_${PV}_amd64.deb"
SRC_URI="https://staruml.io/download/releases-v5/StarUML-${PV}.x86_64.rpm"

LICENSE="StarUML-EULA"
SLOT="0"
KEYWORDS="~amd64 "
IUSE=""
RESTRICT="bindist mirror splitdebug"

RDEPEND="
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libgcrypt
	dev-libs/nss
	dev-libs/nspr
	media-libs/fontconfig
	media-libs/freetype
	media-libs/alsa-lib
	net-print/cups
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libX11
	x11-libs/pango
"

S="${WORKDIR}"

#src_unpack() {
#	rpm_src_unpack ${A}
#}

MY_PN=${PN/-bin/}
src_install() {
	mv opt "${ED}" || die
	mkdir -p "${ED}/usr" || die
	mv usr/share "${ED}/usr/" || die
	dosym /opt/StarUML/${MY_PN} /usr/bin/${MY_PN}
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

