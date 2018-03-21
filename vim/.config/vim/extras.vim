" vim: set foldmethod=marker :
scriptencoding utf8  " encoding for this file


" Minor Fixes: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('autocmd')
  augroup missing_filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.gsl set filetype=gsl
    autocmd BufNewFile,BufRead {*.make,*.mk} set filetype=make
    autocmd BufNewFile,BufRead {*.pylintrc,pylintrc,.coafile} set filetype=cfg
  augroup END

  augroup fix_shiftwidth
    autocmd!
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
    augroup start_terminal_on_insert_mode
      autocmd!
      autocmd TermOpen term://* startinsert
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

" Extra Commands: {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=* Wrap set wrap linebreak nolist
" ^  linebreak prevents a word for being splitted between 2 lines,
"    but unfortunatelly it do not work with the list option
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
