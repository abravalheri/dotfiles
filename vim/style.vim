" Syntax Highlighting
if match($TERM, '256') >=  0
  set t_Co=256
  let g:rehash256=1
  colorscheme molokai
else
  colorscheme ir_black
endif

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has('gui_running')
  syntax on
endif

set laststatus=2
" let g:lightline = { 'colorscheme': 'seoul256', }
