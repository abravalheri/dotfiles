## Define Targets
DOTFILES := ${HOME}/.dotfiles
XDG_CONFIG_HOME := ${HOME}/.config
ifneq (,$(wildcard ${XDG_CONFIG_HOME}/zsh))
ZSH_USES_XDG = "true"
ZDOTDIR := ${XDG_CONFIG_HOME}/zsh
else
ZDOTDIR := ${HOME}
endif
ZSHRCD := ${XDG_CONFIG_HOME}/zshrc.d
AUTOLOAD := ${ZSHRCD}/autoloaded

ZDOT_FLAGS := -maxdepth 1 \( ! -type d \) -a \( -name ".pathrc" -o -name "*.zsh" -o -name ".zsh*" \)

AUTOLOAD_FILES := $(shell find -L ${AUTOLOAD} ! -name ".*" ! -name "*.zwc" ! -type d)
ZDOT_FILES := $(shell find -L ${ZDOTDIR} -maxdepth 1 \( ! -type d \) -a \( -name ".pathrc" -o -name ".zsh*" \) ! -name ".zsh_history" ! -name ".*.zwc")
ZSH_FILES := $(shell find -L ${ZSHRCD} ${ZDOTDIR} -maxdepth 1 -name "*.zsh" ! -type d)
SRC_FILES:= ${AUTOLOAD_FILES} ${ZDOT_FILES} ${ZSH_FILES}
TARGET := $(addsuffix .zwc,${SRC_FILES})

default: pre-compile

pre-compile: ${TARGET}

info:
	@echo "ZDOTDIR ${ZDOTDIR}"
	@echo "ZDOT: ${ZDOT_FILES}"
	@echo "ZSH: ${ZSH_FILES}"
	@echo "AUTOLOAD: ${AUTOLOAD_FILES}"

${TARGET}: %.zwc: %
	zsh -c 'zcompile $<'

clean:
	rm -rf ${TARGET} "${XDG_CACHE_HOME}/zsh/"
	find -L . -name "*.zwc" -delete
ifdef ZSH_USES_XDG
	find -L ${ZDOTDIR} -name "*.zwc" -delete
endif
	find -L ${ZSHRCD} -name "*.zwc" -delete

watch:
	find ~/.dotfiles -name "*.zsh" -o -name ".*rc" | entr -d ${MAKE} -C ~/.dotfiles
