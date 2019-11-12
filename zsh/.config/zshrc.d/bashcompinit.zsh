#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Add bash completion for packages installed using stow
if command -v bashcompinit &>/dev/null; then
  autoload bashcompinit
  bashcompinit

  for fp in $HOME/.local/etc/bash_completion.d/*(.); source $fp
fi
