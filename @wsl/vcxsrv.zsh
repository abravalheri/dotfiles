#!/usr/bin/env zsh
linux-process-running() {
  local PID=$1
  kill -s 0 "$PID" &>/dev/null
}

windows-process-running() {
  tasklist.exe | grep -q "$1"
}

load-keyboard() {
  local DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
  local -U xmodmap_candidates=(
    "$DIR/.xmodmap-us-102-tal-enter"
    "$DOTFILES/@wsl/.xmodmap-us-102-tal-enter"
    "$HOME/.dotfiles/@wsl/.xmodmap-us-102-tal-enter"
  )
  for fp in $xmodmap_candidates; do
    if [[ -f $fp ]]; then
      DISPLAY=:0 xmodmap "$fp"
      echo "$fp loaded" >>/dev/stderr
      break
    fi
  done
}

dbus-is-running() {
  service dbus status | grep -vq '\<not\>'
}

start-dbus() {
  if dbus-is-running; then
    return 0
  fi

  if [ -x ~/.local/bin/start-services.sh ]; then
    sudo ~/.local/bin/start-services.sh
  else
    if command -v ssh-askpass &>/dev/null; then
      DISPLAY=:0 SUDO_ASKPASS=/usr/bin/ssh-askpass sudo -A service dbus start
    elif [ -x ~/.local/bin/rofi-askpass ]; then
      DISPLAY=:0 SUDO_ASKPASS=~/.local/bin/rofi-askpass sudo -A service dbus start
    else
      echo "Sudo required to start dbus" >>/dev/stderr
    fi
  fi
}

vcxsrv-is-running() {
  if [[ ! -f "$VCXSRV_PID" ]]; then
    echo "$VCXSRV_PID not found." >>/dev/stderr
    return 1
  fi

  if ! windows-process-running "vcxsrv.exe"; then
    echo "$VCXSRV_PID found, but vcxsrc.exe not running." >>/dev/stderr
    return 1
  fi

  return 0
}

vcxsrv-init() {
  # Initilize VcXsrv unless it is already running
  local VCXSRV_ROOT=$1
  local RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp/run/$(id -u)}"
  local VCXSRV_PID="$RUNTIME_DIR/vcxsrv.pid"
  mkdir -p "$RUNTIME_DIR"

  if ! vcxsrv-is-running; then
    "${VCXSRV_ROOT}/vcxsrv.exe" :0 \
       -dpi auto \
       -multiwindow \
       -clipboard \
       -wgl \
       -silent-dup-error \
       -xkblayout us \
       -xkbvariant altgr-intl \
       -xkbvariant nodeadkeys \
       -xkboptions compose:rctrl &>/dev/null &
    PID=$!
    rm "$VCXSRV_PID"
    (umask 066; echo "$PID" > "$VCXSRV_PID")
    sleep 0.3  # wait for X to boot-up before trying to load the keyboard
    load-keyboard
    start-dbus
  fi

  export DISPLAY=:0
  export LIBGL_ALWAYS_INDIRECT=1
  cat "$VCXSRV_PID"
}

function() {
  local VCXSRV_ROOT=/mnt/c/Local/Apps/VcXsrv

  if [[ -d "$VCXSRV_ROOT" ]]; then
    vcxsrv-init "$VCXSRV_ROOT"
  fi
}
