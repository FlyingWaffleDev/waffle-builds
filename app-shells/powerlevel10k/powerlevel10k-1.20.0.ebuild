# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A theme for Zsh emphasizing speed, flexibility and out-of-the-box experience"
HOMEPAGE="https://github.com/romkatv/powerlevel10k"

# Keep this in sync with gitstatus/build.info for every release.
libgit2ver="tag-2ecf33948a4df9ef45a66c68b8ef24a5e60eaac6"

SRC_URI="https://github.com/romkatv/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/romkatv/libgit2/archive/refs/tags/${libgit2ver}.tar.gz"

LICENSE="MIT GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nerd-fonts"

RDEPEND="
	app-shells/zsh
	nerd-fonts? ( media-fonts/meslo-nerd )"
BDEPEND="dev-build/cmake"

DOCS=(
	README.md
	gitstatus/README.gitstatus.md
	gitstatus/docs/listdir.md
)

src_prepare() {
	default
	sed -i -e 's/ -Werror / /' gitstatus/Makefile || die
}

src_configure() {
	# Build the libgit2 fork required by gitstatus.
	cd "${WORKDIR}/libgit2-${libgit2ver}" || die
	cmake \
		-DZERO_NSEC=ON \
		-DTHREADSAFE=ON \
		-DUSE_BUNDLED_ZLIB=ON \
		-DREGEX_BACKEND=builtin \
		-DUSE_HTTP_PARSER=builtin \
		-DUSE_SSH=OFF \
		-DUSE_HTTPS=OFF \
		-DBUILD_CLAR=OFF \
		-DUSE_GSSAPI=OFF \
		-DUSE_NTLMCLIENT=OFF \
		-DBUILD_SHARED_LIBS=OFF \
		-DENABLE_REPRODUCIBLE_BUILDS=ON \
		. || die
	emake

	# Build gitstatus against the pinned libgit2 fork.
	cd "${S}/gitstatus" || die
	export CXXFLAGS+=" -I${WORKDIR}/libgit2-${libgit2ver}/include -DGITSTATUS_ZERO_NSEC -D_GNU_SOURCE"
	export LDFLAGS+=" -L${WORKDIR}/libgit2-${libgit2ver}"
	emake

	# Compile the Zsh files and give the gitstatus README a unique name.
	cd "${S}" || die
	mv "gitstatus/README.md" "gitstatus/README.gitstatus.md" || die
	local file
	for file in *.zsh-theme internal/*.zsh gitstatus/*.zsh gitstatus/install; do
		zsh -fc "emulate zsh -o no_aliases && zcompile -R -- ${file}.zwc ${file}" || die
	done
}

src_install() {
	einstalldocs

	insinto "/usr/share/zsh/themes/${PN}"

	rm -rf \
		"gitstatus/obj" \
		"gitstatus/.gitignore" \
		"gitstatus/.gitattributes" \
		"gitstatus/src" \
		"gitstatus/build" \
		"gitstatus/deps" \
		"gitstatus/Makefile" \
		"gitstatus/mbuild" \
		"gitstatus/LICENSE" \
		"gitstatus/README.gitstatus.md" \
		"gitstatus/docs" \
		"gitstatus/usrbin/.gitkeep" \
		"gitstatus/.clang-format" \
		"gitstatus/.vscode/" \
		"internal/notes.md" || die
	rm ".gitattributes" ".gitignore" || die

	doins -r "config" "gitstatus" "internal"
	doins \
		"powerlevel10k.zsh-theme" \
		"powerlevel9k.zsh-theme" \
		"powerlevel10k.zsh-theme.zwc" \
		"powerlevel9k.zsh-theme.zwc" \
		"prompt_powerlevel10k_setup" \
		"prompt_powerlevel9k_setup"

	exeinto "/usr/share/zsh/themes/${PN}/gitstatus/usrbin"
	doexe "gitstatus/usrbin/gitstatusd"
}

pkg_postinst() {
	elog "To enable, add the following to your .zshrc:"
	elog "'source /usr/share/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme'"
}
