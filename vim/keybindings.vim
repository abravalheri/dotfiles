"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" toggle auto-indenting for code paste
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" clean search highlight with an enter:
nnoremap <space> :nohlsearch<CR>

" ç is easier than : (and it is in the same position for ABNT keyboards)
nnoremap ç :

" unusual sequence, easier than ESC
inoremap jj <ESC>
