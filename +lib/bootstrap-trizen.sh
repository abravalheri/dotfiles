#!/usr/bin/env bash

bootstrap-trizen() {
  # Attempts to install trizen if missing and pacman is available
  if command -v trizen &>/dev/null; then
      return 0
  fi
  if command -v pacman &>/dev/null; then
    base_dir=$(pwd)
    echo "Installing trizen to help with AUR packages..."
    cd /tmp
    git clone https://aur.archlinux.org/trizen.git
    cd trizen
    sudo makepkg -si
    cd "$base_dir"
  else
    echo "Trizen is not available for this distribution of $(uname -rs)\t ... Skipping"
  fi
}
