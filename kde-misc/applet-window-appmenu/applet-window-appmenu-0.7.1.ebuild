# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm

DESCRIPTION="Plasma 5 applet in order to show window appmenu in your panels"
HOMEPAGE="https://github.com/psifidotos/applet-window-appmenu"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/psifidotos/${PN}.git"
else
	SRC_URI="https://github.com/psifidotos/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="5"
RESTRICT="primaryuri"

DEPEND="dev-libs/libdbusmenu-qt
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	kde-frameworks/kconfigwidgets:5
	kde-plasma/kdecoration:5
	kde-frameworks/kwayland:5
	kde-frameworks/kwindowsystem:5
	kde-frameworks/plasma:5
	kde-plasma/plasma-workspace:5
	x11-libs/libSM
	x11-libs/libxcb
	x11-libs/libXrandr"

# Qt >= 5.9
# KF5 >= 5.38
# Plasma >= 5.12
# plasma-workspace-devel >= 5.19.0 [for wayland support]
# Qt elements: Quick Widgets DBus
# KF5 elements: Plasma WindowSystem KDecoration2 Kirigami2 extra-cmake-modules
# X11 libraries: XCB RandR
# Plasma Workspace: LibTaskManager

DOCS=( {CHANGELOG,README}.md )
