#!/usr/bin/env zsh
# vim: set foldmethod=marker :

alias clipboard='xclip -sel clip'
alias aj='autojump'
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
