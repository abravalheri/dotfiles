source $DOTFILES/zsh/alias.zsh
source $DOTFILES/zsh/functions.zsh
source $DOTFILES/tmux/startup.zsh

## oh-my-zsh already loads this because of plugins
# if [ -d $HOME/.pyenv ] && [ -n "${PATH##*$HOME/.pyenv/bin*}"  ]; then
#   echo "PYENV init ..."
#   export PYENV_ROOT="$HOME/.pyenv"
#   eval "$($PYENV_ROOT/bin/pyenv init -)"
#   eval "$(pyenv virtualenv-init -)"
# fi
#
# if [ -d $HOME/.rbenv ] && [ -n "${PATH##*$HOME/.rbenv/bin*}" ]; then
#   echo "RBENV init ..."
#   export RBENV_ROOT = "$HOME/.rbenv"
#   eval "$($RBENV_ROOT/bin/rbenv init -)"
# fi

# added by travis gem
if [ -f $HOME/.travis/travis.sh ]; then
  source $HOME/.travis/travis.sh
fi
