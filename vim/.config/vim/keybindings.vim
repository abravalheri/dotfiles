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
inoremap <C-u> <C-g>u<C-u>
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

" Open Relative: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cabbr <expr> %% expand('%:p:h')
nnoremap <leader>e :e <C-r>=expand('%:p:h') . '/'<cr>
nnoremap <leader>vs :vs <C-r>=expand('%:p:h') . '/'<cr>
nnoremap <leader>sp :sp <C-r>=expand('%:p:h') . '/'<cr>
if executable('fzy')
  nnoremap <space>e :call FindFile()<cr>
  nnoremap <space>v :call FindFile(':vs')<cr>
  nnoremap <space>s :call FindFile(':sp')<cr>
  nnoremap ,e :call FindFile()<cr>
  nnoremap ,v :call FindFile(':vs')<cr>
  nnoremap ,s :call FindFile(':sp')<cr>
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Search: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" clean search highlight with a backspace | entering in insert mode:
nnoremap <silent> <bs> :nohlsearch<CR>
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
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<cr>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  exec ":'<,'>normal @".nr2char(getchar())
endfunction

nnoremap <silent> ,o   :<C-u>execute "normal! \eo\e"<cr>
nnoremap <silent> ,O   :<C-u>execute "normal! \eO\e"<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


" VIM On The Fly Reconfiguration: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" in mappings instead of writing de pipe character |, <bar> should be used
" <C-u> can be used to clear the command prompt

" quickly edit/reload the vimrc file
" (from http://nvie.com/posts/how-i-boosted-my-vim/)
exec 'nnoremap <silent> <leader>vi :<C-u>e ' . _config_base . '/init.vim<cr>'
exec 'nnoremap <silent> <leader>vc :<C-u>e ' . _config_base . '/config.vim<cr>'
exec 'nnoremap <silent> <leader>vp :<C-u>e ' . _config_base . '/plugins.vim<cr>'
exec 'nnoremap <silent> <leader>vk :<C-u>e ' . _config_base . '/keybindings.vim<cr>'
exec 'nnoremap <silent> <leader>ve :<C-u>e ' . _config_base . '/extras.vim<cr>'
exec 'nnoremap <silent> <leader>vs :<C-u>e ' . _config_base . '/style.vim<cr>'
exec 'nnoremap <silent> <leader>vg :<C-u>e '._config_base.'/ginit.vim<cr>'
nnoremap  <silent> <leader>vr :<C-u>source $MYVIMRC<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Buffer Management: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" avoid closing the window when working with buffers
" so let pretend <leader> is :
nnoremap <silent> <leader>q  :<C-u>bd<cr>
nnoremap <silent> <leader>w  :<C-u>w<cr>
nnoremap <silent> <leader>ww :<C-u>w<bar>bd<cr>
nnoremap <silent> <leader>wq :<C-u>w<bar>bd<cr>

" cycle through buffers
nnoremap <silent> <leader><space> :<C-u>bn<cr>
nnoremap <silent> <bar><space>    :<C-u>bp<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" List Management: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" local list commands are boring and more difficult
nnoremap <silent> <leader>n  :<C-u>lNext<cr>
nnoremap <silent> <bar>n     :<C-u>lprevious<cr>
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
  nnoremap ,t  :<C-u>vsplit <bar> terminal <cr>

  " enter normal mode quicker on terminals
  tnoremap <esc>      <C-\><C-n>
  tnoremap <M-[>      <esc>
  tnoremap <C-v><esc> <esc>

  " simulate insert mode <C-r> in terminal mode
  tnoremap <expr> <C-r>  '<C-\><C-n>"' . nr2char(getchar()) . 'pi'

  " better navigation
  " Terminal mode:
  tnoremap <M-h> <C-\><C-n><C-w>h
  tnoremap <M-j> <C-\><C-n><C-w>j
  tnoremap <M-k> <C-\><C-n><C-w>k
  tnoremap <M-l> <C-\><C-n><C-w>l
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Window Navigation: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert mode:
inoremap <M-h> <esc><C-w>h
inoremap <M-j> <esc><C-w>j
inoremap <M-k> <esc><C-w>k
inoremap <M-l> <esc><C-w>l
" Visual mode:
vnoremap <M-h> <esc><C-w>h
vnoremap <M-j> <esc><C-w>j
vnoremap <M-k> <esc><C-w>k
vnoremap <M-l> <esc><C-w>l
" Normal mode:
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Gundo: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>u :<C-u>GundoToggle<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Magit: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>m :<C-u>tabe <bar> MagitOnly<cr>
nnoremap <silent> ,m :<C-u>Magit<cr>
nnoremap <silent> <leader>M :<C-u>MagitOnly<cr>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Spelling: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <silent> <leader>s :<C-u>set spell!<cr>
" ^  toggle spell checker
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


"""""""""""""""""""""""""""""""""""""""""""
" Extra keybindings in the ginit.vim file "
" (only runs when the GUI is active)      "
"""""""""""""""""""""""""""""""""""""""""""
