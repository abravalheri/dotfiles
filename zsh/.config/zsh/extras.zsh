# vim: set foldmethod=marker :

# improve nvim experience {{{
export NVIM_GTK_NO_HEADERBAR=1              # Disable GTK decorations on nvim-gtk
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket  # Make nvim-{gtk,qt} work nicely with neovim-remote (nvr)
# }}}

source $DOTFILES/zsh/alias.zsh
source $DOTFILES/zsh/functions.zsh
source $DOTFILES/tmux/startup.sh

# enable {linux,home}brew {{{
BREW_ROOT=$HOME/.local/opt/brew
if [ -d $BREW_ROOT ] && [ -n "${PATH##*$BREW_ROOT/bin*}" ]; then
  export PATH="$BREW_ROOT/bin:$BREW_ROOT/sbin:$PATH/"
  export MANPATH="$BREW_ROOT/share/man:$MANPATH"
  export INFOPATH="$BREW_ROOT/share/info:$INFOPATH"
fi
# }}}

# added by travis gem {{{
if [ -f $HOME/.travis/travis.sh ]; then
  source $HOME/.travis/travis.sh
fi
# }}}

# local yarn modules {{{
if command_exists yarn; then
  YARN_GLOBAL_MODULES=$HOME/.local/opt/yarn-modules

  if yarn global bin | grep -wq "$YARN_GLOBAL_MODULES"; then
    yarn config set prefix "$YARN_GLOBAL_MODULES"
  fi

  if [ -d "$YARN_GLOBAL_MODULES/bin" ] && [ -n "${PATH##*$YARN_GLOBAL_MODULES/bin*}" ]; then
    export PATH="$PATH:$YARN_GLOBAL_MODULES/bin"
  fi

  # tabtab source for yarn package
  # uninstall by removing these lines or running `tabtab uninstall yarn`
  if [ -f "${XDG_CONFIG_HOME}/yarn/global/node_modules/tabtab/.completions/yarn.zsh" ]; then
    source "${XDG_CONFIG_HOME}/yarn/global/node_modules/tabtab/.completions/yarn.zsh"
  fi
fi
# }}}
