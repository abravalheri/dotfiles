#!/usr/bin/env bash

sudo service dbus start
sudo service cron start

__start_circus() {
  local here="$(cd "$(dirname "${BASH_SOURCE[0]:-$(dirname "$0")}")" && pwd)"
  local config_file="$here/../../.config/circus/circus.ini"
  if [ -f "$config_file" ]; then
    if [ -f "$here/circusd" ]; then
      "$here/circusd" --daemon "$config_file"
    else
      echo -n "$(tput bold)$(tput setaf 3)"
      echo -n "\nCircus configuration file detected ($config_file) "
      echo -e "but Circus does not seem to be installed."
      echo -e "Try installing with 'pipx install circus circus-web'.\n"
      echo -n "$(tput sgr0)"
    fi
  fi
}

__start_circus
unset -f __start_circus
