# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

if [[ "${PV}" == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/zsh-users/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/zsh-users/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Fish-like autosuggestions for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-autosuggestions"

LICENSE="MIT"
SLOT="0"

RDEPEND=">=app-shells/zsh-4.3.11"

DOC_CONTENTS="To use ${CATEGORY}/${PN}, add
'source /usr/share/zsh/site-functions/${PN}.zsh'
at the end of your ~/.zshrc"

src_install() {
	readme.gentoo_create_doc
	insinto "/usr/share/zsh/site-functions/"
	doins "${PN}.zsh"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
