#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Enable {linux,home}brew
__zshrc_brew() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/brew"
  local fp="$cache_dir/shellenv.zsh"
  local -U candidates
  local brew_root

  [ -d "$cache_dir" ] || mkdir -p "$cache_dir"

  if [ -f "$fp" ]; then
    source "$fp"
  else
    candidates=(
      /home/linuxbrew/.linuxbrew/
      $HOME/.linuxbrew
      $HOME/.local/opt/brew
      $HOME/.local/stow/brew
    )

    for brew_root in $candidates; do
      if [ -d $brew_root ] && [ -n "${PATH##*$brew_root/bin*}" ]; then
        echo "Caching 'brew shellenv' ..."
        "$brew_root/bin/brew" shellenv > "$fp"
        zcompile "$fp"
        source "$fp"
        break
      fi
    done
  fi
}
__zshrc_brew
unset -f __zshrc_brew  # Avoid lambdas so we can use zprof
