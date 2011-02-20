#!/bin/sh
# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/login.defs
# include .bashrc if it exists
#
export ENV="$HOME/.bashrc"
[ -r "$ENV" ] && . "$ENV"
if [ x"$GNOME_DESKTOP_SESSION_ID" == x"" ]; then
    export GNOME_DESKTOP_SESSION_ID="fakeID"
fi
