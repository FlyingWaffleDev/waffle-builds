# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font check-reqs

DESCRIPTION="Iconic font aggregator, and collection"
HOMEPAGE="https://nerdfonts.com https://github.com/ryanoasis/nerd-fonts"
RESTRICT="mirror"

LICENSE="
	MIT
	OFL-1.1
	Apache-2.0
	CC-BY-SA-4.0
	BitstreamVera
	BSD
	WTFPL-2
	Vic-Fieger-License
	UbuntuFontLicense-1.0
"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DIRNAME=(
	0xProto
	3270
	Agave
	AnonymousPro
	Arimo
	AurulentSansMono
	BigBlueTerminal
	BitstreamVeraSansMono
	CascadiaCode
	CascadiaMono
	CodeNewRoman
	ComicShannsMono
	CommitMono
	Cousine
	D2Coding
	DaddyTimeMono
	DejaVuSansMono
	DroidSansMono
	EnvyCodeR
	FantasqueSansMono
	FiraCode
	FiraMono
	GeistMono
	Go-Mono
	Gohu
	Hack
	Hasklig
	HeavyData
	Hermit
	iA-Writer
	IBMPlexMono
	Inconsolata
	InconsolataGo
	InconsolataLGC
	IntelOneMono
	Iosevka
	IosevkaTerm
	IosevkaTermSlab
	JetBrainsMono
	Lekton
	LiberationMono
	Lilex
	MartianMono
	Meslo
	Monaspace
	Monofur
	Monoid
	Mononoki
	MPlus
	NerdFontsSymbolsOnly
	Noto
	OpenDyslexic
	Overpass
	ProFont
	ProggyClean
	RobotoMono
	ShareTechMono
	SourceCodePro
	SpaceMono
	Terminus
	Tinos
	Ubuntu
	UbuntuMono
	VictorMono
)

IUSE_FLAGS=(${DIRNAME[*],,})
IUSE="${IUSE_FLAGS[*]}"
REQUIRED_USE="X || ( ${IUSE_FLAGS[*]} )"

