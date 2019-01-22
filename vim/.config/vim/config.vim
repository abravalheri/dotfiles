" vim: set foldmethod=marker :
scriptencoding utf8  " encoding for this file


" General Settings: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set history=5000    " keep 5000 lines of command line history
set splitbelow
set splitright
" ^  panels open in a more natural way...

set hidden
" ^  keep buffers alive, even if inactive
"    (http://nvie.com/posts/how-i-boosted-my-vim/#change-vim-behaviour)

if !has('nvim')
  set ttyfast
endif

set spell
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" File Properties: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set textwidth=79        " default wrapping
set backspace=indent,eol,start
" ^  allow backspacing over everything in insert mode

filetype plugin indent on
" ^  Turn on the combination of filetype detection, fyletype dependent plugins
"    and indentation.
"    Use the default filetype settings, so that mail gets 'tw' set to 72,
"    'cindent' is on in C files, etc.
"    Also load indent files, to automatically do language-dependent indenting.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" UI Properties: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set colorcolumn=+1
" set title           " change the terminal's title, broken on URXVT
set showmode
set laststatus=2
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set visualbell
set list
set listchars=tab:▶\ ,trail:•,extends:❱,precedes:❰,nbsp:␣,eol:↲
set scrolloff=5     " show 5 lines before and 3 lines after cursor always
set number
set linebreak
let &showbreak='↪ … '
" ^  use ellipsis to indicate line is broken in softwrap

" netrw config {{{
let g:netrw_liststyle = 3   " tree view
let g:netrw_winsize = 30
let g:netrw_preview = 1     " Split previews vertical split
let g:netrw_alto = 0        " Split botright first
let g:netrw_altv = 1        " Split botright first
" }}}

" try to make things faster {{{
set lazyredraw
" set synmaxcol=200
" syntax sync minlines=255

if has('gui_running')
  set guioptions-=m   " remove menu bar
  set guioptions-=T   " remove toolbar
  set guioptions-=r   " remove right-hand scroll bar
  set guioptions-=L   " remove left-hand scroll bar
endif
" }}}

if exists('+relativenumber')
  set relativenumber
  " ^  line numbering in hybrid mode for easier motions
endif

if has('mouse')
  " in many terminal emulators the mouse works just fine, thus enable it.
  set mouse=a
endif

if has('autocmd')
  "" Open Last Edited Line: {{{
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  augroup last_line_edited
    autocmd!
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
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

  "" Spell: {{{
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  augroup set_spell
    autocmd!
    autocmd Filetype {text,markdown,rst} set spell
  augroup END
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Backups: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set undolevels=1000 " use several levels of undo

if has('vms')
  set nobackup    " do not keep a backup file, use versions instead
else
  set backup      " keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile  " keep an undo file (undo changes after closing)
  endif
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Diffs: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set diffopt+=iwhite,vertical "Ignore changes in amount of white space

if !exists(':DiffOrig')
  command DiffOrig vert new | set buftype=nofile | r ++edit # | 0d_ | diffthis
      \ | wincmd p | diffthis
  " ^  Convenient command to see the difference between the current buffer and
  "    the file it was loaded from, thus the changes you made.  Only define it
  "    when not defined already.
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Search: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch     " do incremental searching
set ignorecase
set smartcase     " if the regex has an upper letter, do not ignore case
set wrapscan      " circular search through the file

if &t_Co > 2 || has('gui_running')
  " if terminal has colors highlighting the last used search pattern.
  set hlsearch
endif

if has('nvim')
  " nvim supports incremental searching for substitute
  set inccommand=split
end

if executable('ag')
  " faster grep
  set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
  set grepformat^=%f:%l:%c:%m  " file:line:column:message
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Command Line Autocompletion: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Autocomplete: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('autocmd') && exists('+omnifunc')
  " activate omni autocomplete
  augroup activate_ominifunc
    au!
    autocmd Filetype *
      \ if &omnifunc == "" |
      \   setlocal omnifunc=syntaxcomplete#Complete |
      \ endif
  augroup END
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Load Additional Configuration: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:files = ['plugins', 'style', 'extras', 'keybindings', '+local']

for s:file in s:files
  let s:fname = _config_base . '/' . s:file . '.vim'
  if !empty(glob(expand(s:fname)))
    exec 'source ' . s:fname
  endif
endfor
