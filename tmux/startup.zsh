#/bin/env zsh

# which ignores previous aliases but is not portable
# command does not ignore aliases, but is built in
# so it's better to try to check first with which and fallback to command
if (which tmux &>/dev/null || command -v tmux &>/dev/null); then
  alias tmux='tmux -2'
  alias tm='tmux -2 new-session -A -s main'

  if [ -z $TMUX ]; then
    tmux -2 new-session -A -s main
  fi
fi


# # old procedure, before new-session -A were possible
# if [[ -z "$TMUX" ]]; then
#   if ! tmux -q has-session; then
#     # if not available create a new one
#     tmux new-session -d -s "main"
#   fi
#
#   ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
#   tmux attach-session -t "$ID"
# fi

