#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Set XDG global variables to their defaults if not set {{{
: ${XDG_CONFIG_HOME:=$HOME/.config}
: ${XDG_DATA_HOME:=$HOME/.local/share}
: ${XDG_CONFIG_DIRS:=/etc/xdg}
: ${XDG_DATA_DIRS:=/usr/local/share:/usr/share}
# }}}

# Functions required for bootstrapping {{{
command-exists() {
  # which ignores previous aliases but is not portable
  # command does not ignore aliases, but is built in
  # so it's better to try to check first with which and fallback to command
  which "$1" &>/dev/null || command -v "$1" &>/dev/null
}
# }}}

DOTFILES=$HOME/.dotfiles
ZSH_CONFIG_HOME="$XDG_CONFIG_HOME/zsh"

# Source configurations from extra files {{{
if [ -f $ZSH_CONFIG_HOME/+local.zsh ]; then
  # Files specific to host, not shared via dotfiles
  source $ZSH_CONFIG_HOME/+local.zsh
fi

if [ -d "$ZSH_CONFIG_HOME/zshrc.d" ]; then
  for f in $ZSH_CONFIG_HOME/zshrc.d/?*.zsh; do
    [ -x "$f" ] && source "$f"
  done
  unset f
fi
# }}}

# Cleanup duplicates in path (rbenv and pyenv do not care) {{{
if command-exists awk; then
  export PATH=$(printf %s "$PATH" | awk -v RS=: -v ORS=: '!arr[$0]++')
fi
# }}}

# Autostart X if directly logged to the machine {{{
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
# }}}
