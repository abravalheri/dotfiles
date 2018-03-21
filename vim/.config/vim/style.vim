" vim: set foldmethod=marker :
scriptencoding utf8  " encoding for this file


" Theme:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
  if match($TERM, '256') >= 0 || has('gui_running')
    set t_Co=256
    let g:rehash256=1
    colorscheme molokai
  else
    colorscheme ir_black
  endif
catch
  silent !echo 'colorscheme not found:' . g:colors_name
  colorscheme delek
endtry

" Syntax Highlighting:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &t_Co > 2 || has('gui_running')
  syntax on
endif
