#!/bin/env zsh
set -e

# configuration
dotfiles_path=$(readlink -f .)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
backup_dir="$config_home/dotfiles.bkp"
oh_my_zsh_path="$dotfiles_path/+oh-my-zsh"
git_conf_extra_dir="$HOME/.config/git"
# I've chosen do not use $config_home, because git cannot do advanced expansion
# in gitconfig files

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

# git extra configurations
mkdir -p $git_conf_extra_dir

echo "Would you like to remove git user config? (y/n)"
read answer

case $answer in
  [yY]*)
    if [ -f "$git_conf_extra_dir/author.conf" ]; then
      rm "$git_conf_extra_dir/author.conf"
    fi
    ;;
  *);;
esac

# install oh-my-zsh
echo "Would you like to uninstall Oh-My-ZSH? (y/n)"
read answer

case $answer in
  [yY]*)
    if [ -d "$oh_my_zsh_path" ]; then
      rm -Rf "$oh_my_zsh_path"
    fi
    ;;
  *);;
esac


# default shell
echo "Would you like to change your default shell to BASH? (y/n)"
read answer

case $answer in
  [yY]*)
    chsh -s /bin/bash
    env bash
    source ~/.bashrc
    ;;
  *);;
esac


echo "\nDotfiles uninstalled.\n"
