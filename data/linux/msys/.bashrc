# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything:


umask 002
#[ -z "$PS1" ] && return

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
fi
PS2='> '
PS4='+ '

# some more ls aliases
alias ll='ls -lh'
alias la='ls -A'
alias path='echo "$PATH"'


# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#xterm-color)
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#    ;;
#*)
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#    ;;
#esac

# Comment in the above and uncomment this below for a color prompt
#PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
#PS1='\W/\[\033[01;34m\]>\[\033[00m\] '
#PS1='\W/> '

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac


export HISTCONTROL=ignoredups

export XR_SHARE_DIR="/myplace"
export XR_PERL_SOURCE_DIR="$XR_SHARE_DIR/workspace/perl"
export XR_PERL_BINARY_DIR="$XR_SHARE_DIR/bin"
export XR_PERL_MODULE_DIR="$XR_PERL_SOURCE_DIR/modules"
export XR_SHELL_SOURCE_DIR="$XR_SHARE_DIR/workspace/shellscript"
export XR_SHELL_BINARY_DIR="$XR_SHARE_DIR/bin"
export PERL5_LIB="$XR_PERL_MODULE_DIR"
export XR_APPLICATION_DIR="$XR_SHARE_DIR/lib"
export XR_APPLICATION_BIN_DIR="$XR_APPLICATION_DIR/bin"
export XR_ANDROID_SDK_DIR="$XR_SHARE_DIR/lib/android-sdk"


if ! expr + "$PATH" : ".*:$XR_PERL_SOURCE_DIR" >/dev/null ; then
    PATH="$PATH:$XR_PERL_SOURCE_DIR"
fi
if ! expr + "$PATH" : ".*:$XR_SHELL_SOURCE_DIR" >/dev/null ; then
    PATH="$PATH:$XR_SHELL_SOURCE_DIR"
fi
if ! expr + "$PATH" : ".*:$XR_SHARE_DIR/bin" >/dev/null ; then
    PATH="$PATH:$XR_SHARE_DIR/bin"
fi
if ! expr + "$PATH" : ".*:$XR_APPLICATION_BIN_DIR" >/dev/null ; then
    PATH="$PATH:$XR_APPLICATION_BIN_DIR"
fi
export PATH

#if ! expr + "$XDG_DATA_DIRS" : ".*:$HOME/.local/share/" >/dev/null ; then
#    XDG_DATA_DIRS="$XDG_DATA_DIRS:$HOME/.local/share/"
#    export XDG_DATA_DIRS
#fi


#[[ -f /etc/profile.d/bash-completion ]] && source /etc/profile.d/bash-completion

if [ -f /etc/bash_completion.d/git ] ; then 
    source /etc/bash_completion.d/git
fi
#export XMODIFIERS="xim"
#export GTK_IM_MODULE="xim"

function xterm_title {
	echo -ne "\033]2;$*\007"
}

