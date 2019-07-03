#!/usr/bin/env bash

bootstrap-pipx() {
  # Attempts to install trizen if missing and pacman is available
  if command -v pipx &>/dev/null; then
      return 0
  fi
  if command -v python3 &>/dev/null; then
    echo "Installling pipx ..."
    python3 -m pip install --user pipx
    export PATH="$HOME/.local/bin:$PATH"

  else
    echo "Trizen is not available for this distribution of $(uname -rs)\t ... Skipping"
  fi
}
