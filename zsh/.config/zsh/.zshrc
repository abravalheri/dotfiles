#!/usr/bin/env zsh
# vim: set foldmethod=marker :
# zshrc runs for interactive sessions (login or non-login)
# https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html

# zmodload zsh/zprof  # Profiling

export EDITOR=vim
export PAGER='less -R'
export CLICOLOR=1  # OSX / FreeBSD colored ls

## History file configuration {{{
: ${HISTFILE:=$ZDOTDIR/.zsh_history}
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_ignore_all_dups   # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
# }}}

source $ZDOTDIR/base.zsh      # @inject $ZDOTDIR/base.zsh
source $ZDOTDIR/autoload.zsh  # @inject $XDG_CACHE_HOME/zsh/autoload-cache.zsh
source $ZDOTDIR/extras.zsh    # @inject $XDG_CACHE_HOME/zsh/extras-cache.zsh

[ -z "${SKIP_AGENT+x}" ] && ssh-init

# Run GRML completion framework
is4 && grmlcomp
