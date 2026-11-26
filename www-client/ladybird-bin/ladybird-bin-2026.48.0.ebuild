# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature unpacker xdg

DESCRIPTION="Truly independent web browser (official alpha binary)"
HOMEPAGE="https://ladybird.org/ https://github.com/LadybirdBrowser/ladybird"
SRC_URI="
	amd64? ( https://apt.ladybird.org/pool/main/l/ladybird/ladybird_${PV}-1~ubuntu24.04_amd64.deb )
	arm64? ( https://apt.ladybird.org/pool/main/l/ladybird/ladybird_${PV}-1~ubuntu24.04_arm64.deb )
"
S="${WORKDIR}"

# Includes the bundled libraries, Rust crates, and fonts.
LICENSE="AFL-2.1 Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 BZIP2
	CC0-1.0 FTL IJG ISC LGPL-2.1+ LGPL-3+ libpng2 MIT MPL-2.0 OFL-1.1
	public-domain Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
REQUIRED_USE="elibc_glibc"
RESTRICT="mirror strip"

RDEPEND="
	!www-client/ladybird
	app-misc/ca-certificates
	>=dev-libs/glib-2.79:2
	>=dev-libs/wayland-1.20
	media-fonts/liberation-fonts
	media-libs/libglvnd
	media-libs/libpulse
	>=media-libs/vulkan-loader-1.3.204
	>=sys-devel/gcc-14:*[cxx]
	>=sys-libs/glibc-2.39
	>=x11-libs/libX11-1.8.7
	x11-libs/libdrm
	>=x11-libs/libxcb-1.15
	x11-libs/libxkbcommon[X]
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
"

QA_PREBUILT="opt/ladybird/*"

src_prepare() {
	default

	# The Debian marker makes the update UI recommend apt commands on Gentoo.
	rm opt/ladybird/share/Lagom/package-format || die
}

src_install() {
	dodir /opt
	cp -a opt/ladybird "${ED}/opt/" || die
	dosym ../../opt/ladybird/bin/Ladybird /usr/bin/ladybird

	insinto /usr/share
	doins -r usr/share/.
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "additional media codecs (H.264/AAC)" media-video/ffmpeg
}
