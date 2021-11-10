# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
	alias vi='vim'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export MY_CVS_SOURCE_PATH=/home/sobyungjun/blackbox/janus_nvs3310


#TIBET_PROJECT=next
#TIBET_PROJECT=dm36x
#TIBET_PROJECT=dm365
#TIBET_PROJECT=sdl
#TIBET_PROJECT=A1
#TIBET_PROJECT=gt500
#TIBET_PROJECT=A20
#TIBET_PROJECT=BATTERY_JIG
#TIBET_PROJECT=A4
#TIBET_PROJECT=A5
#TIBET_PROJECT=A7
#TIBET_PROJECT=A8
#TIBET_PROJECT=A9
#TIBET_PROJECT=A20_FOCUS
#TIBET_PROJECT=A31_ISP
#TIBET_PROJECT=K1
#TIBET_PROJECT=CAMD
#TIBET_PROJECT=L3
#TIBET_PROJECT=V5
#TIBET_PROJECT=A3_OLD
#TIBET_PROJECT=A3
#TIBET_PROJECT=A33
#TIBET_PROJECT=V3_OLD
#TIBET_PROJECT=S3_OLD
TIBET_PROJECT=V3
#TIBET_PROJECT=V4
#TIBET_PROJECT=V8
#TIBET_PROJECT=V4_OLD
#TIBET_PROJECT=S3

case $TIBET_PROJECT in
	next)
		COMPILER_DIR1=/home/sobyungjun/svn/toolchain/armv7/codesourcery/bin
		COMPILER_DIR2=/opt/armv7/codesourcery/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-none-linux-gnueabi-
		export CROSS_COMPILE=arm-none-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
#		export THIS_SOURCE_PATH=/home/jk//home/jk/svn/source_working_sdl_2
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
#		export THIS_SOURCE_PATH=$MY_CVS_SOURCE_PATH/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install
#		export SDL_LIB_PATH=/home/jk/source_working_sdl_2/libsdl
#		export SDL_LIB_PATH=/home/jk/svn/source/libsdl
		;;
	dm36x)
		COMPILER_DIR1=/home/sobyungjun/svn/ti_compiler/mv_pro_5.0/montavista/pro/devkit/arm/v5t_le/bin
#		COMPILER_DIR2=/opt/armv7/codesourcery/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm_v5t_le-
		export CROSS_COMPILE=arm_v5t_le-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/montavista_linux-2.6.18
#		export THIS_SOURCE_PATH=/home/sobyungjun//home/jk/svn/source_working_sdl_2
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
#		export THIS_SOURCE_PATH=$MY_CVS_SOURCE_PATH/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install
#		export SDL_LIB_PATH=/home/sobyungjun/source_working_sdl_2/libsdl
#		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libsdl
		;;
	dm365)
		COMPILER_DIR1=/home/sobyungjun/svn/ti_compiler/mv_pro_5.0/montavista/pro/devkit/arm/v5t_le/bin
#		COMPILER_DIR1=/home/sobyungjun/svn/system/compiler/mv_pro_5.0/montavista/pro/devkit/arm/v5t_le/bin
#		COMPILER_DIR2=/opt/armv7/codesourcery/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm_v5t_le-
		export CROSS_COMPILE=arm_v5t_le-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/montavista_linux-2.6.18
#		export THIS_SOURCE_PATH=/home/sobyungjun//home/jk/svn/source_working_sdl_2
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
#		export THIS_SOURCE_PATH=$MY_CVS_SOURCE_PATH/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_dm365
#		export SDL_LIB_PATH=/home/sobyungjun/source_working_sdl_2/libsdl
#		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libsdl
		;;
	sdl)
#		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a3/compiler/external-toolchain/bin	
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/gnet_v5/compiler/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/sdl_compile/sdl_dir/sdl
		export THIS_INSTALL_PATH=/home/sobyungjun/install
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/bin/libsdl
		export SDL_PREFIX=/home/sobyungjun/sdl_compile/sdl_dir/sdl_prefix
		export SDL_INC_PATH=/home/sobyungjun/svn/source/inc/SDL/
#		export SDL_TOOLCHAIN_DIR=/home/sobyungjun/svn/BlackBox/janus_a3/compiler/external-toolchain/bin
		export SDL_TOOLCHAIN_DIR=/home/sobyungjun/svn/BlackBox/gnet_v5/compiler/bin

		;;

	A1)
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a1/compiler/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
#		export THIS_SOURCE_PATH=/home/jk//home/jk/svn/source_working_sdl_2
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
#		export THIS_SOURCE_PATH=$MY_CVS_SOURCE_PATH/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_a1
#		export SDL_LIB_PATH=/home/sobyungjun/source_working_sdl_2/libsdl
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libsdl
		;;
	
	gt500)
		COMPILER_DIR1=/home/sobyungjun/A20/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
