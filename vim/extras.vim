set spell

if has('autocmd')
  augroup missing_filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.gsl set filetype=gsl
    autocmd BufNewFile,BufRead *.make set filetype=make
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
endif

command! -nargs=* Wrap set wrap linebreak nolist

" Linters:
if exists('g:use_syntastic')
  " let g:syntastic_check_on_open = 0 => avoid always checking
  let g:syntastic_vim_checkers = ['vint']
  command! Lint SyntasticCheck
else
  " let g:ale_lint_on_save = 0 => avoid always checking
  let g:ale_set_loclist = 1
  let g:ale_echo_msg_format = '[%severity%:%linter%] %s'
  command! Lint ALELint
endif

" disable fancy concealing of attribute quotes.
let g:vim_json_syntax_conceal = 0

" avoid latex to be messed up:
" http://tex.stackexchange.com/questions/96741/vim-latex-suite-unwanted-in-editor-math-symbol-conversion
let g:tex_conceal = ''
let g:markdown_syntax_conceal = 0

let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'yaml', 'json', 'ruby', 'xml']

if executable('ag')
  " use the silver searcher when available instead of ack
  " (fast: ag > ack > grep)
  let g:ackprg = 'ag --vimgrep'
  cnoreabbrev ag Ack
  cnoreabbrev Ag Ack
  " configure ctrlp to use ag
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
else
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
endif

cnoreabbrev Gitv GV

source $DOTFILES/vim/tmuxline-templates/barebone.vim
