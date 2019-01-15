#!/usr/bin/env vim
export ZPLUG_HOME=$ZDOTDIR/+zplug

[ -d $ZPLUG_HOME ] || git clone https://github.com/zplug/zplug $ZPLUG_HOME

source $ZPLUG_HOME/init.zsh

# Plugin Configuration:
zstyle :omz:plugins:ssh-agent lifetime 4h

# Debugging and Troubleshooting:
zplug "b4b4r07/zplug-doctor"

# Plugin Definition:
zplug "MichaelAquilina/zsh-you-should-use"
zplug "laurenkt/zsh-vimto"
zplug "mafredri/zsh-async"
zplug "mattcl/virtualenv-mod"
zplug "modules/archive", from:prezto
zplug "modules/command-not-found", from:prezto
zplug "modules/history", from:prezto
zplug "modules/spectrum", from:prezto
zplug "plugins/asdf.plugin.zsh", from:oh-my-zsh
zplug "plugins/autojump", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh
zplug "plugins/git-auto-fetch", from:oh-my-zsh
zplug "plugins/thefuck", from:oh-my-zsh
zplug "plugins/tig", from:oh-my-zsh
zplug "plugins/web-search", from:oh-my-zsh
zplug "plugins/ssh-agent", from:oh-my-zsh
zplug "srijanshetty/zsh-pandoc-completion"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"

# Themes:
# zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
# zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

# Executables:
zplug "junegunn/fzf-bin", \
  from:gh-r, \
  as:command, \
  rename-to:fzf, \
  use:"*linux*amd64*"

zplug "raylee/tldr", \
  from:github, \
  as:command, \
  use:"tldr" \
  hook-load:"complete -W \"\$(tldr 2>/dev/null --list)\" tldr"

# Manage itself
zplug "zplug/zplug", hook-build:"zplug --self-manage"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# Then, source plugins and add commands to $PATH
zplug load
