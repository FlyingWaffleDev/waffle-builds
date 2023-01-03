# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm

DESCRIPTION="A fork of BreezeEnhanced to make it (arguably) more minimalistic and informative"
HOMEPAGE="https://github.com/kupiqu/SierraBreezeEnhanced"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kupiqu/SierraBreezeEnhanced.git"
else
	SRC_URI="https://github.com/kupiqu/SierraBreezeEnhanced/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="kde-frameworks/plasma
	dev-qt/qtx11extras
	kde-plasma/kdecoration
	dev-qt/qtdeclarative"

RDEPEND="${DEPEND}"
