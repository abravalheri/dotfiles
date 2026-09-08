#!/bin/env zsh

# Mise integration, activated only when the binary is present.
# Resolve it directly rather than relying on PATH: a pixi-installed mise lands
# in $PIXI_HOME/bin, which may not be on PATH yet when this file runs (the
# pixi helper is sourced later, in alphabetical order).
mise_bin=""
if command -v mise >/dev/null 2>&1; then
  mise_bin="$(command -v mise)"
elif [ -x "${PIXI_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/pixi}/bin/mise" ]; then
  mise_bin="${PIXI_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/pixi}/bin/mise"
fi

if [ -n "$mise_bin" ]; then
  export MISE_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/mise"
  export MISE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/mise"
  eval "$("$mise_bin" activate zsh)"
  eval "$("$mise_bin" completion zsh)" 2>/dev/null
fi
unset mise_bin
