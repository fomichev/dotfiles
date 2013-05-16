if has('win32')
	set guifont=Anonymous\ Pro:h13
else
	if has("gui_macvim")
		set guifont=Anonymous\ Pro:h16
	else
		set guifont=Anonymous\ Pro\ 13
	endif
endif

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
" don't touch system clipboard
set guioptions-=a

if has("gui_macvim")
	macmenu &Tools.Make key=<nop>
endif
