#!/bin/bash
#
# Kernel Build Script v2.0 for ThunderStorms S20 series kernels
#
# XDA@nalas

# Setup
export PLATFORM_VERSION=11
export ANDROID_MAJOR_VERSION=r
export ARCH=arm64
export CROSS_COMPILE=$(pwd)/toolchain/gcc-cfp/gcc-cfp-jopp-only/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CLANG_TRIPLE=aarch64-linux-gnu-
export LINUX_GCC_CROSS_COMPILE_PREBUILTS_BIN=$(pwd)/toolchain/gcc-cfp/gcc-cfp-jopp-only/aarch64-linux-android-4.9/bin
export CLANG_PREBUILT_BIN=$(pwd)/toolchain/clang/host/linux-x86/clang-r349610-jopp/bin/clang
export CC=$(pwd)/toolchain/clang/host/linux-x86/clang-r349610-jopp/bin/clang
#export CLANG_PREBUILT_BIN=$(pwd)/toolchain/clang-12/host/linux-x86/clang-r416183c/bin
#export CC=$(pwd)/toolchain/clang-12/host/linux-x86/clang-r416183c/bin
#export CLANG_PREBUILT_BIN=$(pwd)/toolchain/clang-11/host/linux-x86/clang-r399163b/bin
#export CC=$(pwd)/toolchain/clang-11/host/linux-x86/clang-r399163b/bin/clang
#export CLANG_PREBUILT_BIN=$(pwd)/toolchain/clang/host/linux-x86/clang-r349610-jopp/bin
#export CC=$(pwd)/toolchain/clang/host/linux-x86/clang-r349610-jopp/bin/clang
#export CLANG_PREBUILT_BIN=$(pwd)/toolchain/clang-9/bin
#export CC=$(pwd)/toolchain/clang-9/bin
#export CLANG_PREBUILT_BIN=$(pwd)/toolchain/clang-13/bin
#export CC=$(pwd)/toolchain/clang-13/bin
export PATH=$PATH:$LINUX_GCC_CROSS_COMPILE_PREBUILTS_BIN:$CLANG_PREBUILT_BIN:$CC
export LLVM=1
# -----------------------------

# Paths
OUTDIR=$(pwd)/arch/arm64/boot
DTBDIR=$OUTDIR/dtb
DTB_DIR=$(pwd)/arch/arm64/boot/dts
DTCTOOL=$(pwd)/scripts/dtc/dtc
INCDIR=$(pwd)/include
PAGE_SIZE=2048
DTB_PADDING=0
LOG=compile_build.log
# -----------------------------

# Kernel name
KERNEL_NAME="LOCALVERSION=-ThunderStormS-v1.0-DUF9-OneUI3"
DEFCONFIG1=exynos9830-z3sxxx_defconfig
DEFCONFIG2=exynos9830-x1slte_defconfig
DEFCONFIG3=exynos9830-y2slte_defconfig
DEFCONFIG4=exynos9830-x1sxxx_defconfig
DEFCONFIG5=exynos9830-y2sxxx_defconfig
DEFCONFIG_TS=ts_defconfig
# -----------------------------

# FUNCTIONS
# ---------
DELETE_PLACEHOLDERS()
{
	find . -name \.placeholder -type f -delete
        echo "Placeholders Deleted from Ramdisk"
        echo ""
}

