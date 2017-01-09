command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Path setup
if command_exists ruby; then
  gems_dir="$(ruby -e 'print Gem.user_dir')"
  # http://stackoverflow.com/questions/229551/string-contains-in-bash
  [ -n "${PATH##*$gems_dir*}" ] && PATH="$gems_dir:$PATH"
fi

if [ -d "$HOME/.local/bin" ] && [ -n "${PATH##*$HOME/.local/bin*}" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

export PATH

# Path to your oh-my-zsh installation.
export DOTFILES=$HOME/.config/dotfiles
export ZPLUG_HOME=$DOTFILES/zsh/zplug
export ZPLUG_CACHE_DIR=$HOME/.cache/zplug

source $ZPLUG_HOME/init.zsh
source $DOTFILES/zsh/plugins.zsh

# User configuration
export LANG=en_US.UTF-8
export EDITOR='nvim'

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"

source $DOTFILES/zsh/style.zsh
source $DOTFILES/zsh/extras.zsh
if [ -f $DOTFILES/zsh/+local.zsh ]; then
  source $DOTFILES/zsh/+local.zsh
fi

# Cleanup duplicates in path (rbenv and pyenv do not care)
if command_exists awk; then
  export PATH=$(printf %s "$PATH" | awk -v RS=: -v ORS=: '!arr[$0]++')
fi
