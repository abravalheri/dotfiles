"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins using Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""
" please see http://github.com/gmarik/Vundle.vim
" for more information

" set the runtime path to include Vundle and initialize
set rtp+=~/dotfiles/+vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
call vundle#begin('~/dotfiles/+vim/bundle')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" vim-scripts
Plugin 'Align'
Plugin 'bats.vim'
Plugin 'gsl.vim'
Plugin 'YankRing.vim'

" Github
Plugin 'aklt/plantuml-syntax'
Plugin 'ap/vim-css-color'
Plugin 'benmills/vimux'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'cespare/vim-toml'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'edkolev/tmuxline.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'garbas/vim-snipmate'
Plugin 'godlygeek/tabular'
Plugin 'gregsexton/gitv'
Plugin 'groenewege/vim-less'
Plugin 'hdima/python-syntax'
Plugin 'honza/vim-snippets'
Plugin 'isruslan/vim-es6'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'junegunn/vim-easy-align'
Plugin 'kchmck/vim-coffee-script'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'majutsushi/tagbar'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'mattn/emmet-vim'
Plugin 'mhinz/vim-signify'
Plugin 'mileszs/ack.vim'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'myint/syntastic-extras'
Plugin 'nathanalderson/yang.vim'
Plugin 'othree/html5.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'rust-lang/rust.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/vim-slumlord'
Plugin 'shougo/neocomplete.vim'
Plugin 'sjl/gundo.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'thinca/vim-quickrun'
Plugin 'tomtom/tlib_vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-vinegar'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/SearchComplete'
Plugin 'xuhdev/syntax-dosini.vim'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'Yggdroot/indentLine'

" Status line
Plugin 'itchyny/lightline.vim'
"Plugin 'maciakl/vim-neatstatus.git' " good alternative

" Non-github
Plugin 'git://git.wincent.com/command-t.git'

" My own
Plugin 'abravalheri/ribosome.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
