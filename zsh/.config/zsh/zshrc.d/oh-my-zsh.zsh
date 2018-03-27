#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Path to oh-my-zsh installation 
export ZSH=$ZSH_CONFIG_HOME/oh-my-zsh

# Theme 
ZSH_CUSTOM="$ZSH_CONFIG_HOME/oh-my-zsh.d"
ZSH_THEME="custom" #terminalparty #sunaku #muse
COMPLETION_WAITING_DOTS="true"

zstyle :omz:plugins:ssh-agent agent-forwarding on

# Select plugins to enable
plugins=(
  autojump
  extract
  ssh-agent
  gitignore
  gitfast
  python
  pip
  virtualenv
  web-search
  theme
  thefuck
  docker
  docker-compose
)
#
# Load oh-my-zsh 
source $ZSH/oh-my-zsh.sh
