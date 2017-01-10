" Syntax Highlighting
try
  if match($TERM, '256') >= 0 || has('gui_running')
    set t_Co=256
    let g:rehash256=1
    colorscheme molokai
  else
    colorscheme ir_black
  endif
catch
  silent !echo 'colorscheme not found'
endtry

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has('gui_running')
  syntax on
endif

set laststatus=2
" let g:lightline = { 'colorscheme': 'seoul256', }