MY_URI="https://github.com/ryanoasis/${PN}/releases/download/v${PV}"
SRC_URI="
	https://raw.githubusercontent.com/ryanoasis/${PN}/v${PV}/10-nerd-font-symbols.conf
	0xproto?                ( "${MY_URI}/0xProto.tar.xz" )
	3270?                   ( "${MY_URI}/3270.tar.xz" )
	agave?                  ( "${MY_URI}/Agave.tar.xz" )
	anonymouspro?           ( "${MY_URI}/AnonymousPro.tar.xz" )
	arimo?                  ( "${MY_URI}/Arimo.tar.xz" )
	aurulentsansmono?       ( "${MY_URI}/AurulentSansMono.tar.xz" )
	bigblueterminal?        ( "${MY_URI}/BigBlueTerminal.tar.xz" )
	bitstreamverasansmono?  ( "${MY_URI}/BitstreamVeraSansMono.tar.xz" )
	cascadiacode?           ( "${MY_URI}/CascadiaCode.tar.xz" )
	cascadiamono?           ( "${MY_URI}/CascadiaMono.tar.xz" )
	codenewroman?           ( "${MY_URI}/CodeNewRoman.tar.xz" )
	comicshannsmono?        ( "${MY_URI}/ComicShannsMono.tar.xz" )
	commitmono?             ( "${MY_URI}/CommitMono.tar.xz" )
	cousine?                ( "${MY_URI}/Cousine.tar.xz" )
	d2coding?               ( "${MY_URI}/D2Coding.tar.xz" )
	daddytimemono?          ( "${MY_URI}/DaddyTimeMono.tar.xz" )
	dejavusansmono?         ( "${MY_URI}/DejaVuSansMono.tar.xz" )
	droidsansmono?          ( "${MY_URI}/DroidSansMono.tar.xz" )
	envycoder?              ( "${MY_URI}/EnvyCodeR.tar.xz" )
	fantasquesansmono?      ( "${MY_URI}/FantasqueSansMono.tar.xz" )
	firacode?               ( "${MY_URI}/FiraCode.tar.xz" )
	firamono?               ( "${MY_URI}/FiraMono.tar.xz" )
	geistmono?              ( "${MY_URI}/GeistMono.tar.xz" )
	go-mono?                ( "${MY_URI}/Go-Mono.tar.xz" )
	gohu?                   ( "${MY_URI}/Gohu.tar.xz" )
	hack?                   ( "${MY_URI}/Hack.tar.xz" )
	hasklig?                ( "${MY_URI}/Hasklig.tar.xz" )
	heavydata?              ( "${MY_URI}/HeavyData.tar.xz" )
	hermit?                 ( "${MY_URI}/Hermit.tar.xz" )
	ia-writer?              ( "${MY_URI}/iA-Writer.tar.xz" )
	ibmplexmono?            ( "${MY_URI}/IBMPlexMono.tar.xz" )
	inconsolata?            ( "${MY_URI}/Inconsolata.tar.xz" )
	inconsolatago?          ( "${MY_URI}/InconsolataGo.tar.xz" )
	inconsolatalgc?         ( "${MY_URI}/InconsolataLGC.tar.xz" )
	intelonemono?           ( "${MY_URI}/IntelOneMono.tar.xz" )
	iosevka?                ( "${MY_URI}/Iosevka.tar.xz" )
	iosevkaterm?            ( "${MY_URI}/IosevkaTerm.tar.xz" )
	iosevkatermslab?        ( "${MY_URI}/IosevkaTermSlab.tar.xz" )
	jetbrainsmono?          ( "${MY_URI}/JetBrainsMono.tar.xz" )
	lekton?                 ( "${MY_URI}/Lekton.tar.xz" )
	liberationmono?         ( "${MY_URI}/LiberationMono.tar.xz" )
	lilex?                  ( "${MY_URI}/Lilex.tar.xz" )
	martianmono?            ( "${MY_URI}/MartianMono.tar.xz" )
	meslo?                  ( "${MY_URI}/Meslo.tar.xz" )
	monaspace?              ( "${MY_URI}/Monaspace.tar.xz" )
	monofur?                ( "${MY_URI}/Monofur.tar.xz" )
	monoid?                 ( "${MY_URI}/Monoid.tar.xz" )
	mononoki?               ( "${MY_URI}/Mononoki.tar.xz" )
	mplus?                  ( "${MY_URI}/MPlus.tar.xz" )
	nerdfontssymbolsonly?   ( "${MY_URI}/NerdFontsSymbolsOnly.tar.xz" )
	noto?                   ( "${MY_URI}/Noto.tar.xz" )
	opendyslexic?           ( "${MY_URI}/OpenDyslexic.tar.xz" )
	overpass?               ( "${MY_URI}/Overpass.tar.xz" )
	profont?                ( "${MY_URI}/ProFont.tar.xz" )
	proggyclean?            ( "${MY_URI}/ProggyClean.tar.xz" )
	robotomono?             ( "${MY_URI}/RobotoMono.tar.xz" )
	sharetechmono?          ( "${MY_URI}/ShareTechMono.tar.xz" )
	sourcecodepro?          ( "${MY_URI}/SourceCodePro.tar.xz" )
	spacemono?              ( "${MY_URI}/SpaceMono.tar.xz" )
	terminus?               ( "${MY_URI}/Terminus.tar.xz" )
	tinos?                  ( "${MY_URI}/Tinos.tar.xz" )
	ubuntu?                 ( "${MY_URI}/Ubuntu.tar.xz" )
	ubuntumono?             ( "${MY_URI}/UbuntuMono.tar.xz" )
	victormono?             ( "${MY_URI}/VictorMono.tar.xz" )
"

DEPEND="app-arch/xz-utils"
RDEPEND="media-libs/fontconfig"

CHECKREQS_DISK_BUILD="3G"
CHECKREQS_DISK_USR="4G"

S="${WORKDIR}"
FONT_CONF=( "${S}/10-nerd-font-symbols.conf" )
FONT_S=${S}

pkg_pretend() {
	check-reqs_pkg_setup
}

src_install() {
	declare -A font_filetypes
	local otf_file_number ttf_file_number

	otf_file_number=$(ls "${S}" | grep -ic otf)
	ttf_file_number=$(ls "${S}" | grep -ic ttf)

	if [[ ${otf_file_number} != 0 ]]; then
		font_filetypes[otf]=
	fi

	if [[ ${ttf_file_number} != 0 ]]; then
		font_filetypes[ttf]=
	fi

	FONT_SUFFIX="${!font_filetypes[@]}"

	font_src_install
}

pkg_postinst() {
	einfo "Font-patcher script is not included in this ebuild."
	einfo "You can get it from the nerd-font project."
	einfo "https://github.com/ryanoasis/nerd-fonts"

	font_pkg_postinst
}
