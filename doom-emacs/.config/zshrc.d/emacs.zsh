#!/usr/bin/env zsh
function() {
  local DOOM_BIN="$HOME/.emacs.d/bin"
  [[ -d "$DOOM_BIN" ]] && export -U path=($path "$DOOM_BIN")
}
