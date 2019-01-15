#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Profiling: https://kev.inburke.com/kevin/profiling-zsh-startup-time/ {{{
PROFILE_STARTUP=true
if [[ "$PROFILE_STARTUP" == true ]]; then
  # zmodload zsh/zprof # Output load-time statistics
  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  # PS4=$'%D{%M%S%.} %N:%i> '
  PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
  exec 3>&2 2>/tmp/zshstart.$$.log
  # exec 3>&2 2>"${XDG_CACHE_HOME:-$HOME/.cache}/zsh_statup.$$"
  setopt xtrace prompt_subst
fi
# }}}

# Functions required for bootstrapping {{{
command-exists() {
  # which ignores previous aliases but is not portable
  # command does not ignore aliases, but is built in
  # so it's better to try to check first with which and fallback to command
  which "$1" &>/dev/null || command -v "$1" &>/dev/null
}
# }}}

# Uses the GRML as bases for the system (same as Arch Linux Live CD)
source $ZDOTDIR/auto-packages.zsh
boot-grml-zshrc
boot-asdf

# Source configurations from extra files {{{
typeset -U extra
extra=(
  $ZDOTDIR/+grml.zsh
  $ZDOTDIR/+local.zsh
  # ^  Files specific to host, not shared via dotfiles
  $ZDOTDIR/zshrc.d/?*.zsh
  # ^  Files from other program configurations (e.g. TMUX)
)
for fp in $extra; [ -x $fp ] && source $fp
# }}}

# Profiling {{{
if [[ "$PROFILE_STARTUP" == true ]]; then
    # zprof
    unsetopt xtrace
    exec 2>&3 3>&-
fi
# }}}

# Auto-start X if directly logged to the machine {{{
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
# }}}
