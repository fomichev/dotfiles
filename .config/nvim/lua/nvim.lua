local use = require('packer').use
require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'neovim/nvim-lspconfig'
	use 'nvim-treesitter/nvim-treesitter'
end)

-- https://github.com/neovim/nvim-lspconfig
require'lspconfig'.clangd.setup{}

require'nvim-treesitter.configs'.setup {
	-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
	ensure_installed = { "c", "lua", "vim" },
	sync_install = true,
	auto_install = true,
	ignore_install = { "javascript" },

	highlight = {
		disable = { "javascript" },
		additional_vim_regex_highlighting = true,
	},

	indent = {
		enable = true,
	},
}
