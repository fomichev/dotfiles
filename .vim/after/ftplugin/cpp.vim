let g:clang_auto_user_options = 'path, .clang_complete'

setlocal foldmethod=syntax
setlocal cindent

setlocal sw=4 sts=4 ts=4 et

au BufRead,BufNewFile,BufEnter /google/src/cloud/** setlocal ts=2 sts=2 sw=2 et
