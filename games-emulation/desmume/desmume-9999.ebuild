# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic git-r3 meson xdg

DESCRIPTION="Nintendo DS emulator"
HOMEPAGE="https://desmume.org/ https://github.com/TASEmulators/desmume"

EGIT_REPO_URI="https://github.com/TASEmulators/${PN}.git"

S="${WORKDIR}/${P}"

LICENSE="GPL-2+"
SLOT="0"
IUSE="cli +gui gdb openal wifi"
REQUIRED_USE="|| ( cli gui )"

RDEPEND="
	dev-libs/glib:2
	media-libs/libsdl2[X,opengl,sound,video]
	media-libs/libsoundtouch:=
	net-libs/libpcap
	virtual/zlib:=
	x11-libs/agg
	x11-libs/libX11
	gui? (
		media-libs/libglvnd[X]
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
	)
	openal? ( media-libs/openal )
	!openal? ( media-libs/alsa-lib )
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

DOCS=( ${PN}/{AUTHORS,ChangeLog,README,README.LIN,doc/.} )

src_prepare() {
	default
	sed -e 's|Name=DeSmuME (Gtk)|Name=DeSmuME|' -i "${S}/${PN}/src/frontend/posix/gtk/org.desmume.DeSmuME.desktop" || die
}

src_configure() {
	append-flags -fno-strict-aliasing
	append-cppflags -D_XOPEN_SOURCE=500
	filter-lto

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
