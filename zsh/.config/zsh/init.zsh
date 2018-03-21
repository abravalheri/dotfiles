# vim: set foldmethod=marker :

# Set XDG global variables to their defaults if not set {{{
: ${XDG_CONFIG_HOME:=$HOME/.config}
: ${XDG_DATA_HOME:=$HOME/.local/share}
: ${XDG_CONFIG_DIRS:=/etc/xdg}
: ${XDG_DATA_DIRS:=/usr/local/share:/usr/share}
# }}}

# Functions required for bootstrapping {{{
command_exists() {
  # which ignores previous aliases but is not portable
  # command does not ignore aliases, but is built in
  # so it's better to try to check first with which and fallback to command
  which "$1" &>/dev/null || command -v "$1" &>/dev/null
}
# }}}

# Path setup {{{
if command_exists ruby; then
  gems_dir="$(ruby -e 'print Gem.user_dir')/bin"
  # http://stackoverflow.com/questions/229551/string-contains-in-bash
  [ -n "${PATH##*$gems_dir*}" ] && PATH="$PATH:$gems_dir"
fi

if [ -d "$HOME/.local/bin" ] && [ -n "${PATH##*$HOME/.local/bin*}" ]; then
  PATH="$PATH:$HOME/.local/bin"
fi

if [ -d "$HOME/.local/before/bin" ] && [ -n "${PATH##*$HOME/.local/before/bin*}" ]; then
  PATH="$HOME/.local/before/bin:$PATH"
fi

export PATH
# }}}

# Add bash completion for packages installed using stow {{{
if command_exists bashcompinit; then
  autoload bashcompinit
  bashcompinit

  if [ -d "$HOME/.local/etc/bash_completion.d" ]; then
    for filename in "$HOME/.local/etc/bash_completion.d/"*; do
      [ -f "$filename" ] && source "$filename";
    done
  fi
fi
# }}}

# Path to oh-my-zsh installation {{{
export DOTFILES=$HOME/.dotfiles
_config_base=$DOTFILES/zsh/.config/zsh
export ZSH=$_config_base/oh-my-zsh
# }}}

# Theme {{{
ZSH_CUSTOM=$_config_base/custom
ZSH_THEME="custom" #terminalparty #sunaku #muse
COMPLETION_WAITING_DOTS="true"
# }}}

# Load oh-my-zsh {{{
source $_config_base/plugins.zsh
source $ZSH/oh-my-zsh.sh
# }}}

# User configuration {{{
export LANG=en_US.UTF-8
# }}}

if command_exists nvr; then
  export EDITOR='nvr'
elif command_exists nvim; then
  export EDITOR='nvim'
elif command_exists vim; then
  export EDITOR='vim'
fi


# Source configurations from extra files {{{
source $_config_base/style.zsh
source $_config_base/alias.zsh
source $_config_base/functions.zsh
source $_config_base/extras.zsh

if [ -f $_config_base/+local.zsh ]; then
  source $_config_base/+local.zsh
fi

source $DOTFILES/tmux/.config/tmux/startup.sh
# }}}

# Cleanup duplicates in path (rbenv and pyenv do not care) {{{
if command_exists awk; then
  export PATH=$(printf %s "$PATH" | awk -v RS=: -v ORS=: '!arr[$0]++')
fi
# }}}

unset _config_base
