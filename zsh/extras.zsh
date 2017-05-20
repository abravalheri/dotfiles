source $DOTFILES/zsh/alias.zsh
source $DOTFILES/zsh/functions.zsh
source $DOTFILES/tmux/startup.sh

BREW_ROOT=$HOME/.local/opt/brew
if [ -d $BREW_ROOT ] && [ -n "${PATH##*$BREW_ROOT/bin*}" ]; then
  export PATH="$BREW_ROOT/bin:$PATH/"
  export MANPATH="$BREW_ROOT/share/man:$MANPATH"
  export INFOPATH="$BREW_ROOT/share/info:$INFOPATH"
fi

# added by travis gem
if [ -f $HOME/.travis/travis.sh ]; then
  source $HOME/.travis/travis.sh
fi

# configure z
export _Z_DATA=$XDG_CONFIG_HOME/.z
if [ ! -f $_Z_DATA ]; then
  touch $_Z_DATA
fi
