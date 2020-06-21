#!/usr/bin/env bash

if [ ! -d /c/Users ]; then
  sudo sudo mkdir -p /c
  sudo mount --bind /mnt/c /c
fi
