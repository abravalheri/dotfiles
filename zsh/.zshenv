#!/usr/bin/env zsh
# zshenv runs for all types of shells, so let's keep only the minimal
# variables and configurations here.
# https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html

# Don't load default /etc/zsh files
setopt no_global_rcs

# Set XDG global variables to their defaults if not set {{{
: ${XDG_CONFIG_HOME:=$HOME/.config}
: ${XDG_CACHE_HOME:=$HOME/.cache}
: ${XDG_DATA_HOME:=$HOME/.local/share}
: ${XDG_CONFIG_DIRS:=/etc/xdg}
: ${XDG_DATA_DIRS:=/usr/local/share:/usr/share}
# : ${XDG_RUNTIME_DIR:=/tmp/run/$(id -u)}
# }}}

# Environment variables
export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_CONFIG_DIRS XDG_DATA_DIRS
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export DOTFILES=$HOME/.dotfiles
export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"

# Locale
export LANG=en_US.UTF-8

# set up $PATH
source "${ZDOTDIR}/.pathrc"  # @inject $ZDOTDIR/.pathrc

# Remove '/' from wordchars to allow word deletion on files
export WORDCHARS=$(sed 's|/||' <<< $WORDCHARS)
