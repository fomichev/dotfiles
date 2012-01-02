" obj-c is c superset
runtime! ftplugin/c.vim ftplugin/c_*.vim ftplugin/c/*.vim

let c_space_errors=1
let c_curly_error=1
let c_bracket_error=1
let c_gnu=1

set cindent

set sw=4
set sts=4
set ts=4
set et
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,gs,hs,ps,t0,is,+s,c3,C0,(0

setlocal makeprg=xcodebuild\ -sdk\ iphonesimulator5.0

let g:clang_auto_user_options = '.clang_complete'

" don't load c stuff again
let b:did_ftplugin = 1
