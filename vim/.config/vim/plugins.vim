" vim: set foldmethod=marker :
scriptencoding utf8  " encoding for this file


"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugs using vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""

" Auto Install Plugin Manager: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
  let s:autoload_dir=$HOME . '/.local/share/nvim/site/autoload'
else
  let s:autoload_dir=$HOME . '/.vim/autoload'
endif

let s:vim_plug=s:autoload_dir . '/plug.vim'

if empty(glob(s:vim_plug))
  exec 'silent !mkdir -p ' . _config_base . '/+plugins'
  exec 'silent !curl -kfLo ' . s:vim_plug . ' --create-dirs ' .
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  augroup install_vim_plug
    autocmd!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Plugin List:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin(_config_base . '/+plugins')

Plug 'beloglazov/vim-online-thesaurus' | " search for replacing words
Plug 'junegunn/vim-easy-align'         | " align using chars/regex
Plug 'tpope/vim-commentary'            | " easily add/remove/toogle comments on lines
Plug 'tpope/vim-repeat'                | " make the . command do more
Plug 'tpope/vim-surround'              | " easily change quotes/parenthesis/braces/tags/etc ... {{{
  if has('autocmd')
    augroup vim_surroung_erb
      autocmd!
      autocmd FileType ruby,yaml let b:surround_45 = '<% \r %>'
      autocmd FileType ruby,yaml let b:surround_61 = '<%= \r %>'
    augroup END
  endif
" }}}
Plug 'tpope/vim-vinegar'               | " improve netrw
Plug 'tpope/vim-unimpaired'            | " better navigation
Plug 'editorconfig/editorconfig-vim'   | " allow per project configuration of style
Plug 'sjl/gundo.vim'                   | " visualize vim undo tree
Plug 'ludovicchabant/vim-gutentags'    | " automatically manages tag files
Plug 'chrisbra/recover.vim'            | " show a diff, whenever recovering a buffer
Plug 'padde/jump.vim'                  | " integrate autojump to vim
Plug 'Chiel92/vim-autoformat'          | " code autoformat ftw!

" Git: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'tpope/vim-fugitive'              | " git frontend for vim
Plug 'airblade/vim-gitgutter'          | " displays change markers on lines
Plug 'jreybert/vimagit'                | " another git porcelain (experimental)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Extra Syntax: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'aklt/plantuml-syntax'
Plug 'nathanalderson/yang.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'python-mode/python-mode', { 'branch': 'develop' }
Plug 'plytophogy/vim-virtualenv'
Plug 'aquach/vim-http-client'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-endwise'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Linters: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('g:use_syntastic') || v:version < 703
  Plug 'scrooloose/syntastic'
  Plug 'myint/syntastic-extras' | " {{{
    let g:syntastic_vim_checkers = ['vint']

    command! Lint SyntasticCheck
  " }}}
else
  Plug 'w0rp/ale' | " {{{
    let g:ale_set_loclist = 1
    let g:ale_echo_msg_format = '[%severity%:%linter%] %s'
    " By default, ALE checks every time the document is save
    " to prevent that from happening set g:ale_lint_on_save to 0

    command! Lint ALELint
  " }}}
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" UI: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'dracula/vim', {'as': 'dracula'}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

call plug#end()
