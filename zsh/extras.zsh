source $DOTFILES/zsh/alias.zsh
source $DOTFILES/zsh/functions.zsh
source $DOTFILES/tmux/startup.zsh
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$HOME/.rbenv/bin:$PYENV_ROOT/bin:$PATH"
eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
