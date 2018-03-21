#!/usr/bin/env bash

on_icon=$1
off_icon=$2

remove-ansi() {
  sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"
}

level=$(pulseaudio-ctl | awk -F': ' '/Volume level/ {print $2}' | remove-ansi)
speaker_mutted=$(pulseaudio-ctl | awk -F': ' '/sink muted/ {print $2}' | remove-ansi)

if [ "$speaker_mutted" == yes ]; then
  echo "$off_icon"
else
  echo "$on_icon $level"
fi