#		export THIS_SOURCE_PATH=/home/jk//home/jk/svn/source_working_sdl_2
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
#		export THIS_SOURCE_PATH=$MY_CVS_SOURCE_PATH/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/gnet_gt500
#		export SDL_LIB_PATH=/home/sobyungjun/source_working_sdl_2/libsdl
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libsdl
		;;

	A20)
		COMPILER_DIR1=/home/sobyungjun/A20/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
#		export THIS_SOURCE_PATH=/home/jk//home/jk/svn/source_working_sdl_2
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
#		export THIS_SOURCE_PATH=$MY_CVS_SOURCE_PATH/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_gw200
#		export SDL_LIB_PATH=/home/sobyungjun/source_working_sdl_2/libsdl
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libsdl
		;;
	A31)
		COMPILER_DIR1=/home/sobyungjun/A20/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_a2
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		;;
	A3_OLD)
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a3/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_a3
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;

	A3)
		COMPILER_DIR1=/home/sobyungjun/blackbox/a3/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/blackbox/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/blackbox/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_a3
		export SDL_LIB_PATH=/home/sobyungjun/blackbox/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/blackbox/system/ramdisk/usr/lib
		;;


	A33)
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a33/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_a33
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;

	A20_FOCUS)
		COMPILER_DIR1=/home/sobyungjun/A20/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/BlackBox/janus_a1/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_focus
		;;
	A31_ISP)
		COMPILER_DIR1=/home/sobyungjun/A20/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/BlackBox/util/isp_fusing/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_isp
		;;
	K1)
		COMPILER_DIR1=/home/sobyungjun/A20/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_k1
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libsdl
		;;
	CAMD)
		COMPILER_DIR1=/home/sobyungjun/A20/compiler/external-toolchain/bin
#		COMPILER_DIR1=/home/sobyungjun/V3/SDK_NAND/camdroid/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.6/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_c3
#		export ONE_SHOT_MAKEFILE=/home/sobyungjun/svn/source/CamLinux.mk 
#		export TOP=/home/sobyungjun/V3/SDK_NAND/camdroid
		;;
	A4)
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a1/compiler/bin
#		COMPILER_DIR1=/home/sobyungjun/V40/lichee/brandy/gcc-linaro/bin
#		COMPILER_DIR1=/home/sobyungjun/V40/lichee/out/sun8iw11p1/linux/common/buildroot/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_a4
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;
	A5)
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a3/compiler/external-toolchain/bin
#		COMPILER_DIR1=/home/sobyungjun/V40/lichee/brandy/gcc-linaro/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_a5
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;
	A7)
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a1/compiler/bin
#		COMPILER_DIR1=/home/sobyungjun/V40/lichee/brandy/gcc-linaro/bin
#		COMPILER_DIR1=/home/sobyungjun/V40/lichee/out/sun8iw11p1/linux/common/buildroot/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_a7
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;
	A8)
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a1/compiler/bin
#		COMPILER_DIR1=/home/sobyungjun/V40/lichee/brandy/gcc-linaro/bin
#		COMPILER_DIR1=/home/sobyungjun/V40/lichee/out/sun8iw11p1/linux/common/buildroot/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_a8
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;

	L3)
		COMPILER_DIR1=/home/sobyungjun/A3/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
#		export THIS_LINUX_KERNEL=/home/sobyungjun/extrahdd/V3/SDK_NAND/lichee/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_l3
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;

	A9)
#		COMPILER_DIR1=/home/sobyungjun/A3/compiler/external-toolchain/bin
		COMPILER_DIR1=/home/sobyungjun/extrahdd/V5/v5evb2/lichee/out/external-toolchain/gcc-arm/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
#		export THIS_LINUX_KERNEL=/home/sobyungjun/extrahdd/V3/SDK_NAND/lichee/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/janus_a9
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;

	BATTERY_JIG)
#		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a3/compiler/external-toolchain/bin
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/battery_jig/compiler/external-toolchain/bin

		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/battery_jig
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;

	V5)
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/gnet_v5/compiler/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/gnet_v5
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;

	V3_OLD)
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a3/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/gnet_v3
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;

	V3)
		COMPILER_DIR1=/home/sobyungjun/blackbox/a3/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=/home/sobyungjun/blackbox/v3/system/kernel
		export THIS_SOURCE_PATH=/home/sobyungjun/blackbox/v3/source
		export THIS_INSTALL_PATH=/home/sobyungjun/install/gnet_v3
		export SDL_LIB_PATH=/home/sobyungjun/blackbox/v3/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=/home/sobyungjun/blackbox/v3/system/ramdisk/usr/lib
		;;


	V4)
		COMPILER_DIR1=/home/sobyungjun/blackbox/v4/compiler/bin
		PATH=$COMPILER_DIR1:$PATH
