#!/usr/bin/env bash

bootstrap-brew() {
  # Attempts to install brew if missing
  if command -v brew &>/dev/null; then
    return 0
  fi
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Installing Homebrew ..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo "Installing Linuxbrew ..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  else
    echo "Homebrew/Linuxbrew is not available for $(uname -rs)\t ... Skipping"
  fi
}
