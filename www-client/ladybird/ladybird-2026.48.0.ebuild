# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..15} )
RUST_MIN_VER="1.98.0"
CRATES="
	adblock@0.13.5
	addr@0.15.6
	aead@0.5.2
	aes-gcm@0.10.3
	aes@0.8.4
	aho-corasick@1.1.4
	alloc-no-stdlib@3.0.0
	alloc-stdlib@0.3.0
	allocator-api2@0.2.21
	alsa-sys@0.3.1
	alsa@0.9.1
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.104
	arc-swap@1.9.3
	array-init@2.1.0
	arrayvec@0.7.6
	asn1-rs-derive@0.5.1
	asn1-rs-impl@0.2.0
	asn1-rs@0.6.2
	async-trait@0.1.92
	atomic-waker@1.1.2
	audiopus@0.2.0
	audiopus_sys@0.1.8
	autocfg@1.5.0
	base16ct@1.0.0
	base64@0.22.1
	base64ct@1.8.3
	bindgen@0.72.1
	bitflags@1.3.2
	bitflags@2.11.0
	block-buffer@0.10.4
	block-buffer@0.12.1
	block-padding@0.3.3
	brotli-decompressor@6.3.2
	brotli@9.1.3
	bumpalo@3.20.3
	bytecheck@0.8.3
	bytecheck_derive@0.8.3
	byteorder@1.5.0
	bytes@1.12.1
	calendrical_calculations@0.2.4
	cbc@0.1.2
	cbindgen@0.29.2
	cc@1.5.1
	ccm@0.5.0
	cesu8@1.1.0
	cexpr@0.6.0
	cfg-if@1.0.4
	chacha20@0.9.1
	chacha20poly1305@0.10.1
	chardetng@1.0.0
	cipher@0.4.4
	clang-sys@1.9.1
	clap@4.6.0
	clap_builder@4.6.0
	clap_lex@1.1.0
	cmov@0.5.4
	colorchoice@1.0.5
	combine@4.6.9
	const-oid@0.10.3
	core-foundation-sys@0.8.7
	core_detect@1.0.0
	core_maths@0.1.1
	coreaudio-rs@0.11.3
	coreaudio-sys@0.2.18
	cpal@0.15.3
	cpubits@0.1.1
	cpufeatures@0.2.17
	cpufeatures@0.3.1
	crc-catalog@2.5.0
	crc@3.4.0
	crossbeam-deque@0.8.8
	crossbeam-epoch@0.9.21
	crossbeam-utils@0.8.23
	crypto-bigint@0.7.11
	crypto-common@0.1.7
	crypto-common@0.2.2
	ctr@0.9.2
	ctutils@0.4.8
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@4.1.3
	dasp_sample@0.11.0
	data-encoding@2.11.1
	defmt-macros@1.2.0
	defmt-parser@1.1.0
	defmt@1.2.0
	der-parser@9.0.0
	der@0.8.3
	deranged@0.5.9
	digest@0.10.7
	digest@0.11.3
	displaydoc@0.2.5
	dtls@0.17.3
	ecdsa@0.17.0
	either@1.16.0
	elliptic-curve@0.14.3
	encoding_rs@0.8.44
	env_filter@2.0.0
	env_logger@0.11.11
	equivalent@1.0.2
	errno@0.3.14
	fARM64@0.0.2
	fastrand@2.5.0
	ff@0.14.0
	fiat-crypto@0.2.9
	fiat-crypto@0.3.0
	find-msvc-tools@0.1.14
	flatbuffers@25.12.19
	flate2@1.1.11
	foldhash@0.1.5
	foldhash@0.2.0
	form_urlencoded@1.2.2
	futures-channel@0.3.34
	futures-core@0.3.34
	futures-executor@0.3.34
	futures-io@0.3.34
	futures-macro@0.3.34
	futures-sink@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	futures@0.3.34
	generic-array@0.14.7
	getrandom@0.2.17
	getrandom@0.3.4
	getrandom@0.4.2
	ghash@0.5.1
	glob@0.3.4
	group@0.14.0
	hashbrown@0.15.5
	hashbrown@0.16.1
	hashbrown@0.17.1
	heck@0.5.0
	hex@0.4.3
	hkdf@0.13.0
	hmac@0.12.1
	hmac@0.13.0
	hybrid-array@0.4.15
	iced-x86@1.22.0
	icu_calendar@2.4.0
	icu_calendar_data@2.4.0
	icu_collections@2.2.0
	icu_locale_core@2.4.0
	icu_locale_fallback@2.4.0
	icu_locale_fallback_data@2.4.0
	icu_normalizer@2.2.0
	icu_normalizer_data@2.2.0
	icu_properties@2.2.0
	icu_properties_data@2.2.0
	icu_provider@2.4.0
	id-arena@2.3.0
	idna@1.1.0
	idna_adapter@1.2.2
	indexmap@2.13.1
	inout@0.1.4
	interceptor@0.17.3
	ipnet@2.12.2
	is_terminal_polyfill@1.70.2
	itertools@0.13.0
	itertools@0.14.0
	itoa@1.0.18
	ixdtf@0.6.7
	jiff-core@0.1.1
	jiff-static@0.2.38
	jiff@0.2.38
	jni-sys-macros@0.4.1
	jni-sys@0.3.1
	jni-sys@0.4.1
	jni@0.21.1
	jobserver@0.1.35
	js-sys@0.3.106
	jxl@0.7.4
	jxl_macros@0.7.4
	jxl_simd@0.7.4
	jxl_transforms@0.7.4
	lazy_static@1.5.0
	leb128fmt@0.1.0
	libc@0.2.190
	libloading@0.8.9
	libm@0.2.16
	linux-raw-sys@0.12.1
	litemap@0.8.2
	lock_api@0.4.14
	log@0.4.29
	mach2@0.4.3
	md-5@0.10.6
	memchr@2.8.0
	memoffset@0.7.1
	minimal-lexical@0.2.1
	mio@1.2.4
	multiversion_no_op@1.0.0
	munge@0.4.7
	munge_macro@0.4.7
	ndk-context@0.1.1
	ndk-sys@0.5.0+25.2.9519653
	ndk@0.8.0
	nix@0.26.4
	nom@7.1.3
	num-bigint@0.4.8
	num-bigint@0.5.1
	num-conv@0.2.2
	num-derive@0.4.2
	num-integer@0.1.46
	num-traits@0.2.19
	num_enum@0.7.6
	num_enum_derive@0.7.6
	oboe-sys@0.6.1
	oboe@0.6.1
	oid-registry@0.7.1
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	opaque-debug@0.3.1
	p256@0.14.0
	p384@0.14.0
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	pem-rfc7468@1.0.0
	pem@3.0.6
	percent-encoding@2.3.2
	pin-project-lite@0.2.17
	pin-utils@0.1.1
	pkcs8@0.11.0
	pkg-config@0.3.34
	poly1305@0.8.0
	polyval@0.6.2
	portable-atomic-util@0.2.8
	portable-atomic@1.15.0
	potential_utf@0.1.5
	powerfmt@0.2.1
	ppv-lite86@0.2.21
	precis-core@0.1.11
	precis-profiles@0.1.13
	precis-tools@0.1.10
	prettyplease@0.2.37
	primefield@0.14.0
	primeorder@0.14.0
	proc-macro-crate@3.5.0
	proc-macro2@1.0.106
	psl-types@2.0.11
	psl@2.1.210
	ptr_meta@0.3.2
	ptr_meta_derive@0.3.2
	quote@1.0.45
	r-efi@5.3.0
	r-efi@6.0.0
	rancor@0.1.3
	rand@0.9.5
	rand_chacha@0.9.0
	rand_core@0.10.1
	rand_core@0.6.4
	rand_core@0.9.5
	rayon-core@1.13.0
	rayon@1.12.0
	rcgen@0.13.2
	redox_syscall@0.5.18
	regex-automata@0.4.14
	regex-lite@0.1.9
	regex-syntax@0.8.10
	regex@1.12.3
	rend@0.5.4
	rfc6979@0.6.0
	ring@0.17.14
	rkyv@0.8.18
	rkyv_derive@0.8.18
	rtcp@0.17.3
	rtp@0.17.3
	rustc-demangle@0.1.28
	rustc-hash@2.1.2
	rustc_version@0.4.1
	rusticata-macros@4.1.0
	rustix@1.1.6
	rustls-pki-types@1.15.1
	rustls-webpki@0.103.16
	rustls@0.23.46
	rustversion@1.0.23
	same-file@1.0.6
	scopeguard@1.2.0
	sdp@0.17.3
	seahash@4.1.0
	sec1@0.8.1
	semver@1.0.28
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	serde_spanned@1.1.1
	serdect@0.4.3
	sha1@0.10.7
	sha2@0.10.9
	sha2@0.11.1
	shlex@1.3.0
	shlex@2.0.1
	signal-hook-registry@1.4.8
	signature@3.0.0
	simdutf8@0.1.5
	slab@0.4.12
	smallvec@1.16.5
	smol_str@0.2.2
	socket2@0.5.10
	socket2@0.6.5
	spki@0.8.1
	stable_deref_trait@1.2.1
	strsim@0.11.1
	stun@0.17.3
	substring@1.4.5
	subtle@2.6.1
	syn@2.0.117
	syn@3.0.4
	synstructure@0.13.2
	synstructure@0.14.0
	tempfile@3.27.0
	thiserror-impl@1.0.69
	thiserror-impl@2.0.20
	thiserror@1.0.69
	thiserror@2.0.20
	time-core@0.1.9
	time-macros@0.2.32
	time@0.3.55
	tinystr@0.8.5
	tinyvec@1.13.3
	tokio-macros@2.7.2
	tokio-util@0.7.20
	tokio@1.54.1
	toml@0.9.12+spec-1.1.0
	toml_datetime@0.7.5+spec-1.1.0
	toml_datetime@1.1.2+spec-1.1.0
	toml_edit@0.25.13+spec-1.1.0
	toml_parser@1.1.2+spec-1.1.0
	toml_writer@1.1.1+spec-1.1.0
	turn@0.17.3
	typenum@1.20.1
	ucd-parse@0.1.13
	unicase@2.10.0
	unicode-ident@1.0.24
	unicode-normalization@0.1.26
	unicode-xid@0.2.6
	universal-hash@0.5.1
	untrusted@0.9.0
	url@2.5.8
	utf8_iter@1.0.4
	utf8parse@0.2.2
	uuid@1.29.0
	version_check@0.9.5
	waitgroup@0.1.2
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.2+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-bindgen-futures@0.4.79
	wasm-bindgen-macro-support@0.2.129
	wasm-bindgen-macro@0.2.129
	wasm-bindgen-shared@0.2.129
	wasm-bindgen@0.2.129
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	web-sys@0.3.106
	webrtc-data@0.17.3
	webrtc-ice@0.17.3
	webrtc-mdns@0.17.3
	webrtc-media@0.17.3
	webrtc-sctp@0.17.3
	webrtc-srtp@0.17.3
	webrtc-util@0.17.3
	webrtc@0.17.3
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.54.0
	windows-link@0.2.1
	windows-result@0.1.2
	windows-sys@0.45.0
	windows-sys@0.52.0
	windows-sys@0.61.2
	windows-targets@0.42.2
	windows-targets@0.52.6
	windows@0.54.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.52.6
	winnow@0.7.15
	winnow@1.0.1
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-parser@0.244.0
	wnaf@0.14.1
	writeable@0.6.4
	x25519-dalek@2.0.1
	x509-parser@0.16.0
	yasna@0.5.2
	yoke-derive@0.8.4
	yoke@0.8.4
	yuv@0.8.20
	zerocopy-derive@0.8.63
	zerocopy@0.8.63
	zerofrom-derive@0.1.7
	zerofrom@0.1.7
	zeroize@1.9.1
	zeroize_derive@1.5.0
	zerotrie@0.2.5
	zerovec-derive@0.11.7
	zerovec@0.11.9
	zlib-rs@0.6.8
	zmij@1.0.21
