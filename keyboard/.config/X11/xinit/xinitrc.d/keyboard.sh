#!/bin/sh

usermodmap=$HOME/.config/X11/xinit/.Xmodmap
sysmodmap=/etc/X11/xinit/.Xmodmap

# Load modified key maps
if command -v xmodmap >/dev/null; then
  if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
  fi

  if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
  fi
fi

# Share modifiers with standalone keys using xcape
if command -v xcape >/dev/null; then
  xcape -e 'Control_L=Escape'
  xcape -e 'Super_L=Tab'
  xcape -e 'Hyper_L=Escape'
  xcape -e 'Meta_R=Multi_key'
fi
