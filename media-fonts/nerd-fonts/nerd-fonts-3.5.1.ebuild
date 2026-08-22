# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs font

DESCRIPTION="Collection of fonts patched with Nerd Fonts glyphs"
HOMEPAGE="https://www.nerdfonts.com/ https://github.com/ryanoasis/nerd-fonts"

DIRNAME=(
	0xProto
	3270
	AdwaitaMono
	Agave
	AnnotationMono
	AnonymousPro
	Arimo
	AtkinsonHyperlegibleMono
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
	DepartureMono
	DroidSansMono
	EnvyCodeR
	FantasqueSansMono
	FiraCode
	FiraMono
	GeistMono
	Go-Mono
	Gohu
	GoogleSansCode
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
	Recursive
	RobotoMono
	ShareTechMono
	SourceCodePro
	SpaceMono
	Terminus
	Tinos
	Ubuntu
	UbuntuMono
	UbuntuSans
	VictorMono
	ZedMono
)

MY_URI="https://github.com/ryanoasis/${PN}/releases/download/v${PV}"
SRC_URI="
	https://raw.githubusercontent.com/ryanoasis/${PN}/v${PV}/10-nerd-font-symbols.conf
		-> 10-nerd-font-symbols-${PV}.conf
	0xproto?                ( ${MY_URI}/0xProto.tar.xz -> ${P}-0xProto.tar.xz )
	3270?                   ( ${MY_URI}/3270.tar.xz -> ${P}-3270.tar.xz )
	adwaitamono?            ( ${MY_URI}/AdwaitaMono.tar.xz -> ${P}-AdwaitaMono.tar.xz )
	agave?                  ( ${MY_URI}/Agave.tar.xz -> ${P}-Agave.tar.xz )
	annotationmono?         ( ${MY_URI}/AnnotationMono.tar.xz -> ${P}-AnnotationMono.tar.xz )
	anonymouspro?           ( ${MY_URI}/AnonymousPro.tar.xz -> ${P}-AnonymousPro.tar.xz )
	arimo?                  ( ${MY_URI}/Arimo.tar.xz -> ${P}-Arimo.tar.xz )
	atkinsonhyperlegiblemono? ( ${MY_URI}/AtkinsonHyperlegibleMono.tar.xz -> ${P}-AtkinsonHyperlegibleMono.tar.xz )
	aurulentsansmono?       ( ${MY_URI}/AurulentSansMono.tar.xz -> ${P}-AurulentSansMono.tar.xz )
	bigblueterminal?        ( ${MY_URI}/BigBlueTerminal.tar.xz -> ${P}-BigBlueTerminal.tar.xz )
	bitstreamverasansmono?  ( ${MY_URI}/BitstreamVeraSansMono.tar.xz -> ${P}-BitstreamVeraSansMono.tar.xz )
	cascadiacode?           ( ${MY_URI}/CascadiaCode.tar.xz -> ${P}-CascadiaCode.tar.xz )
	cascadiamono?           ( ${MY_URI}/CascadiaMono.tar.xz -> ${P}-CascadiaMono.tar.xz )
	codenewroman?           ( ${MY_URI}/CodeNewRoman.tar.xz -> ${P}-CodeNewRoman.tar.xz )
	comicshannsmono?        ( ${MY_URI}/ComicShannsMono.tar.xz -> ${P}-ComicShannsMono.tar.xz )
	commitmono?             ( ${MY_URI}/CommitMono.tar.xz -> ${P}-CommitMono.tar.xz )
	cousine?                ( ${MY_URI}/Cousine.tar.xz -> ${P}-Cousine.tar.xz )
	d2coding?               ( ${MY_URI}/D2Coding.tar.xz -> ${P}-D2Coding.tar.xz )
	daddytimemono?          ( ${MY_URI}/DaddyTimeMono.tar.xz -> ${P}-DaddyTimeMono.tar.xz )
	dejavusansmono?         ( ${MY_URI}/DejaVuSansMono.tar.xz -> ${P}-DejaVuSansMono.tar.xz )
	departuremono?          ( ${MY_URI}/DepartureMono.tar.xz -> ${P}-DepartureMono.tar.xz )
	droidsansmono?          ( ${MY_URI}/DroidSansMono.tar.xz -> ${P}-DroidSansMono.tar.xz )
	envycoder?              ( ${MY_URI}/EnvyCodeR.tar.xz -> ${P}-EnvyCodeR.tar.xz )
	fantasquesansmono?      ( ${MY_URI}/FantasqueSansMono.tar.xz -> ${P}-FantasqueSansMono.tar.xz )
	firacode?               ( ${MY_URI}/FiraCode.tar.xz -> ${P}-FiraCode.tar.xz )
	firamono?               ( ${MY_URI}/FiraMono.tar.xz -> ${P}-FiraMono.tar.xz )
	geistmono?              ( ${MY_URI}/GeistMono.tar.xz -> ${P}-GeistMono.tar.xz )
	go-mono?                ( ${MY_URI}/Go-Mono.tar.xz -> ${P}-Go-Mono.tar.xz )
	gohu?                   ( ${MY_URI}/Gohu.tar.xz -> ${P}-Gohu.tar.xz )
	googlesanscode?         ( ${MY_URI}/GoogleSansCode.tar.xz -> ${P}-GoogleSansCode.tar.xz )
	hack?                   ( ${MY_URI}/Hack.tar.xz -> ${P}-Hack.tar.xz )
	hasklig?                ( ${MY_URI}/Hasklig.tar.xz -> ${P}-Hasklig.tar.xz )
	heavydata?              ( ${MY_URI}/HeavyData.tar.xz -> ${P}-HeavyData.tar.xz )
	hermit?                 ( ${MY_URI}/Hermit.tar.xz -> ${P}-Hermit.tar.xz )
	ia-writer?              ( ${MY_URI}/iA-Writer.tar.xz -> ${P}-iA-Writer.tar.xz )
	ibmplexmono?            ( ${MY_URI}/IBMPlexMono.tar.xz -> ${P}-IBMPlexMono.tar.xz )
	inconsolata?            ( ${MY_URI}/Inconsolata.tar.xz -> ${P}-Inconsolata.tar.xz )
	inconsolatago?          ( ${MY_URI}/InconsolataGo.tar.xz -> ${P}-InconsolataGo.tar.xz )
	inconsolatalgc?         ( ${MY_URI}/InconsolataLGC.tar.xz -> ${P}-InconsolataLGC.tar.xz )
	intelonemono?           ( ${MY_URI}/IntelOneMono.tar.xz -> ${P}-IntelOneMono.tar.xz )
	iosevka?                ( ${MY_URI}/Iosevka.tar.xz -> ${P}-Iosevka.tar.xz )
	iosevkaterm?            ( ${MY_URI}/IosevkaTerm.tar.xz -> ${P}-IosevkaTerm.tar.xz )
	iosevkatermslab?        ( ${MY_URI}/IosevkaTermSlab.tar.xz -> ${P}-IosevkaTermSlab.tar.xz )
	jetbrainsmono?          ( ${MY_URI}/JetBrainsMono.tar.xz -> ${P}-JetBrainsMono.tar.xz )
	lekton?                 ( ${MY_URI}/Lekton.tar.xz -> ${P}-Lekton.tar.xz )
	liberationmono?         ( ${MY_URI}/LiberationMono.tar.xz -> ${P}-LiberationMono.tar.xz )
	lilex?                  ( ${MY_URI}/Lilex.tar.xz -> ${P}-Lilex.tar.xz )
	martianmono?            ( ${MY_URI}/MartianMono.tar.xz -> ${P}-MartianMono.tar.xz )
	meslo?                  ( ${MY_URI}/Meslo.tar.xz -> ${P}-Meslo.tar.xz )
	monaspace?              ( ${MY_URI}/Monaspace.tar.xz -> ${P}-Monaspace.tar.xz )
	monofur?                ( ${MY_URI}/Monofur.tar.xz -> ${P}-Monofur.tar.xz )
	monoid?                 ( ${MY_URI}/Monoid.tar.xz -> ${P}-Monoid.tar.xz )
	mononoki?               ( ${MY_URI}/Mononoki.tar.xz -> ${P}-Mononoki.tar.xz )
	mplus?                  ( ${MY_URI}/MPlus.tar.xz -> ${P}-MPlus.tar.xz )
	nerdfontssymbolsonly?   ( ${MY_URI}/NerdFontsSymbolsOnly.tar.xz -> ${P}-NerdFontsSymbolsOnly.tar.xz )
	noto?                   ( ${MY_URI}/Noto.tar.xz -> ${P}-Noto.tar.xz )
	opendyslexic?           ( ${MY_URI}/OpenDyslexic.tar.xz -> ${P}-OpenDyslexic.tar.xz )
	overpass?               ( ${MY_URI}/Overpass.tar.xz -> ${P}-Overpass.tar.xz )
	profont?                ( ${MY_URI}/ProFont.tar.xz -> ${P}-ProFont.tar.xz )
	proggyclean?            ( ${MY_URI}/ProggyClean.tar.xz -> ${P}-ProggyClean.tar.xz )
	recursive?              ( ${MY_URI}/Recursive.tar.xz -> ${P}-Recursive.tar.xz )
	robotomono?             ( ${MY_URI}/RobotoMono.tar.xz -> ${P}-RobotoMono.tar.xz )
	sharetechmono?          ( ${MY_URI}/ShareTechMono.tar.xz -> ${P}-ShareTechMono.tar.xz )
	sourcecodepro?          ( ${MY_URI}/SourceCodePro.tar.xz -> ${P}-SourceCodePro.tar.xz )
	spacemono?              ( ${MY_URI}/SpaceMono.tar.xz -> ${P}-SpaceMono.tar.xz )
	terminus?               ( ${MY_URI}/Terminus.tar.xz -> ${P}-Terminus.tar.xz )
	tinos?                  ( ${MY_URI}/Tinos.tar.xz -> ${P}-Tinos.tar.xz )
	ubuntu?                 ( ${MY_URI}/Ubuntu.tar.xz -> ${P}-Ubuntu.tar.xz )
	ubuntumono?             ( ${MY_URI}/UbuntuMono.tar.xz -> ${P}-UbuntuMono.tar.xz )
	ubuntusans?             ( ${MY_URI}/UbuntuSans.tar.xz -> ${P}-UbuntuSans.tar.xz )
	victormono?             ( ${MY_URI}/VictorMono.tar.xz -> ${P}-VictorMono.tar.xz )
	zedmono?                ( ${MY_URI}/ZedMono.tar.xz -> ${P}-ZedMono.tar.xz )
