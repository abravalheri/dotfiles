#/bin/env zsh

if command_exists tmux; then
  alias tmux='tmux -2'
  alias tm='tmux -2 new-session -A -s main'

  # Load tmux if it is not loaded, except is SKIP_TMUX
  # is defined.
  if [ -z $TMUX ] && [ -z ${SKIP_TMUX+x} ]; then
    tmux -2 new-session -A -s main
  fi
fi
