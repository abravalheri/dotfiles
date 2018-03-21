# For a full list of active aliases, run `alias`.

if command_exists nvr && ! command_exists vim; then
  alias vim=nvr
  alias vimdiff='nvr -d'
fi

alias zshconfig='vim ~/.zshrc'
alias clipboard='xclip -sel clip'
