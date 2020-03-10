# dotfiles
Configuration files for my workstation.
This helps to setup and maintain all the machines I use for work, or even in my
free time.
It is specially useful in the cases I have to start working with a new machine,
server, VM, etc…

## *dotfiles*?
You can find some information about what are *dotfiles* in
[Github's dedicated page](https://dotfiles.github.io/)


## Quickstart

Clone the repo to `~/.dotfiles` and run the installation script:

```bash
cd ~
mkdir -p .config
git clone --recursive https://github.com/abravalheri/dotfiles .dotfiles
cd .dotfiles
./install
```

## How it works?
The dotfiles in this repository are organized using a layered approach.
Groups of configuration files (and sometimes scripts/functions) with the same
purpose form together a *layer*.
A *layer* is represented by a single folder inside the *dotfiles* root, and
this folder should mimic the same infrastructure of the *home* directory.
For example, if a layer `git` wants to specify a `~/.config/git/config` file,
a file `$dotfiles/git/.config/git/config` should be present in the
repository.

Layers can be classified as **default** or **alternative**. Default layers are
implemented as folders starting with a `/a-z/i` char, while alternative layers
are folders starting with an `%` char. Default folders are meant to be used
regularly, while alternative folders are created for special cases.  For
example, the `doom-emacs` layer provides the preferable configurations for the
standard dev environment, while `%emacs.minimal` is created as an experiment,
to be installed in secondary machines, or with less powerful hardware.

Layers are installed using [GNU Stow](https://www.gnu.org/software/stow/)
([tutorial](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/)),
which makes per-layer installation easy:

``` bash
stow -R layer1 layer2 …
# -R is optional in this case, it will update a layer in the case it is already installed
```

A *bundle* encapsulates one of more layers, being able to additionally install
packages or run arbitrary scripts during installation time.
Similarly to layers, bundles are folders located in the *dotfiles* root
repository, however starting with an `@` char.
This folders contain a few files with lists of layers, programs/OS packages and
scrips
An example of how a bundle can be organized can be found bellow:

```
@bundle1
├── bootstrap.sh
├── layers.stow
├── formulas.brew
├── packages.pacman
├── packages.trizen
├── packages.apt
├── packages.pipx
├── rubygems.gem
└── finish.sh
```

## Bundle-based installation
The process of installing a bundle can be summarized in 5 steps:

1. Run `bootstrap.sh` scripts
2. Stow listed layers (`*.stow`)
3. Pre-compile ZSH scripts (`make pre-compile`)
4. Install packages (order: `*.brew`, `*.apt` or `*.pacman` + `*.trizen*`, `*.pipx`, `*.gem`)
5. Run `finish.sh` scripts

For all the steps, the installation script looks recursively for files and
expands symbolic links.
As a consequence, when creating bundles, it is possible to:
- improve organization by maintaining separated files and folder;
- re-use and compose bundles (one bundle can `extend` others),
  by including links to them inside its folder.
  * Example for creating a bundle that re-uses previous ones:
    ```bash
    mkdir @tmux+vim
    cd @tmux+vim
    ln -sr ../@tmux
    ln -sr ../@vim
    echo "tmuxp" > packages.pipx
    ```
Notice that, since the `bootstrap.sh` scripts run as the first step,
it is possible generate other bundle files on the fly.
The `@full` bundle is an example of how to use the bootstrap script to
generate the list of layers to be installed.
(It also take advantage of the rules in the `.gitignore`, by naming the
generated file `+local-layers.stow` and avoiding them to be commited in the
repository).

All the layer and package files (`*.stow`, `*``*.brew`, `*.apt` or `*.pacman` +
`*.trizen*`, `*.pipx`, `*.gem`) are plain text files with one package name per
line. Commented lines are allowed, by starting with a `#` char.

After the bootstrap script executes, the layers are stowed.
Indeed, installing all the layers in a bundle can be done manually with
the following one-liner:

```bash
stow -R $(< find -L $bundle -name '*.stow' -exec cat {} \; | uniq | grep -v '#')
```

With the layers installed, the ZSH files are compiled (`make pre-compile`)
and the packages are installed using the correct package managers (if
available). Package installation is similar to layer installation, as showed
bellow:

```bash
sudo apt-get install $(< find -L $bundle -name '*.apt' -exec cat {} \; | uniq | grep -v '#')
```

It is important to emphasize that all the bundles are processed simultaneously,
not one by one.
In each stage, the equivalent action happens for all the bundles (e.g. install
layers for all the bundles, then install packages for all the bundles, …).

## Local Customization

Per-machine customization can be done using files/folder prefixed with one of
the following strings:

- `+local`
- `@local`
- `%local`

These files/folders are not commited to the repository thanks to a rule in
.gitignore, but are considered during runtime. So, for example, the following
files can be created for customization purposes:

- `~/.config/vim/+local.vim`
- `~/.config/zsh/+local.zsh`

## Conventions

In the top-level dotfiles repository:
- `folder`  is used for default installation of layers
- `%folder` is used for alternative installation of layers
- `@folder` is used for bundles
- `+folder` holds auxiliary files to the `dotfiles` installer itself, e.g.
  `+lib`.

Inside a bundle:
- `@folder` is used as a symlink to another bundle (reuse all the packages/scripts)
- `%folder` is used to partially reuse another bundle.
  It should be a regular folder that contains symlinks to specific files inside
  the target bundle.
  For example, in order to create a bundle that inherits `packages.apt`
  from `%minimal`, but avoid using `%minimal` layers, the following can be
  done:

  ```bash
  cd ~/.dotfiles
  mkdir -p @bundle/%minimal
  cd @bundle/minimal
  ln -sr ../../@minimal/pacakges.apt
  ```

## WSL Notes

WSL is supported via the `@wsl` bundle:

```bash
./install @wsl
```

However, to maximize user experience on WSL, a few extra manual steps are
required:

- Install [Vcxsrv](https://sourceforge.net/projects/vcxsrv/)
  on C:\Local\Apps\VcXsrv (or change the scripts in `@wsl` accordingly) -
  **This enables GUI apps to run**.
- Enable "systemd-like services" in WSL:
  - Make sure the script `~/.local/bin/start-services.sh`
    can run `sudo` without asking for credentials.
  - This can be done by editing the sudoers file.
    ```bash
    sudo visudo
    # Add to the file the following line:
    %sudo ALL=NOPASSWD: /home/<USERNAME>/.local/bin/start-services.sh
    ```
  - Create a Windows shortcut to the VBS script `@wsl/start-services.vbs` to 
    `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Start-up` -
    **This enables the script to run automatically when the user logs in**.
  - Alternatively you can run the `.sh` script conditionally
    inside `~/.bashrc` or `~/.zshrc`.

You might also want to:
- Add the location ``\\wsl$\home\<USERNAME>`` to Windows Quick Access list.
- Add "executable links" targeting some GUI programs inside WSL to the Start Menu.

  This can be done by creating Windows shortcuts to VBA scripts inside the
  folder `%APPDATA%\Microsoft\Windows\Start Menu\Programs`.

  - Drag & drop with `ALT` pressed will create Windows shortcuts.
  - There are VBA scripts inside `@wsl` that can be used directly, or as an example.

References:
- https://github.com/QMonkey/wsl-tutorial
- https://dev.to/ironfroggy/wsl-tips-starting-linux-background-services-on-windows-login-3o98
- https://github.com/Microsoft/WSL/issues/637
- https://github.com/troytse/wsl-autostart
- https://medium.com/@dhanar.santika/installing-wsl-with-gui-using-vcxsrv-6f307e96fac0
- https://seanthegeek.net/234/graphical-linux-applications-bash-ubuntu-windows/
- https://superuser.com/questions/140047/how-to-run-a-batch-file-without-launching-a-command-window
