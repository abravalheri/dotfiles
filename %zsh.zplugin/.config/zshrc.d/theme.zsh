#!/usr/bin/env zsh
# vim: set foldmethod=marker :

# Reference:
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
# http://www.pedaldrivenprogramming.com/2018/09/customize-grml-zsh-config/
# http://bewatermyfriend.org/p/2013/003/

__zstyle_wrap() {
  zstyle $1 pre $2
  zstyle $1 post $3
}

function () {
  local blue=081
  local green=118
  local red=197
  local yellow=222
  local purple=135
  local orange=208
  local grey_light=252
  local grey_dark=241

  local bold="%B"
  local foreground="%F"
  local reset="%b%f%k%u%s"

  # GRML-based:
  grml_theme_add_token reset_styles "$reset"
  zstyle ':prompt:grml:left:setup' items user at host path vcs newline change-root rc percent reset_styles
  __zstyle_wrap ':prompt:grml:left:items:user' "$bold$foreground{$blue}" "$reset"
  __zstyle_wrap ':prompt:grml:left:items:user' "$bold$foreground{$blue}" "$reset"
  __zstyle_wrap ':prompt:grml:left:items:at' "$bold" "$reset"
  __zstyle_wrap ':prompt:grml:left:items:path' "$bold" "$reset"
  __zstyle_wrap ':prompt:grml:left:items:percent' \
    "$bold%(?,$foreground{$green},$foreground{$red})" "$reset"

  # Packed Themes:
  #  - First turn off GRML prompt, so we can actually use a theme
  # autoload -Uz promptinit
  # promptinit
  # prompt off
  # zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
  # zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
}

# Anonymous function that will run automatically. Prevents polluting the global
# scope

unfunction __zstyle_wrap
