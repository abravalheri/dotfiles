#!/usr/bin/env bash

# References:
# https://seanthegeek.net/234/graphical-linux-applications-bash-ubuntu-windows/
# https://medium.com/@dhanar.santika/installing-wsl-with-gui-using-vcxsrv-6f307e96fac0
# https://superuser.com/questions/140047/how-to-run-a-batch-file-without-launching-a-command-window
# https://github.com/Microsoft/WSL/issues/637
# https://github.com/QMonkey/wsl-tutorial

__finish_wsl() {
  local here="$(cd "$(dirname "${BASH_SOURCE[0]:-$(dirname "$0")}")" && pwd)"
  local wsl_home="\\\\wsl$\\home\\$(id -u -n)"
  local VCXSRV_ROOT=/mnt/c/Local/Apps/VcXsrv
  local VCXSRV_WINDOWS="C:\\Local\\Apps\\VcXsrv"

  if [ ! -f "${VCXSRV_ROOT}/vcxsrv.exe" ]; then
    echo -n "  ** $(tput bold)$(tput setaf 3)"
    echo -n "Please install Vcxsrv "
    echo -n "$(tput sgr0)"
    echo -n "(https://sourceforge.net/projects/vcxsrv/) "
    echo -e "in ${VCXSRV_WINDOWS} to have access to GUI applications."
  fi
  echo -en "\n  ** $(tput bold)$(tput setaf 3)"
  echo -e       "You might also want to:"
  echo -n       "$(tput sgr0)"
  echo -e "     - Add the location '${wsl_home}' to Windows Quick Access list."
  echo -e "     - Go inside '${wsl_home}\\.dotfiles\\@wsl' and"
  echo -n         "$(tput bold)"
  echo -e "       [Right Click] > Send to > Desktop (create shortcut)"
  echo -n         "$(tput sgr0)"
  echo -e "       on the *.vbs files you find important."
  echo -e "       Alternatively you can drag-and-drop the file with \"ALT\" pressed."
  echo -e "     - Then go to your desktop and rename/change the icon"
  echo -e "       of the new shortcuts."
  echo -e "     - Move these shortcuts to "
  echo -n         "$(tput bold)"
  echo -e "       '%APPDATA%\\Microsoft\\Windows\\Start Menu\\Programs'"
  echo -n         "$(tput sgr0)"
  echo -e "     - Have a look on https://github.com/QMonkey/wsl-tutorial"

  echo -en "\n  ** $(tput bold)$(tput setaf 4)"
  echo -n      "Enabling \"services\" in WSL"
  echo -e      "$(tput sgr0):"
  echo -e "     - Make sure the script '~/.local/bin/start-services.sh'"
  echo -e "       can run sudo without asking for credentials."
  echo -e "     - This can be done by editing the sudoers file.\n"
  echo -n         "$(tput bold)$(tput setaf 3)"
  echo -e "       sudo visudo\n"
  echo -e "       %sudo ALL=NOPASSWD: /home/<USERNAME>/.local/bin/start-services.sh"
  echo -e         "$(tput sgr0)"
  echo -e "       References:"
  echo -e "       - https://dev.to/ironfroggy/wsl-tips-starting-linux-background-services-on-windows-login-3o98"
  echo -e "       - https://github.com/troytse/wsl-autostart\n"
  echo -e "     - Create a symlink/copy the VBS script '$here/start-services.vbs' to "
  echo -n         "$(tput bold)"
  echo -e "       '%APPDATA%\\Microsoft\\Windows\\Start Menu\\Programs\\Start-up'"
  echo -n         "$(tput sgr0)"
  echo -e "     - Alternatively you can run the '.sh' script conditionally"
  echo -e "       inside '~/.bashrc' or '~/.zshrc'."
  echo ""
}

__finish_wsl
unset -f __finish_wsl
