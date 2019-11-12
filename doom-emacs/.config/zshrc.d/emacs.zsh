#!/usr/bin/env zsh
local __doom_bin="$HOME/.emacs.d/bin"
[[ -d "$__doom_bin" ]] && path=($path "$__doom_bin")

if (( ${+INSIDE_EMACS} )); then
  export SKIP_TMUX=true
  export SKIP_AGENT=true
fi
unset __doom_bin
