#!/bin/sh

config_file=$HOME/.config/urxvt/config.

userresources=$HOME/.Xresources
sysresources=/etc/X11/xinit/.Xresources

# merge in defaults and keymaps

if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -f "$userresources" ]; then
  xrdb -merge "$userresources"
fi

# Auto-start all the things!

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

if [ -d $HOME/.config/X11/xinit/xinitrc.d ] ; then
  for f in $HOME/.config/X11/xinit/xinitrc.d/?*.sh ; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
