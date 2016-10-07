source $DOTFILES/vim/tmuxline.vim

set colorcolumn=+1
set smartcase
set splitbelow
set splitright
set number
set relativenumber
set ignorecase

autocmd BufNewFile,BufRead *.gsl set filetype=gsl
autocmd BufNewFile,BufRead *.pylintrc set filetype=toml
autocmd BufNewFile,BufRead pylintrc set filetype=toml
autocmd BufNewFile,BufRead *.py set textwidth=79

" Avoid latex to be messed up:
" http://tex.stackexchange.com/questions/96741/vim-latex-suite-unwanted-in-editor-math-symbol-conversion
let g:tex_conceal = ""
