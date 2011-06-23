" update tags in the current directory and add them to the tags
" variable
function! UpdateTags(path)
	if a:path == ''
		let l:path = fnamemodify(".",":ph")
		let l:include = 'y'
	else
		let l:path = a:path . '/'
		let l:include = 'n'
	endif

	let l:ctags_opts='--format=2 --excmd=pattern --fields=+iaS'

	exec system('ctags -R -f ' . l:path . 'tags ' . l:ctags_opts . ' ' . l:path)

	if l:include == 'y'
		exec 'set tags+=' . l:path . 'tags'
	endif
endfunction

function! UpdateSystemTags(path)
	if a:path == ''
		let l:path='/usr/include/'
	else
		let l:path = a:path . '/'
	endif

	let l:ctags_opts='--format=2 --excmd=pattern --fields=+iaS'

	exec system('ctags -R -f $HOME/.vim/tmp/system_tags ' . l:ctags_opts . ' ' . l:path)
endfunction

function! UpdateLinuxTags(tags)
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
		\ '--c-kinds=-m+px --format=2 ' .
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
