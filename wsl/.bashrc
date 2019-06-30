set bell-style visible

## Expand PATH if custom program is needed
# case ":$PATH:" in
#   *":$HOME/.local/bin:"*) :;; # already there
#   *) PATH="$HOME/.local/bin:$PATH";;
# esac

# Launch ZSH
if [ -t 1 ]; then
  # Hack to start Windows Terminal App on WSL ~
  if [[ ! -v _start_home ]]; then
    cd ~ || return
    export _start_home=$(pwd)
  fi
  # Replace bash process with zsh
  exec zsh
fi
