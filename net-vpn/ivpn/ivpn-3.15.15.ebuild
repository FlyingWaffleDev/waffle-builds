# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info systemd toolchain-funcs

DESCRIPTION="Official IVPN command-line client and service"
HOMEPAGE="https://www.ivpn.net/ https://github.com/ivpn/desktop-app"
SRC_URI="https://github.com/ivpn/desktop-app/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/FlyingWaffleDev/gentoo-ivpn-deps/releases/download/${P}/${P}-deps.tar.xz"
S="${WORKDIR}/desktop-app-${PV}/cli"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"
RESTRICT="mirror"

RDEPEND="dev-libs/liboqs:0/9
	net-dns/dnscrypt-proxy
	~net-proxy/v2ray-bin-5.12.1
	net-proxy/lyrebird
	net-vpn/openvpn
	net-vpn/wireguard-tools
	net-wireless/wireless-tools
	sys-process/lsof"
DEPEND="dev-libs/liboqs:0/9"
BDEPEND="virtual/pkgconfig
	>=dev-lang/go-1.26.0"

DOCS=( ../ACKNOWLEDGEMENTS.md ../CHANGELOG.md ../readme.md )

pkg_pretend() {
	local CONFIG_CHECK="NETFILTER_XT_SET NETFILTER_XT_MATCH_CGROUP
		NETFILTER_XT_MATCH_MARK NETFILTER_XT_MATCH_CONNMARK
		NETFILTER_XT_TARGET_MARK NETFILTER_XT_TARGET_CONNMARK"

	check_extra_config
}

src_compile() {
	local build_date commit ldflags
	export CGO_ENABLED=0

	build_date="$(date -u -r ../CHANGELOG.md +%Y-%m-%d)" || die
	commit="${PV}_stamped"
	ldflags="-X github.com/ivpn/desktop-app/daemon/version._version=${PV}
		-X github.com/ivpn/desktop-app/daemon/version._commit=${commit}
		-X github.com/ivpn/desktop-app/daemon/version._time=${build_date}"

	pushd ../daemon >/dev/null || die
	ego build -mod=vendor -buildmode=pie -buildvcs=false -trimpath \
		-ldflags "${ldflags}" -o "${T}/ivpn-service"
	popd >/dev/null || die

	ego build -mod=vendor -buildvcs=false -trimpath \
		-ldflags "${ldflags}" -o "${T}/ivpn"

	pushd ../daemon/References/common/kem-helper >/dev/null || die
	"$(tc-getCC)" ${CFLAGS} ${CPPFLAGS} -pthread -Wall \
		main.c base64.c -o "${T}/kem-helper" \
		$(pkg-config --cflags --libs liboqs) ${LDFLAGS} \
		-Wl,-z,stack-size=5242880 || die "failed to compile kem-helper"
	popd >/dev/null || die
}

src_install() {
	insinto /usr/bin
	doins "${T}/ivpn-service" "${T}/ivpn"
	fperms 0755 /usr/bin/{ivpn-service,ivpn}

	insinto /opt/ivpn/etc
	insopts -m0700
	doins ../daemon/References/Linux/etc/{client.down,client.up,firewall.sh,splittun.sh}
	insopts -m0600
	doins ../daemon/References/common/etc/servers.json
	insopts -m0400
	doins ../daemon/References/common/etc/{ca.crt,ta.key,dnscrypt-proxy-template.toml}
	fperms 0700 /opt/ivpn/etc

	dosym -r /usr/bin/wg-quick /opt/ivpn/wireguard-tools/wg-quick
	dosym -r /usr/bin/wg /opt/ivpn/wireguard-tools/wg
	dosym -r /usr/bin/lyrebird /opt/ivpn/obfsproxy/obfs4proxy
	dosym -r /usr/bin/v2ray /opt/ivpn/v2ray/v2ray
	dosym -r /usr/bin/dnscrypt-proxy /opt/ivpn/dnscrypt-proxy/dnscrypt-proxy

	insinto /opt/ivpn/kem
	doins "${T}/kem-helper"
	fperms 0755 /opt/ivpn/kem/kem-helper

	if use systemd; then
		systemd_dounit "${FILESDIR}/ivpn-service.service"
	else
		newinitd "${FILESDIR}/ivpn.initd" ivpn
	fi
}
