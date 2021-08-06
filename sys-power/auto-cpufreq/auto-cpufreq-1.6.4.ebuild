# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 systemd

DESCRIPTION="Automatic CPU speed & power optimizer for Linux"
HOMEPAGE="https://github.com/AdnanHodzic/auto-cpufreq"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AdnanHodzic/${PN}.git"
else
	SRC_URI="https://github.com/AdnanHodzic/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/psutil
	dev-python/click
	dev-python/distro"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

RESTRICT="mirror"

DOCS=( README.md )

src_prepare() {
	sed -i 's|usr/local|usr|g' "scripts/${PN}.service" source/core.py
	distutils-r1_src_prepare
}

python_install() {
	distutils-r1_python_install

	exeinto "/usr/local/share/${PN}/scripts"
	doexe scripts/cpufreqctl.sh

	systemd_douserunit "scripts/${PN}.service"
}

pkg_postinst() {
	touch /var/log/auto-cpufreq.log

	elog ""
	elog "Enable auto-cpufreq daemon service at boot:"
	elog "systemctl enable --now auto-cpufreq"
	elog ""
	elog "To view live log, run:"
	elog "auto-cpufreq --log"
	elog ""
}

pkg_postrm() {
	# Remove auto-cpufreq log file
	rm /var/log/auto-cpufreq.log

	# Remove auto-cpufreq's cpufreqctl binary
	# it copies cpufreqctl.sh over (I do NOT like this behavior)
	rm /usr/bin/cpufreqctl

	# Restore original cpufreqctl binary if backup was made
	if [ -f "/usr/bin/cpufreqctl.auto-cpufreq.bak" ]; then
		mv /usr/bin/cpufreqctl.auto-cpufreq.bak /usr/bin/cpufreqctl
	fi
}
