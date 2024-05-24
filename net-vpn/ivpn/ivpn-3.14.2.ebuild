# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd linux-info

go-module_set_globals

DESCRIPTION="Official IVPN Desktop app"
HOMEPAGE="https://www.ivpn.net/ https://github.com/ivpn"
SRC_URI="https://github.com/ivpn/desktop-app/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/FlyingWaffleDev/gentoo-ivpn-deps/releases/download/${P}/${P}-deps.tar.xz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE="systemd"
RESTRICT="primaryuri"

RDEPEND="sys-libs/glibc
	sys-process/lsof
	net-vpn/openvpn
	net-vpn/wireguard-tools
	net-wireless/wireless-tools
	net-proxy/lyrebird
	net-proxy/v2ray #TODO: Make/copy an ebuild
	net-dns/dnscrypt-proxy"

DEPEND="${RDEPEND}"

BDEPEND="net-misc/curl
	=dev-libs/liboqs-0.8.0 #TODO: Make an ebuild
	>=dev-lang/go-1.18"

#S="${WORKDIR}/desktop-app-${PV}"
S="${WORKDIR}/desktop-app-${PV}/cli"

DOCS=( readme.md CHANGELOG.md )

pkg_pretend() {
	local CONFIG_CHECK="NETFILTER_XT_SET NETFILTER_XT_MATCH_CGROUP
		NETFILTER_XT_MATCH_MARK NETFILTER_XT_MATCH_CONNMARK
		NETFILTER_XT_TARGET_MARK NETFILTER_XT_TARGET_CONNMARK"

	check_extra_config
}

src_compile() {
	# version info variables
	VERSION="${PV}"
	DATE="$(date "+%Y-%m-%d")"
	COMMIT="${PV}_stamped"

	# build daemon
	SCRIPT_DIR="${S}/../daemon/References/Linux/scripts"
	OUT_DIR="$SCRIPT_DIR/_out_bin"
	OUT_FILE="$OUT_DIR/ivpn-service"

	mkdir -p "$OUT_DIR" || die

	# updating servers.json
	# cd ${SCRIPT_DIR}
	# ./update-servers.sh
	# # Or just add "https://api.ivpn.net/v5/servers.json" to the SRC_URI

	cd "${S}/../daemon" || die
	go build -buildmode=pie -o "$OUT_FILE" -trimpath -ldflags "-s -w -X github.com/ivpn/desktop-app/daemon/version._version=$VERSION -X github.com/ivpn/desktop-app/daemon/version._commit=$COMMIT -X github.com/ivpn/desktop-app/daemon/version._time=$DATE" || die "failed to compile daemon"

	# build kem-helper
	#cd "${S}/../daemon/Refernces/common/kem-helper" || die
	#may need to change shit for liboqs
	#gcc main.c base64.c -o $OUT_DIR/kem-helper -Wall -O2 -I$_LIBOQS_INSTALL_FOLDER/include -L$_LIB_FOLDER -loqs -Wl,-z,stack-size=5242880

	# build cli
	SCRIPT_DIR="${S}/References/Linux"
	OUT_DIR="$SCRIPT_DIR/_out_bin"
	OUT_FILE="$OUT_DIR/ivpn"

	mkdir -p "$OUT_DIR" || die

	cd "${S}" || die
	go build -o "$OUT_FILE" -trimpath -ldflags "-s -w -X github.com/ivpn/desktop-app/daemon/version._version=$VERSION -X github.com/ivpn/desktop-app/daemon/version._commit=$COMMIT -X github.com/ivpn/desktop-app/daemon/version._time=$DATE" || die "failed to compile cli"
}

src_install() {
	mkdir -p "${D}/opt/ivpn/etc" || die

	cd "${S}/../daemon" || die

	dobin "References/Linux/scripts/_out_bin/ivpn-service"

	insinto "opt/ivpn/etc"
	insopts -m700
	doins "References/Linux/etc/client.down"
	doins "References/Linux/etc/client.up"
	doins "References/Linux/etc/firewall.sh"
	doins "References/Linux/etc/splittun.sh"
	insopts -m600
	doins "References/common/etc/servers.json"
	insopts -m400
	doins "References/common/etc/ca.crt"
	doins "References/common/etc/ta.key"
	doins "References/common/etc/dnscrypt-proxy-template.toml"

	dosym "$(which wg-quick)" "opt/ivpn/wireguard-tools/wg-quick"
	dosym "$(which wg)" "opt/ivpn/wireguard-tools/wg"
	dosym "$(which lyrebird)" "opt/ivpn/obfsproxy/obfs4proxy"
	dosym "$(which v2ray)" "opt/ivpn/v2ray/v2ray"
	dosym "$(which dnscrypt-proxy)" "opt/ivpn/dnscrypt-proxy/dnscrypt-proxy"

	exeinto "opt/ivpn/kem"
	doexe "References/Linux/scripts/_out_bin/kem-helper"

	cd "${S}" || die
	dobin "References/Linux/_out_bin/ivpn"

	if  use systemd;  then
		systemd_dounit "${FILESDIR}/ivpn-service.service"
	else
		newinitd "${FILESDIR}/ivpn.initd" ivpn
	fi
}