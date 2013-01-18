" Pathogen {{{1

set nocompatible
filetype off
call pathogen#infect()
filetype plugin indent on

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
set number

" always show status line
set laststatus=2

" customize status line
set statusline=%<%m\ %f\ [%{&fileformat}]\ %r%=%b\ \ %c:%l/%L\ %P

" speedup macros
set lazyredraw

" show partial command on the last line
set showcmd

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

" start with all folds closed
set foldlevelstart=0

" support only root fold for syntax
set foldnestmax=1

" don't use swap files
set noswapfile

" searching includes is too slow
set complete -= i

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

" show tabs and trailing spaces
set list
set listchars=tab:¦\ ,trail:·

" enable spell check
set spelllang=en_us,ru
set spellfile=$HOME/.vim/spell/all.add
set spell

" make russian keys work in normal mode
set keymap=russian-jcukenwin
set imsearch=0
set iminsert=0

" use homegrown grep wrapper
set grepprg=g\ $*
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
	else
		set undodir=~/.vim/tmp
	endif
endif

" 1}}}
" Color scheme {{{1
" GNU Screen / Tmux {{{2

if &term == "screen"
	set term=xterm
	" problem with PuTTY
	let g:solarized_termtrans = 1
endif

" 2}}}
" Solarized settings {{{2

let g:solarized_underline = 0
let g:solarized_bold = 1
let g:solarized_italic = 1

" 2}}}

syntax enable
set t_Co=16
set background=dark
colorscheme solarized

" Color scheme enhancements {{{2

" highlight trailing white spaces
match ErrorMsg /\s\+$\| \+\ze\t/

" don't highlight tabs/spaces background
highlight SpecialKey cterm=NONE gui=NONE ctermbg=NONE ctermfg=11 guibg=NONE guifg=#586e75

" 2}}}
" 1}}}
" Folding {{{1

function! MyFoldText()
	let line = getline(v:foldstart)

	let nucolwidth = &fdc + &number * &numberwidth
	let windowwidth = winwidth(0) - nucolwidth - 2
	let foldedlinecount = v:foldend - v:foldstart

	" expand tabs into spaces
	let onetab = strpart('          ', 0, &tabstop)
	let line = substitute(line, '\t', onetab, 'g')

	let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
	let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
	return line . ' ' . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction

set foldtext=MyFoldText()

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
nnoremap * /\C\<<C-r><C-w>\><CR>N
nnoremap # ?\C\<<C-r><C-w>\><CR>N

" use convenient regular expressions
nnoremap / /\v
nnoremap ? /\v

" use sudo to save file
cmap w!! w !sudo tee % > /dev/null

" 2}}}
" Windows {{{2

" jump between windows easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 2}}}
" Tabs {{{2

map <Leader>1 1gt
map <Leader>2 2gt
map <Leader>3 3gt
map <Leader>4 4gt
map <Leader>5 5gt
map <Leader>6 6gt
map <Leader>7 7gt
map <Leader>8 8gt
map <Leader>9 9gt

" 2}}}
" Folding {{{2

" use space to open/close folds
nnoremap <Space> za
vnoremap <Space> za

" make zO work no matter where the cursor is
nnoremap zO zCzO

" 2}}}
" 1}}}
" Plugins {{{1
" Clang complete {{{2

let g:clang_complete_copen = 1
let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'
let g:clang_complete_auto = 0
let g:clang_use_library = 0

noremap <silent> <Leader>c :call g:ClangUpdateQuickFix()<CR>
inoremap <silent> <S-Tab> <C-x><C-o>

" 2}}}
" Ctrl-p {{{2

" search by full path
let g:ctrlp_by_filename = 0
" don't manage working directory
let g:ctrlp_working_path_mode = 0
" don't search for dotfiles
let g:ctrlp_dotfiles = 0
" open new file in current window
let g:ctrlp_open_new_file = 'r'
" let ctrl-p replace netrw buffer
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'
" use ,, to invoke
let g:ctrlp_map = '<Leader>,'
" store cache along with other temporary files
let g:ctrlp_cache_dir = $HOME.'/.vim/tmp/ctrlp'
" only jump to the buffer if it's opened in the current tab
let g:ctrlp_switch_buffer = 1

nnoremap <leader>. :CtrlPMRUFiles<cr>

" 2}}}
" Alternative (header/source) {{{2

nnoremap <silent> <Leader>a :A<CR>

" 2}}}
" Netrw {{{2

let g:netrw_fastbrowse = 2
let g:netrw_banner = 0
let g:netrw_home = expand($HOME) . '/local/.vim'
let g:netrw_special_syntax = 1
let g:netrw_browse_split = 0

" 2}}}
" Matchit {{{2

runtime macros/matchit.vim

" 2}}}
" Fakeclip {{{2

let g:fakeclip_terminal_multiplexer_type = "tmux"

" 2}}}
" DirDiff {{{2

let g:DirDiffExcludes = ".hg,.git,*.o,*.a"

" 2}}}
" Gitv {{{2

let g:Gitv_DoNotMapCtrlKey = 1

" 2}}}
" 1}}}
" Associations {{{1

autocmd BufRead,BufNewFile *mutt-* setfiletype mail
autocmd BufRead,BufNewFile *.md setlocal filetype=markdown
autocmd BufRead,BufNewFile */notes/* setlocal filetype=markdown
autocmd BufRead,BufNewFile *.cls setlocal filetype=tex

" 1}}}
" Local configuration {{{1

" execute local configuration
if filereadable(expand($HOME) . '/local/.vimrc')
	source $HOME/local/.vimrc
endif

" 1}}}
