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

Plug 'editorconfig/editorconfig-vim'   | " allow per project configuration of style

Plug 'beloglazov/vim-online-thesaurus' | " search for replacing words

Plug 'tpope/vim-commentary'            | " easily add/remove/toogle comments on lines
" Plug 'tpope/vim-dispatch'              | " dispatch commands in tmux panels
Plug 'tpope/vim-eunuch'                | " unix helpers, such as SudoWrite
Plug 'tpope/vim-projectionist'         | " easily change between files
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

Plug 'andrewradev/linediff.vim'        | " allow diff of 2 selections
Plug 'Chiel92/vim-autoformat'          | " code autoformat ftw!
Plug 'chrisbra/recover.vim'            | " show a diff, whenever recovering a buffer
Plug 'ludovicchabant/vim-gutentags'    | " automatically manages tag files
Plug 'michaeljsmith/vim-indent-object' | " extra text object: vii, vaI
Plug 'nelstrom/vim-visual-star-search'
Plug 'padde/jump.vim'                  | " integrate autojump to vim {{{
" Plug 'abravalheri/jump.vim', { 'branch': 'add-lcd' }
  let g:autojump_vim_command = 'tcd'
" }}}
Plug 'rhysd/clever-f.vim'              | " more convenient and responsive f {{{
  let g:clever_f_across_no_line = 1
  let g:clever_f_fix_key_direction = 1
  let g:clever_f_timeout_ms = 3000
" }}}
Plug 'roxma/vim-tmux-clipboard'        | " clipboard integration
Plug 'sjl/gundo.vim'                   | " visualize vim undo tree
Plug 'tommcdo/vim-lion'                | " easy alignment with gl<char> {{{
  let g:lion_squeeze_spaces = 1
" }}}
Plug 'junegunn/vim-easy-align'
Plug 'vim-scripts/BufOnly.vim'         | " `only` but for buffers
Plug 'wellle/targets.vim'              | " extra text objects, e.g. ci_ va| da,

" Git: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'tpope/vim-fugitive'                 | " git frontend for vim
Plug 'airblade/vim-gitgutter'             | " displays change markers on lines
Plug 'jreybert/vimagit'                   | " another git porcelain (experimental) {{{
augroup magit_hooks
  autocmd!
  autocmd User VimagitEnterCommit startinsert \| setlocal textwidth=72
  autocmd User VimagitLeaveCommit setlocal textwidth=0
augroup END
" }}}
Plug 'gregsexton/gitv', {'on': ['Gitv']}  | " Interactive Git Graph
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Extra Syntax: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
  Plug 'alerque/vim-commonmark', {'do': 'make'}
endif

Plug 'aklt/plantuml-syntax'
Plug 'nathanalderson/yang.vim'
" Plug 'python-mode/python-mode', { 'branch': 'develop' }
Plug 'plytophogy/vim-virtualenv'
Plug 'aquach/vim-http-client'
Plug 'tpope/vim-endwise'
" Plug 'tpope/vim-rails'
Plug 'sheerun/vim-polyglot'
Plug 'slashmili/alchemist.vim'
Plug 'mhinz/vim-mix-format'  " {{{
  let g:mix_format_on_save = 0
" }}}
Plug 'goerz/jupytext.vim'
Plug 'manicmaniac/coconut.vim'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Editor Features: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'tpope/vim-obsession'  | " Record vim sessions with the command :Obsess

Plug 'mipmip/vim-scimark'   | " Allow editing markdown tables using sc-im

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

" " Unfortunately LSP makes things slow
" if has('nvim') || v:version >= 800
"   Plug 'prabirshrestha/vim-lsp' | " {{{
"     if executable('pyls')
"       " make sure to run ``pip3 install python-language-server``
"       au User lsp_setup call lsp#register_server({
"           \ 'name': 'pyls',
"           \ 'cmd': {server_info->['pyls']},
"           \ 'whitelist': ['python'],
"           \ })
"     endif
"   " }}}
" end

if has('nvim') && (executable('node') || executable('nodejs'))
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" UI: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'flazz/vim-colorschemes'
" Plug 'sonph/onehalf', {'rtp': 'vim/'}

if !empty($NVIM_QT_RUNTIME_PATH)
  Plug 'equalsraf/neovim-gui-shim'
endif

if has('nvim') || has('terminal')
  Plug 'srstevenson/vim-picker'
  " Plug 'abravalheri/vim-picker', { 'branch': 'expose-direct-functions' }
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

call plug#end()
