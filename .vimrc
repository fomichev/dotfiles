" vim-plug {{{1

set nocompatible

"1}}}
" Essentials {{{1

" use utf-8 everywhere
set encoding=utf-8

" show current mode
set showmode

" show partial command
set showcmd

" allow backspacing over everything
set backspace=indent,eol,start

" suppose all files in Unix format (\n only)
set fileformats=unix,dos

" place a $ mark at the end of change
set cpoptions+=$

" don't show relative numbers to current line
set norelativenumber

" enable line numbers
set relativenumber
set number

" always show status line
set laststatus=2

" don't show default mode inficator
set noshowmode

" speedup macros
set lazyredraw

" key word definition
set iskeyword=@,48-57,_

" show the cursor position all the time
set ruler

" set highlighting search mode
set hlsearch

" find the next match as we type
set incsearch

" ":substitute" flag 'g' is default on
set gdefault

" ignore case in search patterns
set ignorecase

" switch off ignorecase when pattern contains upper case chars
set smartcase

" don't force me to save file
set hidden

" don't wait to much for mappings/key codes
set timeout timeoutlen=3000 ttimeoutlen=100

" highlight current line
set cursorline

" don't beep!
set visualbell

" messages tweaks
set shortmess=atToOI

" don't put the first matched word and always show menu
set completeopt=menu,menuone,longest

" don't insert comment when pressing o/O
set formatoptions-=o

" don't place additional spaces on join
set nojoinspaces

" use bash-like completion
set wildmenu
set wildmode=list:longest

" ignore VC files and other
set wildignore+=.git/*,.hg/*,.svn/*

" ignore compiled files
set wildignore+=*.o,*.a,*.class,*.pyc

" ignore OSX shit
set wildignore+=.DS_Store

" other ignores
set wildignore+=*.orig

" show non-ASCII
set isprint=

" don't use swap files
set noswapfile

" searching includes is too slow
set complete-=i
" and tags...
set complete-=t

nnoremap <c-\> :tab split<cr><c-]>

" try to show last line (at least partially)
set display+=lastline

set clipboard=

" cache more lines
let c_minlines=100

" mappings
let mapleader = ","
" use \ instead of , (because , is map leader now)
noremap \ ,

" place all auxiliary files under one directory
if has('win32')
	set runtimepath+=$HOME/.vim
	set directory=$HOME/.vim/tmp
	set backupdir=$HOME/.vim/tmp
else
	set directory=~/.vim/tmp
	set backupdir=~/.vim/tmp
endif

" use homegrown grep wrapper
set grepprg=g\ --vimgrep\ --no-heading\ $*
noremap <Leader>g :Grep<space>
command! -nargs=+ Grep execute 'silent grep <args>' | botright copen | redraw!

" 1}}}
" Vim 7.3 specific {{{1

if version >= 703
	" color 80 column
	set colorcolumn=80

	" use persistent undo
	set undofile
	set undolevels=1000

	" set undo directory
	if has('win32')
		set undodir=$HOME/.vim/tmp
		set undodir=~/.vim/tmp
	endif
endif

" 1}}}
" Color scheme {{{1

set termguicolors

" uncomment on mosh
" https://github.com/mobile-shell/mosh/commit/fa9335f737a057c0b43fe9165dc0ef0f32a5887f
" https://github.com/mobile-shell/mosh/commit/ce7ba37ad4e493769a126db2b39b8a9aa9121278
set notermguicolors

" :help xterm-true-color (for vim inside of tmux)
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

syntax enable

colorscheme desert

" 1}}}
" Mappings {{{1
" Quickfix {{{2

augroup quickfix
	au!
	au BufWinEnter quickfix nnoremap <buffer> q :close<CR>
augroup END

" 2}}}
" Common {{{2

" disable search highlight
nmap <silent> <Leader>/ :silent :nohlsearch<CR>

" toggle list option
nmap <silent> <Leader>l :set nolist!<CR>

" don't show help window when I miss ESC key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" don't jump on * & #
nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>
nnoremap <silent> # :let stay_hash_view = winsaveview()<cr>#:call winrestview(stay_hash_view)<cr>

" use convenient regular expressions
nnoremap / /\v
nnoremap ? ?\v

" use sudo to save file
cmap w!! w !sudo tee % > /dev/null

" open new tab
nnoremap <leader>n :tabnew<CR>

" close current buffer
nnoremap <leader>q :bd<CR>

" save file
nnoremap <leader>s :w<CR>

" execute current file
nnoremap <leader>e :!%:p<CR>

" moving with Up/Down/Left/Right over wrapped lines
nnoremap <Left> gh
nnoremap <Down> gj
nnoremap <Up> gk
nnoremap <Right> gl

" 2}}}
" Windows {{{2

" jump between windows easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

inoremap <C-h> <Esc><C-w>hi
inoremap <C-j> <Esc><C-w>ji
inoremap <C-k> <Esc><C-w>ki
inoremap <C-l> <Esc><C-w>li

" 2}}}
" 1}}}
" Plugins {{{1
" Netrw {{{2

let g:netrw_fastbrowse = 2
let g:netrw_banner = 0
let g:netrw_home = expand($HOME) . '/local/.vim'
let g:netrw_special_syntax = 1
let g:netrw_browse_split = 0

" 2}}}
" 1}}}
