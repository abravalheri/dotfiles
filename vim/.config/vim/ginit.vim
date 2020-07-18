" Auxiliary Functions:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! GetGuiDistribution()
  if exists('g:GtkGuiLoaded')
    return 'nvim-gtk'
  elseif exists('g:GuiLoaded')
    return 'nvim-qt'
  elseif exists('g:fvim_loaded')
    return 'fvim'
  end

  return get(g:, 'default_gui_distribution', 'gvim')
endfunction

if exists('*trim')
  let s:Trim = function('trim')
else
  function! s:Trim(input_string, ...)
      let s:mask = a:0 > 0 ? a:1 : '\s'
      let s:mask = '\['.s:mask.'\]'
      let s:regex = '^'.s:mask.'*\(.\{-}\)'.s:mask.'*$'
      return substitute(a:input_string, s:regex, '\1', '')
  endfunction
end

function!  s:ensure_know_distribution()
  let distribution = GetGuiDistribution()

  if ! has_key(g:font_manipulation, distribution)
    throw 'Impossible to configure GUI, unknown distribution: `' .
          \ GetGuiDistribution() ."`.\n" .
          \ 'Please to configure `g:font_manipulation`.'
  end
  return distribution
endfunction

" NVIM GTK:
let s:nvim_gtk_font = []
function! s:nvim_gtk_get_font()
  " TODO: actually implement this by calling the RPC
  return get(s:, 'nvim_gtk_font', g:default_font['nvim-gtk'])
endfunction

function! s:nvim_gtk_set_font(name, size)
  let s:nvim_gtk_font = [a:name, a:size]
  call rpcnotify(1, 'Gui', 'Font', a:name.' '.a:size)
endfunction

" NVIM Qt:
function! s:nvim_qt_get_font()
  let font = s:Trim(execute('GuiFont'))
  let font = split(font, ':h')
  let name = font[0]
  let size = s:Trim(font[1], ':hsb')
  return [name, size]
endfunction

function! s:nvim_qt_set_font(name, size)
  execute('GuiFont! '.a:name.':h'.a:size)
endfunction

" FVIM:
function! s:fvim_get_font()
  let font = split(&guifont, ':h')
  let name = font[0]
  let size = s:Trim(font[1], ':hsb')
  return [name, size]
endfunction

function! s:fvim_set_font(name, size)
  let &guifont = a:name.':h'.a:size
endfunction

" GVIM:
function! s:gvim_get_font()
  let font = split(&guifont, ' ')
  let name = join(font[0:-2], ' ')
  let size = s:Trim(font[-1], ':hsb')
  return [name, size]
endfunction

function! s:gvim_set_font(name, size)
  let &guifont = a:name.' '.a:size
endfunction

" General:
function! GetFont()
  let distribution = s:ensure_know_distribution()
  let l:Getter = get(g:font_manipulation, distribution)[0]
  return l:Getter()
endfunction

function! SetFont(name, ...)
  let distribution = s:ensure_know_distribution()
  let l:Setter = get(g:font_manipulation, distribution)[1]
  if a:0 > 0
    let size = a:1
  else
    let size = GetFont()[1]
  endif
  return l:Setter(a:name, size)
endfunction

function! IncreaseFont(...)
  let increment = a:0 > 0 ?
      \ a:1 : get(b:, 'font_increment', g:font_increment)
  let font = GetFont()
  let name = font[0]
  let size = font[1]
  return SetFont(name, size + increment)
endfunction

function! DecreaseFont(...)
  let increment = a:0 > 0 ?
      \ a:1 : get(b:, 'font_increment', g:font_increment)
  let font = GetFont()
  let name = font[0]
  let size = font[1]
  echom 'Size: '.size.' . Diff '.(size-increment)
  return SetFont(name, size - increment)
endfunction

function! DefaultFont()
  let distribution = s:ensure_know_distribution()
  let font = get(g:default_font, distribution)
  return call('SetFont', font)
endfunction

function! FontSize(size)
  let font = GetFont()
  let name = font[0]
  return SetFont(name, a:size)
endfunction


" Meta Configuration:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:source_pro = 'Source Code Pro'
let s:fira = 'Fira Code'
let s:cascadia = 'CaskaydiaCove NF'
let s:iosevka = 'Iosevka Term'
let s:fantasque = 'Fantasque Sans Mono'

let g:fallback_font = [s:source_pro, 12]
let g:default_font = {
  \'nvim-qt':  [s:cascadia, 11],
  \'nvim-gtk': [s:source_pro, 12],
  \'fvim':     [s:fira, 15],
  \'gvim':     [s:fira, 12],
\ }
let g:font_manipulation = {
  \'nvim-qt':  [function('s:nvim_qt_get_font'), function('s:nvim_qt_set_font')],
  \'nvim-gtk': [function('s:nvim_gtk_get_font'), function('s:nvim_gtk_set_font')],
  \'fvim':     [function('s:fvim_get_font'), function('s:fvim_set_font')],
  \'gvim':     [function('s:gvim_get_font'), function('s:gvim_set_font')],
\ }
let g:font_increment = 1


" Configurations:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('g:SetColorScheme')
  call g:SetColorScheme()
end

let g:gui_distribution = GetGuiDistribution()

if g:gui_distribution ==? 'gvim'
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
end

if g:gui_distribution ==? 'fvim'
    FVimFontNoBuiltinSymbols v:true
endif

call DefaultFont()


" Key Bindings:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reload:
exec 'nnoremap <silent> <leader>vR :<C-u>source '._config_base.'/ginit.vim<cr>'

" Font Size:
nnoremap <silent> <leader>+ :<c-u>call IncreaseFont()<cr>
nnoremap <silent> <leader>- :<c-u>call DecreaseFont()<cr>
nnoremap <silent> <leader>= :<c-u>call DefaultFont()<cr>

command! Fira call SetFont(s:fira)
command! Cascadia call SetFont(s:cascadia)
command! Iosevka call SetFont(s:iosevka)
command! Fantasque call SetFont(s:fantasque)
