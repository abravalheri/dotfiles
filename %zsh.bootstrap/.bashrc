set bell-style visible

## Expand PATH if custom program is needed
# case ":$PATH:" in
#   *":$HOME/.local/bin:"*) :;; # already there
#   *) PATH="$HOME/.local/bin:$PATH";;
# esac

# Hack to start ZSH from Bash
if [ -t 1 ]; then
  if [[ ! -v _start_home ]]; then
    # Usefull hack to make tmux open ~ at first,
    # but keep $pwd otherwise
    cd ~ || return
    export _start_home=$(pwd)
  fi
  # Replace bash process with zsh
  exec zsh
fi
