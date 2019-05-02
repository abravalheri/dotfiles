" vim: set foldmethod=marker :
scriptencoding utf8  " encoding for this file

" Theme:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:SetColorScheme()
  " For true color terminals (not the case for urxvt)
  try
    " if $TERM !~ "rxvt" && $TERM =~ '256' && exists('+termguicolors')
    "   let &t_8f = '\<Esc>[38;2;%lu;%lu;%lum'  " Needed in tmux
    "   let &t_8b = '\<Esc>[48;2;%lu;%lu;%lum'  " Ditto
    "   set termguicolors
    " endif

    if &term =~ "xterm"
      " 256 colors
      let &t_Co = 256
      " restore screen after quitting
      let &t_ti = "\<Esc>7\<Esc>[r\<Esc>[?47h"
      let &t_te = "\<Esc>[?47l\<Esc>8"
      if has("terminfo")
        let &t_Sf = "\<Esc>[3%p1%dm"
        let &t_Sb = "\<Esc>[4%p1%dm"
      else
        let &t_Sf = "\<Esc>[3%dm"
        let &t_Sb = "\<Esc>[4%dm"
      endif
    endif

    set t_Co=256
    let g:rehash256=1
    colorscheme railscasts
    hi CursorLine cterm=underline gui=underline
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