"

S="${WORKDIR}"

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

IUSE_FLAGS=( ${DIRNAME[*],,} )
IUSE="${IUSE_FLAGS[*]/nerdfontssymbolsonly/+nerdfontssymbolsonly}"
REQUIRED_USE="|| ( ${IUSE_FLAGS[*]} )"
RESTRICT="mirror"

BDEPEND="app-arch/xz-utils"
RDEPEND="media-libs/fontconfig"

CHECKREQS_DISK_BUILD="3G"
CHECKREQS_DISK_USR="4G"

FONT_CONF=( "${DISTDIR}/10-nerd-font-symbols-${PV}.conf" )
FONT_S=${S}

pkg_pretend() {
	check-reqs_pkg_setup
}

src_install() {
	declare -A font_filetypes
	local otf_file_number ttf_file_number

	otf_file_number=$(find "${S}" -type f -name '*.otf' -print -quit)
	ttf_file_number=$(find "${S}" -type f -name '*.ttf' -print -quit)

	if [[ -n ${otf_file_number} ]]; then
		font_filetypes[otf]=
	fi

	if [[ -n ${ttf_file_number} ]]; then
		font_filetypes[ttf]=
	fi

	FONT_SUFFIX="${!font_filetypes[@]}"

	font_src_install
}

pkg_postinst() {
	einfo "This ebuild does not install the font-patcher script."
	einfo "Get it from https://github.com/ryanoasis/nerd-fonts if needed."

	font_pkg_postinst
}
