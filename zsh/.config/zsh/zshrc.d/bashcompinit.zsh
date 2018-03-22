#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Add bash completion for packages installed using stow
if command-exists bashcompinit; then
  autoload bashcompinit
  bashcompinit

  if [ -d "$HOME/.local/etc/bash_completion.d" ]; then
    for filename in "$HOME/.local/etc/bash_completion.d/"*; do
      [ -f "$filename" ] && source "$filename";
    done
  fi
fi
