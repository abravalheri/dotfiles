#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Improve nvim graphical experience
export NVIM_GTK_NO_HEADERBAR=1              # Disable GTK decorations on nvim-gtk
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket  # Make nvim-{gtk,qt} work nicely with neovim-remote (nvr)
