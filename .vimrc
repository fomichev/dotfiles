" Pathogen {{{1

filetype off
call pathogen#infect()
filetype plugin indent on

"1}}}
" Essentials {{{1

" don't compatible with vi
set nocompatible

" use utf-8 everywhere
set encoding=utf-8

" show current mode
set showmode

" show partial command
set showcmd

" allow backspacing over everything
set backspace=indent,eol,start

" suppose all files in Unix format (\n only)
set fileformats=unix

" place a $ mark at the end of change
set cpoptions+=$

" don't show relative numbers to current line
set norelativenumber

" enable line numbers
set number

" always show status line
set laststatus=2

" speedup macros
set lazyredraw

" show partial command on the last line
set showcmd

" key word definition
set iskeyword=a-z,A-Z,48-57,_

" show the cursor position all the time
set ruler

" set highlighting search mode
set hlsearch

" find the next match as we type
set incsearch

" don't force me to save file
set hidden

" don't wait to much for mappings/key codes
set timeout timeoutlen=3000 ttimeoutlen=100

" highlight current line
set cursorline

" always use 8-color (actually 8 + 8) terminal mode
set t_Co=8

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

" cache more lines
let c_minlines=100

" mappings
let mapleader = ","

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
set listchars=tab:→·,trail:·

" enable spell check
set spelllang=en_us
set spell

" make russian keys work in normal mode
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

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

"1}}}
" Color scheme {{{1

" enable syntax coloring
set background=dark
let g:solarized_termcolors = 8
let g:solarized_termtrans = 1
colorscheme solarized
syntax on

" 1}}}
" Mappings {{{1
" Common {{{2

" disable search highlight
nmap <silent> <Leader>n :silent :nohlsearch<CR>

" toggle list option
nmap <silent> <Leader>l :set nolist!<CR>

" don't show help window when I miss ESC key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" don't jump on * & #
nnoremap * *<c-o>
nnoremap # #<c-o>

" use sudo to save file
cmap w!! w !sudo tee % > /dev/null

" 2}}}
" Windows {{{2

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-v> <C-w>v
nnoremap <C-s> <C-w>s

" 2}}}
" Tags {{{2

map <Leader>tp :call UpdateTags()<CR>
map <Leader>tl :call UpdateLinuxTags('')<CR>
map <Leader>ts :call UpdateSystemTags('')<CR>

" 2}}}
" Folding {{{2

nnoremap <Space> za
vnoremap <Space> za

" 2}}}
" Spaces {{{2

function! ShowSpaces()
	let @/='\v(\s+$)|( +\ze\t)'
endfunction

function! TrimSpaces()
	let l:winview = winsaveview()
	silent! %s/\s\+$//
	call winrestview(l:winview)
endfunction

" show trailing spaces
noremap <silent> <Leader>ss :call ShowSpaces()<CR>

" remove trailing spaces
noremap <silent> <Leader>sr :call TrimSpaces()<CR>

" 2}}}
" 1}}}
" Plugins {{{1
" Ack {{{2

noremap <Leader>g :Ack!<space>

" 2}}}
" Clang complete {{{2

let g:clang_complete_copen = 1
let g:clang_snippets = 1
let g:clang_complete_auto = 0

noremap <silent> <Leader>c :call g:ClangUpdateQuickFix()<CR>
inoremap <silent> <S-Tab> <C-x><C-o>

" 2}}}
" Ctrl-p {{{2

" start with clean prompt each time
let g:ctrlp_persistent_input = 0
" don't search by full path
let g:ctrlp_by_filename = 1
" don't keep MRU files
let g:ctrlp_mru_files = 0
" don't manage working directory
let g:ctrlp_working_path_mode = 0
" don't search for dotfiles
let g:ctrlp_dotfiles = 0
" don't split when open
let g:ctrlp_split_window = 0
let g:ctrlp_open_new_file = 0
" let ctrl-p replace netrw buffer
let g:ctrlp_dont_split = 'netrw'
" use ,f to invoke
let g:ctrlp_map = '<Leader>,'

" 2}}}
" Tagbar {{{2

nnoremap <silent> <Leader>b :TagbarToggle<CR>

" 2}}}
" Alternative (header/source) {{{2

nnoremap <silent> <Leader>a :A<CR>

" 2}}}
" Netrw {{{2

" netrw
let g:netrw_fastbrowse=2
let g:netrw_banner=0
let g:netrw_home=expand($HOME) . '/local/.vim'
let g:netrw_special_syntax=1
let g:netrw_browse_split=0

" 2}}}
" Matchit {{{2

" load matchit
runtime macros/matchit.vim

" 2}}}
" 1}}}
" Filetypes {{{1
" C {{{2

let c_space_errors=1
let c_curly_error=1
let c_bracket_error=1
let c_gnu=1

