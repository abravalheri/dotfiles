" vim: set foldmethod=marker :
scriptencoding utf8  " encoding for this file

" Theme:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:SetColorScheme()
  try
    set t_Co=256
    let g:rehash256=1
    colorscheme dracula
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

" Make Active Window Obvious:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

" Configure Statusline:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" spiiph's
" jamessan's
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=%=                           " right align
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]\             " file format
set statusline+=%16((%l,%c)%)\               " line and column
set statusline+=%4(%p%{'%'}%)                " percentage of file
