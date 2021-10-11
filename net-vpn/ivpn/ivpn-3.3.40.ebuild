# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

EGO_SUM=(
	"github.com/fsnotify/fsnotify v1.4.9 h1:hsms1Qyu0jgnwNXIxa+/V/PDsU6CfLf6CNO8H7IWoS4="
	"github.com/fsnotify/fsnotify v1.4.9/go.mod h1:znqG4EE+3YCdAaPaxE2ZRY/06pZUdp0tY4IgpuI1SZQ="
	"github.com/mattn/go-runewidth v0.0.9 h1:Lm995f3rfxdpd6TSmuVCHVb/QhupuXlYr8sCI/QdE+0="
	"github.com/mattn/go-runewidth v0.0.9/go.mod h1:H031xJmbD/WCDINGzjvQ9THkh0rPKHF+m2gUSrubnMI="
	"github.com/olekukonko/tablewriter v0.0.5 h1:P2Ga83D34wi1o9J6Wh1mRuqd4mF/x/lgBS7N7AbDhec="
	"github.com/olekukonko/tablewriter v0.0.5/go.mod h1:hPp6KlRPjbx+hW8ykQs1w3UBbZlj6HuIJcUGPhkA7kY="
	"github.com/parsiya/golnk v0.0.0-20200515071614-5db3107130ce h1:A8XpVS2Jz5/aVqmDh5lyeQA6V8d5IfjXTcDyFWj+JsY="
	"github.com/parsiya/golnk v0.0.0-20200515071614-5db3107130ce/go.mod h1:K81/KqyRQt+tqXkg+ENusP67AeIrzJRa2uVlrCYwF5Y="
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod h1:djNgcEr1/C05ACkg1iLfiJU5Ep61QUkGW8qpdssI0+w="
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod h1:LzIPMQfyMNhhGPhUkYOs5KpL4U8rLKemX1yGLhDgUto="
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9 h1:psW17arqaxU48Z5kZ0CQnkZWQJsqcURM6tKiBApRjXI="
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod h1:t9HGtf8HONx5eT2rtn7q6eTqICYqUVnKs3thJo3Qplg="
	"golang.org/x/net v0.0.0-20200226051749-491c5fce7268 h1:fnuNgko6vrkrxuKfTMd+0eOz50ziv+Wi+t38KUT3j+E="
	"golang.org/x/net v0.0.0-20200226051749-491c5fce7268/go.mod h1:z5CRVTTTmAJ677TzLLGU+0bjPO0LkuOLi4/5GtJWs/s="
	"golang.org/x/net v0.0.0-20200505041828-1ed23360d12c h1:zJ0mtu4jCalhKg6Oaukv6iIkb+cOvDrajDH9DH46Q4M="
	"golang.org/x/net v0.0.0-20200904194848-62affa334b73 h1:MXfv8rhZWmFeqX3GNZRsd6vOLoaCHjYEX3qkRo3YBUA="
	"golang.org/x/net v0.0.0-20200904194848-62affa334b73/go.mod h1:/O7V0waA8r7cgGh81Ro3o1hOxt32SMVPicZroKQ2sZA="
	"golang.org/x/net v0.0.0-20201110031124-69a78807bb2b h1:uwuIcX0g4Yl1NC5XAz37xsr2lTtcqevgzYNVt49waME="
	"golang.org/x/net v0.0.0-20201110031124-69a78807bb2b/go.mod h1:sp8m0HH+o8qH0wwXwYZr8TS3Oi6o0r6Gce1SSxlDquU="
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod h1:STP8DvDyc/dI5b8T5hshtkjS+E42TnysNCUPdjciGhY="
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20191005200804-aed5e4c7ecf9/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20200327173247-9dae0f8f5775 h1:TC0v2RSO1u2kn1ZugjrFXkRZAEaqMN/RW+OTZkBzmLE="
	"golang.org/x/sys v0.0.0-20200327173247-9dae0f8f5775/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f h1:+Nyd8tzPX9R7BWHguqsrbFdRx3WQ/1ib8I44HXV5yTA="
	"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"golang.org/x/text v0.3.0/go.mod h1:NqM8EUOU14njkJ3fqMW+pc6Ldnwhi/IjpwHt7yyuwOQ="
	"golang.org/x/text v0.3.3/go.mod h1:5Zoc/QRtKVWzQhOtBMvqHzDpF6irO9z98xDceosuGiQ="
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod h1:n7NCudcB/nEzxVGmLbDWY5pfWTLqBcC2KZ6jyYvM4mQ="
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
	net-wireless/wireless-tools"

DEPEND="${RDEPEND}"

BDEPEND="net-misc/curl
	>=dev-lang/go-1.15"

S="${WORKDIR}/desktop-app-${PV}"

DOCS=( readme.md CHANGELOG.md )

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

	cd "${S}/daemon" || die
	go build -o "$OUT_FILE" -trimpath -ldflags "-X github.com/ivpn/desktop-app/daemon/version._version=$VERSION -X github.com/ivpn/desktop-app/daemon/version._commit=$COMMIT -X github.com/ivpn/desktop-app/daemon/version._time=$DATE" || die "failed to compile daemon"

	# build cli
	SCRIPT_DIR="${S}/cli/References/Linux"
	OUT_DIR="$SCRIPT_DIR/_out_bin"
	OUT_FILE="$OUT_DIR/ivpn"

	mkdir -p "$OUT_DIR" || die

	cd "${S}/cli" || die
	go build -o "$OUT_FILE" -trimpath -ldflags "-X github.com/ivpn/desktop-app/daemon/version._version=$VERSION -X github.com/ivpn/desktop-app/daemon/version._commit=$COMMIT -X github.com/ivpn/desktop-app/daemon/version._time=$DATE" || die "failed to compile cli"
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
	insopts -m600
	doins "References/Linux/etc/servers.json"
	insopts -m400
	doins "References/Linux/etc/ca.crt"
	doins "References/Linux/etc/ta.key"

	cd "${S}/cli" || die
	dobin "References/Linux/_out_bin/ivpn"

	if  use systemd;  then
		systemd_dounit "${FILESDIR}/ivpn-service.service"
	else
		newinitd "${FILESDIR}/ivpn.initd" ivpn
	fi
}
