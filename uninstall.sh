#!/bin/env zsh
set -e

# configuration
dotfiles_path=$(readlink -f .)
backup_dir="${XDG_CONFIG_HOME:-"$HOME/.config"}/dotfiles.bkp"
oh_my_zsh_path="$dotfiles_path/+oh-my-zsh"

# restore previous state
for f in $dotfiles_path/\.*(.); do
  link_name="$(basename $f)"
  link_path="$HOME/$link_name"
  backup_file="$backup_dir/$link_name"
  backup_symlink="$backup_file.symlink"

  # unlink dotfiles from home
  if [ -L "$link_path" ]; then
    echo "unlink \"$link_path\""
    unlink "$link_path"
  fi

  # check if a backup exist, and restore it
  if [ -f "$backup_file" ]; then
    echo "$backup_file restored to home"
    mv "$backup_file" $HOME
  elif [ -f "$backup_symlink" ]; then
    $original_file=$(cat $backup_symlink)
    echo "$link_path linked to $original_file"
    ln -sT "$original_file" "$link_path"
    unlink "$backup_symlink"
  fi
done

source ~/.zshrc
rm -Rf "$oh_my_zsh_path"
chsh -s /bin/bash
env bash
source ~/.bashrc
