#/bin/env zsh

if command_exists tmux; then
  alias tmux='tmux -2'
  alias tm='tmux -2 new-session -A -s main'

  if [ -z $TMUX ]; then
    tmux -2 new-session -A -s main
  fi
fi
