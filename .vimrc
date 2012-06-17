" Pathogen {{{1

set nocompatible
filetype off
call pathogen#infect()
filetype plugin indent on

"1}}}
" Essentials {{{1

" use utf-8 everywhere
set encoding=utf-8

" show current mode
set showmode

" show partial command
set showcmd

" allow backspacing over everything
set backspace=indent,eol,start

" suppose all files in Unix format (\n only)
set fileformats=unix,dos

" place a $ mark at the end of change
set cpoptions+=$

" don't show relative numbers to current line
set norelativenumber

" enable line numbers
set number

" always show status line
set laststatus=2

" customize status line
set statusline=%<%m\ %f\ [%{&fileformat}]\ %r%=%c:%l/%L\ %P

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

" ":substitute" flag 'g' is default on
set gdefault

" ignore case in search patterns
set ignorecase

" switch off ignorecase when pattern contains upper case chars
set smartcase

" don't force me to save file
set hidden

" don't wait to much for mappings/key codes
set timeout timeoutlen=3000 ttimeoutlen=100

" highlight current line
set cursorline

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

" support only root fold for syntax
set foldnestmax=1

" cache more lines
let c_minlines=100

" mappings
let mapleader = ","
let maplocalleader = "\\"

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
set listchars=tab:→\ ,trail:·

" enable spell check
set spelllang=en_us,ru
set spellfile=$HOME/.vim/spell/all.add
set spell

" make russian keys work in normal mode
set keymap=russian-jcukenwin
set imsearch=0
set iminsert=0

" highlight trailing white spaces
highlight TrailWhitespace ctermbg=red guibg=red
match TrailWhitespace /\s\+$\| \+\ze\t/

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

" 1}}}
" Color scheme {{{1
" GNU Screen / Tmux {{{2

if &term == "screen"
	set term=xterm
	" problem with PuTTY
	let g:solarized_termtrans = 1
endif

" 2}}}
" Solarized {{{2

let g:solarized_underline = 0
let g:solarized_bold = 1
let g:solarized_italic = 1

" }}}2

syntax enable
set t_Co=16
set background=dark
colorscheme solarized

" 1}}}
" Folding {{{1

function! MyFoldText()
	let line = getline(v:foldstart)

	let nucolwidth = &fdc + &number * &numberwidth
	let windowwidth = winwidth(0) - nucolwidth - 2
	let foldedlinecount = v:foldend - v:foldstart

	" expand tabs into spaces
	let onetab = strpart('          ', 0, &tabstop)
	let line = substitute(line, '\t', onetab, 'g')

	let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
	let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
	return line . ' ' . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction

set foldtext=MyFoldText()

" 1}}}
" Mappings {{{1
" Common {{{2

" disable search highlight
nmap <silent> <Leader>/ :silent :nohlsearch<CR>

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

" jump between windows easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 2}}}
" Tabs {{{2

map <Leader>1 1gt
map <Leader>2 2gt
map <Leader>3 3gt
map <Leader>4 4gt
map <Leader>5 5gt
map <Leader>6 6gt
map <Leader>7 7gt
map <Leader>8 8gt
map <Leader>9 9gt

" 2}}}
" Folding {{{2

" use space to open/close folds
nnoremap <Space> za
vnoremap <Space> za

" make zO work no matter where the cursor is
nnoremap zO zCzO

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
" Cocoa.vim {{{2

nmap <silent> <Leader>x :w<bar>call g:RunInXcode()<CR>

" }}}2
" Clang complete {{{2

let g:clang_complete_copen = 1
let g:clang_snippets = 1
let g:clang_snippets_engine = 'clang_complete'
let g:clang_complete_auto = 0
let g:clang_use_library = 0

noremap <silent> <Leader>c :call g:ClangUpdateQuickFix()<CR>
inoremap <silent> <S-Tab> <C-x><C-o>

" 2}}}
" Ctrl-p {{{2

" don't search by full path
let g:ctrlp_by_filename = 1
" don't manage working directory
let g:ctrlp_working_path_mode = 0
" don't search for dotfiles
let g:ctrlp_dotfiles = 0
" don't split when open
let g:ctrlp_split_window = 0
" open new file in current window
let g:ctrlp_open_new_file = 'r'
" let ctrl-p replace netrw buffer
let g:ctrlp_dont_split = 'netrw\|help\|quickfix'
" use ,, to invoke
let g:ctrlp_map = '<Leader>,'
" store cache along with other temporary files
let g:ctrlp_cache_dir = $HOME.'/.vim/tmp/ctrlp'

nnoremap <leader>. :CtrlPMRUFiles<cr>

" 2}}}
" Tagbar {{{2

" add a definition for Objective-C to tagbar
let g:tagbar_type_objc = {
	\ 'ctagstype' : 'ObjectiveC',
	\ 'kinds'     : [
		\ 'i:interface',
		\ 'I:implementation',
		\ 'p:Protocol',
		\ 'm:Object_method',
		\ 'c:Class_method',
		\ 'v:Global_variable',
		\ 'F:Object field',
		\ 'f:function',
		\ 'p:property',
		\ 't:type_alias',
		\ 's:type_structure',
		\ 'e:enumeration',
		\ 'M:preprocessor_macro',
	\ ],
	\ 'sro'        : ' ',
	\ 'kind2scope' : {
		\ 'i' : 'interface',
		\ 'I' : 'implementation',
		\ 'p' : 'Protocol',
		\ 's' : 'type_structure',
		\ 'e' : 'enumeration'
	\ },
	\ 'scope2kind' : {
		\ 'interface'      : 'i',
		\ 'implementation' : 'I',
		\ 'Protocol'       : 'p',
		\ 'type_structure' : 's',
		\ 'enumeration'    : 'e'
	\ }
\ }

