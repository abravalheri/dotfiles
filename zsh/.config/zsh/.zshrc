#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# zshrc runs for interactive sessions (login or non-login)
# https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html

# Variables for interactive sessions: {{{
export EDITOR=vim
export PAGER=less
export CLICOLOR=1  # OSX / FreeBSD colored ls
# }}}

# Profiling {{{
PROFILE_STARTUP=true
if [[ "${PROFILE_STARTUP:-false}" == true ]]; then
  # Profiling:
  # https://kev.inburke.com/kevin/profiling-zsh-startup-time/

  zsh_start=$(date +'%s')

  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
  exec 3>&2 2>/tmp/zsh-profile.$$.log
  # exec 3>&2 2>"${XDG_CACHE_HOME:-$HOME/.cache}/zsh_statup.$$.log"
  setopt xtrace prompt_subst

  # Alternatively:
  # zmodload zsh/zprof # Start recording load-time statistics
fi
# }}}

source $ZDOTDIR/base.zsh

# Source configurations from extra files {{{
function() {
  local fp
  local -U extra=(
    $ZDOTDIR/+local*.zsh(xN)
    # ^  Files specific to host, not shared via dotfiles
    $XDG_CONFIG_HOME/zshrc.d/?*.zsh(xN)
    # ^  Files from other program configurations (e.g. TMUX)
  )
  for fp in $extra; source $fp
}
# }}}

# Run GRML completion framework
is4 && grmlcomp

# Profiling {{{
if [[ "${PROFILE_STARTUP:-false}" == true ]]; then
  unsetopt xtrace
  exec 2>&3 3>&-

  echo "ZSHRC took $(($(date +'%s') - $zsh_start)) seconds"
  unset zsh_start

  # Alternatively:
  # zprof # Output load-time statistics
fi
# }}}

# Auto-start X if directly logged to the machine {{{
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
# }}}
