"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" some reference: http://nvie.com/posts/how-i-boosted-my-vim/

" insteado of using Ex mode, use Q for formatting
" the current paragraph or selection
nnoremap Q gqap
vnoremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" toggle auto-indenting for code paste
set pastetoggle=<F6>

" clean search highlight with a space | entering in insert mode:
nnoremap <silent> <space> :nohlsearch<CR>
if has("autocmd")
  " it is not a keybinding but is similar ...
  autocmd InsertEnter * :setlocal nohlsearch
  autocmd InsertLeave * :setlocal hlsearch
endif

" quickly edit/reload the vimrc file
" (from http://nvie.com/posts/how-i-boosted-my-vim/)
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" ç is easier than : (and it is in the same position for ABNT keyboards)
nnoremap ç :
" also exchange ;(less frequent) and :
nnoremap ; :
nnoremap : ;

vnoremap ç :
vnoremap ; :
vnoremap : ;

" unusual sequence, easier than ESC
inoremap jj <ESC>

" avoid anti-patterns
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" NEOSNIPPET:
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
