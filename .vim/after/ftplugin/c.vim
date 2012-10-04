let g:clang_auto_user_options = 'path, .clang_complete'

let c_space_errors=1
let c_curly_error=1
let c_bracket_error=1
let c_gnu=1

" treat .h files as C files
let g:c_syntax_for_h=1

setlocal foldmethod=syntax
setlocal cindent

setlocal shiftwidth=8
setlocal softtabstop=8
setlocal tabstop=8
setlocal noexpandtab
setlocal cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,gs,hs,ps,t0,is,+s,c3,C0,(0
