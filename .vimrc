" config from source $VIMRUNTIME/defaults.vim, without mouse

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start
set history=200		" keep 200 lines of command line history
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5


" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when Vim was compiled with the +eval feature.
if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

set number
set relativenumber
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4

syntax on
set background=dark
set hls

highlight OverLength ctermbg=darkred ctermfg=white guibg=#592929
match OverLength /\%>120v.\+/

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if has('syntax') && has('eval')
    packadd! matchit
endif

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
