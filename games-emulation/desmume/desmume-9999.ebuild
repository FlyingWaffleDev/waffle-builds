# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg git-r3 meson

DESCRIPTION="Nintendo DS emulator"
HOMEPAGE="https://desmume.org/ https://github.com/TASVideos/desmume"

EGIT_REPO_URI="https://github.com/TASVideos/${PN}.git"

S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="cli +gui gdb hud openal soundtouch wifi"

RDEPEND="
	media-libs/alsa-lib
	media-libs/libsdl2[X,joystick,opengl,video]
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	gui? ( x11-libs/gtk+:3 )
	openal? ( media-libs/openal )
	soundtouch? ( media-libs/soundtouch )
	hud? ( x11-libs/agg )
	"

DEPEND="${RDEPEND}
	net-libs/libpcap
	x11-base/xorg-proto
	virtual/pkgconfig
	"

DOCS=( ${PN}/{AUTHORS,ChangeLog,README,README.LIN,doc/.} )

src_prepare() {
	default
	sed -e 's|Name=DeSmuME (Gtk)|Name=DeSmuME|' -i "${S}/${PN}/src/frontend/posix/gtk/org.desmume.DeSmuME.desktop" || die
}

src_configure() {
	local EMESON_SOURCE="${S}/${PN}/src/frontend/posix"
	local emesonargs=(
		$(meson_use cli frontend-cli)
		$(meson_use gdb gdb-stub)
		$(meson_use gui frontend-gtk)
		$(meson_use openal)
		$(meson_use wifi)
	)
	meson_src_configure
}
