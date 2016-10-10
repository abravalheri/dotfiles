# dotfiles
Custom Linux configuration files, including default oh-my-zsh and
vundle configuration
(using [dotbot](https://github.com/anishathalye/dotbot/)).

## Instalation

Clone the repo to `~/.config/dotfiles` and run the installation script:

```bash
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/abravalheri/dotfiles
cd dotfiles
zsh ./install
```

This script will symlink the dotfiles and clone the required repositories
(vundle, oh-my-zsh).

Please make sure to have `zsh`, `git`, `python`, `ruby`, `tmux`, `vim` and `astyle` installed before running this.

## Local Customizations

Per-machine customizations (not versioned) can be done by adding the following files:

- `vim/+local.vim`;
- `zsh/+local.zsh`.
