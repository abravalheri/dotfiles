if command-exists docker.exe; then
  if [ ! -d /c ]; then
    if [ -x ~/.local/bin/mount-for-docker.sh ]; then
      sudo ~/.local/bin/mount-for-docker.sh
    else
      if command -v ssh-askpass &>/dev/null; then
        DISPLAY=:0 SUDO_ASKPASS=/usr/bin/ssh-askpass sudo mount --bind /mnt/c /c
      elif [ -x ~/.local/bin/rofi-askpass ]; then
        DISPLAY=:0 SUDO_ASKPASS=~/.local/bin/rofi-askpass sudo mount --bind /mnt/c /c
      else
        echo "Sudo required to bind volume required fo docker interoperation" >>/dev/stderr
      fi
    fi
  fi

  export DOCKER_HOST=tcp://localhost:2375
fi
