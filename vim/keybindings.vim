"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" some reference: http://nvie.com/posts/how-i-boosted-my-vim/
scriptencoding utf8

let mapleader="\\"

" instead of using Ex mode, use Q for formatting
" the current paragraph or selection
nnoremap Q gqap
vnoremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <c-u> <c-g>u<c-u>

" toggle auto-indenting for code paste
set pastetoggle=<f6>

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

" but ensure some navigability in command mode
" (Prefer C-f to edit complex command)
cnoremap <left> <left>
cnoremap <right> <right>

" execute macros over selected text
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader Mappings for convenience!
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OBS:
" in mappings instead of writing de pipe character |, <bar> should be used
" <c-u> can be used to clear the command prompt

" quickly edit/reload the vimrc file
" (from http://nvie.com/posts/how-i-boosted-my-vim/)
noremap  <silent> <leader>ev :<c-u>e $MYVIMRC<cr>
noremap  <silent> <leader>ep :<c-u>e $DOTFILES/vim/plugins.vim<cr>
noremap  <silent> <leader>ek :<c-u>e $DOTFILES/vim/keybindings.vim<cr>
noremap  <silent> <leader>ee :<c-u>e $DOTFILES/vim/extras.vim<cr>
noremap  <silent> <leader>sv :<c-u>so $MYVIMRC<cr>
noremap  <silent> <leader>so :<c-u>so %<cr>

" avoid closing the window when working with buffers
" so let pretend <leader> is :
nnoremap <silent> <leader>q  :<c-u>bd<cr>
nnoremap <silent> <leader>w  :<c-u>w<cr>
nnoremap <silent> <leader>ww :<c-u>w<bar>bd<cr>
nnoremap <silent> <leader>wq :<c-u>w<bar>bd<cr>

" cycle through buffers
nnoremap <silent> <leader><space> :<c-u>bn<cr>
nnoremap <silent> <bar><space>    :<c-u>bp<cr>

" local list commands are boring and more difficult
nnoremap <silent> <leader>n  :<c-u>lnext<cr>
nnoremap <silent> <bar>n     :<c-u>lprevious<cr>

" improve vimdiff
nnoremap <silent> <leader>dp V:diffput<cr>
nnoremap <silent> <leader>dg V:diffget<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let CtrlP search everything and use it to navigate the buffer list
let g:ctrlp_cmd = 'CtrlPMixed'
nnoremap <silent> <leader>b :<c-u>CtrlPBuffer<cr>
nnoremap <silent> <bar>f    :<c-u>CtrlPMixed<cr>

" easyalign
nmap ga <plug>(EasyAlign)
xmap ga <plug>(EasyAlign)
nmap ge <plug>(LiveEasyAlign)
xmap ge <plug>(LiveEasyAlign)

" NERDTree
nnoremap <silent> <leader>f :<c-u>NERDTreeToggle<cr>

" Gundo
nnoremap <silent> <leader>g :<c-u>GundoToggle<cr>

" vim-surround
if has('autocmd')
  augroup vim_surroung_erb
    autocmd!
    autocmd FileType ruby,yaml let b:surround_45 = '<% \r %>'
    autocmd FileType ruby,yaml let b:surround_61 = '<%= \r %>'
  augroup END
endif

" incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" snippets
if exists('g:neocomplete')
  imap <c-k> <plug>(neosnippet_expand_or_jump)
  smap <c-k> <plug>(neosnippet_expand_or_jump)
  xmap <c-k> <plug>(neosnippet_expand_target)
else
  imap <c-k> <plug>snipMateNextOrTrigger
  smap <c-k> <plug>snipMateNextOrTrigger
  xmap <c-k> <plug>snipMateNextOrTrigger
endif
