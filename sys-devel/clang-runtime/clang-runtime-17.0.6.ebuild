# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build toolchain-funcs

DESCRIPTION="Meta-ebuild for clang runtime libraries"
HOMEPAGE="https://clang.llvm.org/"

LICENSE="metapackage"
SLOT="${PV%%.*}"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~arm64-macos ~ppc-macos ~x64-macos"
IUSE="+compiler-rt libcxx openmp +sanitize"
REQUIRED_USE="sanitize? ( compiler-rt )"

RDEPEND="
	compiler-rt? (
		~sys-libs/compiler-rt-${PV}:${SLOT}[abi_x86_32(+)?,abi_x86_64(+)?]
		sanitize? (
			~llvm-runtimes/compiler-rt-sanitizers-${PV}:${SLOT}[abi_x86_32(+)?,abi_x86_64(+)?]
		)
	)
	libcxx? ( >=llvm-runtimes/libcxx-${PV}[${MULTILIB_USEDEP}] )
	openmp? ( >=llvm-runtimes/openmp-${PV}[${MULTILIB_USEDEP}] )
"

pkg_pretend() {
	if tc-is-clang; then
		ewarn "You seem to be using clang as a system compiler.  As of clang-16,"
		ewarn "upstream has turned a few warnings that commonly occur during"
		ewarn "configure script runs into errors by default.  This causes some"
		ewarn "configure tests to start failing, sometimes resulting in silent"
		ewarn "breakage, missing functionality or runtime misbehavior.  It is"
		ewarn "not yet clear whether the change will remain or be reverted."
		ewarn
		ewarn "For more information, please see:"
		ewarn "https://discourse.llvm.org/t/configure-script-breakage-with-the-new-werror-implicit-function-declaration/65213"
	fi
}
