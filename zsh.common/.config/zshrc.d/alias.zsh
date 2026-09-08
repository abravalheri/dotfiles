#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Cross-platform clipboard: pbcopy/pbpaste on macOS, xclip/xsel on Linux.
if [[ "$OSTYPE" == darwin* ]] && command -v pbcopy &>/dev/null; then
  alias clipboard='pbcopy'
  alias pasteboard='pbpaste'
  alias xcopy='pbcopy'
  alias xpaste='pbpaste'
elif command -v xclip &>/dev/null; then
  alias clipboard='xclip -selection clipboard'
  alias pasteboard='xclip -o -selection clipboard'
  alias xcopy='xclip -selection clipboard'
  alias xpaste='xclip -o -selection clipboard'
elif command -v xsel &>/dev/null; then
  alias clipboard='xsel --clipboard --input'
  alias pasteboard='xsel --clipboard --output'
  alias xcopy='xsel --clipboard --input'
  alias xpaste='xsel --clipboard --output'
fi

if command -v autojump &>/dev/null; then
  alias aj='autojump'
fi
alias mx='emacsclient -na ""'
alias em='emacsclient -cna ""'
alias e='emacsclient -ta emacs'
alias ek='emacsclient -e "(kill-emacs)"'
alias gc='git checkout'
alias gf='git fetch --all'
alias gs='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias reb='git rebase -i'
alias lola='git lola'
alias commit='git commit'
alias ammend='git commit --amend'
alias push='git push'
alias branch='git checkout -b'
alias dash=zeal
alias mmv='noglob zmv'
alias tre="tree -I 'node_modules|.venv|__pycache__|*.py[cod]|.cache|*.swp|*~|*.egg|*.eggs|.tox|.nox|.mypy_cache|.*.swp'"

alias vim='nvim'
alias vimdiff='nvim -d'

# References:
# - https://blog.sebastian-daschner.com/entries/zsh-aliases
