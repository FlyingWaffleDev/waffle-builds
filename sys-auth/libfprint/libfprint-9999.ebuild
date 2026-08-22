# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson udev

DESCRIPTION="Library to add support for consumer fingerprint readers"
HOMEPAGE="
	https://fprint.freedesktop.org/
	https://gitlab.freedesktop.org/libfprint/libfprint
"
EGIT_REPO_URI="https://gitlab.freedesktop.org/libfprint/libfprint.git"

LICENSE="LGPL-2.1+"
SLOT="2"
IUSE="examples gtk-doc +introspection"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libgudev
	dev-libs/libgusb
	>=dev-libs/openssl-3:=
	dev-python/pygobject
	x11-libs/pixman
	examples? (
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	introspection? (
		>=dev-libs/gobject-introspection-1.82.0-r2
		dev-libs/libgusb[introspection]
	)
"

export AS_VALIDATE_NONET="true"

src_configure() {
	local emesonargs=(
		$(meson_use examples gtk-examples)
		$(meson_use gtk-doc doc)
		$(meson_use introspection)
		-Ddrivers=all
		-Dinstalled-tests=false
		-Dudev_rules=enabled
		-Dudev_rules_dir=$(get_udevdir)/rules.d
	)
	meson_src_configure
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
