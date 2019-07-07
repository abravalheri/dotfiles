#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Enable {linux,home}brew
__zshrc_brew() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local fp="$cache_dir/brew-shellenv-cache.zsh"
  local -U candidates
  local brew_root

  if [ ! -f "$fp" ]; then
    candidates=(
      /home/linuxbrew/.linuxbrew/
      $HOME/.linuxbrew
      $HOME/.local/opt/brew
      $HOME/.local/stow/brew
    )

    for brew_root in $candidates; do
      if [ -d $brew_root ] && [ -n "${PATH##*$brew_root/bin*}" ]; then
        echo "Caching 'brew shellenv' ..."
        set -x
        mkdir -p "$cache_dir"
        "$brew_root/bin/brew" shellenv > "$fp"
        zcompile "$fp" &!
        set +x
        break
      fi
    done
  fi
  source "$fp"
}
__zshrc_brew
unset -f __zshrc_brew  # Avoid lambdas so we can use zprof
