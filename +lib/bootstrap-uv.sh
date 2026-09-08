#!/usr/bin/env bash

bootstrap-uv() {
  # Only install uv after showing the exact command and asking for confirmation.
  if command -v uv &>/dev/null; then
    return 0
  fi

  local uv_install_cmd="curl -LsSf https://astral.sh/uv/install.sh | sh"
  echo "uv is not installed."
  echo "Install it manually with:"
  echo "  $uv_install_cmd"
  read -r -p "Run the command above now? [y/N] " answer
  case "$answer" in
    y|Y|yes)
      echo "Running: $uv_install_cmd"
      eval "$uv_install_cmd" && export PATH="$HOME/.local/bin:$PATH"
      ;;
    *)
      echo "Skipping uv install; install it manually later."
      ;;
  esac

  command -v uv &>/dev/null
}
