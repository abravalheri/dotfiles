#!/usr/bin/env bash

command-exists() {
  # which ignores previous aliases but is not portable
  # command does not ignore aliases, but is built in
  # so it's better to try to check first with which and fallback to command
  which "$1" &>/dev/null || command -v "$1" &>/dev/null
}

set-clipboard-bindings () {
  ## --- Version-specific commands [grumble, grumble] ---
  # See: https://github.com/tmux/tmux/blob/master/CHANGES
  # http://stackoverflow.com/a/40902312

  local copy_mode="-t vi-copy"
  local copy="copy-pipe"
  local sel="begin-selection"
  local rect="rectangle-toggle"
  local line="select-line"

  if [ "$(echo "$TMUX_VERSION >= 2.4" | bc)" = 1 ]; then
    copy_mode="-T copy-mode-vi"
    copy="send -X copy-pipe-and-cancel"
    sel="send -X $sel"
    rect="send -X $rect"
    line="send -X $line"
  fi

  local copy_script="xclip -i -sel p -f | xclip -i -sel c "
  local paste_script="xclip -o | tmux load-buffer - ; tmux paste-buffer"

  if uname | grep -qi Linux && command-exists xclip; then
    # Select
    eval "tmux unbind $copy_mode v"
    eval "tmux unbind $copy_mode V"
    eval "tmux unbind $copy_mode C-v"
    eval "tmux bind   $copy_mode v   $sel"
    eval "tmux bind   $copy_mode V   $line"
    eval "tmux bind   $copy_mode C-v $rect"

    # Copy "default tmux"
    eval "tmux unbind $copy_mode Enter"
    eval "tmux bind   $copy_mode Enter $copy '$copy_script'"
    # Copy vim-like
    eval "tmux unbind $copy_mode y"
    eval "tmux bind   $copy_mode y     $copy '$copy_script'"

    # Paste "default tmux"
    eval "tmux unbind ]"
    eval "tmux bind   ] run '$paste_script'"
    # Paste vim-like
    eval "tmux unbind p"
    eval "tmux bind   p run '$paste_script'"
  fi
}

set-clipboard-bindings
unset -f set-clipboard-bindings
