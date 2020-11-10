# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson pam systemd

DESCRIPTION="D-Bus service to access fingerprint readers"
HOMEPAGE="https://fprint.freedesktop.org/ https://gitlab.freedesktop.org/libfprint/fprintd"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/libfprint/${PN}.git"
else
	SRC_URI="https://gitlab.freedesktop.org/libfprint/${PN}/-/archive/${PV}/${P}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +pam test systemd"

RDEPEND="systemd? ( sys-apps/systemd )
	!systemd? ( sys-auth/elogind )
	sys-apps/dbus
	dev-libs/dbus-glib
	dev-libs/glib:2
	>=sys-auth/libfprint-1.90.0
	sys-auth/polkit
	pam? ( sys-libs/pam )"

DEPEND="${RDEPEND}
	test? ( dev-python/dbus-python
		dev-python/dbusmock
		dev-python/pycairo
		pam? ( >=sys-libs/pam_wrapper-1.1.0 )
	)
	doc? (
		dev-util/gtk-doc
		dev-util/gtk-doc-am
	)"

S="${WORKDIR}/${PN}-${PV}"

RESTRICT="mirror
	!test? ( test )"

src_prepare() {
	if ! use test ; then
		eapply "${FILESDIR}/${PV}-tests.patch"
	fi
	if ! use systemd ; then
		eapply "${FILESDIR}/${PV}-elogind.patch"
	fi
	eapply_user
}

src_configure() {
	local emesonargs=(
		-Dman=true
		-Dgtk_doc=$(usex doc true false)
		-Dpam=$(usex pam true false)
		-Dpam_modules_dir=$(usex pam "$(getpam_mod_dir)")
		-Dsystemd_system_unit_dir=$(usex systemd "$(systemd_get_systemunitdir)")
	)
	meson_src_configure
}
