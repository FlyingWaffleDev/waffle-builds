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

DESCRIPTION="ZSH port of Fish history search (up arrow)"
HOMEPAGE="https://github.com/zsh-users/zsh-history-substring-search"
LICENSE="BSD"
SLOT="0"
RESTRICT="primaryuri"

RDEPEND=">=app-shells/zsh-4.3.0"

DOC_CONTENTS="In order to use ${CATEGORY}/${PN} add
'source /usr/share/zsh/site-functions/${PN}/${PN}.zsh'
at the end of your ~/.zshrc
If you want to use zsh-syntax-highlighting along with this script,
then make sure that you load it before you load this script.
For further information,  please read the README.md file installed
in ${EROOT}/usr/share/doc/${PF}."

src_install() {
	einstalldocs
	readme.gentoo_create_doc
	insinto "/usr/share/zsh/site-functions/"
	doins "${PN}.zsh"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
