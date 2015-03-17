#!/bin/env zsh
set -e

# configuration
dotfiles_path=$(readlink -f .)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
backup_dir="$config_home/dotfiles.bkp"
oh_my_zsh_path="$dotfiles_path/+oh-my-zsh"
git_conf_extra_dir="$HOME/.config/git"
# I choose do not use $config_home, because git cannot do advanced expansion
# in gitconfig files

# ensure backup dir exist
mkdir -p $backup_dir

# link all the dotfiles to home
for f in $dotfiles_path/\.*(.); do
  link_name="$(basename $f)"
  link_path="$HOME/$link_name"
  backup_file="$backup_dir/$link_name"
  backup_symlink="$backup_file.symlink"

  if [ -L "$link_path" ]; then
    original_file=$(readlink -f $link_path)
    # The file exists in HOME, but it is a link
    echo "$link_name already exists. The symlink $link_path will be removed, "\
      "but the original file can be fount at $original_file"
    unlink "$link_path"
    echo "$original_file" > "$backup_symlink"
  elif [ -e "$link_path" ]; then
    # The file already exists in HOME
    echo "$link_name already exists. The original file will be moved to "\
      "$backup_file"

    mv $link_path $backup_dir
  fi

  echo "$link_name linked to $HOME"
  ln -s $f $HOME
done

# git extra configurations
mkdir -p $git_conf_extra_dir

echo "Please provide an user name for git:"
read git_user_name
echo "Please provide an user email for git:"
read git_user_email

echo "[user]\n"\
"  name = \"$git_user_name\"\n"\
"  email = $git_user_email\n" > "$git_conf_extra_dir/author.conf"

# install oh-my-zsh
if [ ! -d "$link_path" ]; then
  git clone git://github.com/robbyrussell/oh-my-zsh.git $oh_my_zsh_path

  chsh -s /bin/zsh
  env zsh
  source ~/.zshrc
fi
