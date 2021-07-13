#!/bin/bash

export CC_PATH=/disk/Kernel/Toolchain/clang-4639204/bin/clang
export CROSS_COMPILE_PATH=/disk/Kernel/Toolchain/gcc-4.9-64/bin/aarch64-linux-android-
USE_CLANG_TRIPLE=1

BUILD_COMMAND=()
BUILD_COMMAND+=( 'make CC=${CC_PATH} CROSS_COMPILE=${CROSS_COMPILE_PATH}' )
if [[ ${USE_CLANG_TRIPLE} == 1 ]]; then
	BUILD_COMMAND+=( 'CLANG_TRIPLE=aarch64-linux-gnu-' )
fi

build_defconfig() {
	local i
	for i in arch/arm64/configs/*; do
		i=${i##*/}
		for defconfig in $i; do
			${BUILD_COMMAND[@]} O=out/${i%_*} $i
		done
	done
}

build_kernel() {
	local i
	for i in out/*; do
		${BUILD_COMMAND[@]} O=$i
	done
}

copy_defconfig() {
	local i
	for i in out/*; do
		cp $i/.config arch/arm64/configs/${i##*/}_defconfig
	done
}

if [[ ! $@ == "--build-only" ]]; then
	build_defconfig
elif [[ ! $@ == "--no-copy-defconfig" ]]; then
	copy_defconfig
fi
build_kernel
