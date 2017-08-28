scriptencoding utf8
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

" default wrapping
set textwidth=79

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
set title         " change the terminal's title
set showmode

if has('vms')
  set nobackup    " do not keep a backup file, use versions instead
else
  set backup      " keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile    " keep an undo file (undo changes after closing)
  endif
endif

set history=5000    " keep 5000 lines of command line history
set undolevels=1000 " use several levels of undo
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands

set diffopt+=iwhite,vertical "Ignore changes in amount of white space

" set cursorcolumn
set cursorline    " visual feedbak for cursor position
set visualbell

" line numbering in hybrid mode for easier motions
set number
if exists('+relativenumber')
  set relativenumber
endif

" panels open in a more natural way...
set splitbelow
set splitright

" search
set incsearch     " do incremental searching
set ignorecase
set smartcase     " if the regex has an upper letter, do not ignore case
set wrapscan      " circular search through the file
" if terminal has colors highlighting the last used search pattern.
if &t_Co > 2 || has('gui_running')
  set hlsearch
endif
" nvim supports incremental searching for substitute
if has("nvim")
  set inccommand=split
end

" command line autocompletion
set path+=**
set wildmenu
set wildignorecase
set wildmode=longest,full
set wildignore+=*.swp,*.bak,*.pyc,*.class,*.o,*.a
set wildignore+=**/__pycache__/**
set wildignore+=**/node_modules/**
set wildignore+=**/bower_components/**
set wildignore+=**/dist/**
set wildignore+=**/coverage/**
set wildignore+=**/.bundle/**
set wildignore+=**/.sass-cache/**
set wildignore+=**/*.egg-info/**

" keep buffers alive, even if inactive
" (http://nvie.com/posts/how-i-boosted-my-vim/#change-vim-behaviour)
set hidden

set list
set listchars=tab:>.,trail:.,extends:>,precedes:<,nbsp:.

" use ellipsis to indicate line is broken in softwrap
set linebreak
let &showbreak='↪ … '

" activate omni autocomplete
if has("autocmd") && exists("+omnifunc")
  augroup activate_ominifunc
    au!
    autocmd Filetype *
      \ if &omnifunc == "" |
      \   setlocal omnifunc=syntaxcomplete#Complete |
      \ endif
  augroup END
endif

" for Win32 GUI - remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, 't', '', 'g')

" in many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enhancements
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
    " if exists('+colorcolumn')
    "   autocmd FileType {text,vim} set colorcolumn=+1  " one character after textwidth
    " endif
    " make it red
    autocmd FileType {text,vim,python}
      \ au BufNewFile,BufRead,BufWrite,BufWinEnter * let w:m2=matchadd('ErrorMsg', printf('\%%<%dv.\%%>%dv', &textwidth+2, &textwidth+1), -1)

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
" Key Bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $DOTFILES/vim/keybindings.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Style
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $DOTFILES/vim/style.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extras
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $DOTFILES/vim/extras.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !empty(glob(expand('$DOTFILES/vim/+local.vim')))
  source $DOTFILES/vim/+local.vim
endif
