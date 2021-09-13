#!/bin/bash
#
# ThundeRStorms cleaning script v1.1
#
# XDA@nalas

# Make the source clean
make mrproper

# Remove unused temporary and old files
rm -f compile_build.log
rm -f builds/*.img
rm -f *.img
rm -f arch/arm64/boot/dts/exynos/*.dtb
rm -f arch/arm64/boot/dts/exynos/*.dtbo
rm -f arch/arm64/boot/dts/samsung/*.dtbo
rm -f arch/arm64/boot/dts/samsung/*.dtbo.reverse.dts
rm -f arch/arm64/boot/dts/exynos/*.dtbo.reverse.dts
rm -f arch/arm64/boot/dts/samsung/*.dtbo.dtout
rm -f arch/arm64/boot/dts/exynos/*.dtbo.dtout
rm -f arch/arm64/boot/dts/exynos/*.img
rm -f arch/arm64/boot/dts/samsung/*.img

# Locate placeholder in empty Ramdisk folders
echo "" > $PWD/builds/ramdisk/ramdisk/avb/.placeholder
echo "" > $PWD/builds/ramdisk/ramdisk/debug_ramdisk/.placeholder
echo "" > $PWD/builds/ramdisk/ramdisk/dev/.placeholder
echo "" > $PWD/builds/ramdisk/ramdisk/mnt/.placeholder
echo "" > $PWD/builds/ramdisk/ramdisk/proc/.placeholder
echo "" > $PWD/builds/ramdisk/ramdisk/sys/.placeholder
echo "" > $PWD/builds/ramdisk/ramdisk/.backup/.placeholder
