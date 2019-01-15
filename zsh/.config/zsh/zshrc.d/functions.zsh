#!/usr/bin/env zsh
# vim: set foldmethod=marker :

zsh-reload () {
  source $HOME/.zshrc
}

ssh-init() {
  eval ssh-agent $SHELL
}

show-colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
  done
}

show-ansi-colors() {
  # This file echoes a bunch of color codes to the terminal to demonstrate
  # what's available. Each line is the color code of one forground color,
  # out of 17 (default + 16 escapes), followed by a test use of that color
  # on all nine background colors (default + 8 escapes).
  #
  local T='gYw'   # The test text
  echo -e "\n                 40m     41m     42m     43m     44m     45m     46m     47m";
  for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m';
  do FG=${FGs// /}
    echo -en " $FGs \033[$FG  $T  "
    for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
    do echo -en "$EINS \033[$FG\033[$BG  $T \033[0m\033[$BG \033[0m";
    done
    echo;
  done
  echo
}

show-color-table() {
  # generates an 8 bit color table (256 colors) for
  # reference purposes, using the \033[48;5;${val}m
  # ANSI CSI+SGR (see "ANSI Code" on Wikipedia)
  #
  echo -en "\n   +  "
  for i in {0..35}; do
    printf "%2b " $i
  done

  printf "\n\n %3b  " 0
  for i in {0..15}; do
    echo -en "\033[48;5;${i}m  \033[m "
  done

  #for i in 16 52 88 124 160 196 232; do
  for i in {0..6}; do
    let "i = i*36 +16"
    printf "\n\n %3b  " $i
    for j in {0..35}; do
      let "val = i+j"
      echo -en "\033[48;5;${val}m  \033[m "
    done
  done

  echo -e "\n"
}

restart-network() {
  interface=${1:-"enp0s3"}
  sudo ifdown "$interface" && sudo ifup "$interface"
}

activate-venv() {
    project_root=$(pwd -P 2>/dev/null || command pwd)
    while [ ! -d "${project_root}/.venv" ]; do
      project_root=${project_root%/*}
      if [ "${project_root}" = "" ]; then
        echo "Virtual env not found enywhere in the current path" >&2
        return 1
      fi
    done
    source "${project_root}/.venv/bin/activate"
    echo "${project_root}/.venv activated"
}

browse() {
  tabbed -c vimb -e "$@"
}

wttr() {
  curl -4 wttr.in/"$@"
}
