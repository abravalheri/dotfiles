#!/usr/bin/env zsh

function() {
  local here="$(cd "$(dirname "${(%):-%x}")" && pwd)"
  export DISPLAY=:0
  "$here/vcxsrv.zsh"
  exec emacs
}
