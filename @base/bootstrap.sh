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
      echo -e "  ** $(tput bold)$(tput setaf 3)BKP$(tput sgr0) $file -> $BKP_DIR"
      { set -v;
        cp "$file" "$BKP_DIR";
        test -f "$BKP_DIR/$(basename "$file")";
        rm "$file";
        ln -s "$BKP_DIR/$(basename "$file")" ~;
      }
    fi
  done

  echo "Prepare ~/.local FHS (XDG base dirs) ..."
  local base_dirs=(~/.local ~/.local/bin ~/.config/ ~/.config/zsh ~/.config/zshrc.d ~/.config/zshrc.d/autoloaded)
  for dir in "${base_dirs[@]}"; do
    { set +x;
      mkdir -p "$dir"
      chmod 755 "$dir"
    }
  done
}

__bootstrap
unset -f __bootstrap
