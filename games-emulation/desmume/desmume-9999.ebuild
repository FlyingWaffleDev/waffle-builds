# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg git-r3 meson

DESCRIPTION="Nintendo DS emulator"
HOMEPAGE="https://desmume.org/ https://github.com/TASVideos/desmume"

EGIT_REPO_URI="https://github.com/TASVideos/${PN}.git"

S="${WORKDIR}/${P}/${PN}/src/frontend/posix"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="hud openal soundtouch wifi glade"

RDEPEND="
	x11-libs/gtk+:2
	media-libs/libsdl[joystick,opengl,video]
	sys-libs/zlib
	virtual/opengl
	openal? ( media-libs/openal )
	soundtouch? ( media-libs/soundtouch )
	hud? ( x11-libs/agg )
	glade? ( gnome-base/libglade )
	"

DEPEND="${RDEPEND}
	net-libs/libpcap
	virtual/pkgconfig
	"

DOCS=( ../../../README ../../../README.LIN )

src_configure() {
	local emesonargs=(
		$(meson_use openal)
		$(meson_use wifi)
	)
	meson_src_configure
}