"

inherit cargo cmake optfeature python-any-r1 rust-toolchain toolchain-funcs xdg

LLVM_COMMIT="e54169423e7ee5d8b41c2f1b6f7a59000c901ee0"
HSTS_COMMIT="ba9567c435afe2bb2e71d1a348b3c65790a572db"
PDFJS_VERSION="6.5.438"
MIMALLOC_VERSION="2.2.7"
FFMPEG_VERSION="9.0.2"
DESCRIPTION="Truly independent web browser (alpha)"
HOMEPAGE="https://ladybird.org/ https://github.com/LadybirdBrowser/ladybird"
SRC_URI="
	https://download.ladybird.org/linux/${PV}/${P}-source.tar.xz
	https://github.com/llvm/llvm-project/archive/${LLVM_COMMIT}.tar.gz -> llvm-project-${LLVM_COMMIT}.tar.gz
	https://github.com/google/wuffs-mirror-release-c/archive/refs/tags/v0.3.5.tar.gz -> wuffs-mirror-release-c-0.3.5.tar.gz
	https://raw.githubusercontent.com/chromium/chromium/${HSTS_COMMIT}/net/http/transport_security_state_static.json -> ${P}-hsts.json
	https://github.com/mozilla/pdf.js/releases/download/v${PDFJS_VERSION}/pdfjs-${PDFJS_VERSION}-dist.zip
	https://github.com/microsoft/mimalloc/archive/refs/tags/v${MIMALLOC_VERSION}.tar.gz
		-> mimalloc-${MIMALLOC_VERSION}.tar.gz
	https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz
	https://ffmpeg.org/releases/ffmpeg-6.1.6.tar.xz
	https://ffmpeg.org/releases/ffmpeg-7.1.5.tar.xz
	https://ffmpeg.org/releases/ffmpeg-8.1.3.tar.xz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 ISC LGPL-2.1+ MIT MPL-2.0
	OFL-1.1 Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+wayland"