augroup ft_c
	au!

	au FileType c let g:clang_auto_user_options = 'path, .clang_complete'

	au FileType c setlocal foldmethod=syntax
	au FileType c setlocal cindent

	au FileType c setlocal shiftwidth=8
	au FileType c setlocal softtabstop=8
	au FileType c setlocal tabstop=8
	au FileType c setlocal noexpandtab
	au FileType c setlocal cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,gs,hs,ps,t0,is,+s,c3,C0,(0
augroup END

" 2}}}
" Objective-C {{{2

augroup ft_objc
	au!

	au FileType objc let g:clang_auto_user_options = '.clang_complete'

	au FileType objc setlocal foldmethod=syntax
	au FileType objc setlocal cindent

	au FileType objc setlocal shiftwidth=2
	au FileType objc setlocal softtabstop=2
	au FileType objc setlocal tabstop=2
	au FileType objc setlocal expandtab
	au FileType objc setlocal cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,gs,hs,ps,t0,is,+s,c3,C0,(0
	au FileType objc setlocal makeprg=xcodebuild\ -sdk\ iphonesimulator5.0
augroup END

" 2}}}
" Vim {{{2

augroup ft_vim
	au!

	au FileType vim setlocal foldmethod=marker
	au FileType vim setlocal autoindent

	au FileType vim setlocal shiftwidth=4
	au FileType vim setlocal softtabstop=4
	au FileType vim setlocal tabstop=4
	au FileType vim setlocal noexpandtab
augroup END

" 2}}}
" XML {{{2

augroup ft_xml
	au!

	au FileType xml setlocal autoindent

	au FileType xml setlocal shiftwidth=4
	au FileType xml setlocal softtabstop=4
	au FileType xml setlocal tabstop=4
	au FileType xml setlocal noexpandtab
augroup END

" 2}}}
" Python {{{2

augroup ft_python
	au!

	au FileType py setlocal autoindent

	au FileType py setlocal shiftwidth=4
	au FileType py setlocal softtabstop=4
	au FileType py setlocal tabstop=4
	au FileType py setlocal expandtab
augroup END

" 2}}}
" Java {{{2

augroup ft_java
	au!

	au FileType java setlocal autoindent

	au FileType java setlocal shiftwidth=4
	au FileType java setlocal softtabstop=4
	au FileType java setlocal tabstop=4
	au FileType java setlocal expandtab
augroup END

" 2}}}
" Text files {{{2

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" 2}}}
" Mutt {{{2

augroup ft_mutt
	autocmd BufRead,BufNewFile *mutt-* setfiletype mail
augroup END

" 2}}}
" 1}}}
" Ctags {{{1

" update tags in the current directory and add them to the tags
" variable
function! UpdateTags()
	let l:path = fnamemodify(".",":ph")

	let l:ctags_opts='--format=2 --excmd=pattern --fields=+iaS --extra=+q'

	exec system('ctags -R -f ' . l:path . 'tags ' . l:ctags_opts . ' ' . l:path)

	let l:tags_path = l:path . 'tags'

	set tags+=l:tags_path
endfunction

function! UpdateCustomTags(path)
	let l:path = a:path . '/'
	let l:ctags_opts='--format=2 --excmd=pattern --fields=+iaS --extra=+q'

	exec system('ctags --exclude=build_linux -R -f ' . l:path . 'tags ' . l:ctags_opts . ' ' . l:path)
endfunction

function! UpdateSystemTags(path)
	if a:path == ''
		let l:path='/usr/include/'
	else
		let l:path = a:path . '/'
	endif

	let l:ctags_opts='--format=2 --excmd=pattern --fields=+iaS --extra=+q'

	exec system('ctags -R -f $HOME/.vim/tmp/system_tags ' . l:ctags_opts . ' ' . l:path)
endfunction

function! UpdateLinuxTags(path)
	if a:path == ''
		let l:path = fnamemodify(".",":ph")
	else
		let l:path = a:path . '/'
	endif

	let l:ctags_opts =
				\ '-I __initdata,__exitdata,__acquires,__releases ' .
				\ '-I __read_mostly,____cacheline_aligned ' .
				\ '-I ____cacheline_aligned_in_smp ' .
				\ '-I ____cacheline_internodealigned_in_smp ' .
				\ '-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL ' .
				\ '-I EXPORT_TRACEPOINT_SYMBOL_GPL ' .
				\ '-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL ' .
				\ '--regex-asm=''/^ENTRY\(([^)]*)\).*/\1/'' ' .
				\ '--regex-c=''/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'' ' .
				\ '--regex-c++=''/^TRACE_EVENT\(([^,)]*).*/trace_\1/'' ' .
				\ '--regex-c++=''/^DEFINE_EVENT\(([^,)]*).*/trace_\1/'' ' .
				\ '--c-kinds=-m+px --format=2 --extra=+q ' .
				\ '--excmd=pattern --fields=+S'

	let l:path_dirs =
				\ l:path . 'arch/x86 ' .
				\ l:path . 'block ' .
				\ l:path . 'crypto ' .
				\ l:path . 'fs ' .
				\ l:path . 'include ' .
				\ l:path . 'init ' .
				\ l:path . 'ipc ' .
				\ l:path . 'kernel ' .
				\ l:path . 'lib ' .
				\ l:path . 'mm ' .
				\ l:path . 'net ' .
				\ l:path . 'security ' .
				\ l:path . 'virt'

	exec system('ctags -R -f $HOME/.vim/tmp/linux_tags ' . l:ctags_opts . ' ' . l:path_dirs)
endfunction

set tags+=$HOME/.vim/tmp/system_tags
set tags+=$HOME/.vim/tmp/linux_tags

" 1}}}
" Auxiliary functions {{{1

" change word under cursor in each buffer
function! BufChange()
	let from=expand("<cword>")

	let to=input("Change " . from . " in all buffers to: ")

	if strlen(to) > 0
		exe "bufdo! %s/\\<" . from . "\\>/" . to . "/g | update"
	endif
endfunction

" 1}}}
" Local configuration {{{1

" execute local configuration
if filereadable(expand($HOME) . '/local/.vimrc')
	source $HOME/local/.vimrc
endif

" 1}}}
" GNU Screen {{{1

" using PuTTY with GNU Screen makes Vim crazy
if &term == "screen"
	set term=xterm
endif

"1}}}
