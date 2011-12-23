" change word under cursor in each buffer
function! BufChange()
	let from=expand("<cword>")

	let to=input("Change " . from . " in all buffers to: ")

	if strlen(to) > 0
		exe "bufdo! %s/\\<" . from . "\\>/" . to . "/g | update"
	endif
endfunction
