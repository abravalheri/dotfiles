#!/usr/bin/env bash

set-style() {
  # style - chosen by env var / hostname or fallback to default
  local style_name=${TMUX_STYLE:-$(hostname)}
  if [ ! -f "$HOME/.config/tmux/styles/$style_name.tmux" ]; then
    style_name='default'
  fi

  export TMUX_STYLE=$style_name
  tmux setenv -g TMUX_STYLE "$TMUX_STYLE"
  tmux set -g status-position bottom
  tmux source "$HOME/.config/tmux/styles/$TMUX_STYLE.tmux"
}

set-style
unset -f set-style
