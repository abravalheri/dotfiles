#!/usr/bin/env zsh
local __doom_bin="$HOME/.emacs.d/bin"
[[ -d "$__doom_bin" ]] && path=($path "$__doom_bin")
unset __doom_bin
