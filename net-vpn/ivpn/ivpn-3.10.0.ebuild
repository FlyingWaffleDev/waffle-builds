# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

EGO_SUM=(
	"github.com/davecgh/go-spew v1.1.0 h1:ZDRjVQ15GmhC3fiQ8ni8+OwkZQO4DARzQgrnXU1Liz8="
	"github.com/davecgh/go-spew v1.1.0/go.mod h1:J7Y8YcW2NihsgmVo/mv3lAwl/skON4iLHjSsI+c5H38="
	"github.com/fsnotify/fsnotify v1.5.1 h1:mZcQUHVQUQWoPXXtuf9yuEXKudkV2sx1E06UadKWpgI="
	"github.com/fsnotify/fsnotify v1.5.1/go.mod h1:T3375wBYaZdLLcVNkcVbzGHY7f1l/uK5T5Ai1i3InKU="
	"github.com/google/uuid v1.3.0 h1:t6JiXgmwXMjEs8VusXIJk2BXHsn+wx8BZdTaoZ5fu7I="
	"github.com/google/uuid v1.3.0/go.mod h1:TIyPZe4MgqvfeYDBFedMoGGpEw/LqOeaOT+nhxU+yHo="
	"github.com/mattn/go-runewidth v0.0.9 h1:Lm995f3rfxdpd6TSmuVCHVb/QhupuXlYr8sCI/QdE+0="
	"github.com/mattn/go-runewidth v0.0.9/go.mod h1:H031xJmbD/WCDINGzjvQ9THkh0rPKHF+m2gUSrubnMI="
	"github.com/olekukonko/tablewriter v0.0.5 h1:P2Ga83D34wi1o9J6Wh1mRuqd4mF/x/lgBS7N7AbDhec="
	"github.com/olekukonko/tablewriter v0.0.5/go.mod h1:hPp6KlRPjbx+hW8ykQs1w3UBbZlj6HuIJcUGPhkA7kY="
	"github.com/parsiya/golnk v0.0.0-20200515071614-5db3107130ce h1:A8XpVS2Jz5/aVqmDh5lyeQA6V8d5IfjXTcDyFWj+JsY="
	"github.com/parsiya/golnk v0.0.0-20200515071614-5db3107130ce/go.mod h1:K81/KqyRQt+tqXkg+ENusP67AeIrzJRa2uVlrCYwF5Y="
	"github.com/pmezard/go-difflib v1.0.0 h1:4DBwDE0NGyQoBHbLQYPwSUPoCMWR5BEzIk/f1lZbAQM="
	"github.com/pmezard/go-difflib v1.0.0/go.mod h1:iKH77koFhYxTK1pcRnkKkqfTogsbg7gZNVY4sRDYZ/4="
	"github.com/stretchr/objx v0.1.0/go.mod h1:HFkY916IF+rwdDfMAkV7OtwuqBVzrE8GR6GFx+wExME="
	"github.com/stretchr/testify v1.7.1 h1:5TQK59W5E3v0r2duFAb7P95B6hEeOyEnHRa8MjYSMTY="
	"github.com/stretchr/testify v1.7.1/go.mod h1:6Fq8oRcR53rry900zMqJjRRixrwX3KX962/h/Wwjteg="
	"golang.org/x/net v0.0.0-20220425223048-2871e0cb64e4 h1:HVyaeDAYux4pnY+D/SiwmLOR36ewZ4iGQIIrtnuCjFA="
	"golang.org/x/net v0.0.0-20220425223048-2871e0cb64e4/go.mod h1:CfG3xpIq0wQ8r1q4Su4UZFWDARRcnwPjda9FqA0JpMk="
	"golang.org/x/sync v0.0.0-20220601150217-0de741cfad7f h1:Ax0t5p6N38Ga0dThY21weqDEyz2oklo4IvDkpigvkD8="
	"golang.org/x/sync v0.0.0-20220601150217-0de741cfad7f/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM="
	"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg="
	"golang.org/x/sys v0.0.0-20211216021012-1d35b9e2eb4e h1:fLOSk5Q00efkSvAm+4xcoXD+RRmLmmulPn5I3Y9F2EM="
	"golang.org/x/sys v0.0.0-20211216021012-1d35b9e2eb4e/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg="
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405 h1:yhCVgyC4o1eVCa2tZl7eS0r+SDo693bJlVdllGtEeKM="
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod h1:Co6ibVJAznAaIkqp8huTwlJQCZ016jof/cbN4VW5Yz0="
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c h1:dUUwHk2QECo/6vqA44rthZ8ie2QXMNeKRTHCNY2nXvo="
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod h1:K4uyk7z7BCEPqu6E+C64Yfv1cQ7kz7rIZviUmN+EgEM="
	"golang.org/x/crypto v0.0.0-20220427172511-eb4f295cb31f h1:OeJjE6G4dgCY4PIXvIRQbE8+RX+uXZyGhUy/ksMGJoc="
	"golang.org/x/crypto v0.0.0-20220427172511-eb4f295cb31f/go.mod h1:IxCIyHEi3zRg3s0A5j5BB6A9Jmi73HwBIUl50j+osU4="
	"golang.org/x/term v0.0.0-20220411215600-e5f449aeb171 h1:EH1Deb8WZJ0xc0WK//leUHXcX9aLE5SymusoTmMZye8="
	"golang.org/x/term v0.0.0-20220411215600-e5f449aeb171/go.mod h1:jbD1KX2456YbFQfuXm/mYQcufACuNUgVhRMnK/tPxf8="
)

