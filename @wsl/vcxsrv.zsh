#!/usr/bin/env zsh
process-running() {
  local PID=$1
  kill -s 0 "$PID" &>/dev/null
}

vcxsrv-init() {
  # Initilize VcXsrv unless it is already running
  local VCXSRV_ROOT=$1
  local RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp/run/$(id -u)}"
  mkdir -p "$RUNTIME_DIR"
  local VCXSRV_PID="$RUNTIME_DIR/vcxsrv.pid"

  if [[ ! -f "$VCXSRV_PID" ]] || ! process-running "$(< "${VCXSRV_PID}")"; then
    "${VCXSRV_ROOT}/vcxsrv.exe" :0 -multiwindow -clipboard -wgl -silent-dup-error -xkblayout us -xkbvariant altgr-intl -xkbvariant nodeadkeys  &>/dev/null &
    # sudo /etc/init.d/dbus start
    PID=$!
    echo "$PID" > "$VCXSRV_PID"
  fi

  cat "$VCXSRV_PID"
}

function() {
  local VCXSRV_ROOT=/mnt/c/Local/Apps/VcXsrv
  if [[ -d "$VCXSRV_ROOT" ]]; then
    vcxsrv-init "$VCXSRV_ROOT"
  fi
}
