DOTFILES := ${HOME}/.dotfiles
XDG_CONFIG_HOME := ${HOME}/.config
ZDOTDIR := ${XDG_CONFIG_HOME}/zsh
ZSHRCD := ${XDG_CONFIG_HOME}/zshrc.d
AUTOLOADDIR := ${ZSHRCD}/autoloaded

ZDOT_FLAGS := -maxdepth 1 \( -not -type d \) -and \( -iname ".*rc" -or -iname "*.zsh" -or -iname ".zsh*" \)

AUTOLOAD_FILES := $(shell find -L "${AUTOLOADDIR}" -not -iname ".*" -not -iname "*.zwc" -not -type d)
ZDOT_FILES := $(shell find -L "${ZDOTDIR}" -maxdepth 1 \( -not -type d \) -and \( -iname ".*rc" -or -iname ".zsh*" \) -not -iname ".zsh_history" -not -iname ".*.zwc")
ZSH_FILES := $(shell find -L "${ZSHRCD}" -maxdepth 1 -iname "*.zsh" -not -type d) \
             $(shell find -L "${ZDOTDIR}" -maxdepth 1 -iname "*.zsh" -not -type d)

AUTOLOAD_TARGET := $(addsuffix .zwc,${AUTOLOAD_FILES})
ZDOT_TARGET := $(addsuffix .zwc,${ZDOT_FILES})
ZSH_TARGET := ${ZSH_FILES:.zsh=.zwc}
TARGET := ${AUTOLOAD_TARGET} ${ZDOT_TARGET} ${ZSH_TARGET}

default: pre-compile stow

pre-compile: ${TARGET}

${ZDOT_TARGET} ${AUTOLOAD_TARGET}: %.zwc: %
	./zcompile.zsh $<

${ZSH_TARGET}: %.zwc: %.zsh
	./zcompile.zsh $<

clean:
	rm -rf ${TARGET}
	find -L . -iname "*.zwc" -exec rm -rf {} \;
	find -L ${ZDOTDIR} -iname "*.zwc" -exec rm -rf {} \;
	find -L ${ZSHRCD} -iname "*.zwc" -exec rm -rf {} \;

stow:
	# Install everything that is not a hidden directory or starts with + using GNU Stow
	find . -maxdepth 1 -type d -not -iregex "^\.\(/[.+].*\)?" | sed "s~./~~" | xargs -L1 stow -R

watch:
	find ~/.dotfiles -iname "*.zsh" -or -iname ".*rc" | entr -d ${MAKE} -C ~/.dotfiles
