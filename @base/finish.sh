#!/usr/bin/env bash

if [ -s ~/.config/zsh ] && [ -n "${SHELL##*zsh*}" ]; then
  echo -e "To use ZSH as default shell please do:\n"
  echo -n "$(tput bold)$(tput setaf 4)"
  echo -e "  chsh -s $(which zsh)"
  echo -e "  env zsh"
  echo -e "  source ~/.zshrc\n"
  echo -n "$(tput sgr0)"
  echo -e "Alternativelly the .bashrc file provided by @zsh.bootstrap should be used"
fi

install-manually () {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo -n "  ** $(tput bold)$(tput setaf 3)"
    echo -n "Impossible to install"
    echo -n "$(tput sgr0): "
    echo "'$2'. Please install it manually."
  fi
}

problematic_packages=(fd rg)
problematic_packages_names=("fd (find replacement)" "rg (ripgrep)")
for i in "${!problematic_packages[@]}"; do
  install-manually "${problematic_packages[$i]}" "${problematic_packages_names[$i]}"
done

unset problematic_packages pkg
unset -f problematic_packages

