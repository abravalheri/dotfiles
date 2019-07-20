#!/usr/bin/env zsh

function __zshrc_load_extra() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local cache_file="$cache_dir/extras-cache.zsh"
  local -U extra priv list

  if [ ! -f "$cache_file" ]; then
    echo "Compiling extra zshrc files"
    extra=(
      # Meant for external installations, just check if file exists:
      /usr/share/autojump/autojump.zs[h](N)  # [h] -> POG to activate glob

      # Check if the file is executable (so we can deactivate it with chmod)
      $HOME/.config/zsh/+local*.zsh(xN)
      # ^  Files specific to host, not shared via dotfiles
      $HOME/.config/zshrc.d/?*.zsh(xN)
      # ^  Files from other program configurations (e.g. TMUX)
    )
    set -x
    mkdir -p "$cache_dir"
    local fp;
    for fp in $extra; do
      echo "#### $fp ####" >> "$cache_file"
      cat $fp >> "$cache_file"
      echo "" >> "$cache_file"
    done
    zcompile "$cache_file" &!
    set +x
  fi
  source "$cache_file"
}
__zshrc_load_extra
unset -f __zshrc_load_extra  # avoid lambdas so zprof can be used
