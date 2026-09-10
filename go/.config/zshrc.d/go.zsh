#!/usr/bin/env zsh
export GOPATH="$XDG_DATA_HOME/go"
path=( "${GOPATH}/bin" "${path[@]}" )
