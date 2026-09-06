# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Omnissa Horizon Client for Linux"
HOMEPAGE="https://www.omnissa.com/products/horizon-8/
	https://customerconnect.omnissa.com/downloads/info/slug/virtual_desktop_and_apps/omnissa_horizon_clients/8"

MY_BUILD="8.19.0-32216036411"
MY_P="Omnissa-Horizon-Client-Linux-${PV}-${MY_BUILD}"

SRC_URI="https://download3.omnissa.com/software/CART27FQ2_LIN_2606_TARBALL/${MY_P}.tar.gz"
S="${WORKDIR}"

LICENSE="omnissa"
SLOT="0"
KEYWORDS="~amd64"
IUSE="next"
RESTRICT="bindist mirror strip"

RDEPEND="
	app-accessibility/at-spi2-core:2
	app-shells/bash
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/openssl
	media-libs/fontconfig
	media-libs/freetype
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	media-libs/harfbuzz
	media-libs/libpng:0/16
	media-libs/libpulse
	media-libs/libv4l
	media-libs/libva[X]
	media-libs/mesa
	sys-apps/pcsc-lite
	sys-apps/util-linux
	virtual/libudev
	virtual/zlib
	x11-libs/cairo[X]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libdrm
	x11-libs/libvdpau
	x11-libs/libxcb
	x11-libs/libxkbfile
	x11-libs/pango[X]
	next? ( dev-util/lttng-ust-compat )
"

QA_PREBUILT="*"

src_unpack() {
	default

	unpack "${MY_P}/x64/Omnissa-Horizon-Client-${PV}-${MY_BUILD}.x64.tar.gz"
	unpack "${MY_P}/x64/Omnissa-Horizon-PCoIP-${PV}-${MY_BUILD}.x64.tar.gz"
}

src_prepare() {
	default

	local component_dir file
	local libdir
	libdir=$(get_libdir)

	for component_dir in \
		"${WORKDIR}/Omnissa-Horizon-Client-${PV}-${MY_BUILD}.x64" \
		"${WORKDIR}/Omnissa-Horizon-PCoIP-${PV}-${MY_BUILD}.x64"
	do
		while IFS= read -r -d '' file; do
			sed -i -e "s:/usr/lib\\>:/usr/${libdir}:g" "${file}" || die
		done < <(grep -IlRZ '/usr/lib' "${component_dir}")
	done

	sed -i \
		-e 's/^Categories=Application;Network;$/Categories=Network;RemoteAccess;/' \
		-e '/^Encoding=UTF-8$/d' \
		"${WORKDIR}/Omnissa-Horizon-Client-${PV}-${MY_BUILD}.x64"/usr/share/applications/*.desktop || die
}

src_install() {
	local client_dir="${WORKDIR}/Omnissa-Horizon-Client-${PV}-${MY_BUILD}.x64"
	local pcoip_dir="${WORKDIR}/Omnissa-Horizon-PCoIP-${PV}-${MY_BUILD}.x64"
	local component_dir file relative
	local libdir
	libdir=$(get_libdir)

	dobin "${client_dir}"/usr/bin/*

	insinto /usr/share
	doins -r "${client_dir}"/usr/share/*

	insinto "/usr/${libdir}"
	doins -r "${client_dir}"/usr/lib/*
	doins -r "${pcoip_dir}"/usr/lib/*

	for component_dir in "${client_dir}" "${pcoip_dir}"; do
		while IFS= read -r -d '' file; do
			relative=${file#"${component_dir}/usr/lib/"}
			fperms 0755 "/usr/${libdir}/${relative}"
		done < <(find "${component_dir}/usr/lib" -type f -perm /111 -print0)
	done

	if ! use next; then
		rm "${ED}/usr/bin/horizon-client-next" || die
		rm "${ED}/usr/share/applications/horizon-client-next.desktop" || die
		rm -r "${ED}/usr/${libdir}/omnissa/horizon/bin/horizon-client-next-bundle" || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	einfo "Omnissa supports the classic client on X11."
	if use next; then
		einfo "Horizon Client Next is a technology preview."
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}
