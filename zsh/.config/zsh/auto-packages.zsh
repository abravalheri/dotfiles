#!/usr/bin/env zsh
# Auto install and auto update a few packages

revision-date () {
  (cd $1 && git log -1 --pretty=format:%at $2)
}

last-modified() {
  stat --printf="%Z" ${1:-"$(cat)"}
}

to-age() {
  timestamp=${1:-"$(cat)"}
  echo "$(( ($(date +%s) - $timestamp) / 86400 ))"  # in days
}

age() {
  last-modified "${1:-"$(cat)"}" | to-age
}

boot-grml-zshrc() {
  local zshrc_url=https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
  if [ ! -x "$ZDOTDIR/+grml.zsh" ] ||
     (( $(age "$ZDOTDIR/+grml.zsh") > 30 )); then
    echo "GRML ZSH configuration not found or too old. Downloading ..."
    (umask 0755 && wget -O "$ZDOTDIR/+grml.zsh" $zshrc_url)
    # ^  It really doesn't matter in terms of time to download a single file,
    #    so we always download and replace.
    touch $ZDOTDIR/+grml.zsh
  fi
}

boot-asdf() {
  local asdf_version="v0.6.2"
  local asdf_url=https://github.com/asdf-vm/asdf.git
  local latest

  export ASDF_DIR="$HOME/.local/src/asdf"
  export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
  export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"

  if [ ! -d $ASDF_DIR ]; then
    mkdir -p "$(dirname "$ASDF_DIR")"
    mkdir -p "$(dirname "$ASDF_DATA_DIR")"
    git clone $asdf_url $ASDF_DIR --branch $asdf_version
  elif (( $(age $ASDF_DIR) > 30 )); then
    ( cd $ASDF_DIR;
      echo "\`asdf\` is too old. Fetching newest changes ...";
      git fetch --tags;
      latest="$(git describe --tags "$(git rev-list --tags --max-count=1)")";
      git checkout "$latest";
      touch .  # Make sure to change ctime of the repo, so it waits 30 days
    )
  fi
}
