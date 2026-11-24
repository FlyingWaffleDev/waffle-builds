# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..15} )
inherit cmake python-any-r1

MY_COMMIT="d9fc4a372074b1079c193c422fc4a180e79b6636"
LADYBIRD_VERSION="2026.47.7"
WEBKIT_COMMIT="0742522b24152262b04913242cb0b3c48de92ba0"
ZLIB_COMMIT="4028ebf8710ee39d2286cb0f847f9b95c59f84d8"
ZLIB_URI="https://chromium.googlesource.com/chromium/src/third_party/zlib/+/${ZLIB_COMMIT}/google"
DESCRIPTION="OpenGL ES implementation used by Ladybird"
HOMEPAGE="https://angleproject.org/"
SRC_URI="
	https://github.com/google/angle/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz
	https://download.ladybird.org/linux/${LADYBIRD_VERSION}/ladybird-${LADYBIRD_VERSION}-source.tar.xz
	https://raw.githubusercontent.com/WebKit/WebKit/${WEBKIT_COMMIT}/Source/ThirdParty/ANGLE/gni-to-cmake.py
		-> ${P}-gni-to-cmake.py
	https://raw.githubusercontent.com/WebKit/WebKit/${WEBKIT_COMMIT}/Source/ThirdParty/ANGLE/include/CMakeLists.txt
		-> ${P}-include-CMakeLists.txt
	${ZLIB_URI}/compression_utils_portable.cc?format=TEXT
		-> ${P}-compression_utils_portable.cc.base64
	${ZLIB_URI}/compression_utils_portable.h?format=TEXT
		-> ${P}-compression_utils_portable.h.base64
"
S="${WORKDIR}/angle-${MY_COMMIT}"

LICENSE="BSD ZLIB"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	media-libs/libglvnd
	virtual/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/ply[${PYTHON_USEDEP}]')
"

python_check_deps() {
	python_has_version "dev-python/ply[${PYTHON_USEDEP}]"
}

src_unpack() {
	unpack "${P}.tar.gz" "ladybird-${LADYBIRD_VERSION}-source.tar.xz"
}

src_prepare() {
	local port="${WORKDIR}/ladybird-${LADYBIRD_VERSION}/Meta/CMake/vcpkg/overlay-ports/angle"
	eapply "${port}"/001-fix-builder-error.patch "${port}"/002-bsd-support.patch
	cp -r "${port}/cmake-buildsystem/". . || die
	cp "${port}/unofficial-angle-config.cmake" . || die
	cp "${DISTDIR}/${P}-include-CMakeLists.txt" include/CMakeLists.txt || die
	mkdir -p third_party/zlib/google || die
	local ext
	for ext in cc h ; do
		base64 -d "${DISTDIR}/${P}-compression_utils_portable.${ext}.base64" \
			> "third_party/zlib/google/compression_utils_portable.${ext}" || die
	done

	local input output
	for input in compiler libGLESv2 ; do
		output=GLESv2
		[[ ${input} == compiler ]] && output=Compiler
		"${PYTHON}" "${DISTDIR}/${P}-gni-to-cmake.py" "src/${input}.gni" "${output}.cmake" || die
	done
	for input in d3d gl metal ; do
		case ${input} in
			d3d) output=D3D ;;
			gl) output=GL ;;
			metal) output=Metal ;;
		esac
		"${PYTHON}" "${DISTDIR}/${P}-gni-to-cmake.py" \
			"src/libANGLE/renderer/${input}/BUILD.gn" "${output}.cmake" \
			--prepend "src/libANGLE/renderer/${input}/" || die
	done

	cat > src/common/angle_commit.h <<-EOF || die
	#define ANGLE_COMMIT_HASH "${MY_COMMIT:0:12}"
	#define ANGLE_COMMIT_HASH_SIZE 12
	#define ANGLE_COMMIT_DATE "invalid-date"
	#define ANGLE_REVISION ${PV}
	EOF
	cat > src/common/ANGLEShaderProgramVersion.h <<-EOF || die
	#define ANGLE_PROGRAM_VERSION "${MY_COMMIT:0:12}"
	#define ANGLE_PROGRAM_VERSION_HASH_SIZE 12
	EOF

	# Keep EGL/GLES libraries and headers separate from the system OpenGL stack.
	sed -i \
		-e "s|LIBRARY DESTINATION lib|LIBRARY DESTINATION $(get_libdir)/angle|" \
		-e "s|ARCHIVE DESTINATION lib|ARCHIVE DESTINATION $(get_libdir)/angle|" \
		-e 's|INSTALL_INTERFACE:include>|INSTALL_INTERFACE:include/angle>|' \
		CMakeLists.txt || die
	sed -i '/^install($/,$d' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DANGLE_IS_64_BIT_CPU=ON
		-DBUILD_SHARED_LIBS=ON
		-DPORT=Linux
		-DCMAKE_POLICY_VERSION_MINIMUM=3.10
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto /usr/include/angle
	doins -r include/{EGL,GLES,GLES2,GLES3,KHR,platform}
}
