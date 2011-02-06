" don't compatible with vi
set nocompatible

" use utf-8 everywhere
set encoding=utf-8

" allow backspacing over everything
set backspace=indent,eol,start

" suppose all files in Unix format (\n only)
set ffs=unix

" default width (+fold column)
set co=86

" place a $ mark at the end of change
set cpoptions+=$

" enable line numbers
set nu

" speedup macros
set lz

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

	" use external grep
	set grepprg=grep\ -n
else
	set directory=~/.vim/tmp
	set backupdir=~/.vim/tmp

	if has('gui_running')
		" use the following font
		set guifont=Monaco
	endif
endif

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
set list
set listchars=tab:»~,trail:·

if has('spell')
	" enable spell check
	setlocal spell spelllang=en_us
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
	set undolevels=100

	" set undo directory
	if has('win32')
		set undodir=c:/vim
	else
		set undodir=~/.vim/tmp
	endif
endif

if has('syntax')
	" enable syntax coloring
	syntax on
	set background=dark
	"colorscheme molokai
	colorscheme ir_black
endif

if has('autocmd')
	" show non-ASCII
	set isprint=

	" cache more lines
	let c_minlines = 100

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
		set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,b0,gs,hs,ps,t0,is,+s,c3,C0,(0
	endfunction
	map <F6> :call StyleLinux()<CR>

	" python style setup
	function! StylePython()
		set sw=4
		set sts=4
		set ts=4
		set et
	endfunction
	map <F7> :call StylePython()<CR>

	" update tags in the current directory and add them to the tags
	" variable
	function! UpdateTags(path)
		let l:ctags_opts = '--format=2 --excmd=pattern --fields=+iaS'

		exec system('ctags -R -f ' . a:path . ' ' . l:ctags_opts . ' .')
		exec 'set tags+=./tags'
	endfunction
	map <F8> :call UpdateTags('./tags')<CR>

	function! UpdateSystemTags()
		let l:ctags_opts = '--format=2 --excmd=pattern --fields=+iaS'
		let l:paths = '/usr/include'

		exec system('ctags -R -f $HOME/.vim/tmp/system_tags ' . l:ctags_opts . ' ' . l:paths)
	endfunction
	map <F9> :call UpdateSystemTags()<CR>
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

"	set tags+=~/src/linux-2.6/tags

	function! FileC()
		" show additional errors for C files
		set filetype=c
		let c_space_errors=1
		let c_curly_error=1
		let c_bracket_error=1

		" use auto c indentation
		set cindent

		call StyleLinux()
	endfunction
	au BufNewFile,BufRead *.c,*.h,*.cpp,*.hpp,*.C call FileC()

	function! FilePy()
		" use auto indentation
		set ai

		call StylePython()
	endfunction
	au BufNewFile,BufRead *.py call FilePy()

	" change word under cursor in each buffer
	function! BufChange()
		let from = expand("<cword>")

		let to = input("Change " . from . " to: ")

		if strlen(to) > 0
			exe "bufdo! %s/\\<" . from . "\\>/" . to . "/g | update"
		endif
	endfunction
	nnoremap <silent> <F2> :call BufChange()<CR>

	" map switching between header and source
	nnoremap <silent> <F12> :A<CR>
endif

" don't show help window when I miss ESC key
inoremap <F1> <nop>
nnoremap <F1> <nop>
vnoremap <F1> <nop>

" using PuTTY with GNU Screen makes Vim crazy
if &term == "screen"
	set term=xterm
	set t_Co=16
	" this one works good on linux/xterm
	colorscheme molokai
endif
