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


#TIBET_PROJECT=A3
#TIBET_PROJECT=V3
#TIBET_PROJECT=V4
TIBET_PROJECT=V8
#TIBET_PROJECT=S3

case $TIBET_PROJECT in
	A3)
		COMPILER_DIR1=${HOME}/blackbox/a3/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=${HOME}/blackbox/system/kernel
		export THIS_SOURCE_PATH=${HOME}/blackbox/source
		export THIS_INSTALL_PATH=${HOME}/install/janus_a3
		export SDL_LIB_PATH=${HOME}/blackbox/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=${HOME}/blackbox/system/ramdisk/usr/lib
		;;

	V3)
		COMPILER_DIR1=${HOME}/blackbox/a3/compiler/external-toolchain/bin
		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export THIS_LINUX_KERNEL=${HOME}/blackbox/v3/system/kernel
		export THIS_SOURCE_PATH=${HOME}/blackbox/v3/source
		export THIS_INSTALL_PATH=${HOME}/install/gnet_v3
		export SDL_LIB_PATH=${HOME}/blackbox/v3/source/libs/sdl/lib
		export THIS_RAMDISK_LIB=${HOME}/blackbox/v3/system/ramdisk/usr/lib
		;;


	V4)
		COMPILER_DIR1=${HOME}/blackbox/v4/compiler/bin
		PATH=$COMPILER_DIR1:$PATH
#		export CROSS_TOOL=arm-linux-gnueabi-
#		export CROSS_COMPILE=arm-linux-gnueabi-
		export CROSS_TOOL=arm-openwrt-linux-muslgnueabi-
		export CROSS_COMPILE=arm-openwrt-linux-muslgnueabi-
		export STAGING_DIR=${HOME}/blackbox/v4/system/ramdisk
		export MPP_DIR=${HOME}/blackbox/v4/source/mpp
		export THIS_INSTALL_PATH=${HOME}/install/gnet_v4
		export SDL_LIB_PATH=${HOME}/blackbox/v4/source/libs/sdl/lib
		export THIS_SOURCE_PATH=${HOME}/blackbox/v4/source
		export THIS_LINUX_KERNEL=${HOME}/blackbox/v4/system/kernel
		export THIS_RAMDISK_LIB=${HOME}/blackbox/v4/system/ramdisk/usr/lib
		;;

	S3)
#		COMPILER_DIR1=${HOME}/svn/BlackBox/janus_a3/compiler/external-toolchain/bin
#		PATH=$COMPILER_DIR1:$COMPILER_DIR2:$PATH
		COMPILER_DIR1=${HOME}/blackbox/s3/compiler/bin
		PATH=$COMPILER_DIR1:$PATH
		export CROSS_TOOL=arm-linux-gnueabi-
		export CROSS_COMPILE=arm-linux-gnueabi-
		export STAGING_DIR=${HOME}/blackbox/s3/system/ramdisk
#		export MPP_DIR=${HOME}/svn/source/mpp
		export THIS_INSTALL_PATH=${HOME}/install/gnet_s3
		export SDL_LIB_PATH=${HOME}/blackbox/source/libs/sdl/lib
		export THIS_SOURCE_PATH=${HOME}/blackbox/source
		export THIS_LINUX_KERNEL=${HOME}/blackbox/system/kernel
		export THIS_RAMDISK_LIB=${HOME}/blackbox/system/ramdisk/usr/lib
		;;
	V8)
		COMPILER_DIR1=${HOME}/blackbox/v4/compiler/bin
		PATH=$COMPILER_DIR1:$PATH
#		export CROSS_TOOL=arm-linux-gnueabi-
#		export CROSS_COMPILE=arm-linux-gnueabi-
		export CROSS_TOOL=arm-openwrt-linux-muslgnueabi-
		export CROSS_COMPILE=arm-openwrt-linux-muslgnueabi-
		export STAGING_DIR=${HOME}/blackbox/v8/system/ramdisk
		export MPP_DIR=${HOME}/blackbox/v8/source/mpp
		export THIS_INSTALL_PATH=${HOME}/install/gnet_v8
		export SDL_LIB_PATH=${HOME}/blackbox/v8/source/libs/sdl/lib
		export THIS_SOURCE_PATH=${HOME}/blackbox/v8/source
		export THIS_LINUX_KERNEL=${HOME}/blackbox/v8/system/kernel
		export THIS_RAMDISK_LIB=${HOME}/blackbox/v8/system/ramdisk/usr/lib
		;;
esac

export ARCH=arm
export CONFIG_DVR_DEBUG=y
export CC=${COMPILER_DIR1}/${CROSS_COMPILE}gcc

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Prevent Screen Pause by 'Ctrl + S'
stty -ixon
