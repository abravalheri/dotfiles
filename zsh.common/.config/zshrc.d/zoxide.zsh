#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Portable `j`: use zoxide when installed, otherwise autojump's own `j`.
# extras.zsh sources autojump first; once zoxide is evaluated it takes over
# `j`, and on autojump-only systems this block is a no-op so autojump reigns.
if [[ -n "${commands[zoxide]}" ]]; then
  eval "$(zoxide init --cmd j zsh)"
fi
