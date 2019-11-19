#!/usr/bin/env bash
echo -e "\nPreparing sources for Ubuntu packages (PPAs) ..."

sudo apt-get update

echo -e "\nDocker ..."
sudo apt-get install apt-transport-https \
                     ca-certificates \
                     curl \
                     software-properties-common \
                     sudo

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository -y \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

echo -e "\nYarn ..."
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo -e "\ndeb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

echo -e "\nNeovim ..."
sudo add-apt-repository -y ppa:neovim-ppa/stable

echo -e "\nVim 8 ..."
sudo add-apt-repository -y ppa:jonathonf/vim

echo -e "\nJava ..."
sudo add-apt-repository -y ppa:linuxuprising/java

packages=(
  autojump
  ctags
  docker-ce
  graphviz
  hwinfo
  jq
  neovim
  nmap
  nodejs
  p7zip
  python-dev
  python-pip
  python3
  python3-dev
  python3-lxml
  python3-pip
  python3-venv
  ranger
  shellcheck
  silversearcher-ag
  stow
  tmux
  tree
  vim-nox
  w3m
  wget
  yarn
  zsh
)

echo -e "\nFinally installing packages ..."

sudo apt-get update
sudo apt-get install -y "${packages[@]}"
