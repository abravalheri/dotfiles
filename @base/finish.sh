#!/usr/bin/env bash

if [ -s ~/.config/zsh ] && [ -n "${SHELL##*zsh*}" ]; then
  echo -e "To use ZSH as default shell please do:\n"
  echo -n "$(tput bold)$(tput setf 4)"
  echo -e "  chsh -s $(which zsh)"
  echo -e "  env zsh"
  echo -e "  source ~/.zshrc\n"
  echo -n "$(tput srg0)"
  echo -e "Alternativelly the .bashrc file provided by @zsh.bootstrap should be used"
fi
