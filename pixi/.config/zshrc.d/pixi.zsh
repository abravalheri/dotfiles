#!/bin/env zsh

if [[ -d "$XDG_DATA_HOME/pixi" ]]; then
  export PIXI_HOME="$XDG_DATA_HOME/pixi"
  export PIXI_CONFIG_DIR="$XDG_CONFIG_HOME/pixi"
  export PATH="$PIXI_HOME/bin:$PATH"

  eval "$(pixi completion --shell zsh)"  # => causes error and don't work
fi
