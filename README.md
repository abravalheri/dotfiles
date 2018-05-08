# dotfiles
Custom Linux configuration files, including default oh-my-zsh and
vim-plug configuration

## Instalation

Clone the repo to `~/.dotfiles` and run the installation script:

```bash
cd ~
mkdir -p .config
git clone --recursive https://github.com/abravalheri/dotfiles .dotfiles
cd .dotfiles
./install
```

## Local Customizations

Per-machine customizations (not versioned) can be done by adding the following files:

- `vim/+local.vim`;
- `zsh/+local.zsh`.
