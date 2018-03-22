#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Enable {linux,home}brew
BREW_ROOT=$HOME/.local/opt/brew
if [ -d $BREW_ROOT ] && [ -n "${PATH##*$BREW_ROOT/bin*}" ]; then
  export PATH="$BREW_ROOT/bin:$BREW_ROOT/sbin:$PATH/"
  export MANPATH="$BREW_ROOT/share/man:$MANPATH"
  export INFOPATH="$BREW_ROOT/share/info:$INFOPATH"
fi
