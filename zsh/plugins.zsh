zplug "b4b4r07/zplug-doctor"

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"

zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/command-not-found", from:prezto
zplug "modules/spectrum", from:prezto

zplug "robbyrussell/oh-my-zsh", use:"lib/key-bindings.zsh"
zplug "robbyrussell/oh-my-zsh", use:"lib/grep.zsh"
zplug "robbyrussell/oh-my-zsh", use:"lib/misc.zsh"
zplug "robbyrussell/oh-my-zsh", use:"lib/theme-and-appearance.zsh"
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/catimg", from:oh-my-zsh
zplug "plugins/ssh-agent", from:oh-my-zsh
zplug "plugins/gitignore", from:oh-my-zsh
zplug "plugins/gitfast", from:oh-my-zsh
zplug "plugins/rbenv", from:oh-my-zsh
zplug "plugins/bundler", from:oh-my-zsh
zplug "plugins/rake-fast", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/virtualenv", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/yarn", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/thefuck", from:oh-my-zsh
zplug "plugins/web-search", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh

zplug "srijanshetty/zsh-pandoc-completion"

zplug "$DOTFILES/zsh/custom/themes", from:local, use:"custom.zsh-theme"

zplug "zplug/zplug", hook-build:"zplug --self-manage"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install --verbose
  fi
fi

# Then, source plugins and add commands to $PATH
zplug load
