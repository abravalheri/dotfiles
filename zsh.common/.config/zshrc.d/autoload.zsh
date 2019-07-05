#!/usr/bin/env zsh
# Autoload Functions

function() {
  local fp
  fpath=($XDG_CONFIG_HOME/zshrc.d/autoloaded $fpath)
  for fp in $XDG_CONFIG_HOME/zshrc.d/autoloaded/*(x); autoload -Uz $fp
}
