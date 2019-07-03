#!/usr/bin/env bash

command-exists() {
  # Portable way of checking if a command exists
  command -v "$1" >/dev/null 2>&1
}