#		export CROSS_TOOL=arm-linux-gnueabi-
#		export CROSS_COMPILE=arm-linux-gnueabi-
		export CROSS_TOOL=arm-openwrt-linux-muslgnueabi-
		export CROSS_COMPILE=arm-openwrt-linux-muslgnueabi-
		export STAGING_DIR=/home/sobyungjun/blackbox/v4/system/ramdisk
		export MPP_DIR=/home/sobyungjun/blackbox/v4/source/mpp
		export THIS_INSTALL_PATH=/home/sobyungjun/install/gnet_v4
		export SDL_LIB_PATH=/home/sobyungjun/blackbox/v4/source/libs/sdl/lib
		export THIS_SOURCE_PATH=/home/sobyungjun/blackbox/v4/source
		export THIS_LINUX_KERNEL=/home/sobyungjun/blackbox/v4/system/kernel
		export THIS_RAMDISK_LIB=/home/sobyungjun/blackbox/v4/system/ramdisk/usr/lib
		;;

	V4_OLD)
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/gnet_v4/compiler/bin
		PATH=$COMPILER_DIR1:$PATH
#		export CROSS_TOOL=arm-linux-gnueabi-
#		export CROSS_COMPILE=arm-linux-gnueabi-
		export CROSS_TOOL=arm-openwrt-linux-muslgnueabi-
		export CROSS_COMPILE=arm-openwrt-linux-muslgnueabi-
		export STAGING_DIR=/home/sobyungjun/svn/BlackBox/gnet_v4/system/ramdisk
		export MPP_DIR=/home/sobyungjun/svn/BlackBox/gnet_v4/source/mpp
		export THIS_INSTALL_PATH=/home/sobyungjun/install/gnet_v4
		export SDL_LIB_PATH=/home/sobyungjun/svn/BlackBox/gnet_v4/source/libs/sdl/lib
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/BlackBox/gnet_v4/source
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/BlackBox/gnet_v4/system/kernel
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/BlackBox/gnet_v4/system/ramdisk/usr/lib
		;;


	S3_OLD)
#		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a3/compiler/external-toolchain/bin
#		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/gnet_s3/compiler/bin
		PATH=$COMPILER_DIR1:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export STAGING_DIR=/home/sobyungjun/svn/BlackBox/gnet_s3/system/ramdisk
#		export MPP_DIR=/home/sobyungjun/svn/source/mpp
		export THIS_INSTALL_PATH=/home/sobyungjun/install/gnet_s3
		export SDL_LIB_PATH=/home/sobyungjun/svn/source/libs/sdl/lib
		export THIS_SOURCE_PATH=/home/sobyungjun/svn/source
		export THIS_LINUX_KERNEL=/home/sobyungjun/svn/system/kernel
		export THIS_RAMDISK_LIB=/home/sobyungjun/svn/system/ramdisk/usr/lib
		;;

	S3)
#		COMPILER_DIR1=/home/sobyungjun/svn/BlackBox/janus_a3/compiler/external-toolchain/bin
#		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		COMPILER_DIR1=/home/sobyungjun/blackbox/s3/compiler/bin
		PATH=$COMPILER_DIR1:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export STAGING_DIR=/home/sobyungjun/blackbox/s3/system/ramdisk
#		export MPP_DIR=/home/sobyungjun/svn/source/mpp
		export THIS_INSTALL_PATH=/home/sobyungjun/install/gnet_s3
		export SDL_LIB_PATH=/home/sobyungjun/blackbox/source/libs/sdl/lib
		export THIS_SOURCE_PATH=/home/sobyungjun/blackbox/source
		export THIS_LINUX_KERNEL=/home/sobyungjun/blackbox/system/kernel
		export THIS_RAMDISK_LIB=/home/sobyungjun/blackbox/system/ramdisk/usr/lib
		;;
	V8)
		COMPILER_DIR1=/home/sobyungjun/blackbox/v4/compiler/bin
		PATH=$COMPILER_DIR1:$PATH
#		export CROSS_TOOL=arm-linux-gnueabi-
#		export CROSS_COMPILE=arm-linux-gnueabi-
		export CROSS_TOOL=arm-openwrt-linux-muslgnueabi-
		export CROSS_COMPILE=arm-openwrt-linux-muslgnueabi-
		export STAGING_DIR=/home/sobyungjun/blackbox/v8/system/ramdisk
		export MPP_DIR=/home/sobyungjun/blackbox/v8/source/mpp
		export THIS_INSTALL_PATH=/home/sobyungjun/install/gnet_v8
		export SDL_LIB_PATH=/home/sobyungjun/blackbox/v8/source/libs/sdl/lib
		export THIS_SOURCE_PATH=/home/sobyungjun/blackbox/v8/source
		export THIS_LINUX_KERNEL=/home/sobyungjun/blackbox/v8/system/kernel
		export THIS_RAMDISK_LIB=/home/sobyungjun/blackbox/v8/system/ramdisk/usr/lib

esac

export ARCH=arm
export CONFIG_DVR_DEBUG=y

# svn blackbox
CVSROOT=":ext:kbs@125.7.227.2:/rnd/CVS"
#export CVSROOT
export CC=${COMPILER_DIR1}/${CROSS_COMPILE}gcc
#export CC=/home/sobyungjun/V3/SDK_NAND/camdroid/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.6/bin/arm-linux-androideabi-gcc

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export BOUT=/home/bluez/

#PATH=/usr/include:/home/bluez/include:$PATH

stty -ixon
