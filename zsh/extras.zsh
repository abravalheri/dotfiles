source $DOTFILES/zsh/alias.zsh
source $DOTFILES/zsh/functions.zsh
source $DOTFILES/tmux/startup.zsh

## oh-my-zsh plugins already does this;

# PYENV_ROOT="$HOME/.pyenv"
# if [ -d $HOME/.pyenv ] && [ -n "${PATH##*$HOME/.pyenv/bin*}"  ]; then
#   export PYENV_ROOT
#   eval "$($PYENV_ROOT/bin/pyenv init -)"
#   eval "$(pyenv virtualenv-init -)"
# fi
#
# RBENV_ROOT = "$HOME/.rbenv"
# if [ -d $HOME/.rbenv ] && [ -n "${PATH##*$HOME/.rbenv/bin*}" ]; then
#   eval "$($RBENV_ROOT/bin/rbenv init -)"
# fi

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
