#!/bin/sh


if command -v start-pulseaudio-x11 >/dev/null; then
  start-pulseaudio-x11  # used for polybar and volume hotkeys
fi

if command -v bspwm >/dev/null; then
  exec bspwm
fi
