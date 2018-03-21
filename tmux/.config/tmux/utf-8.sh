#!/usr/bin/env bash

## --- Version-specific commands [grumble, grumble] ---
# See: https://github.com/tmux/tmux/blob/master/CHANGES
# http://stackoverflow.com/a/40902312

# UTF8 is autodetected in 2.2 onwards,
# but errors pop up if explicitly set
if [ "$(echo "$TMUX_VERSION < 2.2" | bc)" = 1 ]; then
  tmux set -g utf8 on
  tmux set -g status-utf8 on
  tmux set -g mouse-utf8 on
fi
