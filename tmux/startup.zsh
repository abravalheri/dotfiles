#/bin/env zsh

if [[ -z "$TMUX" ]]; then
  if ! tmux -q has-session; then
    # if not available create a new one
    tmux new-session -d -s "main"
  fi

  ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
  tmux attach-session -t "$ID"
fi

