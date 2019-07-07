#!/usr/bin/env zsh
# Fix terminal colors
local __dircolors_config=~/.config/dircolors/dircolors.solarized-256-dark
if [ -f "${__dircolors_config}" ]; then
  eval "$(dircolors "${__dircolors_config}")"
fi
unset __dircolors_config
