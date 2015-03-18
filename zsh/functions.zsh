ssh-init() {
  eval ssh-agent $SHELL
  ssh-add
}
