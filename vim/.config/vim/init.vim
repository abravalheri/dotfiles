" vim: set foldmethod=marker :
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTICE: Vim reads .vim/vimrc when .vimrc does not exist
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This file only make basic configuration for VIM and redirect to other files
scriptencoding utf8  " encoding for this file

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fundamental Configuration: {{{

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible              " be iMproved, required
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" XDG Environment For VIM: {{{
"
" Effort to make vim more XDG-basedir compatible
" (partially taken from https://gist.github.com/kaleb/3885679)
"
" obs: neovim have built-in support
"
" References
" ----------
"
" - http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables
" - http://tlvince.com/vim-respect-xdg

if has('nvim')
  let _editor = 'nvim'
else
  let _editor = 'vim'

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

  set runtimepath^=$XDG_CONFIG_HOME/vim
  set runtimepath+=$XDG_CONFIG_HOME/vim/after
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration itself
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" but for dotfiles purposes:
if empty($DOTFILES)
  let $DOTFILES = $HOME . '/.dotfiles'
endif

let _config_base = $DOTFILES . '/' . _editor . '/.config/' . _editor
let s:config_file = _config_base . '/config.vim'

if !empty(glob(s:config_file))
  exec 'source ' . s:config_file
endif
