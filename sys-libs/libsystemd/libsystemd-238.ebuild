# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="systemd"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/systemd/systemd.git"
	inherit git-r3
else
	SRC_URI="https://github.com/systemd/systemd/archive/v${PV}/${MY_PN}-${PV}.tar.gz
		https://dev.gentoo.org/~floppym/dist/systemd-${PV}-patches-0.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"
fi

PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit bash-completion-r1 linux-info meson multilib-minimal ninja-utils pam python-any-r1 systemd toolchain-funcs udev user

DESCRIPTION="System library to support SD-BUS without systemd, yea, for Linux"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0/2"
IUSE="audit binmerge +gcrypt usrmerge"

REQUIRED_USE=""
RESTRICT="test"

MINKV="3.11"

COMMON_DEPEND=">=sys-apps/util-linux-2.30:0=[${MULTILIB_USEDEP}]
	sys-libs/libcap:0=[${MULTILIB_USEDEP}]
	!<sys-libs/glibc-2.16
	audit? ( >=sys-process/audit-2:0= )
	gcrypt? ( >=dev-libs/libgcrypt-1.4.5:0=[${MULTILIB_USEDEP}] )"

# baselayout-2.2 has /run
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/baselayout-2.2"

# sys-apps/dbus: the daemon only (+ build-time lib dep for tests)
PDEPEND="
	>=sys-apps/hwids-20150417[udev]
	>=sys-fs/udev-init-scripts-25"

# Newer linux-headers needed by ia64, bug #480218
DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	>=dev-util/intltool-0.50
	>=sys-apps/coreutils-8.16
	>=sys-kernel/linux-headers-${MINKV}
	virtual/pkgconfig
	dev-libs/libxslt:0
	$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')
	!sys-apps/systemd
"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		local CONFIG_CHECK="~AUTOFS4_FS ~BLK_DEV_BSG ~CGROUPS
			~CHECKPOINT_RESTORE ~DEVTMPFS ~EPOLL ~FANOTIFY ~FHANDLE
			~INOTIFY_USER ~IPV6 ~NET ~NET_NS ~PROC_FS ~SIGNALFD ~SYSFS
			~TIMERFD ~TMPFS_XATTR ~UNIX
			~CRYPTO_HMAC ~CRYPTO_SHA256 ~CRYPTO_USER_API_HASH
			~!FW_LOADER_USER_HELPER_FALLBACK ~!GRKERNSEC_PROC ~!IDE ~!SYSFS_DEPRECATED
			~!SYSFS_DEPRECATED_V2"

		kernel_is -lt 3 7 && CONFIG_CHECK+=" ~HOTPLUG"
		kernel_is -lt 4 7 && CONFIG_CHECK+=" ~DEVPTS_MULTIPLE_INSTANCES"
		kernel_is -ge 4 10 && CONFIG_CHECK+=" ~CGROUP_BPF"

		if linux_config_exists; then
			local uevent_helper_path=$(linux_chkconfig_string UEVENT_HELPER_PATH)
			if [[ -n ${uevent_helper_path} ]] && [[ ${uevent_helper_path} != '""' ]]; then
				ewarn "It's recommended to set an empty value to the following kernel config option:"
				ewarn "CONFIG_UEVENT_HELPER_PATH=${uevent_helper_path}"
			fi
			if linux_chkconfig_present X86; then
				CONFIG_CHECK+=" ~DMIID"
			fi
		fi

		if kernel_is -lt ${MINKV//./ }; then
			ewarn "Kernel version at least ${MINKV} required"
		fi

		check_extra_config
	fi
}

pkg_setup() {
	:
}

src_unpack() {
	default
	[[ ${PV} != 9999 ]] || git-r3_src_unpack
}

src_prepare() {
	local PATCHES=()

	[[ -d "${WORKDIR}"/patches ]] && PATCHES+=( "${WORKDIR}"/patches )

	PATCHES+=(
		"${FILESDIR}/238-libmount-include.patch"
		"${FILESDIR}/238-initctl.patch"
		"${FILESDIR}/238-nspawn-wait.patch"
		"${FILESDIR}/${PN}-238-meson_build.patch"
	)

	default

	# meson.build patch magic
	sed '/sd-device/,/sd-utf8/d' -i "${S}/src/libsystemd/meson.build" || die

	# replace files after patchwork
	cp -v "${S}/meson.build" "${S}/meson.build.orig" || die
	cp -v "${S}/src/libsystemd/libsystemd.sym" "${S}/src/libsystemd/libsystemd.sym.orig" || die

	cp -v "${FILESDIR}/${PN}-238-meson.build" "${S}/meson.build" || die
	cp -v "${FILESDIR}/${PN}-238-libsystemd.sym" "${S}/src/libsystemd/libsystemd.sym" || die
}

src_configure() {
	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB

	python_setup

	multilib-minimal_src_configure
}

meson_use() {
	usex "$1" true false
}

meson_multilib_native_use() {
	if multilib_is_native_abi && use "$1"; then
		echo true
	else
		echo false
	fi
}

multilib_src_configure() {
	local myconf=(
		--localstatedir="${EPREFIX}/var"
		# make sure we get /bin:/sbin in PATH
		-Dsplit-bin=$(usex binmerge false true)
		-Dsplit-usr=$(usex usrmerge false true)
		-Drootprefix="$(usex usrmerge "${EPREFIX}/usr" "${EPREFIX:-/}")"
		-Daudit=$(meson_multilib_native_use audit)
		-Dgcrypt=$(meson_use gcrypt)
	)

	meson_src_configure "${myconf[@]}"
}

multilib_src_compile() {
	eninja
}

multilib_src_test() {
	eninja test
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}
