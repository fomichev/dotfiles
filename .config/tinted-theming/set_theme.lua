local current_theme_name = "eighties"
function colorscheme_exists(scheme)
    local status_ok, _ = pcall(vim.cmd, "colorscheme " .. scheme)
    return status_ok
end

print("X")
if current_theme_name and current_theme_name ~= "" and vim.g.colors_name ~= 'base16-' .. current_theme_name and colorscheme_exists('base16-' .. current_theme_name) then
  vim.cmd('colorscheme base16-' .. current_theme_name)
end
