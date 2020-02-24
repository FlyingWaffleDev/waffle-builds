# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg autotools git-r3

DESCRIPTION="Nintendo DS emulator"
HOMEPAGE="http://desmume.org/"
#COMMIT="7a3699aba6318ac5818a162dfc55feb3718bcd0e"
#MY_PN="${PN/_/-}"

#SRC_URI="https://github.com/TASVideos/desmume/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
EGIT_REPO_URI="https://github.com/TASVideos/desmume.git"

#S="${WORKDIR}/${MY_PN}-${COMMIT}/desmume/src/frontend/posix"
S="${WORKDIR}/desmume-9999/desmume/src/frontend/posix"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="hud openal osmesa soundtouch wifi"

RDEPEND="
	dev-libs/zziplib
	gnome-base/libglade
	media-libs/libsdl[joystick,opengl,video]
	openal? ( media-libs/openal )
	osmesa? ( media-libs/mesa[osmesa] )
	sys-libs/zlib
	virtual/opengl
	hud? ( x11-libs/agg )
	soundtouch? ( media-libs/soundtouch )
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/intltool
	net-libs/libpcap
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README README.LIN )

src_prepare() {
	default
	eautoreconf
}

src_install(){
	einfo "docs: ${DOCS[@]}"
	for i in "${DOCS[@]}"; do
		dodoc "../../../$i"
	done
	unset DOCS

	default
}

# why does $( use_enable hud ) fail without agg?
src_configure() {
	econf \
		$(use_enable openal) \
		$(use_enable osmesa) \
		$(use_enable wifi) \
		|| die "econf failed"
}
