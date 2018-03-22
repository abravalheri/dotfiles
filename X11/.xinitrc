#!/bin/sh

# merge in resources
sysresources=/etc/X11/xinit/.Xresources

if [ -f $sysresources ]; then
  xrdb -merge $sysresources
fi

if [ -d $HOME/.config/X11/xinit/xresources.d ] ; then
  for f in $HOME/.config/X11/xinit/xresources.d/?*.Xresources ; do
    [ -f "$f" ] && xrdb -merge "$f"
  done
  unset f
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
