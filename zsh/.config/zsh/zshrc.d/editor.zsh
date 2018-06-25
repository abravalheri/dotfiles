#!/usr/bin/env zsh
# vim: set foldmethod=marker :

if command-exists nvim; then
  export EDITOR='nvim'
elif command-exists vim; then
  export EDITOR='vim'
fi
