"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugs using vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""
" please see https://github.com/junegunn/vim-plug
" for more information

" Auto install plugins
if empty(glob($DOTFILES . '/vim/autoload/plug.vim'))
  silent !curl -kfLo $DOTFILES/vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup install_vim_plug
    autocmd!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif

" Plugin List
call plug#begin($DOTFILES . '/vim/+plugins')

"" Consistency:
Plug 'editorconfig/editorconfig-vim'   | " configure vim to use the given project's indentation/whitespace settings

" Enhancements:
Plug 'Yggdroot/indentLine'             | " alternative: nathanaelkane/vim-indent-guides
Plug 'bling/vim-bufferline'            | " displays a list of buffers on the page bottom
Plug 'bronson/vim-trailing-whitespace' | " highlight whitespace (use FixWhitespace)
Plug 'mileszs/ack.vim'                 | " better vimgrep using ack or ag
Plug 'nelstrom/vim-visual-star-search' | " make * search for the selection in visual mode
Plug 'sjl/gundo.vim'                   | " visualize vim undo tree
Plug 'terryma/vim-multiple-cursors'    | " try to emulate sublime multiple cursors (not complete)
Plug 'vim-scripts/matchit.zip'         | " extended % matching
Plug 'ludovicchabant/vim-gutentags'    | " automatically manages tag files
Plug 'chrisbra/recover.vim'            | " show a diff, whenever recovering a buffer
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' } | " better autocomplete

" DiffEhancements:
Plug 'lambdalisue/vim-unified-diff'    | " automatically uses git diff --histogram to imrpove diffs
Plug 'lambdalisue/vim-improve-diff'    | " auto diffupdate and auto diffoff

"" SearchFeedback:
Plug 'osyo-manga/vim-over'             | " highlight feedback for substitute
Plug 'haya14busa/incsearch.vim'        | " better highlight feedback for search

"" TimPope:
Plug 'tpope/vim-abolish'               | " add Subvert command and case changes
Plug 'tpope/vim-commentary'            | " comment out code, alternatives: scrooloose/nerdcommenter, tomtom/tcomment_vim
Plug 'tpope/vim-dispatch'              | " async dispatch compilers linters and stuff
Plug 'tpope/vim-repeat'                | " better . command
Plug 'tpope/vim-surround'              | " manipulate surrounding characters such as quotes and braces
Plug 'tpope/vim-eunuch'                | " unix helpers for vim (like Move, Rename, Remove, Sudoedit ...)

"" Linters:
if exists('g:use_syntastic') || v:version < 703
  let g:use_syntastic = 1
  Plug 'scrooloose/syntastic'
  Plug 'myint/syntastic-extras'
else
  Plug 'w0rp/ale'
endif

"" Autocompletion:
if v:version >= 703
  let g:use_neocomplete = 1
  Plug 'Shougo/neocomplete.vim'
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'
else
  Plug 'ervandew/supertab'
  Plug 'MarcWeber/vim-addon-mw-utils'
  Plug 'tomtom/tlib_vim'
  Plug 'garbas/vim-snipmate'
  Plug 'honza/vim-snippets'
endif

"" Alignment:
Plug 'junegunn/vim-easy-align'

"" File Navigation:
Plug 'scrooloose/nerdtree',            {'on': 'NERDTreeToggle'}
Plug 'jistr/vim-nerdtree-tabs',        {'on': 'NERDTreeToggle'}
Plug 'ctrlpvim/ctrlp.vim'              | " fuzzy file finder

"" Git:
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'junegunn/gv.vim'                 | " basic git navigation, alternative: gregsexton/gitv
Plug 'airblade/vim-gitgutter'          | " displays change markers on lines
Plug 'xuyuanp/nerdtree-git-plugin',    {'on': 'NERDTreeToggle'}

"" Tmux:
Plug 'edkolev/tmuxline.vim',           {'on': 'Tmuxline'}
Plug 'tpope/vim-tbone'                 | " Tyank, Tput, Twrite and Tmux
Plug 'benmills/vimux'                  | " Open tmux mini-panels with VimuxPromptCommand

"" Python:
Plug 'hdima/python-syntax',            {'for': 'python'}
Plug 'davidhalter/jedi-vim',           {'for': 'python'}
Plug 'jmcantrell/vim-virtualenv',      {'for': 'python'}

"" Ruby:
Plug 'vim-ruby/vim-ruby',              {'for': 'ruby'}
Plug 'tpope/vim-rake',                 {'for': 'ruby'}
Plug 'tpope/vim-rails',                {'for': 'ruby'}

"" Web:
Plug 'ap/vim-css-color'
Plug 'gko/vim-coloresque'
Plug 'tpope/vim-haml'                  | " SCSS, SASS and HAML syntax
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less',            {'for': 'less'}
Plug 'isruslan/vim-es6',               {'for': 'javascript'}
Plug 'kchmck/vim-coffee-script',       {'for': 'coffee'}
Plug 'maksimr/vim-jsbeautify',         {'for': ['javascript', 'javascript.jsx', 'css', 'html']}
Plug 'mxw/vim-jsx',                    {'for': 'javascript.jsx'}
Plug 'othree/html5.vim',               {'for': 'html'}
Plug 'pangloss/vim-javascript',        {'for': 'javascript'}
Plug 'leafgarland/typescript-vim'
Plug 'rstacruz/sparkup',               {'rtp': 'vim/',  'for': 'html'}

"" Other Syntaxes:
" Plug 'abravalheri/ribosome.vim'
" Plug 'aklt/plantuml-syntax'
" Plug 'cespare/vim-toml'
" Plug 'elixir-lang/vim-elixir'
" Plug 'jvirtanen/vim-octave'
" Plug 'mustache/vim-mustache-handlebars'
" Plug 'nathanalderson/yang.vim'
" Plug 'rust-lang/rust.vim'
" Plug 'scrooloose/vim-slumlord'         | " previews for plantuml
" Plug 'vim-scripts/bats.vim'
" Plug 'vim-scripts/gsl.vim'
" Plug 'xuhdev/syntax-dosini.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'tpope/vim-markdown'
Plug 'bpietravalle/vim-bolt'

"" Style:
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'           | " alternative: Plug 'maciakl/vim-neatstatus.git'

""" For future consideration
" Plug 'Lokaltog/vim-easymotion'
" Plug 'ervandew/supertab'
" Plug 'godlygeek/tabular'
" Plug 'itchyny/lightline-powerful'
" Plug 'majutsushi/tagbar'
" Plug 'thinca/vim-quickrun'
" Plug 'tommcdo/vim-exchange'
" Plug 'tpope/vim-sleuth'
" Plug 'tpope/vim-unimpaired'
" Plug 'vim-scripts/Align'
" Plug 'vim-scripts/SearchComplete'

" All of your Plugs must be added before the following line
call plug#end()
