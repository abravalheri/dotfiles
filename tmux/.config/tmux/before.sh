#!/usr/bin/env bash

# Hook that runs before tmux configuration

export TMUX_VERSION=$(tmux -V | cut -d" " -f2)
tmux setenv -g TMUX_VERSION "$TMUX_VERSION"
