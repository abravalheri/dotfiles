#!/usr/bin/env zsh
declare -A ZPLGM
ZPLGM[HOME_DIR]=${XDG_DATA_HOME}/zplugin
ZPLGM[BIN_DIR]=${ZPLGM[HOME_DIR]}/bin
ZPLGM[PLUGINS_DIR]=${ZPLGM[HOME_DIR]}/plugins
ZPLGM[COMPLETIONS_DIR]=${ZPLGM[HOME_DIR]}/completions
ZPLGM[SNIPPETS_DIR]=${ZPLGM[HOME_DIR]}/snippets
ZPLGM[SERVICES_DIR]=${ZPLGM[HOME_DIR]}/services

if [ ! -d ${ZPLGM[HOME_DIR]} ]; then
  mkdir -p ${ZPLGM[HOME_DIR]}
  git clone https://github.com/zdharma/zplugin ${ZPLGM[BIN_DIR]}
  source ${ZPLGM[HOME_DIR]}/bin/zplugin.zsh
  zplugin self-update
else
  source ${ZPLGM[HOME_DIR]}/bin/zplugin.zsh
fi
autoload -Uz _zplugin
# shellcheck disable=SC2154,2034,2004
(( ${+_comps} )) && _comps[zplugin]=_zplugin

# Plugin Configuration:
zstyle :omz:plugins:ssh-agent lifetime 4h
zstyle :omz:plugins:ssh-agent identities id_rsa
zstyle :omz:plugins:ssh-agent agent-forwarding on
# PURE_PROMPT_SYMBOL="%%"
# SPACESHIP_VI_MODE_SHOW=false

# Plugin Definition:
# zplugin ice wait:3
zplugin light "MichaelAquilina/zsh-you-should-use"
# zplugin light "laurenkt/zsh-vimto"
zplugin light "mafredri/zsh-async"
zplugin ice svn; zplugin snippet PZT::"modules/command-not-found"
zplugin ice svn; zplugin snippet PZT::"modules/history"
# zplugin ice svn; zplugin snippet PZT::"modules/spectrum"
zplugin ice svn; zplugin snippet OMZ::"plugins/autojump"
zplugin ice svn; zplugin snippet OMZ::"plugins/colored-man-pages"
# zplugin ice svn; zplugin snippet OMZ::"plugins/fzf"
zplugin ice svn; zplugin snippet OMZ::"plugins/git-auto-fetch"
zplugin ice svn; zplugin snippet OMZ::"plugins/thefuck"
# zplugin ice svn; zplugin "plugins/tig", from:oh-my-zsh
zplugin ice svn; zplugin snippet OMZ::"plugins/web-search"
zplugin ice svn; zplugin snippet OMZ::"plugins/ssh-agent"
# zplugin ice svn; zplugin snippet "srijanshetty/zsh-pandoc-completion"
# zplugin ice svn; zplugin snippet "zsh-users/zaw"
# zplugin ice svn; zplugin snippet "zsh-users/zsh-completions"
# zplugin ice svn; zplugin snippet "zsh-users/zsh-history-substring-search"
