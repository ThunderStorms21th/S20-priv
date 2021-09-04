#!/bin/bash


export PLATFORM_VERSION=11
export ANDROID_MAJOR_VERSION=r
export ARCH=arm64

make ARCH=arm64 exynos9830-z3sxxx_defconfig
make ARCH=arm64 -j16