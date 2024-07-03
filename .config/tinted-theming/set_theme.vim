function! ColorschemeExists(theme)
    try
        execute 'colorscheme ' . a:theme
        return 1
    catch
        return 0
    endtry
endfunction

if strlen('precious-dark-fifteen') > 0 && (!exists('g:colors_name') || g:colors_name != 'base16-precious-dark-fifteen') && ColorschemeExists('base16-precious-dark-fifteen')
  colorscheme base16-precious-dark-fifteen
endif
