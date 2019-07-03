#!/usr/bin/env bash

__bootstrap() {
  local HERE="$(pwd)"
  cd $(dirname "${BASH_SOURCE[0]}") || exit 1
  find .. -maxdepth 1 -type d \
    | xargs -n1 realpath \
    | xargs -n1 basename \
    | grep -vE '^[.+@%]' \
    | tee > ./+local-layers.stow
  cd "$HERE" || exit 1
}

__bootstrap
unset -f __bootstrap
