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
Plug 'editorconfig/editorconfig-vim'

" Enhancements:
Plug 'bronson/vim-trailing-whitespace'
Plug 'vim-scripts/matchit.zip'
Plug 'airblade/vim-gitgutter'
Plug 'mileszs/ack.vim'
Plug 'sjl/gundo.vim' | " visualize vim undo tree
Plug 'terryma/vim-multiple-cursors'
Plug 'Yggdroot/indentLine' | " alternative: nathanaelkane/vim-indent-guides
Plug 'tomtom/tcomment_vim' | " alternative: Plug 'scrooloose/nerdcommenter'
Plug 'bling/vim-bufferline'
Plug 'nelstrom/vim-visual-star-search'

Plug 'tpope/vim-markdown'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

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
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeToggle'}
Plug 'jistr/vim-nerdtree-tabs', {'on': 'NERDTreeToggle'}
Plug 'ctrlpvim/ctrlp.vim'

"" Git:
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'gregsexton/gitv'

"" Tmux:
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-tbone'
Plug 'benmills/vimux'

"" Python:
Plug 'hdima/python-syntax', {'for': 'python'}
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'jmcantrell/vim-virtualenv', {'for': 'python'}

"" Ruby:
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}
Plug 'tpope/vim-rake', {'for': 'ruby'}
Plug 'tpope/vim-rails', {'for': 'ruby'}

"" Web:
Plug 'ap/vim-css-color'
Plug 'gko/vim-coloresque'
Plug 'tpope/vim-haml' | " SCSS, SASS and HAML syntax
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'
Plug 'isruslan/vim-es6', {'for': 'javascript'}
Plug 'kchmck/vim-coffee-script'
Plug 'maksimr/vim-jsbeautify'
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}
Plug 'othree/html5.vim', {'for': 'html'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'rstacruz/sparkup', {'rtp': 'vim/',  'for': 'html'}

"" Other Syntaxes:
" Plug 'abravalheri/ribosome.vim'
" Plug 'cespare/vim-toml'
" Plug 'rust-lang/rust.vim'
" Plug 'scrooloose/vim-slumlord' | " previews for plantuml
" Plug 'vim-scripts/gsl.vim'
" Plug 'xuhdev/syntax-dosini.vim'
Plug 'aklt/plantuml-syntax'
Plug 'ekalinin/Dockerfile.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'jvirtanen/vim-octave'
Plug 'mustache/vim-mustache-handlebars'
Plug 'nathanalderson/yang.vim'
Plug 'vim-scripts/bats.vim'

"" Style:
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim' | " alternative: Plug 'maciakl/vim-neatstatus.git'

""" For future consideration
" Plug 'Lokaltog/vim-easymotion'
" Plug 'ervandew/supertab'
" Plug 'godlygeek/tabular'
" Plug 'itchyny/lightline-powerful'
" Plug 'majutsushi/tagbar'
" Plug 'thinca/vim-quickrun'
" Plug 'tommcdo/vim-exchange'
" Plug 'tpope/vim-abolish'
" Plug 'tpope/vim-sleuth'
" Plug 'tpope/vim-unimpaired'
" Plug 'vim-scripts/Align'
" Plug 'vim-scripts/SearchComplete'

" All of your Plugs must be added before the following line
call plug#end()
