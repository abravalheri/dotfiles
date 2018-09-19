" vim: set foldmethod=marker :
scriptencoding utf8  " encoding for this file


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
scriptencoding utf8

" Normalization: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader="\\"

" instead of using Ex mode, use Q for formatting
" the current paragraph or selection
nnoremap Q gqap
vnoremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <c-u> <c-g>u<c-u>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Easier Commands: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ç is easier than : (and it is in the same position for ABNT keyboards)
nnoremap ç :
" also exchange ;(less frequent) and :
nnoremap ; :
nnoremap : ;

vnoremap ç :
vnoremap ; :
vnoremap : ;

" unusual sequence, easier than ESC
inoremap jj <esc>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Avoid Anti Patterns: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
noremap <pageup> <nop>
noremap <pagedown> <nop>

noremap! <up> <nop>
noremap! <down> <nop>
noremap! <left> <nop>
noremap! <right> <nop>
noremap! <pageup> <nop>
noremap! <pagedown> <nop>

" but ensure some navigability in command mode
" (Prefer C-f to edit complex command)
cnoremap <left> <left>
cnoremap <right> <right>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Search: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" clean search highlight with a space | entering in insert mode:
nnoremap <silent> <space> :nohlsearch<cr>
if has('autocmd')
  " it is not a keybinding but is similar ...
  augroup stop_hlsearch
    autocmd!
    autocmd InsertEnter * :setlocal nohlsearch
    autocmd InsertLeave * :setlocal hlsearch
  augroup END
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Pasting: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" toggle auto-indenting for code paste
set pastetoggle=<f6>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Macros: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" execute macros over selected text
xnoremap @ :<c-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  exec ":'<,'>normal @".nr2char(getchar())
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" VIM On The Fly Reconfiguration: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" in mappings instead of writing de pipe character |, <bar> should be used
" <c-u> can be used to clear the command prompt

" quickly edit/reload the vimrc file
" (from http://nvie.com/posts/how-i-boosted-my-vim/)
exec 'noremap  <silent> <leader>vi :<c-u>e ' . _config_base . '/init.vim<cr>'
exec 'noremap  <silent> <leader>vc :<c-u>e ' . _config_base . '/config.vim<cr>'
exec 'noremap  <silent> <leader>vp :<c-u>e ' . _config_base . '/plugins.vim<cr>'
exec 'noremap  <silent> <leader>vk :<c-u>e ' . _config_base . '/keybindings.vim<cr>'
exec 'noremap  <silent> <leader>ve :<c-u>e ' . _config_base . '/extras.vim<cr>'
exec 'noremap  <silent> <leader>vs :<c-u>e ' . _config_base . '/style.vim<cr>'
noremap  <silent> <leader>vr :<c-u>so $MYVIMRC<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Buffer Management: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" avoid closing the window when working with buffers
" so let pretend <leader> is :
nnoremap <silent> <leader>q  :<c-u>bd<cr>
nnoremap <silent> <leader>w  :<c-u>w<cr>
nnoremap <silent> <leader>ww :<c-u>w<bar>bd<cr>
nnoremap <silent> <leader>wq :<c-u>w<bar>bd<cr>

" cycle through buffers
nnoremap <silent> <leader><space> :<c-u>bn<cr>
nnoremap <silent> <bar><space>    :<c-u>bp<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" List Management: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" local list commands are boring and more difficult
nnoremap <silent> <leader>n  :<c-u>lNext<cr>
nnoremap <silent> <bar>n     :<c-u>lprevious<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Diff: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>dp V:diffput<cr>
nnoremap <silent> <leader>dg V:diffget<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Forgot Sudo: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" save file as root
" (https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work#7078429)
cmap W!! w !sudo tee > /dev/null %
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Terminal: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
  " open nvim integrated terminal
  nnoremap ,t  :<c-u>vsplit <bar> terminal <cr>

  " enter normal mode quicker on terminals
  tnoremap <esc>      <c-\><c-n>
  tnoremap <M-[>      <esc>
  tnoremap <C-v><esc> <esc>

  " simulate insert mode <c-r> in terminal mode
  tnoremap <expr> <c-r>  '<c-\><c-n>"' . nr2char(getchar()) . 'pi'

  " better navigation
  " Terminal mode:
  tnoremap <M-h> <c-\><c-n><c-w>h
  tnoremap <M-j> <c-\><c-n><c-w>j
  tnoremap <M-k> <c-\><c-n><c-w>k
  tnoremap <M-l> <c-\><c-n><c-w>l
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Window Navigation: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert mode:
inoremap <M-h> <esc><c-w>h
inoremap <M-j> <esc><c-w>j
inoremap <M-k> <esc><c-w>k
inoremap <M-l> <esc><c-w>l
" Visual mode:
vnoremap <M-h> <esc><c-w>h
vnoremap <M-j> <esc><c-w>j
vnoremap <M-k> <esc><c-w>k
vnoremap <M-l> <esc><c-w>l
" Normal mode:
nnoremap <M-h> <c-w>h
nnoremap <M-j> <c-w>j
nnoremap <M-k> <c-w>k
nnoremap <M-l> <c-w>l
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" EasyAlign: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>a<tab> :<c-u>easyalign<space>/
xmap <leader>a<tab> :<c-u>easyalign<space>/
nmap <leader>a      <plug>(easyalign)
xmap <leader>a      <plug>(easyalign)
nmap <leader>e      <plug>(liveeasyalign)
xmap <leader>e      <plug>(liveeasyalign)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Gundo: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>g :<c-u>GundoToggle<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Spelling: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <silent> <leader>s :<c-u>set spell!<cr>
" ^  toggle spell checker
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
