#!/usr/bin/env bash

# In version 2.1 "mouse" replaced the previous 4 mouse options
# See: https://github.com/tmux/tmux/blob/master/CHANGES
# http://stackoverflow.com/a/40902312

if [ "$(echo "$TMUX_VERSION < 2.1" | bc)" = 1 ]; then
  tmux set -g mouse-select-pane on
  tmux set -g mode-mouse on;
  tmux set -g mouse-resize-pane on
  tmux set -g mouse-select-window on
else
  tmux set -g mouse on
fi