go-module_set_globals

DESCRIPTION="Official IVPN Desktop app"
HOMEPAGE="https://www.ivpn.net/ https://github.com/ivpn"
SRC_URI="https://github.com/ivpn/desktop-app/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

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
	net-proxy/obfs4proxy
	net-dns/dnscrypt-proxy"

DEPEND="${RDEPEND}"

BDEPEND="net-misc/curl
	>=dev-lang/go-1.15"

S="${WORKDIR}/desktop-app-${PV}"

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
	SCRIPT_DIR="${S}/daemon/References/Linux/scripts"
	OUT_DIR="$SCRIPT_DIR/_out_bin"
	OUT_FILE="$OUT_DIR/ivpn-service"

	mkdir -p "$OUT_DIR" || die

	# updating servers.json
	# cd ${SCRIPT_DIR}
	# ./update-servers.sh
	# # Or just add "https://api.ivpn.net/v5/servers.json" to the SRC_URI

	cd "${S}/daemon" || die
	go build -o "$OUT_FILE" -trimpath -ldflags "-s -w -X github.com/ivpn/desktop-app/daemon/version._version=$VERSION -X github.com/ivpn/desktop-app/daemon/version._commit=$COMMIT -X github.com/ivpn/desktop-app/daemon/version._time=$DATE" || die "failed to compile daemon"

	# build cli
	SCRIPT_DIR="${S}/cli/References/Linux"
	OUT_DIR="$SCRIPT_DIR/_out_bin"
	OUT_FILE="$OUT_DIR/ivpn"

	mkdir -p "$OUT_DIR" || die

	cd "${S}/cli" || die
	go build -o "$OUT_FILE" -trimpath -ldflags "-s -w -X github.com/ivpn/desktop-app/daemon/version._version=$VERSION -X github.com/ivpn/desktop-app/daemon/version._commit=$COMMIT -X github.com/ivpn/desktop-app/daemon/version._time=$DATE" || die "failed to compile cli"
}

src_install() {
	mkdir -p "${D}/opt/ivpn/etc" || die

	cd "${S}/daemon" || die

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
	dosym "$(which obfs4proxy)" "opt/ivpn/obfsproxy/obfs4proxy"
	dosym "$(which dnscrypt-proxy)" "opt/ivpn/dnscrypt-proxy/dnscrypt-proxy"

	cd "${S}/cli" || die
	dobin "References/Linux/_out_bin/ivpn"

	if  use systemd;  then
		systemd_dounit "${FILESDIR}/ivpn-service.service"
	else
		newinitd "${FILESDIR}/ivpn.initd" ivpn
	fi
}
