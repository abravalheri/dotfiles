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
    ~/.config/zsh/.zcompdump
  )

  local file
  local BKP_DIR=~/.local/share/dotfiles.bkp
  mkdir -p "$BKP_DIR"
  for file in "${bkp[@]}"; do
    if [[ -f "$file" ]] && [[ ! -L "$file" ]]; then
      echo -n "  ** $(tput bold)$(tput setaf 3)BKP$(tput sgr0) $file -> "
      { set -v;
        bkp_file="${file/~/"$BKP_DIR"}";
        echo "$bkp_file";
        cp "$file" "$bkp_file";
        test -f "$bkp_file";
        rm "$file";
      }
    elif [[ -L "$file" ]]; then
      { set -v;
        echo "  ** $(tput bold)$(tput setaf 3)UNLINK$(tput sgr0) $file ($(readlink -f "$file"))";
        unlink "$file";
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
