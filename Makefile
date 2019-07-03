## Define Targets
DOTFILES := ${HOME}/.dotfiles
XDG_CONFIG_HOME := ${HOME}/.config
ifneq (,$(wildcard "${XDG_CONFIG_HOME}/zsh"))
ZSH_USES_XDG = "true"
ZDOTDIR := ${XDG_CONFIG_HOME}/zsh
else
ZDOTDIR := ${HOME}
endif
ZSHRCD := ${XDG_CONFIG_HOME}/zshrc.d
AUTOLOAD := ${ZSHRCD}/autoloaded

ZDOT_FLAGS := -maxdepth 1 \( -not -type d \) -and \( -iname ".pathrc" -or -iname "*.zsh" -or -iname ".zsh*" \)

AUTOLOAD_FILES := $(shell find -L ${AUTOLOAD} -not -iname ".*" -not -iname "*.zwc" -not -type d)
ZDOT_FILES := $(shell find -L ${ZDOTDIR} -maxdepth 1 \( -not -type d \) -and \( -iname ".pathrc" -or -iname ".zsh*" \) -not -iname ".zsh_history" -not -iname ".*.zwc")
ZSH_FILES := $(shell find -L ${ZSHRCD} -maxdepth 1 -iname "*.zsh" -not -type d) \
             $(shell find -L ${ZDOTDIR} -maxdepth 1 -iname "*.zsh" -not -type d)

AUTOLOAD_TARGET := $(addsuffix .zwc,${AUTOLOAD_FILES})
ZDOT_TARGET := $(addsuffix .zwc,${ZDOT_FILES})
ZSH_TARGET := ${ZSH_FILES:.zsh=.zwc}
TARGET := ${AUTOLOAD_TARGET} ${ZDOT_TARGET} ${ZSH_TARGET}

default: pre-compile

pre-compile: ${TARGET}

${ZDOT_TARGET} ${AUTOLOAD_TARGET}: %.zwc: %
	zsh -c 'zcompile $<'

${ZSH_TARGET}: %.zwc: %.zsh
	zsh -c 'zcompile $<'

clean:
	rm -rf ${TARGET}
	find -L . -iname "*.zwc" -delete
ifdef ZSH_USES_XDG
	find -L ${ZDOTDIR} -iname "*.zwc" -delete
endif
	find -L ${ZSHRCD} -iname "*.zwc" -delete

watch:
	find ~/.dotfiles -iname "*.zsh" -or -iname ".*rc" | entr -d ${MAKE} -C ~/.dotfiles
