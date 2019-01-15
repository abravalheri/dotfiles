#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Profiling: https://kev.inburke.com/kevin/profiling-zsh-startup-time/ {{{
PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    zmodload zsh/zprof # Output load-time statistics
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>"${XDG_CACHE_HOME:-$HOME/.cache}/zsh_statup.$$"
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

download-grml-zshrc() {
  wget "$@" https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
}

file-age() {
  echo "$((($(date +%s) - $(date +%s -r "$1")) / 86400))"  # in days
}
# }}}

# Uses the GRML as bases for the system (same as Arch Linux Live CD)
# Make sure the file exists and it is up-to-date {{{
if [ ! -f "$ZDOTDIR/+grml.zsh" ] || (( $(file-age "$ZDOTDIR/+grml.zsh") > 30)); then
  echo "GRML ZSH configuration not found or too old. Downloading ..."
  download-grml-zshrc -O "$ZDOTDIR/+grml.zsh"
  chmod +x "$ZDOTDIR/+grml.zsh"
fi
# }}}

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
    zprof
    unsetopt xtrace
    exec 2>&3 3>&-
fi
# }}}

# Auto-start X if directly logged to the machine {{{
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
# }}}
