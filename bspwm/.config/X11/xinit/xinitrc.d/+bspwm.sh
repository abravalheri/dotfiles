#!/bin/sh

# The name of this file starting with + is important to make sure
# it runs after the other ones

start-pulseaudio-x11  # used for polybar and volume hotkeys

exec bspwm
