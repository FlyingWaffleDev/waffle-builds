# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm kde.org

DESCRIPTION="Plasma 5 applet in order to show window buttons in your panels"
HOMEPAGE="https://github.com/psifidotos/applet-window-buttons"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/psifidotos/${PN}.git"
else
	MY_P="${MY_PN}-${PV}"
	SRC_URI="https://github.com/psifidotos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=kde-frameworks/plasma-5.12
	>=kde-frameworks/frameworkintegration-5.38
	>=kde-plasma/kdecoration-5.12
	kde-frameworks/kcoreaddons
	kde-frameworks/kdeclarative"

RDEPEND="${DEPEND}"
