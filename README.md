# ThunderStormS Kernel for Samsung Galaxy :
# S20 devices

Kernel Project by Team ThunderStorms

ThunderStorms kernel is based on Cruel Kernel - big thanks and credits to
Cruel Kernel Team.

Based on samsung sources and android common tree.
Supported devices:
G980F

## Credits

- Exynoobs Team
- Switch-Gott
- Jesse Chan (jesec)
- CruelKernel
- @evdenis - for kernel source and updates from Samsung source, toolchains

## How to install

First of all, TWRP Recovery + multidisabler should be installed in all cases.
It's a preliminary step. Next, backup your existing kernel. You will be able
to restore it from TWRP Recovery in case of problems.

### TWRP

Reboot to TWRP Recovery. Flash boot.img in boot slot.

### Heimdall

Reboot to Download Mode.
```bash
$ sudo heimdall flash --BOOT boot.img
```

### Franco Kernel Manager

Flash boot.img with FK Manager.

## Pin problem (Can't login)

The problem is not in sources. It's due to os_patch_level mismatch with you current
kernel (and/or twrp). CruelKernel/ThunderStorms uses common security patch date to be
in sync with the official twrp and samsung firmware. You can check the default os_patch_level
in build.mkbootimg.* files. However, this date can be lower than other kernels use. When
you flash a kernel with an earlier patch date on top of the previous one with a higher
date, android activates rollback protection mechanism and you face the pin problem. It's
impossible to use a "universal" os_patch_level because different users use different
custom kernels and different firmwares. CruelKernel uses the common date by default
in order to suite most of users.

How can you solve the problem? 6 different ways:
- You can restore your previous kernel and unlock problem will gone
  in TWRP to set the os_patch_level date for your boot and recovery partitions to 2099-12.
  You can use other than 2099-12 date in the zip filename. You need to set it to the same
  or greater date as your previous kernel. Nemesis and Los (from ivanmeller) kernels use 2099-12.
  Max possible date is: 2127-12. It will be used if there will be no date in the zip filename.
- You can check the os_patch_level date of your previous kernel here
  https://cruelkernel.org/tools/bootimg/ and patch cruel kernel image to the same date.
  If your previous kernel is nemesis, patch cruel to 2099-12 date.
- You can reboot to TWRP, navigate to data/system and delete 3 files those names starts
  with 'lock'. Reboot. Login, set a new pin. To fix samsung account login, reinstall the app
- You can rebuild cruel kernel with os_patch_level that suites you. To do it, you need to
  add the line os_patch_level="\<your date\>" to the main.yml cruel configuration.
  See the next section if you want to rebuild the kernel.
- You can do the full wipe during cruel kernel flashing

----------------------------------------------------------------------------------------
## DESCRIPTION FROM CRUEL KERNEL - thx to the Cruel Kernel Team
----------------------------------------------------------------------------------------

## How to build the kernel locally on your PC

This instructions assumes you are using Linux. Install heimdall if you want to flash the
kernel automatically.

Next:
```sh
# Install prerequisites
# If you use ubuntu or ubuntu based distro then you need to install these tools:
$ sudo apt-get install build-essential libncurses-dev libtinfo5 bc bison flex libssl-dev libelf-dev
# If you use Fedora:
$ sudo dnf group install "Development Tools"
$ sudo dnf install ncurses-devel ncurses-compat-libs bc bison flex elfutils-libelf-devel openssl-devel

# Install mkbootimg
$ wget -q https://android.googlesource.com/platform/system/tools/mkbootimg/+archive/refs/heads/master.tar.gz -O - | tar xzf - mkbootimg.py
$ chmod +x mkbootimg.py
$ sudo mv mkbootimg.py /usr/local/bin/mkbootimg

# Get the sources
$ git clone https://github.com/ThunderStorms21th/Galaxy-S10
$ cd Galaxy-S20
# List available branches
$ git branch -a | grep remotes | grep ts | cut -d '/' -f 3
# Switch to the branch you need
$ git checkout master
# Install compilers
$ git submodule update --init --recursive
# Compile
$ ./build mkimg name="ThunderStorms" model=G980F
# You will find your kernel in boot.img file after compilation inside the prime folder.
$ ls -lah ./boot.img

# You can automatically flash the kernel with heimdall
# if you connect your phone to the PC and execute:
$ ./build :flash

# Or in a single command (compilation with flashing)
# ./build flash name="ThunderStorms" model=G980F
```
----------------------------------------------------------------------------------------
# Available toolchains:

