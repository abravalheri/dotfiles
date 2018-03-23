" vim: set foldmethod=marker :
scriptencoding utf8  " encoding for this file


" Theme:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:SetColorScheme()
  try
    set t_Co=256
    let g:rehash256=1
    colorscheme molokai
  catch
    silent !echo 'colorscheme not found:' . g:colors_name
    colorscheme delek
  endtry
endfunction

if match($TERM, '256') >= 0 || has('gui_running') || exists('g:GuiLoaded')
  call g:SetColorScheme()
else
  colorscheme delek
endif

" Syntax Highlighting:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &t_Co > 2 || has('gui_running') || exists('g:GuiLoaded')
  syntax on
endif

" GVIM Font:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gui_running')
  set guifont=Source\ Code\ Pro\ 11
endif
