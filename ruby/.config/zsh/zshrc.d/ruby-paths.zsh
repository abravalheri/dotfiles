#!/usr/bin/env zsh

if command-exists ruby; then
  export GEM_HOME="$XDG_DATA_HOME/gem"
  export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"

  gems_dir="$(ruby -e 'print Gem.user_dir')/bin"
  # http://stackoverflow.com/questions/229551/string-contains-in-bash
  [ -n "${PATH##*$gems_dir*}" ] && PATH="$PATH:$gems_dir"

  export PATH
fi
