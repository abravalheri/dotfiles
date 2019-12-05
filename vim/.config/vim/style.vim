" vim: set foldmethod=marker :
scriptencoding utf8  " encoding for this file

let g:gui_colorscheme = 'monokai-phoenix'
let g:tui_colorscheme = 'ir_black'
let g:fallback_scheme = 'delek'

" Theme:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:GetColorSchemes()
  " Returns the list of available color schemes

   return uniq(sort(map(
   \  globpath(&runtimepath, 'colors/*.vim', 0, 1),
   \  'fnamemodify(v:val, ":t:r")'
   \)))
endfunction

function! SetColorScheme(...)
  " Try to set a colorscheme to work nicely

  let gui_scheme = a:0 > 0 ? a:1 : g:gui_colorscheme
  let tui_scheme = a:0 > 0 ? a:1 : g:tui_colorscheme
  let fallback_scheme = a:0 > 1 ? a:1 : g:fallback_scheme

  let support_colors = (match($TERM, '256') >= 0 || has('gui_running') || exists('g:GuiLoaded'))

  if !support_colors
    execute('colorscheme '.fallback_scheme)
    return
  end

  let available = GetColorSchemes()

  if index(available, tui_scheme) < 0
    let tui_scheme = fallback_scheme
  end

  if index(available, gui_scheme) < 0
    silent !echom 'Colorscheme `' . scheme . '` not installed.'
    let gui_scheme = tui_scheme
  end

  " For true color terminals (not the case for urxvt)
  try
    " if $TERM !~ "rxvt" && $TERM =~ '256' && exists('+termguicolors')
    "   let &t_8f = '\<Esc>[38;2;%lu;%lu;%lum'  " Needed in tmux
    "   let &t_8b = '\<Esc>[48;2;%lu;%lu;%lum'  " Ditto
    "   set termguicolors
    " endif

    if &term =~? 'xterm'
      " 256 colors
      let &t_Co = 256
      " restore screen after quitting
      let &t_ti = "\<Esc>7\<Esc>[r\<Esc>[?47h"
      let &t_te = "\<Esc>[?47l\<Esc>8"
      if has('terminfo')
        let &t_Sf = "\<Esc>[3%p1%dm"
        let &t_Sb = "\<Esc>[4%p1%dm"
      else
        let &t_Sf = "\<Esc>[3%dm"
        let &t_Sb = "\<Esc>[4%dm"
      endif
    endif

    set t_Co=256
    let g:rehash256=1
    execute('colorscheme '.gui_scheme)
    hi CursorLine cterm=underline gui=underline
  catch
    silent !echom 'Something went wrong defining colorscheme: `' . g:colorscheme . '`'
    execute('colorscheme '.fallback_scheme)
  endtry
endfunction

call SetColorScheme()

" Syntax Highlighting:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &t_Co > 2 || has('gui_running') || exists('g:GuiLoaded')
  syntax on
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
