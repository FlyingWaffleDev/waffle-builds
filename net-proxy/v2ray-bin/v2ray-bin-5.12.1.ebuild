# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="V2Ray proxy platform binary used by IVPN"
HOMEPAGE="https://www.v2fly.org/ https://github.com/v2fly/v2ray-core"
SRC_URI="amd64? ( https://github.com/v2fly/v2ray-core/releases/download/v${PV}/v2ray-linux-64.zip -> ${P}-linux-amd64.zip )"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"

BDEPEND="app-arch/unzip"

QA_PREBUILT="usr/bin/v2ray"

src_install() {
	insinto /usr/bin
	doins v2ray
	fperms 0755 /usr/bin/v2ray
}
