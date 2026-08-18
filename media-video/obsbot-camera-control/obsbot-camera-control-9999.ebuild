# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop systemd xdg

DESCRIPTION="Qt application for controlling OBSBOT cameras on Linux"
HOMEPAGE="https://github.com/aaronsb/obsbot-camera-control"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/aaronsb/obsbot-camera-control.git"
else
	SRC_URI="https://github.com/aaronsb/obsbot-camera-control/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

# The bundled OBSBOT SDK has no upstream license grant.
LICENSE="MIT all-rights-reserved"
SLOT="0"
IUSE="+lsof virtual-camera"

DEPEND="
	dev-qt/qtbase:6[gui,opengl,widgets]
	dev-qt/qtmultimedia:6
"
RDEPEND="
	${DEPEND}
	lsof? ( sys-process/lsof )
	virtual-camera? ( media-video/v4l2loopback )
"
BDEPEND="dev-util/patchelf"

# The proprietary SDK is only distributed as an amd64 binary.
QA_PREBUILT="usr/lib*/${PN}/libdev.so.1.0.2"

DOCS=( README.md )

src_install() {
	dobin bin/obsbot-{cli,gui}

	# Keep the generically named vendor library private to this package.
	insinto /usr/$(get_libdir)/${PN}
	insopts -m0755
	doins sdk/lib/libdev.so.1.0.2

	patchelf --remove-rpath \
		"${ED}/usr/$(get_libdir)/${PN}/libdev.so.1.0.2" || die
	local sdk_rpath="\$ORIGIN/../$(get_libdir)/${PN}"
	patchelf --set-rpath "${sdk_rpath}" "${ED}"/usr/bin/obsbot-{cli,gui} || die

	insopts -m0644
	domenu obsbot-control.desktop
	newicon -s scalable resources/icons/camera.svg obsbot-control.svg

	if use virtual-camera ; then
		insinto /usr/lib/modprobe.d
		doins resources/modprobe.d/obsbot-virtual-camera.conf
		systemd_dounit resources/systemd/obsbot-virtual-camera.service
	fi

	einstalldocs
}
