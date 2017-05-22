set spell

if has('autocmd')
  augroup missing_filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.gsl set filetype=gsl
    autocmd BufNewFile,BufRead {*.pylintrc,pylintrc,.coafile} set filetype=toml
  augroup END

  augroup fix_shiftwidth
    autocmd!
    autocmd BufNewFile,BufRead *.rst setlocal shiftwidth=4 tabstop=4 textwidth=79 colorcolumn=+1
    autocmd FileType javascript.jsx setlocal shiftwidth=2 tabstop=2 textwidth=79 colorcolumn=+1
  augroup END

  augroup fix_word_separators
    autocmd!
    autocmd FileType octave,matlab set iskeyword-=.
    autocmd FileType sh set iskeyword+=$
  augroup END
endif

" Lintes:
if exists('g:use_syntastic')
  " let g:syntastic_check_on_open = 0 => avoid always checking
  let g:syntastic_vim_checkers = ['vint']
  command! Lint SyntasticCheck
else
  " let g:ale_lint_on_save = 0 => avoid always checking
  let g:ale_set_loclist = 1
  command! Lint ALELint
endif

" Disable fancy concealing of attribute quotes.
let g:vim_json_syntax_conceal = 0

" avoid latex to be messed up:
" http://tex.stackexchange.com/questions/96741/vim-latex-suite-unwanted-in-editor-math-symbol-conversion
let g:tex_conceal = ''
let g:markdown_syntax_conceal = 0

let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'yaml', 'json', 'ruby', 'xml']

source $DOTFILES/vim/tmuxline-templates/barebone.vim
