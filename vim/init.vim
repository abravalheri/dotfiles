""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTICE: Vim reads .vim/vimrc when .vimrc does not exist
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This file only make basic configuration for VIM and redirect to other files
scriptencoding utf8


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" When started as 'evim', evim.vim will already have done these settings.
if v:progname =~? 'evim'
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible              " be iMproved, required


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" XDG Environment For VIM
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Effort to make vim more XDG-basedir compatible
" (partially taken from https://gist.github.com/kaleb/3885679)
"
" References
" ----------
"
" - http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables
" - http://tlvince.com/vim-respect-xdg
"

if empty($XDG_CACHE_HOME)
  let $XDG_CACHE_HOME = $HOME . '/.cache'
endif

if empty($XDG_CONFIG_HOME)
  let $XDG_CONFIG_HOME = $HOME . '/.config'
endif

if !isdirectory($XDG_CACHE_HOME . '/vim/swap')
  call mkdir($XDG_CACHE_HOME . '/vim/swap', 'p')
endif

if !isdirectory($XDG_CACHE_HOME . '/vim/backup')
  call mkdir($XDG_CACHE_HOME . '/vim/backup', 'p')
endif

" see :help persistent-undo
if !isdirectory($XDG_CACHE_HOME . '/vim/undo')
  call mkdir($XDG_CACHE_HOME . '/vim/undo', 'p')
endif

set directory=$XDG_CACHE_HOME/vim/swap,~/,/tmp
set backupdir=$XDG_CACHE_HOME/vim/backup,~/,/tmp
if has('persistent_undo')
  set undodir=$XDG_CACHE_HOME/vim/undo,~/,/tmp
endif
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo

set runtimepath-=~/.vim
set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath-=~/.vim/after
set runtimepath+=$XDG_CONFIG_HOME/vim/after


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration itself
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" but for dotfiles purposes:
if empty($DOTFILES)
  let $DOTFILES = $XDG_CONFIG_HOME . '/dotfiles'
endif

if !empty(glob($DOTFILES . '/vim/config.vim'))
  source $DOTFILES/vim/config.vim
endif
