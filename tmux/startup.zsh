#/bin/env zsh

if command_exists tmux; then
  alias tmux='tmux -2'
  alias tm='tmux -2 new-session -A -s main'

  function has-session {
    tmux has-session -t $1 2>/dev/null
  }

  function hello {
    greeting="$DOTFILES/tmux/greetings/$(hostname).sh"
    [ -f "$greeting" ] && sh $greeting
  }

  function tm {
    if ! has-session 'main'; then
      tmux -2 new -d -s main
      tmux -2 send -t main "hello" C-m
    fi

    tmux -2 attach -t main
  }

  # Load tmux if it is not loaded, except is SKIP_TMUX
  # is defined.
  [ -z $TMUX ] && [ -z ${SKIP_TMUX+x} ] && tm
fi