CLEAN_DTB()
{
	if ! [ -d $(pwd)/arch/arm64/boot/dts ] ; then
		echo "no directory : "$(pwd)/arch/arm64/boot/dts""
	else
		echo "rm files in : "$(pwd)/arch/arm64/boot/dts/*.dtb""
		rm $(pwd)/arch/arm64/boot/dts/exynos/*.dtb
		rm $(pwd)/arch/arm64/boot/dts/exynos/*.dtb_dtout
		rm $(pwd)/arch/arm64/boot/dts/exynos/*.dtb.dtout
		rm $(pwd)/arch/arm64/boot/dts/exynos/*.dtb.reverse.dts
		rm $(pwd)/arch/arm64/boot/dts/samsung/*.dtb
		rm $(pwd)/arch/arm64/boot/dts/samsung/*.dtb_dtout
		rm $(pwd)/arch/arm64/boot/dts/samsung/*.dtb.dtout
		rm $(pwd)/arch/arm64/boot/dts/samsung/*.dtb.reverse.dts
		rm $(pwd)/arch/arm64/boot/boot.img-dtb
		rm $(pwd)/arch/arm64/boot/boot.img-kernel
	fi
}

BUILD_KERNEL_988B()
{
    # Make .config
	cp -f $(pwd)/arch/arm64/configs/$DEFCONFIG1 $(pwd)/arch/arm64/configs/tmp_defconfig
	cat $(pwd)/arch/arm64/configs/$DEFCONFIG_TS >> $(pwd)/arch/arm64/configs/tmp_defconfig

    # Compile kernels
    echo "***** Compiling kernel *****"
    [ ! -d "out" ] && mkdir out
    [ ! -d "out/SM-988B" ] && mkdir out/SM-988B
    # SM-G988B
    make -j$(nproc) -C $(pwd) $KERNEL_NAME tmp_defconfig
    make -j$(nproc) -C $(pwd) $KERNEL_NAME
    [ -e arch/arm64/boot/Image.gz ] && cp arch/arm64/boot/Image.gz $(pwd)/out/SM-988B/Image.gz
    if [ -e arch/arm64/boot/Image ]; then
      cp arch/arm64/boot/Image $(pwd)/out/SM-988B/Image
      # DTB for Exynos 9830 - SM-G988B
      echo "***** Compiling Device Tree Blobs *****"
      $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-988B/dtb.img dt.configs/exynos9830.cfg -d ${DTB_DIR}/exynos
      $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-988B/dtbo.img dt.configs/z3sxxx.cfg -d ${DTB_DIR}/samsung
    else
      echo "return to Main menu' 'Kernel STUCK in BUILD!"
    fi
}

BUILD_KERNEL_980F()
{
    # Make .config
	cp -f $(pwd)/arch/arm64/configs/$DEFCONFIG2 $(pwd)/arch/arm64/configs/tmp_defconfig
	cat $(pwd)/arch/arm64/configs/$DEFCONFIG_TS >> $(pwd)/arch/arm64/configs/tmp_defconfig
    # Compile kernels
    echo "***** Compiling kernel *****"
    [ ! -d "out" ] && mkdir out
    [ ! -d "out/SM-980F" ] && mkdir out/SM-980F
    # SM-G980F
    make -j$(nproc) -C $(pwd) $KERNEL_NAME tmp_defconfig
    make -j$(nproc) -C $(pwd) $KERNEL_NAME
    [ -e arch/arm64/boot/Image.gz ] && cp arch/arm64/boot/Image.gz $(pwd)/out/SM-980F/Image.gz
    if [ -e arch/arm64/boot/Image ]; then
      cp arch/arm64/boot/Image $(pwd)/out/SM-980F/Image
      # DTB for Exynos 9830 - SM-G980F
      echo "***** Compiling Device Tree Blobs *****"
      $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-980F/dtb.img dt.configs/exynos9830.cfg -d ${DTB_DIR}/exynos
      $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-980F/dtbo.img dt.configs/x1slte.cfg -d ${DTB_DIR}/samsung
    else
      echo "return to Main menu' 'Kernel STUCK in BUILD!"
    fi
}

BUILD_KERNEL_985F()
{
    # Make .config
	cp -f $(pwd)/arch/arm64/configs/$DEFCONFIG3 $(pwd)/arch/arm64/configs/tmp_defconfig
	cat $(pwd)/arch/arm64/configs/$DEFCONFIG_TS >> $(pwd)/arch/arm64/configs/tmp_defconfig
    # Compile kernels
    echo "***** Compiling kernel *****"
    [ ! -d "out" ] && mkdir out
    [ ! -d "out/SM-985F" ] && mkdir out/SM-985F
    # SM-G985F
    make -j$(nproc) -C $(pwd) $KERNEL_NAME tmp_defconfig
    make -j$(nproc) -C $(pwd) $KERNEL_NAME
    [ -e arch/arm64/boot/Image.gz ] && cp arch/arm64/boot/Image.gz $(pwd)/out/SM-985F/Image.gz
    if [ -e arch/arm64/boot/Image ]; then
      cp arch/arm64/boot/Image $(pwd)/out/SM-985F/Image
      # DTB for Exynos 9830 - SM-G985F
      echo "***** Compiling Device Tree Blobs *****"
      $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-985F/dtb.img dt.configs/exynos9830.cfg -d ${DTB_DIR}/exynos
      $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-985F/dtbo.img dt.configs/y2slte.cfg -d ${DTB_DIR}/samsung
    else
      echo "return to Main menu' 'Kernel STUCK in BUILD!"
    fi
}

BUILD_KERNEL_981B()
{
    # Make .config
	cp -f $(pwd)/arch/arm64/configs/$DEFCONFIG4 $(pwd)/arch/arm64/configs/tmp_defconfig
	cat $(pwd)/arch/arm64/configs/$DEFCONFIG_TS >> $(pwd)/arch/arm64/configs/tmp_defconfig
    # Compile kernels
    echo "***** Compiling kernel *****"
    [ ! -d "out" ] && mkdir out
    [ ! -d "out/SM-981B" ] && mkdir out/SM-981B
    # SM-G91BF
    make -j$(nproc) -C $(pwd) $KERNEL_NAME tmp_defconfig
    make -j$(nproc) -C $(pwd) $KERNEL_NAME
    [ -e arch/arm64/boot/Image.gz ] && cp arch/arm64/boot/Image.gz $(pwd)/out/SM-981B/Image.gz
    if [ -e arch/arm64/boot/Image ]; then
      cp arch/arm64/boot/Image $(pwd)/out/SM-981B/Image
      # DTB for Exynos 9830 - SM-G981B
      echo "***** Compiling Device Tree Blobs *****"
      $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-981B/dtb.img dt.configs/exynos9830.cfg -d ${DTB_DIR}/exynos
      $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-981B/dtbo.img dt.configs/x1sxxx.cfg -d ${DTB_DIR}/samsung
    else
      echo "return to Main menu' 'Kernel STUCK in BUILD!"
    fi
}

BUILD_KERNEL_986B()
{
    # Make .config
	cp -f $(pwd)/arch/arm64/configs/$DEFCONFIG5 $(pwd)/arch/arm64/configs/tmp_defconfig
	cat $(pwd)/arch/arm64/configs/$DEFCONFIG_TS >> $(pwd)/arch/arm64/configs/tmp_defconfig
    # Compile kernels
    echo "***** Compiling kernel *****"
    [ ! -d "out" ] && mkdir out
    [ ! -d "out/SM-986B" ] && mkdir out/SM-986B
    # SM-G91BF
    make -j$(nproc) -C $(pwd) $KERNEL_NAME tmp_defconfig
    make -j$(nproc) -C $(pwd) $KERNEL_NAME
    [ -e arch/arm64/boot/Image.gz ] && cp arch/arm64/boot/Image.gz $(pwd)/out/SM-986B/Image.gz
    if [ -e arch/arm64/boot/Image ]; then
      cp arch/arm64/boot/Image $(pwd)/out/SM-986B/Image
      # DTB for Exynos 9830 - SM-G986B
      echo "***** Compiling Device Tree Blobs *****"
      $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-986B/dtb.img dt.configs/exynos9830.cfg -d ${DTB_DIR}/exynos
      $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-986B/dtbo.img dt.configs/y2sxxx.cfg -d ${DTB_DIR}/samsung
    else
      echo "return to Main menu' 'Kernel STUCK in BUILD!"
    fi
}

BUILD_DTB()
{
    # Compile DTB/DTBO images
    echo "***** Compiling Device Tree Blobs *****"
    # DTB for all Exynos 9830 devices
    $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-988B/dtb.img dt.configs/exynos9830.cfg -d ${DTB_DIR}/exynos
    $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-980F/dtb.img dt.configs/exynos9830.cfg -d ${DTB_DIR}/exynos
    $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-985F/dtb.img dt.configs/exynos9830.cfg -d ${DTB_DIR}/exynos
    $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-981B/dtb.img dt.configs/exynos9830.cfg -d ${DTB_DIR}/exynos
    $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-986B/dtb.img dt.configs/exynos9830.cfg -d ${DTB_DIR}/exynos
    # DTBO for Exynos 9830 SM-988B
    $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-988B/dtbo.img dt.configs/z3sxxx.cfg -d ${DTB_DIR}/samsung
    # DTBO for Exynos 9830 SM-980F
    $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-980F/dtbo.img dt.configs/x1slte.cfg -d ${DTB_DIR}/samsung
    # DTBO for Exynos 9830 SM-985F
    $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-985F/dtbo.img dt.configs/y2slte.cfg -d ${DTB_DIR}/samsung
    # DTBO for Exynos 9830 SM-981B
    $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-981B/dtbo.img dt.configs/x1sxxx.cfg -d ${DTB_DIR}/samsung
    # DTBO for Exynos 9830 SM-986B
    $(pwd)/tools/mkdtimg cfg_create $(pwd)/out/SM-986B/dtbo.img dt.configs/y2sxxx.cfg -d ${DTB_DIR}/samsung
}

BUILD_RAMDISK_988B()
{
    # Build Ramdisk and boot.img
    # SM-G988B
    echo ""
    echo "Building Ramdisk for SM-988B"
    mv $(pwd)/out/SM-988B/Image $(pwd)/out/SM-988B/boot.img-kernel
    mv $(pwd)/out/SM-988B/dtb.img $(pwd)/out/SM-988B/boot.img-dtb
    mkdir $(pwd)/builds/temp
    cp -rf $(pwd)/builds/aik/. $(pwd)/builds/temp
    cp -rf $(pwd)/builds/ramdisk/. $(pwd)/builds/temp
    rm -f $(pwd)/builds/temp/split_img/boot.img-kernel
    rm -f $(pwd)/builds/temp/split_img/boot.img-dtb
    mv $(pwd)/out/SM-988B/boot.img-kernel $(pwd)/builds/temp/split_img/boot.img-kernel
    mv $(pwd)/out/SM-988B/boot.img-dtb $(pwd)/builds/temp/split_img/boot.img-dtb
    echo "Done"
    cd $(pwd)/builds/temp
    ./repackimg.sh
    echo SEANDROIDENFORCE >> image-new.img
    cd ..
    cd ..
    mv $(pwd)/builds/temp/image-new.img $(pwd)/builds/SM988B-boot.img
    rm -rf $(pwd)/builds/temp
}

BUILD_RAMDISK_980F()
{
    # SM-G980F
    echo ""
    echo "Building Ramdisk for SM-980F"
    mv $(pwd)/out/SM-980F/Image $(pwd)/out/SM-980F/boot.img-kernel
    mv $(pwd)/out/SM-980F/dtb.img $(pwd)/out/SM-980F/boot.img-dtb
    mkdir $(pwd)/builds/temp
    cp -rf $(pwd)/builds/aik/. $(pwd)/builds/temp
    cp -rf $(pwd)/builds/ramdisk/. $(pwd)/builds/temp
    rm -f $(pwd)/builds/temp/split_img/boot.img-kernel
    rm -f $(pwd)/builds/temp/split_img/boot.img-dtb
    mv $(pwd)/out/SM-980F/boot.img-kernel $(pwd)/builds/temp/split_img/boot.img-kernel
    mv $(pwd)/out/SM-980F/boot.img-dtb $(pwd)/builds/temp/split_img/boot.img-dtb
    echo "Done"
    cd $(pwd)/builds/temp
    ./repackimg.sh
    echo SEANDROIDENFORCE >> image-new.img
    cd ..
    cd ..
    mv $(pwd)/builds/temp/image-new.img $(pwd)/builds/SM980F-boot.img
    rm -rf $(pwd)/builds/temp
}

BUILD_RAMDISK_985F()
{
    # SM-G985F
    echo ""
    echo "Building Ramdisk for SM-985F"
    mv $(pwd)/out/SM-985F/Image $(pwd)/out/SM-985F/boot.img-kernel
    mv $(pwd)/out/SM-985F/dtb.img $(pwd)/out/SM-985F/boot.img-dtb
    mkdir $(pwd)/builds/temp
    cp -rf $(pwd)/builds/aik/. $(pwd)/builds/temp
    cp -rf $(pwd)/builds/ramdisk/. $(pwd)/builds/temp
    rm -f $(pwd)/builds/temp/split_img/boot.img-kernel
    rm -f $(pwd)/builds/temp/split_img/boot.img-dtb
    mv $(pwd)/out/SM-985F/boot.img-kernel $(pwd)/builds/temp/split_img/boot.img-kernel
    mv $(pwd)/out/SM-985F/boot.img-dtb $(pwd)/builds/temp/split_img/boot.img-dtb
    echo "Done"
    cd $(pwd)/builds/temp
    ./repackimg.sh
    echo SEANDROIDENFORCE >> image-new.img
    cd ..
    cd ..
    mv $(pwd)/builds/temp/image-new.img $(pwd)/builds/SM985F-boot.img
    rm -rf $(pwd)/builds/temp
}

BUILD_RAMDISK_981B()
{
    # SM-G981B
    echo ""
    echo "Building Ramdisk for SM-981B"
    mv $(pwd)/out/SM-981B/Image $(pwd)/out/SM-981B/boot.img-kernel
    mv $(pwd)/out/SM-981B/dtb.img $(pwd)/out/SM-981B/boot.img-dtb
    mkdir $(pwd)/builds/temp
    cp -rf $(pwd)/builds/aik/. $(pwd)/builds/temp
    cp -rf $(pwd)/builds/ramdisk/. $(pwd)/builds/temp
    rm -f $(pwd)/builds/temp/split_img/boot.img-kernel
    rm -f $(pwd)/builds/temp/split_img/boot.img-dtb
    mv $(pwd)/out/SM-981B/boot.img-kernel $(pwd)/builds/temp/split_img/boot.img-kernel
    mv $(pwd)/out/SM-981B/boot.img-dtb $(pwd)/builds/temp/split_img/boot.img-dtb
    echo "Done"
    cd $(pwd)/builds/temp
    ./repackimg.sh
    echo SEANDROIDENFORCE >> image-new.img
    cd ..
    cd ..
    mv $(pwd)/builds/temp/image-new.img $(pwd)/builds/SM981B-boot.img
    rm -rf $(pwd)/builds/temp
}

BUILD_RAMDISK_986B()
{
    # SM-G986B
    echo ""
    echo "Building Ramdisk for SM-986B"
    mv $(pwd)/out/SM-986B/Image $(pwd)/out/SM-986B/boot.img-kernel
    mv $(pwd)/out/SM-986B/dtb.img $(pwd)/out/SM-986B/boot.img-dtb
    mkdir $(pwd)/builds/temp
    cp -rf $(pwd)/builds/aik/. $(pwd)/builds/temp
    cp -rf $(pwd)/builds/ramdisk/. $(pwd)/builds/temp
    rm -f $(pwd)/builds/temp/split_img/boot.img-kernel
    rm -f $(pwd)/builds/temp/split_img/boot.img-dtb
    mv $(pwd)/out/SM-986B/boot.img-kernel $(pwd)/builds/temp/split_img/boot.img-kernel
    mv $(pwd)/out/SM-986B/boot.img-dtb $(pwd)/builds/temp/split_img/boot.img-dtb
    echo "Done"
    cd $(pwd)/builds/temp
    ./repackimg.sh
    echo SEANDROIDENFORCE >> image-new.img
    cd ..
    cd ..
    mv $(pwd)/builds/temp/image-new.img $(pwd)/builds/SM986B-boot.img
    rm -rf $(pwd)/builds/temp
}

MAIN()
{

(
    echo ""
    # -----------------------------
    START_TIME=`date +%T`
	START_TIME_SEC=`date +%s`
        BUILD_KERNEL_988B
        BUILD_RAMDISK_988B
        BUILD_KERNEL_981B
        BUILD_RAMDISK_981B
        BUILD_KERNEL_986B
        BUILD_RAMDISK_986B
        BUILD_KERNEL_980F
        BUILD_RAMDISK_980F
        BUILD_KERNEL_985F
        BUILD_RAMDISK_985F
        # BUILD_DTB
    END_TIME=`date +%T`
    END_TIME_SEC=`date +%s`
    # -----------------------------

    # Add making date and hrs to logs
    echo ""
    echo "Start compile time is $START_TIME."
    echo "End compile time is $END_TIME."
	let "ELAPSED_TIME=$END_TIME_SEC - $START_TIME_SEC"
	echo "Total compile time is $ELAPSED_TIME seconds."
    echo ""
) 2>&1 | tee -a ./$LOG

	echo "Your flasheable release can be found in the build folder"
	echo ""
}

# PROGRAM START
# -------------
clear
echo "*****************************************"
echo "*   ThunderStorms Kernel Build Script   *"
echo "*****************************************"
echo ""
echo "    CUSTOMIZABLE STOCK SAMSUNG KERNEL"
echo ""
echo "         Build Kernel for: S20"
echo ""
echo ""
echo "-- Start compiling the kernel."
echo ""
echo ""

DELETE_PLACEHOLDERS
CLEAN_DTB
MAIN
