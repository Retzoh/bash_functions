set number
set relativenumber
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4

syntax on
set background=dark
set hls

highlight OverLength ctermbg=darkred ctermfg=white guibg=#592929
match OverLength /\%>120v.\+/

" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
" source : https://github.com/pehota/dotfiles/blob/vim-elm/vimrc
call plug#begin('~/.vim/plugged')

" == General
" source: https://www.vimfromscratch.com/articles/vim-for-python/
Plug 'preservim/nerdtree'
map <C-n> :NERDTreeToggle<CR>

Plug 'chrisbra/vim-commentary'

" == elm
Plug 'andys8/vim-elm-syntax'
let g:elm_format_autosave = 1

Plug 'antew/vim-elm-language-server'

" == Python
" Plug 'Valloric/YouCompleteMe'
" doc : https://github.com/ycm-core/YouCompleteMe/wiki/Full-Installation-Guide
Plug 'ycm-core/YouCompleteMe'

" == Ale
" Enable completion where available.
" This setting must be set before ALE is loaded.
let g:ale_completion_enabled = 1

Plug 'w0rp/ale'

let g:ale_linters = {
\   'python': ['pylint'],
\   'elm': ['elm_ls'],
\   'sh': ['shellcheck'],
\}

let g:ale_python_pylint_options = '--disable=C0114,C0115,C0116,C0301,C0330'

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'css': ['prettier'],
\   'python': ['isort', 'black'],
\   'elm': ['elm-format'],
\   'html': ['prettier'],
\}

" Do not lint or fix minified files.
let g:ale_pattern_options = {
\ '\.min\.*$': {'ale_linters': [], 'ale_fixers': []},
\}
"

let g:ale_elm_ls_use_global = 1
let g:ale_elm_ls_executable = "/home/visiteur/environments/taskbot/node_modules/.bin/elm-language-server"
let g:ale_elm_ls_elm_analyse_trigger = 'change'
let g:ale_elm_ls_elm_path = "/home/visiteur/environments/taskbot/node_modules/elm/bin/elm"
let g:ale_elm_ls_elm_format_path = "/home/visiteur/environments/taskbot/node_modules/elm/bin/elm"
let g:ale_elm_ls_elm_test_path = "/home/visiteur/environments/taskbot/node_modules/elm/bin/elm"

let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1

" Initialize plugin system
call plug#end()

" == General
nmap <F10> :ALEFix<CR>
let mapleader = ","
nnoremap <silent> <leader><space> :nohlsearch<CR>
nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l

" == elm
autocmd FileType elm nnoremap <leader>r :ALERename<CR>
autocmd FileType elm nnoremap <silent> <leader>e :ALENext<CR>
autocmd FileType elm nnoremap <silent> <leader>E :ALEPrevious<CR>
autocmd FileType elm nnoremap <silent> <leader>d :ALEGoToDefinition<CR>
autocmd FileType elm nnoremap <silent> <leader>t :ALEGoToTypeDefinition<CR>
autocmd FileType elm nnoremap <silent> <leader>h :ALEHover<CR>
autocmd FileType elm nnoremap <silent> <leader>f :ALEFindReferences<CR>
autocmd FileType elm nnoremap <silent> <leader>D :ALEDetail<CR>

" == Python
autocmd Filetype python setlocal tabstop=4
autocmd FileType python nnoremap <silent> <leader>D :ALEDetail<CR>
autocmd FileType python nnoremap <silent> <leader>e :ALENext<CR>
autocmd FileType python nnoremap <silent> <leader>E :ALEPrevious<CR>
autocmd Filetype python nnoremap <silent> <leader>g :YcmCompleter GoTo<CR>
autocmd Filetype python nnoremap <silent> <leader>r :YcmCompleter GoToReferences<CR>
" autocmd Filetype python nnoremap <silent> <leader>t :YcmCompleter GetType<CR>
autocmd Filetype python nnoremap <silent> <leader>d :YcmCompleter GetDoc<CR>
" let g:pymode_rope = 0
" let g:pymode_folding = 0


" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
