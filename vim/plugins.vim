"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugs using vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""
" please see https://github.com/junegunn/vim-plug
" for more information

call plug#begin($DOTFILES . '/vim/+plugins')

"" Consistency:
Plug 'editorconfig/editorconfig-vim'

" Enhancements:
Plug 'bronson/vim-trailing-whitespace'
Plug 'matchit.zip'
Plug 'airblade/vim-gitgutter'
Plug 'mileszs/ack.vim'
Plug 'sjl/gundo.vim'
" visualize vim undo tree
Plug 'terryma/vim-multiple-cursors'
Plug 'Yggdroot/indentLine'
" alternative: nathanaelkane/vim-indent-guides
Plug 'tomtom/tcomment_vim'
" alternative: Plug 'scrooloose/nerdcommenter'
Plug 'bling/vim-bufferline'
Plug 'maksimr/vim-jsbeautify'

Plug 'scrooloose/syntastic'
Plug 'myint/syntastic-extras'

Plug 'tpope/vim-markdown'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

"" Autocompletion:
if version >= 703
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
Plug 'tpope/vim-haml'
" SCSS, SASS and HAML syntax
Plug 'groenewege/vim-less'
Plug 'othree/html5.vim', {'for': 'html'}
Plug 'rstacruz/sparkup', {'rtp': 'vim/',  'for': 'html'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'isruslan/vim-es6', {'for': 'javascript'}
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}
Plug 'kchmck/vim-coffee-script'
Plug 'elzr/vim-json'

"" Other Syntaxes:
" Plug 'abravalheri/ribosome.vim'
Plug 'aklt/plantuml-syntax'
" Plug 'scrooloose/vim-slumlord'  " previews for plantuml
" Plug 'cespare/vim-toml'
Plug 'mustache/vim-mustache-handlebars'
Plug 'nathanalderson/yang.vim'
" Plug 'rust-lang/rust.vim'
" Plug 'xuhdev/syntax-dosini.vim'
Plug 'ekalinin/Dockerfile.vim'
" Plug 'vim-scripts/bats.vim'
" Plug 'vim-scripts/gsl.vim'
Plug 'jvirtanen/vim-octave'
Plug 'elixir-lang/vim-elixir'

"" Style:
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
" alternative: Plug 'maciakl/vim-neatstatus.git'

""" For future consideration
" Plug 'Lokaltog/vim-easymotion'
" Plug 'godlygeek/tabular'
" Plug 'vim-scripts/Align'
" Plug 'majutsushi/tagbar'
" Plug 'vim-scripts/SearchComplete'
" Plug 'tpope/vim-sleuth'
" Plug 'tpope/vim-abolish'
" Plug 'thinca/vim-quickrun'
" Plug 'ervandew/supertab'
" Plug 'tommcdo/vim-exchange'
" Plug 'tpope/vim-unimpaired'
" Plug 'itchyny/lightline-powerful'

" All of your Plugs must be added before the following line
call plug#end()
