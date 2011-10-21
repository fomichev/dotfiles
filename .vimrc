" don't compatible with vi
set nocompatible

" use utf-8 everywhere
set encoding=utf-8

" allow backspacing over everything
set backspace=indent,eol,start

" suppose all files in Unix format (\n only)
set fileformats=unix

" 1, 2, 3, 4, etc
"set foldcolumn=1
"set foldmethod=syntax

" place a $ mark at the end of change
set cpoptions+=$

" enable line numbers
set number

" speedup macros
set nolazyredraw

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

if has('win32')
	set runtimepath+=$HOME/.vim
	set directory=$HOME/.vim/tmp
	set backupdir=$HOME/.vim/tmp

	if has('gui_running')
		set guifont=Lucida_Console:h10
	endif
else
	set directory=~/.vim/tmp
	set backupdir=~/.vim/tmp

	if has('gui_running')
"		set guifont=DejaVuSansMono
		set guifont=Monofur\ 13
	endif
endif

if has('gui_running')
	" remove toolbar
	set guioptions-=T
	" remove menubar
	set guioptions-=m
	" use text tabs
	set guioptions-=e
	" remove right scrollbar
	set guioptions-=r
	set guioptions-=R
	" remove left scrollbar
	set guioptions-=l
	set guioptions-=L
	" remove bottom scrollbar
	set guioptions-=b
	set guioptions-=h
	" use console dialogs
	set guioptions+=c
endif

" show tabs and trailing spaces
if has('multi_byte')
	set list
	set listchars=tab:»·,trail:·
"	set listchars=tab:»~,trail:·,eol:¶
endif

if has('spell')
	" enable spell check
	set spelllang=en_us
	set spell
endif

if has('langmap')
	" make russian keys work in normal mode
	set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
endif

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

if has('autocmd')
	" pathogen
	filetype off
	call pathogen#infect()

	if has('syntax')
		" enable syntax coloring
		set background=dark
		colorscheme solarized
		syntax on
	endif

	" show non-ASCII
	set isprint=

	" cache more lines
	let c_minlines=100

	" enable filetype & indent plugins
	filetype plugin indent on

	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

	" mutt's mails
	augroup filetypedetect
	autocmd BufRead,BufNewFile *mutt-* setfiletype mail
	augroup END

	source $HOME/.vim/tags.vim
	source $HOME/.vim/indent.vim

	" mappings
	let mapleader = ","

	" exit normal mode with jj
	inoremap jj <ESC>

	" switching between tabs and buffers
	nnoremap <silent> <C-k> :bprev<CR>
	nnoremap <silent> <C-j> :bnext<CR>

	" don't show help window when I miss ESC key
	inoremap <F1> <ESC>
	nnoremap <F1> <ESC>
	vnoremap <F1> <ESC>

	" tags related
	map <F2> :call UpdateTags()<CR>
	map <F3> :call UpdateLinuxTags('')<CR>
	map <F4> :call UpdateSystemTags('')<CR>

	" netrw
	let g:netrw_fastbrowse=2
	let g:netrw_banner=0
	let g:netrw_home=expand($HOME) . '/local/.vim'
	let g:netrw_special_syntax=1

	" alternative
	nnoremap <silent> <Leader>a :A<CR>

	" tagbar
	nnoremap <silent> <Leader>t :TagbarToggle<CR>

	" ctrl-p

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
	" ignore VC files and other
	set wildignore+=.git/*,.hg/*,.svn/*,*.o,*.a,*.class

	function! ShowSpaces()
		let @/='\v(\s+$)|( +\ze\t)'
	endfunction

	function! TrimSpaces()
	    let l:winview = winsaveview()
	    silent! %s/\s\+$//
	    call winrestview(l:winview)
	endfunction

	" automatically remove trailing spaces
	"autocmd BufWritePre  * call TrimSpaces()

	" show trailing spaces
	noremap <silent> <Leader>s :call ShowSpaces()<CR>

	" remove trailing spaces
	noremap <silent> <Leader>r :call TrimSpaces()<CR>

	" execute local configuration
	if filereadable(expand($HOME) . '/local/.vimrc')
		source $HOME/local/.vimrc
	endif
endif

" always use 16-color terminal mode
set t_Co=16

" using PuTTY with GNU Screen makes Vim crazy
if &term == "screen"
	set term=xterm
endif
