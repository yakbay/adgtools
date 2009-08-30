# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# special prompt information for git repositories
# Format: <user name>:<repo path>/<repo name>[branch]<sub dir>$
_bold=$(tput bold)
_normal=$(tput sgr0)

__vcs_dir() {
	local vcs base_dir sub_dir ref repo_path
	sub_dir() {
	  local sub_dir
	  sub_dir=$(stat -f "${PWD}")
	  sub_dir=${sub_dir#$1}
	  echo ${sub_dir#/}
	}

	git_dir() {
	  base_dir=$(git rev-parse --show-cdup 2>/dev/null) || return 1
	  if [ -n "$base_dir" ]; then
	    base_dir=`cd $base_dir; pwd`
	  else
            base_dir=$PWD
          fi
          sub_dir=$(git rev-parse --show-prefix)
	  sub_dir="/${sub_dir%/}"
	  ref=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
	  ref=${ref#refs/heads/}
	  vcs="git"
	  repo_path="$(dirname "${base_dir}")"
	  repo_path="${repo_path/$HOME/~}"
	  base_dir="$(basename "${base_dir}")"
	}

	git_dir

	if [ -n "$vcs" ]; then
# don't print git	  __vcs_prefix="($vcs)"
	  __vcs_base_dir="${base_dir/$HOME/~}"
	  __vcs_repo_path="${repo_path}/"
	  __vcs_ref="[$ref]"
	  __vcs_sub_dir="${sub_dir}"
	else
	  __vcs_prefix=''
	  __vcs_repo_path=''
	  __vcs_base_dir_temp=`basename "$PWD"`
	  if [ "$PWD" == "$HOME" ]; then
	    __vcs_base_dir="~"
          else
	    __vcs_base_dir="`basename "$PWD"`"
	  fi
	  __vcs_ref=''
	  __vcs_sub_dir=''
	fi
}

PROMPT_COMMAND=__vcs_dir
PS1='\[\033]0;\u@\h:\w\007\]\u:$__vcs_prefix${__vcs_repo_path}\[${_bold}\]${__vcs_base_dir}\[${_normal}\]${__vcs_ref}\[${_bold}\]${__vcs_sub_dir}\[${_normal}\]\$ '

# Setup ubicom32 development environment
export PATH=$PATH:/home/adg/ubicom/ubicom32toolchain/bin:/home/adg/ubicom/adgtools
#export PATH=$PATH:/home/adg/ubicom/adgtools
export TOOLCHAIN_DIR=~/ubicom/ubicom32toolchain
export UBICOM_DONGLE_IP=172.18.201.155
export UBICOM_DONGLE=$UBICOM_DONGLE_IP:5010
