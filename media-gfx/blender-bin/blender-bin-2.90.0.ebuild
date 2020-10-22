# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="http://www.blender.org/"

#SRC_URI="https://www.blender.org/download/Blender2.90/blender-${PV}-linux64.tar.xz -> ${P}.tar.xz"
SRC_URI="https://builder.blender.org/download/blender-${PV}-linux64.tar.xz -> ${P}.tar.xz"

LICENSE="|| ( GPL-2 BL )"
SLOT="2.90"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

QA_PREBUILT="
	/opt/blender-bin/blender-bin
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_curses.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_curses_panel.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_asyncio.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_bisect.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_blake2.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_bz2.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_codecs_cn.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_codecs_hk.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_codecs_iso2022.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_codecs_jp.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_codecs_kr.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_codecs_tw.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_contextvars.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_crypt.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_csv.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_ctypes.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_ctypes_test.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_datetime.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_decimal.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_elementtree.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_hashlib.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_heapq.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_json.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_lsprof.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_lzma.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_md5.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_multibytecodec.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_multiprocessing.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_opcode.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_pickle.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_posixsubprocess.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_queue.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_random.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_sha1.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_sha256.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_sha3.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_sha512.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_socket.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_sqlite3.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_ssl.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_struct.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_testbuffer.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_testcapi.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_testimportmultiple.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_testmultiphase.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/_xxtestfuzz.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/array.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/audioop.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/binascii.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/cmath.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/fcntl.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/grp.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/math.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/mmap.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/nis.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/ossaudiodev.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/parser.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/pyexpat.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/resource.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/select.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/spwd.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/syslog.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/termios.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/unicodedata.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/xxlimited.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/lib-dynload/zlib.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/libextern_draco.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/fft/_pocketfft_internal.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/core/_dummy.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/core/_multiarray_tests.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/core/_multiarray_umath.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/core/_operand_flag_tests.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/core/_rational_tests.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/core/_struct_ufunc_tests.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/core/_umath_tests.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/linalg/_umath_linalg.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/linalg/lapack_lite.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/random/bit_generator.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/random/bounded_integers.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/random/common.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/random/generator.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/random/mt19937.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/random/mtrand.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/random/pcg64.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/random/philox.cpython-37m-x86_64-linux-gnu.so
	/opt/blender-bin/2.90/python/lib/python3.7/site-packages/numpy/random/sfc64.cpython-37m-x86_64-linux-gnu.so
	"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/blender-${PV}-linux64"

src_prepare() {
    default
    sed -e 's|Exec=blender|Exec=/opt/blender-bin/blender-bin|' -i ${S}/blender.desktop || die
    mv ${S}/blender ${S}/blender-bin
    mv ${S}/blender.desktop ${S}/blender-bin.desktop
}

src_install() {
    insinto /opt/blender-bin
    doins -r ${S}/*
    exeinto /opt/blender-bin
    doexe ${S}/blender-bin
    domenu ${S}/blender-bin.desktop
    newicon ${S}/blender-symbolic.svg blender
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
    ewarn ""
    ewarn "You may want to remove the following directory:"
    ewarn "~/.config/blender/${MY_PV}/cache/"
    ewarn "It may contain extra render kernels not tracked by portage"
    ewarn ""
}
