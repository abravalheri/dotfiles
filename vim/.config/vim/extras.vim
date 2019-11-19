" vim: set foldmethod=marker :
scriptencoding utf8  " encoding for this file


" Minor Fixes: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" fix python mode
let g:pymode_python = 'python3'
" let g:pymode_syntax_all = 1
" let g:pymode_rope = 0 " Too much
" let g:pymode_options = 0
"
let g:ale_virtualenv_dir_names = [
  \'.tox/default',
  \'.env',
  \'.venv',
  \'env',
  \'ve-py3',
  \'ve',
  \'virtualenv',
  \'venv'
\]

if has('python3')
  silent! python3 1
endif

if has('autocmd')
  augroup missing_filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.gsl set filetype=gsl
    autocmd BufNewFile,BufRead {*.make,*.mk} set filetype=make
    autocmd BufNewFile,BufRead {*.pylintrc,pylintrc,.coafile} set filetype=cfg
  augroup END

  augroup fix_shiftwidth
    autocmd!
    autocmd FileType python setlocal colorcolumn=79,88,100
    autocmd BufNewFile,BufRead *.rst setlocal shiftwidth=4 tabstop=4 textwidth=79
    autocmd FileType javascript.jsx setlocal shiftwidth=2 tabstop=2 textwidth=79
    autocmd FileType yaml setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2
  augroup END

  augroup fix_word_separators
    autocmd!
    autocmd FileType octave,matlab set iskeyword-=.
    autocmd FileType sh set iskeyword+=$
  augroup END

  if has('nvim')
    augroup start_terminal_on_insert_mode_no_spell
      autocmd!
      autocmd TermOpen term://* setlocal nospell | startinsert
    augroup END
  endif
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Disable Annoying Concealing: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" disable fancy concealing of attribute quotes.
let g:vim_json_syntax_conceal = 0
let g:tex_conceal = ''
let g:markdown_syntax_conceal = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Markdown Code Blocks: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'yaml', 'json', 'ruby', 'xml']
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" Personal Library {{{
function! ProjectRoot()
  return system("(git rev-parse --show-toplevel 2>/dev/null | tr -d '\\n') || echo ''")
endfunction
" }}}

" Fzy Support: {{{
if executable('fzy')
if has('nvim') || has('terminal')
    " nvim doesn't allow system to run interactive programs
    function! FzyCommand(choice_command, vim_command)
      call picker#File(a:choice_command, a:vim_command)
    endfunction
  else
    function! FzyCommand(choice_command, vim_command)
      try
        let l:output = system('echo -n "$('.a:choice_command.' | fzy)"')
      catch /Vim:Interrupt/
        " Swallow errors from ^C, allow redraw! bellow
      endtry
      redraw!
      if v:shell_error == 0 && !empty(l:output)
        echo fnameescape(l:output)
        exec a:vim_command . ' ' . fnameescape(l:output)
      endif
    endfunction
  endif

  if executable('fd')
    function! FindFile(...)
      let l:vim_command = a:0 > 0 ? a:1 : ':e'
      let l:project_root = ProjectRoot()
      if empty(l:project_root)
        let l:flags = ''
      else
        let l:flags = "--exclude '**/.git' --search-path ".l:project_root
      endif
      call FzyCommand("fd -H --type f ".l:flags, l:vim_command)
    endfunction
  endif
endif
" }}}

" Extra Commands: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=* Wrap set wrap linebreak nolist
" ^  linebreak prevents a word for being splitted between 2 lines,
"    but unfortunatelly it do not work with the list option
command! -nargs=* FindFile call FindFile(<f-args>)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}


" Automatic Tasks On Save: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:autoformat_commands = {
  \ 'python': 'black --line-length=LINE_LENGTH %',
  \ 'elixir': 'mix format %',
\ }

let g:autoformat_on_save = 0
let g:autoformat_line_length = 88

function! ExternalFormat(command)
  let l:autoformat_on_save = get(b:, 'autoformat_on_save', g:autoformat_on_save)

  if !l:autoformat_on_save
    return
  endif

  let l:autoformat_line_length = get(b:, 'autoformat_line_length', g:autoformat_line_length)

  let l:command = substitute(a:command, 'LINE_LENGTH', l:autoformat_line_length, 'g')

  if len(l:command) <= 0
    echom 'Attempt to autoformat file "'.expand('%').'", ' .
          \'but no autoformat command is defined. ' .
          \'Please define `b:autoformat_command` or ' .
          \'an entry for "'.&l:filetype.'"(filetype) ' .
          \'in `g:autoformat_commands`.'
    return
  endif

  silent execute('!' . l:command) | edit!
endfunction

function! FormatByFileType()
  let l:default = get(g:autoformat_commands, &l:filetype, '')
  let l:command = get(b:, 'autoformat_command', l:default)
  call ExternalFormat(l:command)
endfunction

" augroup tasks_on_save
"   autocmd!
"   autocmd BufWritePost *.exs,*.ex call s:external_format('!mix format %')
" augroup END

augroup tasks_on_save
  autocmd!
  autocmd BufWritePost *.py call FormatByFileType()
augroup END


" Projectionist: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd User ProjectionistActivate call CustomProjectionistConfig()

function! CustomProjectionistConfig() abort
  for [root, value] in projectionist#query('textwidth')
    let &l:textwidth = value
    let b:autoformat_line_length = value
    break
  endfor
  for [root, value] in projectionist#query('autoformat')
    let b:autoformat_on_save = value
    break
  endfor
endfunction
" }}}
