# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson pam systemd git-r3

DESCRIPTION="D-Bus service to access fingerprint readers - live version"
HOMEPAGE="https://cgit.freedesktop.org/libfprint/fprintd/"
EGIT_REPO_URI="https://gitlab.freedesktop.org/libfprint/fprintd.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc pam static-libs"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	>=sys-auth/libfprint-9999
	sys-auth/polkit
	pam? ( sys-libs/pam )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	dev-util/intltool
	doc? ( dev-libs/libxml2 dev-libs/libxslt )
"

#PATCHES=( ${FILESDIR}/sys-auth/${PN}/ )

S="${WORKDIR}/fprintd-9999"

src_configure() {
	local emesonargs=(
		-Dpam=true
		-Dman=true
		-Dsystemd_system_unit_dir="$(systemd_get_systemunitdir)"
#		-Ddbus_service_dir="$()"
		-Dpam_modules_dir="$(getpam_mod_dir)"
		-Dgtk_doc=false
	)
	meson_src_configure
}
