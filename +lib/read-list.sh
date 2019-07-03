#!/usr/bin/env bash

read-list() {
  # USAGE: read-list $pattern $folders[@]
  # EXAMPLE: read-list '*.stow' @minimal @wsl
  #
  # Recursivelly reads newline-separated lists from files that follow $pattern
  # inside $folders.
  # Lines can be commented by `#`, and symbolic links are expanded.
  find -L "${@:2}" -name "$1" -type f -exec cat {} \; | uniq | grep -v '#'
}
