# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson s6

DESCRIPTION="Init-independent launcher and service activation for dbus-broker"
HOMEPAGE="https://github.com/FlyingWaffleDev/dbus-broker-dispatch"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="dinit elogind +openrc pam runit s6 selinux"

RDEPEND="
	sys-apps/dbus
	sys-apps/dbus-broker[-launcher]
	dev-libs/expat
	elogind? ( sys-auth/elogind )
	pam? ( sys-libs/pam )
	selinux? ( sys-libs/libselinux )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/meson
	dev-build/ninja
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Delogind=$(usex elogind true false)
		-Dpam=$(usex pam enabled disabled)
		-Dselinux=$(usex selinux enabled disabled)
	)
	if use pam; then
		emesonargs+=( -Dpam-module-dir="/$(get_libdir)/security" )
	fi
	meson_src_configure
}

src_install() {
	meson_src_install
	if use openrc; then
		newinitd "${S}/init/openrc/dbus.initd" dbus
		newconfd "${S}/init/openrc/dbus.confd" dbus
		exeinto /etc/user/init.d
		newexe "${S}/init/openrc/dbus.user.initd" dbus
		if ! use pam; then
			insinto /etc/profile.d
			newins "${S}/init/openrc/dbus-broker-dispatch.sh" dbus-broker-dispatch.sh
		fi
	fi
	if use runit; then
		exeinto /etc/sv/dbus
		newexe "${S}/init/runit/system/dbus/run" run
		exeinto /usr/share/dbus-broker-dispatch/runit/user/dbus
		newexe "${S}/init/runit/user/dbus/run" run
		if ! use pam; then
			insinto /etc/profile.d
			newins "${S}/init/runit/dbus-broker-dispatch.sh" dbus-broker-dispatch-runit.sh
		fi
	fi
	if use dinit; then
		insinto /etc/dinit.d
		newins "${S}/init/dinit/system/dbus" dbus
		insinto /etc/dinit.d/user
		newins "${S}/init/dinit/user/dbus" dbus
		if ! use pam; then
			insinto /etc/profile.d
			newins "${S}/init/dinit/dbus-broker-dispatch.sh" dbus-broker-dispatch-dinit.sh
		fi
	fi
	if use s6; then
		s6_install_service dbus "${S}/init/s6/system/dbus/run"
		exeinto /usr/share/dbus-broker-dispatch/s6/user/dbus
		newexe "${S}/init/s6/user/dbus/run" run
		if ! use pam; then
			insinto /etc/profile.d
			newins "${S}/init/s6/dbus-broker-dispatch.sh" dbus-broker-dispatch-s6.sh
		fi
	fi
	dodoc README.md
	newdoc init/README.md init-services.md
}

pkg_postinst() {
	if use pam; then
		einfo "The PAM user-bus module is installed but is not inserted into login"
		einfo "stacks automatically. Add the following after pam_elogind.so in each"
		einfo "session stack that should inherit a user bus:"
		einfo "  -session optional pam_dbus_broker_dispatch.so"
		einfo "See the installed README for display manager and regular-login details."
	elif use openrc || use runit || use dinit || use s6; then
		einfo "Login-shell fallbacks are installed in /etc/profile.d. Configure a"
		einfo "user supervisor first for runit, dinit, or s6; see init-services.md."
		einfo "With multiple init flags, set DBUS_BROKER_DISPATCH_INIT before the"
		einfo "profile hooks run. Sessions that do not source profile.d, including"
		einfo "the SDDM greeter, are not covered."
	else
		einfo "Configure a user service manager to start the user bus and publish"
		einfo "DBUS_SESSION_BUS_ADDRESS, or enable the pam USE flag."
	fi
	if use runit || use s6; then
		einfo "Copy the user service directory from /usr/share/dbus-broker-dispatch/"
		einfo "into the user's writable service directory before enabling it."
	fi
}
