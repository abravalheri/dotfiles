# For a full list of active aliases, run `alias`.

if command_exists nvim && ! command_exists vim; then
  alias vim=nvim
  alias vimdiff='nvim -d'
fi

alias zshconfig='vim ~/.zshrc'
alias clipboard='xclip -sel clip'
