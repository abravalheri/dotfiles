"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins using Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""
" please see http://github.com/VundleVim/Vundle.vim
" for more information

filetype off                  " required

" set the runtime path to include Vundle and initialize
set runtimepath+=$DOTFILES/vim/+plugins/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
call vundle#begin($DOTFILES . '/vim/+plugins')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"" Consistency:
Plugin 'editorconfig/editorconfig-vim'

" Enhancements:
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'mhinz/vim-signify'
" diff signs at left margin
Plugin 'mileszs/ack.vim'
Plugin 'sjl/gundo.vim'
" visualize vim undo tree
Plugin 'terryma/vim-multiple-cursors'
Plugin 'Yggdroot/indentLine'
" alternative: nathanaelkane/vim-indent-guides
Plugin 'tomtom/tcomment_vim'
" alternative: Plugin 'scrooloose/nerdcommenter'

Plugin 'scrooloose/syntastic'
Plugin 'myint/syntastic-extras'

Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'

"" Autocompletion:
if version >= 703
  Plugin 'Shougo/neocomplete.vim'
  Plugin 'Shougo/neosnippet'
  Plugin 'Shougo/neosnippet-snippets'
else
  Plugin 'ervandew/supertab'
  Plugin 'MarcWeber/vim-addon-mw-utils'
  Plugin 'tomtom/tlib_vim'
  Plugin 'garbas/vim-snipmate'
  Plugin 'honza/vim-snippets'
endif

"" Alignment:
Plugin 'junegunn/vim-easy-align'

"" File Navigation:
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'ctrlpvim/ctrlp.vim'

"" Git:
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'gregsexton/gitv'

"" Tmux:
Plugin 'edkolev/tmuxline.vim'
Plugin 'tpope/vim-tbone'
Plugin 'benmills/vimux'

"" Python:
Plugin 'hdima/python-syntax'
Plugin 'davidhalter/jedi-vim'
Plugin 'jmcantrell/vim-virtualenv'

"" Ruby:
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-rails'

"" Web:
Plugin 'ap/vim-css-color'
Plugin 'gko/vim-coloresque'
Plugin 'tpope/vim-haml'
" SCSS, SASS and HAML syntax
Plugin 'groenewege/vim-less'
Plugin 'othree/html5.vim'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'pangloss/vim-javascript'
Plugin 'isruslan/vim-es6'
Plugin 'kchmck/vim-coffee-script'

"" Other Syntaxes:
Plugin 'abravalheri/ribosome.vim'
Plugin 'aklt/plantuml-syntax'
Plugin 'scrooloose/vim-slumlord'  " previews for plantuml
Plugin 'cespare/vim-toml'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'nathanalderson/yang.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'xuhdev/syntax-dosini.vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'vim-scripts/bats.vim'
Plugin 'vim-scripts/gsl.vim'
Plugin 'jvirtanen/vim-octave'

"" Style:
Plugin 'flazz/vim-colorschemes'
Plugin 'itchyny/lightline.vim'
" alternative: Plugin 'maciakl/vim-neatstatus.git'

""" For future consideration
" Plugin 'Lokaltog/vim-easymotion'
" Plugin 'godlygeek/tabular'
" Plugin 'vim-scripts/Align'
" Plugin 'majutsushi/tagbar'
" Plugin 'vim-scripts/SearchComplete'
" Plugin 'tpope/vim-sleuth'
" Plugin 'tpope/vim-abolish'
" Plugin 'thinca/vim-quickrun'
" Plugin 'ervandew/supertab'
" Plugin 'tommcdo/vim-exchange'
" Plugin 'tpope/vim-unimpaired'
" Plugin 'itchyny/lightline-powerful'

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
