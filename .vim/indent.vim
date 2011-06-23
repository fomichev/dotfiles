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

au BufNewFile,BufRead *.xml call FilePy()
au BufNewFile,BufRead *.java call FilePy()

" change word under cursor in each buffer
function! BufChange()
	let from=expand("<cword>")

	let to=input("Change " . from . " to: ")

	if strlen(to) > 0
		exe "bufdo! %s/\\<" . from . "\\>/" . to . "/g | update"
	endif
endfunction
