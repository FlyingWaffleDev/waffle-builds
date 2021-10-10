# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

inherit cargo

DESCRIPTION="A secure JavaScript and TypeScript runtime."
HOMEPAGE="https://deno.land/ https://github.com/denoland/deno"

if [ "${PV}" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/denoland/deno"
	SRC_URI="!build-v8? ( https://github.com/denoland/rusty_v8/releases/download/v0.31.0/librusty_v8_release_x86_64-unknown-linux-gnu.a )"
else
	SRC_URI="$(cargo_crate_uris ${CRATES})
	https://github.com/denoland/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	!build-v8? ( https://github.com/denoland/rusty_v8/releases/download/v0.31.0/librusty_v8_release_x86_64-unknown-linux-gnu.a )"
	KEYWORDS="~amd64"
fi

RESTRICT="primaryuri test"
LICENSE="MIT"
SLOT="0"
IUSE="build-v8"

DEPEND="build-v8? ( >=dev-lang/python-3
	dev-libs/glib:2 )"
RDEPEND=""

src_unpack() {
	if ! use build-v8; then
		# trim last element (v8 bin) from SRC_URI string
		A="${A% *}"

		mkdir -p "${T}/v0.31.0" || die
		ln -s "${DISTDIR}/librusty_v8_release_x86_64-unknown-linux-gnu.a" "${T}/v0.31.0/librusty_v8_release_x86_64-unknown-linux-gnu.a" || die
	fi

	if [ "${PV}" == "9999" ]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	if use build-v8; then
		export V8_FROM_SOURCE=1
	else
		export RUSTY_V8_MIRROR=${T}
	fi

	cargo_src_configure -vv
}

src_install() {
	cargo_src_install --path cli
}
