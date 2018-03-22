#!/usr/bin/env zsh
# vim: set foldmethod=marker :

if [ -d "$HOME/.local/bin" ] && [ -n "${PATH##*$HOME/.local/bin*}" ]; then
  PATH="$PATH:$HOME/.local/bin"
fi

if [ -d "$HOME/.local/before/bin" ] && [ -n "${PATH##*$HOME/.local/before/bin*}" ]; then
  PATH="$HOME/.local/before/bin:$PATH"
fi

export PATH
