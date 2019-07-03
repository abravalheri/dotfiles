#!/usr/bin/env bash

find-scripts() {
  # USAGE: find-scripts $pattern $folders[@]
  # EXAMPLE: find-scripts 'bootstrap.sh' @minimal @wsl
  #
  # Recursivelly identify files named affter $pattern inside $folders.
  find -L "${@:2}" -name "$1" -type f | sort -n | xargs realpath -L | uniq
}
