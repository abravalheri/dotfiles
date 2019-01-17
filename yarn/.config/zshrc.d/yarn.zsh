#!/usr/bin/env zsh
# vim: set foldmethod=marker :

if command-exists yarn; then
  YARN_GLOBAL_MODULES=$HOME/.local/opt/yarn-modules

  if yarn global bin | grep -wq "$YARN_GLOBAL_MODULES"; then
    yarn config set prefix "$YARN_GLOBAL_MODULES"
  fi

  if [ -d "$YARN_GLOBAL_MODULES/bin" ] && [ -n "${PATH##*$YARN_GLOBAL_MODULES/bin*}" ]; then
    export PATH="$PATH:$YARN_GLOBAL_MODULES/bin"
  fi

  # tabtab source for yarn package
  # uninstall by removing these lines or running `tabtab uninstall yarn`
  if [ -f "${XDG_CONFIG_HOME}/yarn/global/node_modules/tabtab/.completions/yarn.zsh" ]; then
    source "${XDG_CONFIG_HOME}/yarn/global/node_modules/tabtab/.completions/yarn.zsh"
  fi
fi
