#!/usr/bin/env zsh
# Autoload Functions

__zshrc_autoload() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local fp="$cache_dir/autoload-cache.zsh"
  if [ ! -f $fp ]; then
    echo "Compiling autoload directive"
    set -x
    local -U autoloaded=($XDG_CONFIG_HOME/zshrc.d/autoloaded/[^_]*(xN:t))
    mkdir -p "$cache_dir"
    echo -e "#!/usr/bin/env zsh\nautoload -Uz ${autoloaded[*]}" > "$fp"
    zcompile "$fp" &!
    set +x
  fi
  source "$fp"
}
__zshrc_autoload
unset -f __zshrc_autoload  # avoid lambdas so we can use zprof
