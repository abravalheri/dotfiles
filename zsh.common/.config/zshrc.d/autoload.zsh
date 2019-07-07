#!/usr/bin/env zsh
# Autoload Functions

__zshrc_autoload() {
  local fp
  fpath=($XDG_CONFIG_HOME/zshrc.d/autoloaded $fpath)
  for fp in $XDG_CONFIG_HOME/zshrc.d/autoloaded/*(x); autoload -Uz $fp
}
__zshrc_autoload
unset -f __zshrc_autoload  # avoid lambdas so we can use zprof
