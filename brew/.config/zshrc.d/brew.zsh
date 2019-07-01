#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Enable {linux,home}brew
function() {
  local -U candidates
  candidates=(
    /home/linuxbrew/.linuxbrew/
    $HOME/.linuxbrew
    $HOME/.local/opt/brew
    $HOME/.local/stow/brew
  )

  for BREW_ROOT in $candidates; do
    if [ -d $BREW_ROOT ] && [ -n "${PATH##*$BREW_ROOT/bin*}" ]; then
      eval $("$BREW_ROOT/bin/brew" shellenv)
      break
    fi
  done
}
