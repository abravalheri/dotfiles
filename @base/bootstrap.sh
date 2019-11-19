#!/usr/bin/env bash

__bootstrap() {
  local bkp=(
    ~/.profile
    ~/.pathrc
    ~/.bashrc
    ~/.bash_profile
    ~/.zshrc
    ~/.zshenv
    ~/.zprofile
    ~/.gitconfig
    ~/.git/config
    ~/.vimrc
    ~/.vim/vimrc
  )

  local file
  local BKP_DIR=~/.local/share/dotfiles.bkp
  mkdir -p "$BKP_DIR"
  for file in "${bkp[@]}"; do
    if [[ -f "$file" ]] && [[ ! -L "$file" ]]; then
      echo -n "BKP $file"
      { set -v;
        cp "$file" "$BKP_DIR";
      }
    fi
  done
}

__bootstrap
unset -f __bootstrap
