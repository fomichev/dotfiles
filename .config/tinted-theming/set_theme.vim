function! ColorschemeExists(theme)
    try
        execute 'colorscheme ' . a:theme
        return 1
    catch
        return 0
    endtry
endfunction

if strlen('eighties') > 0 && (!exists('g:colors_name') || g:colors_name != 'base16-eighties') && ColorschemeExists('base16-eighties')
  colorscheme base16-eighties
endif
