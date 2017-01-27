command_exists() {
  # which ignores previous aliases but is not portable
  # command does not ignore aliases, but is built in
  # so it's better to try to check first with which and fallback to command
  which "$1" &>/dev/null || command -v "$1" &>/dev/null
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
export ZSH=$DOTFILES/zsh/oh-my-zsh

# Theme
ZSH_CUSTOM=$DOTFILES/zsh/custom
ZSH_THEME="custom" #terminalparty #sunaku #muse
COMPLETION_WAITING_DOTS="true"

# Load oh-my-zsh
source $DOTFILES/zsh/plugins.zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8

if command_exists nvim; then
  export EDITOR='nvim'
elif command_exists vim; then
  export EDITOR='vim'
fi

source $DOTFILES/zsh/style.zsh
source $DOTFILES/zsh/extras.zsh
if [ -f $DOTFILES/zsh/+local.zsh ]; then
  source $DOTFILES/zsh/+local.zsh
fi

# Cleanup duplicates in path (rbenv and pyenv do not care)
if command_exists awk; then
  export PATH=$(printf %s "$PATH" | awk -v RS=: -v ORS=: '!arr[$0]++')
fi
