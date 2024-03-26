# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic
SRC_URI="https://dev.gentoo.org/~aidecoe/distfiles/${CATEGORY}/${PN}/gentoo-logo.png"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/plymouth/plymouth"
else
	SRC_URI="${SRC_URI} https://www.freedesktop.org/software/plymouth/releases/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

inherit meson readme.gentoo-r1 systemd

DESCRIPTION="Graphical boot animation (splash) and logger"
HOMEPAGE="https://cgit.freedesktop.org/plymouth/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug docs +drm freetype +gtk +pango selinux systemd +udev"

CDEPEND="
	>=media-libs/libpng-1.2.16:=
	drm? ( x11-libs/libdrm )
	gtk? (
		dev-libs/glib:2
		>=x11-libs/gtk+-3.14:3
		x11-libs/cairo
	)
	pango? ( >=x11-libs/pango-1.21 )
	freetype? ( media-libs/freetype:2 )
"
DEPEND="${CDEPEND}
	elibc_musl? ( sys-libs/rpmatch-standalone )
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
"
# Block due bug #383067
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-plymouthd )
	udev? ( virtual/udev )
	!<sys-kernel/dracut-0.37-r3
"

DOC_CONTENTS="
	Follow the following instructions to set up Plymouth:\n
	https://wiki.gentoo.org/wiki/Plymouth#Configuration
"

src_prepare() {
	use elibc_musl && append-ldflags -lrpmatch
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use debug tracing)
		$(meson_use systemd systemd-integration)
		$(meson_use drm)
		$(meson_feature gtk)
		$(meson_feature pango)
		$(meson_feature freetype)
		$(meson_feature udev)
		$(meson_use docs)
	)
	meson_src_configure
}

src_install() {
	default

	meson_install

	insinto /usr/share/plymouth
	newins "${DISTDIR}"/gentoo-logo.png bizcom.png

	readme.gentoo_create_doc

	rm -rf "${D}"/var/run
	rm -rf "${D}"/run
	rm -rf "${D}"/var/lib/lib

	keepdir /var/spool/plymouth
	keepdir /var/lib/plymouth

	# fix broken symlink
	dosym ../../bizcom.png /usr/share/plymouth/themes/spinfinity/header-image.png
}

pkg_postinst() {
	readme.gentoo_print_elog
	if ! has_version "sys-kernel/dracut"; then
		ewarn "If you want initramfs builder with plymouth support, please emerge"
		ewarn "sys-kernel/dracut or sys-kernel/genkernel."
	fi
}
