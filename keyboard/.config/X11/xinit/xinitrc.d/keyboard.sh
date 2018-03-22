#!/bin/sh

usermodmap=$HOME/.config/X11/xinit/.Xmodmap
sysmodmap=/etc/X11/xinit/.Xmodmap

if [ -f $sysmodmap ]; then
  xmodmap $sysmodmap
fi

if [ -f "$usermodmap" ]; then
  xmodmap "$usermodmap"
fi

# share modifiers with standalone keys using xcape
xcape -e 'Control_L=Escape'
xcape -e 'Super_L=Tab'
xcape -e 'Hyper_L=Escape'
xcape -e 'Meta_R=Multi_key'
