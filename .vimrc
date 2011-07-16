" don't compatible with vi
set nocompatible

" use utf-8 everywhere
set encoding=utf-8

" allow backspacing over everything
set backspace=indent,eol,start

" suppose all files in Unix format (\n only)
set fileformats=unix

" default width (+fold column)
set columns=86

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
set timeoutlen=100

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
		set guifont=Monofur\ 12
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
	call pathogen#helptags()
	call pathogen#runtime_append_all_bundles()

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

	" switching between tabs and buffers
	nnoremap <silent> <C-h> gT
	nnoremap <silent> <C-k> :bprev<CR>
	nnoremap <silent> <C-j> :bnext<CR>
	nnoremap <silent> <C-l> gt

	" don't show help window when I miss ESC key
	inoremap <F1> <ESC>
	nnoremap <F1> <ESC>
	vnoremap <F1> <ESC>

	" tags related
	map <F2> :call UpdateTags('')<CR>
	map <F3> :call UpdateLinuxTags('')<CR>
	map <F4> :call UpdateSystemTags('')<CR>

	" alternative
	nnoremap <silent> <M-a> :A<CR>

	" tagbar
	nnoremap <silent> <M-t> :TagbarToggle<CR>

	" netrw
	let g:netrw_fastbrowse=2
	let g:netrw_banner=0
	let g:netrw_home=expand($HOME) . '/local/.vim'
	let g:netrw_special_syntax=1

	" mini buffer explorer
	let g:miniBufExplCloseOnSelect = 1
	let g:miniBufExplVSplit = 50
	nnoremap <silent> <M-b> :TMiniBufExplorer<CR>

	" gundo
	let g:gundo_help=0
	if !has('python')
		let g:gundo_disable=1
	endif
	nnoremap <silent> <M-u> :GundoToggle<CR>

	" omci cpp completion
	let OmniCpp_MayCompleteDot = 0
	let OmniCpp_MayCompleteArrow = 0
	let OmniCpp_MayCompleteScope = 0
	autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
	autocmd InsertLeave * if pumvisible() == 0|pclose|endif

	if filereadable(expand($HOME) . '/local/.vimrc')
		source $HOME/local/.vimrc
	endif
endif

" using PuTTY with GNU Screen makes Vim crazy
if &term == "screen"
	set term=xterm
	set t_Co=16

	" http://vim.wikia.com/wiki/Fix_meta-keys_that_break_out_of_Insert_mode
	let c = 'a'
	while c <= 'z'
		exec "map " . c . " <M-" . c . ">"
		let c = nr2char(1 + char2nr(c))
	endw
endif
