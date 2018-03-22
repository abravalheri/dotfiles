#!/usr/bin/env zsh
# vim: set foldmethod=marker :

if command-exists nvr; then
  export EDITOR='nvr -s'
elif command-exists nvim; then
  export EDITOR='nvim'
elif command-exists vim; then
  export EDITOR='vim'
fi
