if has("autocmd")
  autocmd BufNewFile,BufRead *.gsl set filetype=gsl
  autocmd BufNewFile,BufRead {*.pylintrc,pylintrc} set filetype=toml
endif

" hide markers from snippets (neosnippet)
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" avoid latex to be messed up:
" http://tex.stackexchange.com/questions/96741/vim-latex-suite-unwanted-in-editor-math-symbol-conversion
let g:tex_conceal = ""
let g:markdown_syntax_conceal = 0

source $DOTFILES/vim/tmuxline-templates/barebone.vim
