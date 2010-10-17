" File: prj.vim
" Author: Stanislav Fomichev <s AT fomichev DOT me>
" Version: 0.1
" Last Modified: September 8, 2010
"
" TODO:
" - PrjTodo
" - Possibility to use '.' and '..' in project directory line; update PrjDir
"   accordingly.
" - Add solution handling (projects in one folder are considered as a solution
"   and tags should be loaded for the whole solution (also consider adding
"   PrjSolutionOpen & PrjSolutionsTags to open and update tags for the whole
"   solution)

if exists('prj_loaded')
	" don't load any stuff
	finish
else
	" first time loading; prepare ourself

	" plugin load indication
	let g:prj_loaded = 1

	" keep this tags files
	if !exists('g:static_tags')
		let g:static_tags = ''
	endif

	" project search directories
	let s:prj_dirs = $HOME . '/.vim/projects/'
	" project search directories separator
	let s:prj_dirs_sep = ','
	" active project
	let s:prj = ''

	" ctags generation options
	let s:prj_ctags_opts = '--format=2 --excmd=pattern --fields=+iaS'

	" define commands and aliases
	command! -nargs=1 -complete=command PrjOpen call PrjOpen(<q-args>)
	ca prjo PrjOpen
	command! -nargs=? -complete=command PrjTags call PrjTags(<q-args>)
	ca prjt PrjTags
	command! -nargs=? -complete=command PrjTodo call PrjTodo(<q-args>)
	ca prjd PrjTodo
	command! -nargs=1 -complete=command PrjGrep call PrjGrep(<q-args>)
	ca prjg PrjGrep
endif

" return project file
function! s:PrjFind(name)
	for l:line in split(s:prj_dirs, s:prj_dirs_sep)
		if filereadable(l:line . '/' . a:name)
			let l:prj = l:line . '/' . a:name
		endif
	endfor

	if !exists('l:prj')
		echo 'Project ' . a:name . ' not found!'
		return ''
	endif

	return l:prj
endfunction

" return project file directory
function! s:PrjDir(prj)
	let l:lines = readfile(a:prj)

	for l:line in readfile(a:prj)
		" pass empty lines
		if len(l:line) == 0
			continue
		endif

		" pass lines which start with #
		if match(l:line, '^#') != -1
			continue
		endif

		if match(l:line, ':$') != -1
			return substitute(l:line, ':$', '', 0)
		endif
	endfor

	echo "Project " . a:prj . " directory not found!"
endfunction

" return project tags file location
function! s:PrjTagsFile(prj)
	return s:PrjDir(a:prj) . '/tags'
endfunction

" load project tags
function! s:PrjLoadTags(prj)
	exec 'set tags=' . g:static_tags . s:PrjTagsFile(a:prj)
endfunction

" return list of project files
function! s:PrjFiles(prj)
	let l:fl = []

	for l:line in readfile(a:prj)
		" pass empty lines
		if len(l:line) == 0
			continue
		endif

		" pass lines which start with #
		if match(l:line, '^#') != -1
			continue
		endif

		if match(l:line, ':$') != -1
			if match(l:line, '^\.') != -1
"				let l:dir = s:PrjDir(a:name)
				echo "Path " . l:line . " is not supported yet"
				return []
			else
				let l:dir = substitute(l:line, ':$', '', 0)
			endif
		else
			for l:pat in split(globpath(l:dir, l:line), '\n')
				call extend(l:fl, [ l:pat ])
			endfor
		endif
	endfor

	return l:fl
endfunction

" return list of project files patterns
function! s:PrjPatterns(prj)
	let l:fl = []

	for l:line in readfile(a:prj)
		" pass empty lines
		if len(l:line) == 0
			continue
		endif

		" pass lines which start with #
		if match(l:line, '^#') != -1
			continue
		endif

		if match(l:line, ':$') != -1
			if match(l:line, '^\.') != -1
"				let l:dir = PrjDir(a:name)
				echo "Path " . l:line . " is not supported yet"
				return []
			else
				let l:dir = substitute(l:line, ':$', '', 0)
			endif
		else
			call extend(l:fl, [ l:dir . '/' . l:line ])
		endif
	endfor

	return l:fl
endfunction

" open project
function! PrjOpen(name)

	" close all buffers
	for l:i in range(1, bufnr('$'))
		if buflisted(l:i) != 0
			exec 'bdelete ' . l:i
		endif
	endfor

	" find project
	let l:prj = s:PrjFind(a:name)

	if l:prj == ''
		return
	endif

	" set global project variable for PrjTags
	let s:prj = l:prj

	" change current directory to project's one
	exec 'cd ' . s:PrjDir(l:prj)

	" use project tags
	call s:PrjLoadTags(l:prj)

	" update Vim args
	exec 'args ' . join(s:PrjFiles(l:prj), ' ')
endfunction

" generate tags for project
function! PrjTags(name)
	if a:name == ''
		if s:prj == ''
			echo 'No project loaded!'

			return
		endif

		let l:prj = s:prj
	else
		let l:prj = s:PrjFind(a:name)

		if l:prj == ''
			return
		endif
	endif

	exec system('ctags -f ' . s:PrjTagsFile(l:prj) . ' ' . s:prj_ctags_opts . ' ' . join(s:PrjPatterns(l:prj), ' '))

	call s:PrjLoadTags(l:prj)
endfunction

" create a quickfix list with all project TODOs, FIXMEs, XXXs
function! PrjTodo(name)
"vimgrep /fixme\\|todo/j *.[c,cpp,h,hpp,py]<CR>:cw<CR>
endfunction

" grep in project (all listed buffers)
function! PrjGrep(pattern)
	let list = ''

	for i in range(bufnr('$'))
		if buflisted(i)
			let list .= ' ' . bufname(i)
		endif
	endfor

	exec "vimgrep " . a:pattern . list
endfunction
