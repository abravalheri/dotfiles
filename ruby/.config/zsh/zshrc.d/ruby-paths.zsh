#!/usr/bin/env zsh

if command-exists ruby; then
  export PATH  # Make sure ruby have access to the updated PATH
  PATH="$(ruby -e 'print (ENV["PATH"].split(":") + [Gem.bindir, Gem.user_dir + "/bin"]).uniq.compact.join(":")')"
  export PATH  # Make sure updated version of env var is available
fi
