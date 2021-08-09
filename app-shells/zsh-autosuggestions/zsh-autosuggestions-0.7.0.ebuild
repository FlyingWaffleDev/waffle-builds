# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

if [[ "${PV}" == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/zsh-users/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/zsh-users/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Fish shell-like autosuggestions for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-autosuggestions"
LICENSE="MIT"
SLOT="0"
RESTRICT="primaryuri"

RDEPEND=">=app-shells/zsh-4.3.11"

DOCS=(
	CHANGELOG.md
	README.md
)

DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS="In order to use ${CATEGORY}/${PN} add
. /usr/share/zsh/plugins/${PN}/${PN}.zsh
at the end of your ~/.zshrc"

src_prepare() {
	default
	emake clean
}

src_install() {
	einstalldocs
	readme.gentoo_create_doc
	insinto "/usr/share/zsh/plugins/${PN}"
	doins "${PN}.zsh"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
