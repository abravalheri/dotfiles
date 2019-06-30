# dotfiles
Linux configuration files for my personal environment.
Programs supported include `git`, `vim`, `tmux` and `zsh`

## Default Installation

Clone the repo to `~/.dotfiles` and run the installation script:

```bash
cd ~
mkdir -p .config
git clone --recursive https://github.com/abravalheri/dotfiles .dotfiles
cd .dotfiles
./install
```

## Profile-based installation
A small subset of configurations can be installed, this can be achieved using
`profiles`.
Since `dotfiles` uses GNU Stow, a profile is a simple text file with lists of
subdirectories to be stwoed.

For example, a minimal dotfiles installation in ubuntu can be achieved (after
cloning the repository as indicated above) by:

```bash
sudo apt install $(< minimal.apt)
stow -R $(< minimal.stow)
```

## Local Customizations

Per-machine customizations (not versioned) can be done by adding the following files:

- `~/.config/vim/+local.vim`
- `~/.config/zsh/+local.zsh`