# Upstream tests include network/browser integration and a large external corpus.
RESTRICT="test"

RDEPEND="
	!www-client/ladybird-bin
	app-misc/ca-certificates
	dev-cpp/cpptrace
	dev-cpp/simdutf:=
	dev-db/sqlite:3
	~dev-libs/angle-7258:0=
	~dev-libs/icu-78.3:=
	dev-libs/libedit
	dev-libs/openssl:=
	dev-libs/simdjson:=
	dev-libs/zmij:=
	>=dev-qt/qtbase-6.10:6[X,gui,network,opengl,wayland=,widgets]
	>=dev-qt/qtpositioning-6.10:6
	media-fonts/liberation-fonts
	media-libs/dav1d:=
	media-libs/fontconfig
	media-libs/harfbuzz:=[icu]
	media-libs/libavif:=[dav1d]
	media-libs/libglvnd
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=[apng]
	media-libs/libpulse
	media-libs/libsdl3[wayland=]
	media-libs/libwebp:=
	media-libs/opus
	~media-libs/skia-148:0=
	media-libs/vulkan-loader[wayland=]
	media-libs/woff2
	net-libs/libpsl
	net-misc/curl[curl_ssl_openssl,http2,ssl,websockets]
	sys-apps/dbus
	virtual/zlib
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/xcb-util-wm
	wayland? ( dev-libs/wayland )
