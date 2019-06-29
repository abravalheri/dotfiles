#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Bootstrap zplugin: {{{
declare -A ZPLGM
ZPLGM[HOME_DIR]=${XDG_DATA_HOME:-$HOME/.local/share}/zplugin
ZPLGM[BIN_DIR]=${ZPLGM[HOME_DIR]}/bin

if [ ! -d ${ZPLGM[HOME_DIR]} ]; then
  mkdir -p ${ZPLGM[HOME_DIR]}
  git clone https://github.com/zdharma/zplugin ${ZPLGM[BIN_DIR]}
  source ${ZPLGM[BIN_DIR]}/zplugin.zsh
  zplugin self-update
else
  source ${ZPLGM[BIN_DIR]}/zplugin.zsh
fi
autoload -Uz _zplugin
# shellcheck disable=SC2154,2034,2004
(( ${+_comps} )) && _comps[zplugin]=_zplugin
# }}}

# Plugin Configuration:
## ssh-agent: {{{
zstyle :omz:plugins:ssh-agent lifetime 4h
zstyle :omz:plugins:ssh-agent identities id_rsa
zstyle :omz:plugins:ssh-agent agent-forwarding on
## }}}

## fzy : {{{
zstyle :fzy:file command rg --files
# ALT-C: cd into the selected directory
# CTRL-T: Place the selected file path in the command line
# CTRL-R: Place the selected command from history in the command line
# CTRL-P: Place the selected process ID in the command line
bindkey '\ec' fzy-cd-widget
bindkey '^T'  fzy-file-widget
bindkey '^R'  fzy-history-widget
bindkey '^P'  fzy-proc-widget
## }}}

## Theme: {{{
# PURE_PROMPT_SYMBOL="%%"
# SPACESHIP_VI_MODE_SHOW=false
## }}}

# Plugin Definition:
## Blocking:
zplugin ice svn; zplugin snippet OMZ::"plugins/autojump"
## Turbo Load:
zplugin ice svn wait:!0; zplugin snippet PZT::"modules/command-not-found"
zplugin ice svn wait:!0; zplugin snippet PZT::"modules/history"
zplugin ice svn wait:!0; zplugin snippet PZT::"modules/spectrum"
zplugin ice svn wait:!0; zplugin snippet OMZ::"plugins/colored-man-pages"
zplugin ice svn wait:!0; zplugin snippet OMZ::"plugins/git-auto-fetch"
zplugin ice svn wait:!0; zplugin snippet OMZ::"plugins/thefuck"
zplugin ice svn wait:!0; zplugin snippet OMZ::"plugins/web-search"
zplugin ice svn wait:!0; zplugin snippet OMZ::"plugins/ssh-agent"
zplugin ice wait:!0; zplugin light "srijanshetty/zsh-pandoc-completion"
zplugin ice wait:!0; zplugin light "aperezdc/zsh-fzy"
zplugin ice wait:!0; zplugin light "MichaelAquilina/zsh-you-should-use"
zplugin ice wait:!0; zplugin light "zsh-users/zsh-autosuggestions"
zplugin ice wait:!0; zplugin light "zdharma/fast-syntax-highlighting"
