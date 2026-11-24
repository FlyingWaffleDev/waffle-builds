# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..15} )
inherit ninja-utils python-any-r1 toolchain-funcs

MY_COMMIT="e7c90ecca9444fe09598f1630ab7cee2c0ee027a"
DESCRIPTION="2D graphics library (Ladybird configuration)"
HOMEPAGE="https://skia.org/"
SRC_URI="https://github.com/google/skia/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/skia-${MY_COMMIT}"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-libs/expat
	dev-libs/icu:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=[icu]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/libwebp:=
	virtual/zlib
"
DEPEND="${RDEPEND}
	>=dev-util/vulkan-headers-1.4.321
	>=media-libs/VulkanMemoryAllocator-3.5.0
"
BDEPEND="
	${NINJA_DEPEND}
	${PYTHON_DEPS}
	dev-build/gn
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-skparagraph-exports.patch"
	"${FILESDIR}/${P}-pathops.patch"
	"${FILESDIR}/${P}-string-exports.patch"
	"${FILESDIR}/${P}-skcms-exports.patch"
)

src_configure() {
	mkdir -p out/Release || die
	cat > out/Release/args.gn <<-EOF || die
	is_official_build = true
	is_component_build = true
	is_debug = false
	skia_enable_tools = false
	skia_enable_spirv_validation = false
	skia_use_dng_sdk = false
	skia_use_wuffs = false
	skia_use_piex = false
	skia_use_libjpeg_turbo_decode = false
	skia_use_libjpeg_turbo_encode = true
	skia_use_libpng_decode = false
	skia_use_libpng_encode = true
	skia_use_libwebp_decode = false
	skia_use_libwebp_encode = true
	skia_use_zlib = true
	skia_use_system_zlib = true
	skia_use_harfbuzz = true
	skia_use_system_harfbuzz = true
	skia_use_vulkan = true
	skia_use_gl = false
	skia_use_fontconfig = true
	skia_use_freetype = true
	skia_use_system_freetype2 = true
	skia_use_icu = true
	skia_use_system_icu = true
	EOF
	local cpu
	case $(tc-arch) in
		amd64) cpu=x64 ;;
		arm64) cpu=arm64 ;;
		*) die "Unsupported architecture" ;;
	esac
	"${PYTHON}" - "$(tc-getCC)" "$(tc-getCXX)" "$(tc-getAR)" "${cpu}" \
		"${CFLAGS}" "${CXXFLAGS}" "${LDFLAGS}" >> out/Release/args.gn <<-'PY' || die
	import json
	import shlex
	import sys
	for key, value in zip(("cc", "cxx", "ar", "target_cpu"), sys.argv[1:5]):
	    print(f"{key} = {json.dumps(value)}")
	flags = shlex.split(sys.argv[5]) + ["-DSK_USE_EXTERNAL_VULKAN_HEADERS"]
	print("extra_cflags = " + json.dumps(flags))
	print("extra_cflags_cc = " + json.dumps(shlex.split(sys.argv[6]) + ["-DSKCMS_DLL", "-USK_HIDE_PATH_EDIT_METHODS"]))
	print("extra_ldflags = " + json.dumps(shlex.split(sys.argv[7])))
	PY
	gn gen out/Release || die
}

src_compile() {
	eninja -C out/Release :skia :modules
}

src_install() {
	dolib.so out/Release/*.so
	dolib.a out/Release/libskcms.a
	local header
	while IFS= read -r -d '' header ; do
		insinto "/usr/include/skia/${header%/*}"
		doins "${header}"
	done < <(find include modules -type f \( -name '*.h' -o -name '*.inc' \) -print0)

	cat > "${T}/skia.pc" <<-EOF || die
	prefix=${EPREFIX}/usr
	libdir=\${prefix}/$(get_libdir)
	includedir=\${prefix}/include/skia
	Name: skia
	Description: Skia graphics library for Ladybird
	Version: ${PV}
	Libs: -L\${libdir} -lskia -lskcms
	Cflags: -I\${includedir} -I\${includedir}/include -DSKCMS_DLL -DSK_GANESH -DSK_VULKAN
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}/skia.pc"
	einstalldocs
}
