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

" place a $ mark at the end of change
set cpoptions+=$

" enable line numbers
set number

" speedup macros
set lazyredraw

" show partial command on the last line
set showcmd

" key word definition
set iskeyword=a-z,A-Z,48-57,_

" load plugins on win32
if has('win32')
	set runtimepath+=$HOME/.vim
endif

" set aux files directory
if has('win32')
	set directory=$HOME/tmp
	set backupdir=$HOME/tmp

	if has('gui_running')
		" use the following font
		set guifont=Lucida_Console:h10
	endif
else
	set directory=~/.vim/tmp
	set backupdir=~/.vim/tmp

	if has('gui_running')
		" use the following font
		set guifont=Monaco
	endif
endif

" use ack for grep
set grepprg=ack

" show the cursor position all the time
set ruler

" set highlighting search mode
set hlsearch

" find the next match as we type
set incsearch

" don't wrap screen on search
"set nowrapscan

" 1, 2, 3, 4, etc
"set foldcolumn=1
"set foldmethod=syntax

" terminal has 256 colors
set t_Co=256

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
	set listchars=tab:»~,trail:·
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
		set undodir=$HOME/tmp
	else
		set undodir=~/.vim/tmp
	endif
endif

if has('syntax')
	" enable syntax coloring
	set background=dark
	colorscheme molokai
	syntax on
endif

if has('autocmd')
	" pathogen
	filetype off
	call pathogen#helptags()
	call pathogen#runtime_append_all_bundles()

	" show non-ASCII
	set isprint=

	" cache more lines
	let c_minlines=100

	" enable filetype plugins
	filetype plugin on

	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

	" mutt's mails
	augroup filetypedetect
	autocmd BufRead,BufNewFile *mutt-*              setfiletype mail
	augroup END

	" linux style setup
	function! StyleLinux()
		set sw=8
		set sts=8
		set ts=8
		set noet
		set cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,gs,hs,ps,t0,is,+s,c3,C0,(0
	endfunction

	" python style setup
	function! StylePython()
		set sw=4
		set sts=4
		set ts=4
		set et
	endfunction

	" update tags in the current directory and add them to the tags
	" variable
	function! UpdatePwdTags(path)
		let l:ctags_opts='--format=2 --excmd=pattern --fields=+iaS'

		exec system('ctags -R -f ' . a:path . ' ' . l:ctags_opts . ' .')
		exec 'set tags+=./tags'
	endfunction

	function! UpdateSystemTags()
		let l:ctags_opts='--format=2 --excmd=pattern --fields=+iaS'
		let l:paths='/usr/include'

		exec system('ctags -R -f $HOME/.vim/tmp/system_tags ' . l:ctags_opts . ' ' . l:paths)
	endfunction
	set tags+=$HOME/.vim/tmp/system_tags

	function! UpdateLinuxTags(path)
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
			\ '--c-kinds=-m+px --format=2 ' .
			\ '--excmd=pattern --fields=+S'

		let l:paths =
			\ a:path . '/arch/x86 ' .
			\ a:path . '/block ' .
			\ a:path . '/crypto ' .
			\ a:path . '/fs ' .
			\ a:path . '/include ' .
			\ a:path . '/init ' .
			\ a:path . '/ipc ' .
			\ a:path . '/kernel ' .
			\ a:path . '/lib ' .
			\ a:path . '/mm ' .
			\ a:path . '/net ' .
			\ a:path . '/security ' .
			\ a:path . '/virt'

		exec system('ctags -R -f $HOME/.vim/tmp/linux_tags ' . l:ctags_opts . ' ' . l:paths)
	endfunction
	set tags+=$HOME/.vim/tmp/linux_tags

	function! FileC()
		" show additional errors for C files
		set filetype=c
		let c_space_errors=1
		let c_curly_error=1
		let c_bracket_error=1
		let c_gnu=1

		" use auto c indentation
		set cindent

		call StyleLinux()
	endfunction
	au BufNewFile,BufRead *.c,*.h,*.cpp,*.hpp,*.C call FileC()

	function! FilePy()
		" use auto indentation
		set autoindent

		call StylePython()
	endfunction
	au BufNewFile,BufRead *.py call FilePy()

	" change word under cursor in each buffer
	function! BufChange()
		let from=expand("<cword>")

		let to=input("Change " . from . " to: ")

		if strlen(to) > 0
			exe "bufdo! %s/\\<" . from . "\\>/" . to . "/g | update"
		endif
	endfunction

	" grep word under cursor
	function! GrepWord()
		let from=expand("<cword>")

		if strlen(from)
			exe "grep " . from
		endif
	endfunction

	" mappings
	map <M-s> :call UpdateSystemTags()<CR>
	map <M-l> :call UpdateLinuxTags(fnamemodify(".",":ph"))<CR>
	map <M-p> :call UpdatePwdTags('./tags')<CR>

	nnoremap <silent> <M-c> :call BufChange()<CR>
	nnoremap <silent> <M-a> :A<CR>
	nnoremap <silent> <M-u> :GundoToggle<CR>
	nnoremap <silent> <M-t> :TlistToggle<CR>
	nnoremap <silent> <M-b> :BufExplorer<CR>
	nnoremap <silent> <M-g> :call GrepWord()<CR>

	" don't show help window when I miss ESC key
	inoremap <F1> <ESC>
	nnoremap <F1> <ESC>
	vnoremap <F1> <ESC>

	let g:gundo_help=0
	let Tlist_Compact_Format=1
	let g:bufExplorerDefaultHelp=0
	let g:bufExplorerDetailedHelp=0

	let NERDTreeBookmarksFile=expand('$HOME') . '/.vim/bookmarks'
	let NERDTreeShowBookmarks=1
	let NERDTreeShowHidden=0
	let NERDTreeMinimalUI=1
	let NERDTreeIgnore=['\~$', '\.o$', '\.a$', 'Makefile.in', '\.ko$', 'modules.order', 'built-in.mod.c', '\.mod.c', '\.c.orig']

	if !has('python')
		let g:gundo_disable=1
	endif
endif

" using PuTTY with GNU Screen makes Vim crazy
if &term == "screen"
	set term=xterm
	set t_Co=16
endif