"
DEPEND="${RDEPEND}
	dev-cpp/fast_float
	>=dev-util/vulkan-headers-1.4.321
	>=media-libs/VulkanMemoryAllocator-3.5.0
"
BDEPEND="
	${PYTHON_DEPS}
	app-arch/unzip
	>=dev-build/cmake-3.30
	dev-util/glslang
	dev-vcs/git
	virtual/pkgconfig
	amd64? ( dev-lang/nasm )
	wayland? ( dev-util/wayland-scanner )
"

DOCS=( README.md Documentation/BuildInstructionsLadybird.md )
PATCHES=(
	"${FILESDIR}/${P}-build-flags.patch"
	"${FILESDIR}/${P}-mimalloc.patch"
	"${FILESDIR}/${P}-private-ffmpeg-rpath.patch"
	"${FILESDIR}/${P}-wayland.patch"
)

pkg_setup() {
	rust_pkg_setup
	python-any-r1_pkg_setup
}

src_unpack() {
	unpack "${P}-source.tar.xz" wuffs-mirror-release-c-0.3.5.tar.gz \
		"mimalloc-${MIMALLOC_VERSION}.tar.gz" "ffmpeg-${FFMPEG_VERSION}.tar.xz"
	# Only libc is needed from the LLVM monorepo.
	tar -xf "${DISTDIR}/llvm-project-${LLVM_COMMIT}.tar.gz" \
		"llvm-project-${LLVM_COMMIT}/libc" || die
	mkdir pdfjs || die
	cd pdfjs || die
	unpack "pdfjs-${PDFJS_VERSION}-dist.zip"
	cd "${WORKDIR}" || die
	cargo_crate_unpack
	cargo_gen_config
}

