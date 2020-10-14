# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson pam systemd

DESCRIPTION="D-Bus service to access fingerprint readers - live version"
HOMEPAGE="https://fprint.freedesktop.org/ https://gitlab.freedesktop.org/libfprint/fprintd"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/libfprint/fprintd.git"
else
	SRC_URI="https://gitlab.freedesktop.org/libfprint/${PN}/-/archive/${PV}/${P}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc pam test"

RDEPEND="
	sys-apps/systemd
	sys-apps/dbus
	dev-libs/dbus-glib
	dev-libs/glib:2
	>=sys-auth/libfprint-1.90.0
	sys-auth/polkit
	pam? ( sys-libs/pam )
	"

DEPEND="
	${RDEPEND}
	test? ( dev-python/dbus-python
		dev-python/dbusmock
		dev-python/pycairo
		pam? ( >=sys-auth/pam_wrapper-1.1.0 )
	)
	doc? (
		dev-util/gtk-doc
		dev-util/gtk-doc-am
	)
	"

S="${WORKDIR}/${PN}-${PV}"

RESTRICT="
	!test? ( test )
	mirror
	"

src_configure() {
	if ! use test ; then
		sed -i '181d' meson.build || die "couldn't disable tests"
		sed -i '158d' meson.build || die "couldn't disable tests"
		sed -i '121,135d' meson.build || die "couldn't disable tests"
		sed -i '117d' meson.build || die "couldn't disable tests"
	fi
	local emesonargs=(
		-Dpam=$(usex pam true false)
		-Dman=true
		-Dsystemd_system_unit_dir="$(systemd_get_systemunitdir)"
		-Dpam_modules_dir="$(getpam_mod_dir)"
		-Dgtk_doc=$(usex doc true false)
	)
	meson_src_configure
}
