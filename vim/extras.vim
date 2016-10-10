if has("autocmd")
  autocmd BufNewFile,BufRead *.gsl set filetype=gsl
  autocmd BufNewFile,BufRead {*.pylintrc,pylintrc} set filetype=toml
endif

" Avoid latex to be messed up:
" http://tex.stackexchange.com/questions/96741/vim-latex-suite-unwanted-in-editor-math-symbol-conversion
let g:tex_conceal = ""

source $DOTFILES/vim/tmuxline-templates/barebone.vim
