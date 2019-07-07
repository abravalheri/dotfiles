#!/bin/env zsh

autoload -Uz command-exists
local __session_name='-'

if command-exists tmux; then
  alias tmux='tmux -2'
  alias tm="tmux -2 new-session -A -s '$__session_name'"

  function has-session {
    tmux -2 has-session -t $1 2>/dev/null
  }

  function greet {
    local greeting="$HOME/.config/tmux/greetings/$(hostname).sh"
    [ -f "$greeting" ] && sh "$greeting"
    tmux -2 setenv -gru display_greetings
  }

  function tm {
    if ! has-session "$__session_name"; then
      export display_greetings="please"
      tmux -2 new -d -s "$__session_name"
    fi

    tmux -2 attach -t "$__session_name"
  }

  # If the variable is set, greet
  # POG in order to just display message when first running tmux
  [ ! -z ${display_greetings+x} ] && greet

  # Load tmux if it is not loaded, except is SKIP_TMUX
  # is defined.
  [ -z $TMUX ] && [ -z ${SKIP_TMUX+x} ] && tm
fi
unset __session_name