- default - standard toolchain from samsung's kernel archives for S10/Note10 models (clang6/gcc4.9)
- samsung - samsung's toolchain from S20 sources archive (clang8/gcc-4.9)
- proton  - bleeding-edge clang 12 (https://github.com/kdrag0n/proton-clang)
- arter97 - stable gcc 10.2.0 (https://github.com/arter97/arm64-gcc)
- arm     - arm's gcc 9.2-2019.12 (https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads)
- system  - gcc cross compiler installed in your system

----------------------------------------------------------------------------------------
# WHAT IS LINUX KERNEL:

Best Overview can be found interviewing the chef who cooked the dish!
Linux kernel release notes are linked for refernce <http://kernel.org/>

# WHAT HARDWARE SUPPORTS LINUX:

  Although originally developed first for 32-bit x86-based PCs (386 or higher),
  today Linux also runs on devices with very least of hardware

  Linux is easily portable to most general-purpose 32- or 64-bit architectures
  as long as they have a paged memory management unit (PMMU) and a port of the
  GNU C compiler (gcc) (part of The GNU Compiler Collection, GCC)

# DOCUMENTATION:

 - There is a lot of documentation available both in electronic form on
   the Internet and in books, both Linux-specific and pertaining to
   general UNIX questions.  I'd recommend looking into the documentation
   subdirectories on any Linux FTP site for the LDP (Linux Documentation
   Project) books.  This README is not meant to be documentation on the
   system: there are much better sources available.

 - There are various README files in the Documentation/ subdirectory:
   these typically contain kernel-specific installation notes for some 
   drivers for example. See Documentation/00-INDEX for a list of what
   is contained in each file.  Please read the Changes file, as it
   contains information about the problems, which may result by upgrading
   your kernel.

 - The Documentation/DocBook/ subdirectory contains several guides for
   kernel developers and users.  These guides can be rendered in a
   number of formats:  PostScript (.ps), PDF, HTML, & man-pages, among others.
   After installation, "make psdocs", "make pdfdocs", "make htmldocs",
   or "make mandocs" will render the documentation in the requested format.

# INSTALLING SOURCES:

 - If you install the full sources, put the kernel tarball in a
   directory where you have permissions (eg. your home directory) and
   unpack it:

     gzip -cd linux-4.X.tar.gz | tar xvf -

   or

     bzip2 -dc linux-4.X.tar.bz2 | tar xvf -

   Replace "X" with the version number of the latest kernel.

   Do NOT use the /usr/src/linux area! This area has a (usually
   incomplete) set of kernel headers that are used by the library header
   files.  They should match the library, and not get messed up by
   whatever the kernel-du-jour happens to be.

 - You can also upgrade between 4.x releases by patching.  Patches are
   distributed in the traditional gzip and the newer bzip2 format.  To
   install by patching, get all the newer patch files, enter the
   top level directory of the kernel source (linux-4.X) and execute:

     gzip -cd ../patch-4.x.gz | patch -p1

   or

     bzip2 -dc ../patch-4.x.bz2 | patch -p1

   Replace "x" for all versions bigger than the version "X" of your current
   source tree, _in_order_, and you should be ok.  You may want to remove
   the backup files (some-file-name~ or some-file-name.orig), and make sure
   that there are no failed patches (some-file-name# or some-file-name.rej).
   If there are, either you or I have made a mistake.

   Unlike patches for the 4.x kernels, patches for the 4.x.y kernels
   (also known as the -stable kernels) are not incremental but instead apply
   directly to the base 4.x kernel.  For example, if your base kernel is 4.0
   and you want to apply the 4.0.3 patch, you must not first apply the 4.0.1
   and 4.0.2 patches. Similarly, if you are running kernel version 4.0.2 and
   want to jump to 4.0.3, you must first reverse the 4.0.2 patch (that is,
   patch -R) _before_ applying the 4.0.3 patch. You can read more on this in
   Documentation/applying-patches.txt

   Alternatively, the script patch-kernel can be used to automate this
   process.  It determines the current kernel version and applies any
   patches found.

     linux/scripts/patch-kernel linux

   The first argument in the command above is the location of the
   kernel source.  Patches are applied from the current directory, but
   an alternative directory can be specified as the second argument.

 - Make sure you have no stale .o files and dependencies lying around:

     cd linux
     make mrproper

   You should now have the sources correctly installed.

# SOFT REQUIREMENTS:

   Compiling and running the 4.x kernels requires up-to-date
   versions of various software packages.Beware that using
   excessively old versions of these packages can cause indirect
   errors that are very difficult to track down, so don't assume that
   you can just update packages when obvious problems arise during
   build or operation.

# SET UP LOCALS:

   When compiling the kernel, all output files will per default be
   stored together with the kernel source code.
   Using the option "make O=output/dir" allow you to specify an alternate
   place for the output files (including .config).
   Example:

     kernel source code: /usr/src/linux-4.X
     build directory:    /home/name/build/kernel

   To configure and build the kernel, use:

     cd /usr/src/linux-4.X
     make O=/home/name/build/kernel menuconfig
     make O=/home/name/build/kernel
     sudo make O=/home/name/build/kernel modules_install install

   Please note: If the 'O=output/dir' option is used, then it must be
   used for all invocations of make.

# CONFIGURING THE KERNEL:

   Do not skip this step even if you are only upgrading one minor
   version.  New configuration options are added in each release, and
   odd problems will turn up if the configuration files are not set up
   as expected.  If you want to carry your existing configuration to a
   new version with minimal work, use "make oldconfig", which will
   only ask you for the answers to new questions.

 # CONFIGURATION COMMANDS:

     make config :     Plain text interface.

     make menuconfig :  Text based color menus, radiolists & dialogs.

     make nconfig :     Enhanced text based color menus.

     make xconfig :     X windows (Qt) based configuration tool.

     make gconfig :     X windows (Gtk) based configuration tool.

     make oldconfig :   Default all questions based on the contents of
                        your existing ./.config file and asking about
                        new config symbols.

     make silentoldconfig : Like above, but avoids cluttering the screen
                            with questions already answered. Additionally updates the dependencies.

     make olddefconfig : Like above, but sets new symbols to their default
                         values without prompting.

     make defconfig :   Create a ./.config file by using the default
                        symbol values from either arch/$ARCH/defconfig
                        or arch/$ARCH/configs/${PLATFORM}_defconfig,
                        depending on the architecture.

     make ${PLATFORM}_defconfig : Create a ./.config file by using the default
                        symbol values from arch/$ARCH/configs/${PLATFORM}_defconfig.
                        symbol values from Use "make help" to get a list of all available platforms of your architecture.

     make allyesconfig : Create a ./.config file by setting symbol
                         values to 'y' as much as possible.

     make allmodconfig : Create a ./.config file by setting symbol
                         values to 'm' as much as possible.

     make allnoconfig : Create a ./.config file by setting symbol
                        values to 'n' as much as possible.

     make randconfig :  Create a ./.config file by setting symbol
                        values to random values.

     make localmodconfig : Create a config based on current config and
                           loaded modules (lsmod). Disables any module
                           option that is not needed for the loaded modules.

                           To create a localmodconfig for another machine,
                           store the lsmod of that machine into a file
                           and pass it in as a LSMOD parameter.

                           target$ lsmod > /tmp/mylsmod
                           target$ scp /tmp/mylsmod host:/tmp

                           host$ make LSMOD=/tmp/mylsmod localmodconfig

                           The above also works when cross compiling.

     make localyesconfig : Similar to localmodconfig, except it will convert
                           all module options to built in (=y) options.

   You can find more information on using the Linux kernel config tools
   in Documentation/kbuild/kconfig.txt.

# CAUTIOUS CONFIGURATION:

    - Having unnecessary drivers will make the kernel bigger, and can
      under some circumstances lead to problems: probing for a
      nonexistent controller card may confuse your other controllers

    - Compiling the kernel with "Processor type" set higher than 386
      will result in a kernel that does NOT work on a 386.  The
      kernel will detect this on bootup, and give up.

    - A kernel with math-emulation compiled in will still use the
      coprocessor if one is present: the math emulation will just
      never get used in that case.  The kernel will be slightly larger,
      but will work on different machines regardless of whether they
      have a math coprocessor or not.

    - The "kernel hacking" configuration details usually result in a
      bigger or slower kernel (or both), and can even make the kernel
      less stable by configuring some routines to actively try to
      break bad code to find kernel problems (kmalloc()).  Thus you
      should probably answer 'n' to the questions for "development",
      "experimental", or "debugging" features.

# COMPILING THE KERNEL:

 - Make sure you have at least gcc available.
   For more information, refer to Documentation/Changes.

   Please note that you can still run a.out user programs with this kernel.

 - Do a "make" to create a compressed kernel image. It is also
   possible to do "make install" if you have lilo installed to suit the
   kernel makefiles, but you may want to check your particular lilo setup first.

   To do the actual install, you have to be root, but none of the normal
   build should require that. Don't take the name of root in vain.

 - If you configured any of the parts of the kernel as `modules', you
   will also have to do "make modules_install".

 - Verbose kernel compile/build output:

   Normally, the kernel build system runs in a fairly quiet mode (but not
   totally silent).  However, sometimes you or other kernel developers need
   to see compile, link, or other commands exactly as they are executed.
   For this, use "verbose" build mode.  This is done by inserting
   "V=1" in the "make" command.  E.g.:

     make V=1 all

   To have the build system also tell the reason for the rebuild of each
   target, use "V=2".  The default is "V=0".

 - Keep a backup kernel handy in case something goes wrong.  This is 
   especially true for the development releases, since each new release
   contains new code which has not been debugged.  Make sure you keep a
   backup of the modules corresponding to that kernel, as well.  If you
   are installing a new kernel with the same version number as your
   working kernel, make a backup of your modules directory before you
   do a "make modules_install".

   Alternatively, before compiling, use the kernel config option
   "LOCALVERSION" to append a unique suffix to the regular kernel version.
   LOCALVERSION can be set in the "General Setup" menu.

 - In order to boot your new kernel, you'll need to copy the kernel
   image (e.g. .../linux/arch/i386/boot/bzImage after compilation)
   to the place where your regular bootable kernel is found. 

 - Booting a kernel directly from a floppy without the assistance of a
   bootloader such as LILO, is no longer supported.

   If you boot Linux from the hard drive, chances are you use LILO, which
   uses the kernel image as specified in the file /etc/lilo.conf.  The
   kernel image file is usually /vmlinuz, /boot/vmlinuz, /bzImage or
   /boot/bzImage.  To use the new kernel, save a copy of the old image
   and copy the new image over the old one.  Then, you MUST RERUN LILO
   to update the loading map!! If you don't, you won't be able to boot
   the new kernel image.

   Reinstalling LILO is usually a matter of running /sbin/lilo. 
   You may wish to edit /etc/lilo.conf to specify an entry for your
   old kernel image (say, /vmlinux.old) in case the new one does not
   work.  See the LILO docs for more information. 

   After reinstalling LILO, you should be all set.  Shutdown the system,
   reboot, and enjoy!

   If you ever need to change the default root device, video mode,
   ramdisk size, etc.  in the kernel image, use the 'rdev' program (or
   alternatively the LILO boot options when appropriate).  No need to
   recompile the kernel to change these parameters. 

 - Reboot with the new kernel and enjoy. 

# TROUBLESHOOTING THE BUILD PROCESS:

 - If you have problems that seem to be due to kernel bugs, please check
   the file MAINTAINERS to see if there is a particular person associated
   with the part of the kernel that you are having trouble with. If there
   isn't anyone listed there, then the second best thing is to mail
   them to me (torvalds@linux-foundation.org), and possibly to any other
   relevant mailing-list or to the newsgroup.

 - In all bug-reports, *please* tell what kernel you are talking about,
   how to duplicate the problem, and what your setup is (use your common
   sense).  If the problem is new, tell me so, and if the problem is
   old, please try to tell me when you first noticed it.

 - If the bug results in a message like

     unable to handle kernel paging request at address C0000010
     Oops: 0002
     EIP:   0010:XXXXXXXX
     eax: xxxxxxxx   ebx: xxxxxxxx   ecx: xxxxxxxx   edx: xxxxxxxx
     esi: xxxxxxxx   edi: xxxxxxxx   ebp: xxxxxxxx
     ds: xxxx  es: xxxx  fs: xxxx  gs: xxxx
     Pid: xx, process nr: xx
     xx xx xx xx xx xx xx xx xx xx

   or similar kernel debugging information on your screen or in your
   system log, please duplicate it *exactly*.  The dump may look
   incomprehensible to you, but it does contain information that may
   help debugging the problem.  The text above the dump is also
   important: it tells something about why the kernel dumped code (in
   the above example, it's due to a bad kernel pointer). More information
   on making sense of the dump is in Documentation/oops-tracing.txt

 - If you compiled the kernel with CONFIG_KALLSYMS you can send the dump
   as is, otherwise you will have to use the "ksymoops" program to make
   sense of the dump (but compiling with CONFIG_KALLSYMS is usually preferred).
   This utility can be downloaded from
   ftp://ftp.<country>.kernel.org/pub/linux/utils/kernel/ksymoops/ .
   Alternatively, you can do the dump lookup by hand:

 - In debugging dumps like the above, it helps enormously if you can
   look up what the EIP value means.  The hex value as such doesn't help
   me or anybody else very much: it will depend on your particular
   kernel setup.  What you should do is take the hex value from the EIP
   line (ignore the "0010:"), and look it up in the kernel namelist to
   see which kernel function contains the offending address.

   To find out the kernel function name, you'll need to find the system
   binary associated with the kernel that exhibited the symptom.  This is
   the file 'linux/vmlinux'.  To extract the namelist and match it against
   the EIP from the kernel crash, do:

     nm vmlinux | sort | less

   This will give you a list of kernel addresses sorted in ascending
   order, from which it is simple to find the function that contains the
   offending address.  Note that the address given by the kernel
   debugging messages will not necessarily match exactly with the
   function addresses (in fact, that is very unlikely), so you can't
   just 'grep' the list: the list will, however, give you the starting
   point of each kernel function, so by looking for the function that
   has a starting address lower than the one you are searching for but
   is followed by a function with a higher address you will find the one
   you want.  In fact, it may be a good idea to include a bit of
   "context" in your problem report, giving a few lines around the
   interesting one. 

   If you for some reason cannot do the above (you have a pre-compiled
   kernel image or similar), telling me as much about your setup as
   possible will help.  Please read the REPORTING-BUGS document for details.

 - Alternatively, you can use gdb on a running kernel. (read-only; i.e. you
   cannot change values or set break points.) To do this, first compile the
   kernel with -g; edit arch/i386/Makefile appropriately, then do a "make
   clean". You'll also need to enable CONFIG_PROC_FS (via "make config").

   After you've rebooted with the new kernel, do "gdb vmlinux /proc/kcore".
   You can now use all the usual gdb commands. The command to look up the
   point where your system crashed is "l *0xXXXXXXXX". (Replace the XXXes
   with the EIP value.)

   gdb'ing a non-running kernel currently fails because gdb (wrongly)
   disregards the starting offset for which the kernel is compiled.
   