src_prepare() {
	cmake_src_prepare
	mv "${WORKDIR}/mimalloc-${MIMALLOC_VERSION}" mimalloc || die
	pushd "${WORKDIR}/ffmpeg-${FFMPEG_VERSION}" > /dev/null || die
	eapply "${FILESDIR}/${P}-ffmpeg-"{symbol-versions,vulkan-dpb,vulkan-av1}.patch
	popd > /dev/null || die
	cd "${WORKDIR}/pdfjs" || die
	eapply "${FILESDIR}/${P}-pdfjs.patch"
	cd "${S}" || die

	mkdir -p "${BUILD_DIR}/caches/"{HSTSPreload,FFmpegHeaders} "${WORKDIR}/include/wuffs" || die
	# Headers for upstream's optional system-codec adapters; these are never built.
	cp "${DISTDIR}/"ffmpeg-{6.1.6,7.1.5,8.1.3}.tar.xz "${BUILD_DIR}/caches/FFmpegHeaders/" || die
	cp "${DISTDIR}/${P}-hsts.json" \
		"${BUILD_DIR}/caches/HSTSPreload/transport_security_state_static.json" || die
	cp "${WORKDIR}/wuffs-mirror-release-c-0.3.5/release/c/wuffs-v0.3.c" \
		"${WORKDIR}/include/wuffs/" || die
	ln -s "${WORKDIR}/llvm-project-${LLVM_COMMIT}/libc" "${WORKDIR}/include/llvm-libc" || die
}

