"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration before plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" default tabs before plugins
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" allow backspacing over everything in insert mode
set backspace=indent,eol,start


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
if !empty(glob(expand('$DOTFILES/vim/plugins.vim')))
  source $DOTFILES/vim/plugins.vim
endif
" non-Plugin stuff after this line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editor settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('vms')
  set nobackup    " do not keep a backup file, use versions instead
else
  set backup      " keep a backup file (restore to previous version)
  set undofile    " keep an undo file (undo changes after closing)
endif

set history=5000  " keep 5000 lines of command line history
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands

" numbering
set number
set relativenumber  " hybrid mode

" panels open in a more natural way...
set splitbelow
set splitright

" SEARCH
set incsearch     " do incremental searching
set ignorecase
set smartcase     " if the regex has an upper letter, do not ignore case

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, 't', '', 'g')

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

nnoremap <F2> :set invpaste paste?<CR> " Toggle auto-indenting for code paste
set pastetoggle=<F2>
set showmode


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enhancements
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" SYNTAX HIGHLIGHTING:
if match($TERM, '256') >=  0
  set t_Co=256
  let g:rehash256=1
  colorscheme molokai
  set backspace=2
else
  colorscheme ir_black
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has('gui_running')
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has('autocmd')
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  if exists('+colorcolumn')
    autocmd FileType {text,vim} set colorcolumn=+1  " one character after textwidth
  else  " make it red
    autocmd FileType {text,vim} au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>78v.\+', -1)
  endif

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line('$') |
    \   exe 'normal! g`"' |
    \ endif

  augroup END
else
  set autoindent    " always set autoindenting on
endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(':DiffOrig')
  command DiffOrig vert new | set buftype=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extras
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !empty(glob(expand('$DOTFILES/vim/extras.vim')))
  source $DOTFILES/vim/extras.vim
endif