nnoremap <silent> <Leader>b :TagbarToggle<CR>

" 2}}}
" Alternative (header/source) {{{2

nnoremap <silent> <Leader>a :A<CR>

" 2}}}
" Netrw {{{2

let g:netrw_fastbrowse=2
let g:netrw_banner=0
let g:netrw_home=expand($HOME) . '/local/.vim'
let g:netrw_special_syntax=1
let g:netrw_browse_split=0

" 2}}}
" Matchit {{{2

runtime macros/matchit.vim

" 2}}}
" Fakeclip {{{2

let g:fakeclip_terminal_multiplexer_type = "tmux"

" }}}2
" 1}}}
" Filetypes {{{1
" C {{{2

let c_space_errors=1
let c_curly_error=1
let c_bracket_error=1
let c_gnu=1
" treat .h files as C files
let g:c_syntax_for_h=1

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
" C++ {{{2

augroup ft_cpp
	au!

	au FileType cpp let g:clang_auto_user_options = 'path, .clang_complete'

	au FileType cpp setlocal foldmethod=syntax
	au FileType cpp setlocal cindent

	au FileType cpp setlocal shiftwidth=4
	au FileType cpp setlocal softtabstop=4
	au FileType cpp setlocal tabstop=4
	au FileType cpp setlocal expandtab
augroup END

"
" }}}2
" Objective-C {{{2

augroup ft_objc
	au!

	au FileType objc let g:clang_auto_user_options = '.clang_complete'

	au FileType objc setlocal foldmethod=syntax
	au FileType objc setlocal smartindent

	au FileType objc setlocal shiftwidth=2
	au FileType objc setlocal softtabstop=2
	au FileType objc setlocal tabstop=2
	au FileType objc setlocal expandtab
	au FileType objc setlocal cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,gs,hs,ps,t0,is,+s,c3,C0,(0

	au FileType objc map <Leader>tp :call UpdateTags('--language-force=ObjectiveC')<CR>
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

	au FileType python setlocal autoindent

	au FileType python setlocal shiftwidth=4
	au FileType python setlocal softtabstop=4
	au FileType python setlocal tabstop=4
	au FileType python setlocal expandtab

	au FileType python setlocal completeopt+=preview
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
" Shell {{{2

augroup ft_sh
	au!

	au FileType sh setlocal foldmethod=marker
	au FileType sh setlocal autoindent

	au FileType sh setlocal shiftwidth=8
	au FileType sh setlocal softtabstop=8
	au FileType sh setlocal tabstop=8
	au FileType sh setlocal noexpandtab
augroup END

" 2}}}
" Markdown {{{2
augroup ft_markdown
	au!

	autocmd BufRead,BufNewFile *.md setlocal filetype=markdown
augroup END
" }}}2
" Text files {{{2
augroup ft_txt
	au!

	autocmd BufRead,BufNewFile *.txt setlocal filetype=markdown
augroup END
" 2}}}
" LaTeX {{{2

augroup ft_latex
	au!

	au FileType tex setlocal shiftwidth=2
	au FileType tex setlocal softtabstop=2
	au FileType tex setlocal tabstop=2
	au FileType tex setlocal expandtab

	autocmd BufRead,BufNewFile *.cls setlocal filetype=tex
augroup END

" 2}}}
" 1}}}
" Ctags {{{1
" Current directory (tags should include ./tags) {{{2

function! UpdateTags(opts)
	let l:path = fnamemodify(".",":ph")
	let l:tags_path = l:path . 'tags'

	call UpdateCustomTags(a:opts, tags_path, path)

	set tags+=l:tags_path
endfunction

map <Leader>tp :call UpdateTags('')<CR>

" 2}}}
" Custom directory (don't include in tags) {{{2

function! UpdateCustomTags(opts, tags_path, path)
	let l:ctags_opts='--format=2 --excmd=pattern --fields=+iaS --extra=+q'
	let l:ctags_exclude='--exclude=*.o --exclude=build_linux --exclude=tags'

	exec system('ctags -R -f ' . a:tags_path . ' ' . l:ctags_opts . ' ' . l:ctags_exclude . ' ' . a:opts . ' ' . a:path)
endfunction

" 2}}}
" System directory (and add to tags) {{{2

function! UpdateSystemTags(path)
	if a:path == ''
		let l:path='/usr/include/'
	else
		let l:path = a:path . '/'
	endif

	call UpdateCustomTags('', '$HOME/.vim/tmp/system_tags', l:path)
endfunction

map <Leader>ts :call UpdateSystemTags('')<CR>

set tags+=$HOME/.vim/tmp/system_tags

" 2}}}
" Linux directory (and add to tags) {{{2

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
				\ '--c-kinds=-m+px ' .
				\ '--fields=+S'

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

	call UpdateCustomTags(l:ctags_opts, '$HOME/.vim/tmp/linux_tags', l:path_dirs)
endfunction

map <Leader>tl :call UpdateLinuxTags('')<CR>

set tags+=$HOME/.vim/tmp/linux_tags

" 2}}}
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
" Abbreviations {{{1

ia sf Stanislav Fomichev
ia br Best regards,
ia wtbr With the best regards,
ia kr Kind regards,

" }}}1
" Local configuration {{{1

" execute local configuration
if filereadable(expand($HOME) . '/local/.vimrc')
	source $HOME/local/.vimrc
endif

" 1}}}