src_configure() {
	local ffmpeg_prefix="${WORKDIR}/ffmpeg-prefix"
	local private_libdir="${EPREFIX}/usr/$(get_libdir)/ladybird"
	mkdir -p "${WORKDIR}/ffmpeg-build" || die
	pushd "${WORKDIR}/ffmpeg-build" > /dev/null || die
	# Match upstream's codecs and symbol namespaces; install only into WORKDIR.
	"${WORKDIR}/ffmpeg-${FFMPEG_VERSION}/configure" \
		--prefix="${ffmpeg_prefix}" \
		--libdir="${ffmpeg_prefix}/lib" \
		--incdir="${ffmpeg_prefix}/include" \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--ar="$(tc-getAR)" \
		--nm="$(tc-getNM)" \
		--ranlib="$(tc-getRANLIB)" \
		--extra-cflags="${CFLAGS}" \
		--extra-ldflags="${LDFLAGS} -Wl,-rpath,${private_libdir}" \
		--build-suffix=-ladybird \
		--disable-autodetect --disable-stripping \
		--disable-static --enable-shared \
		--disable-programs --disable-doc --disable-network \
		--disable-avdevice --disable-avfilter --disable-avformat --disable-swscale \
		--disable-everything \
		--enable-avcodec --enable-avutil --enable-swresample \
		--enable-libdav1d --enable-libopus --enable-zlib \
		--enable-vulkan --enable-libdrm \
		--enable-decoder=vp8,vp9,av1,libdav1d,theora,vorbis,opus,flac,mp3float,pcm_u8,pcm_s16le,pcm_s24le,pcm_s32le,pcm_f32le,pcm_alaw,pcm_mulaw \
		--enable-parser=vp8,vp9,av1,mpegaudio \
		--enable-encoder=libopus \
		--enable-hwaccel=vp9_vulkan,av1_vulkan \
		|| die
	# CMake resolves the shared library SONAMEs during configuration.
	emake
	emake install-headers install-libs
	popd > /dev/null || die
	export PKG_CONFIG_PATH="${ffmpeg_prefix}/lib/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}"

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DBUILD_TESTING=OFF
		-DENABLE_CLANG_PLUGINS=OFF
		-DENABLE_INSTALL_HEADERS=OFF
		-DENABLE_INSTALL_FREEDESKTOP_FILES=ON
		-DENABLE_NETWORK_DOWNLOADS=OFF
		-DENABLE_WAYLAND=$(usex wayland)
		-DINCLUDE_WASM_SPEC_TESTS=OFF
		-DLADYBIRD_ENABLE_CCACHE=OFF
		-DLADYBIRD_ENABLE_UPDATE_CHECK=OFF
		-DLADYBIRD_VERSION="${PV}"
		-DLADYBIRD_CACHE_DIR="${BUILD_DIR}/caches"
		-DLLVM_LIBC_INCLUDE_DIR="${WORKDIR}/include"
		-DWUFFS_INCLUDE_DIR="${WORKDIR}/include"
		-DPDFJS_DIR="${WORKDIR}/pdfjs"
		-DPython3_EXECUTABLE="${PYTHON}"
		-DRUST_CARGO="${CARGO}"
		-DRUST_RUSTC="${RUSTC}"
		-DRUST_TARGET_TRIPLE="$(rust_abi)"
		-DCMAKE_INSTALL_LIBEXECDIR=libexec/ladybird
		-DCMAKE_INSTALL_RPATH="${private_libdir};${EPREFIX}/usr/$(get_libdir)/angle"
	)
	cmake_src_configure
}

src_compile() {
	# Build-time helpers need the private libraries before the package is installed.
	LD_LIBRARY_PATH="${WORKDIR}/ffmpeg-prefix/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" \
		cmake_src_compile ladybird WebDriver
}

src_install() {
	local component
	for component in ladybird_Runtime ladybird_Freedesktop ; do
		DESTDIR="${D}" cmake --install "${BUILD_DIR}" --component "${component}" || die
	done
	einstalldocs
	dosym Ladybird /usr/bin/ladybird
	# Ship only the private runtime libraries, with no public headers or pkg-config files.
	local private_libdir="/usr/$(get_libdir)/ladybird"
	dodir "${private_libdir}"
	cp -a "${WORKDIR}/ffmpeg-prefix/lib/"lib{avcodec,avutil,swresample}-ladybird.so* \
		"${ED}${private_libdir}/" || die
	docinto ffmpeg
	dodoc "${WORKDIR}/ffmpeg-${FFMPEG_VERSION}/"{LICENSE.md,COPYING.LGPLv2.1}
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "additional media codecs (H.264/AAC)" media-video/ffmpeg
}
