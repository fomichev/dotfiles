local use = require('packer').use
require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'neovim/nvim-lspconfig'
	use 'nvim-treesitter/nvim-treesitter'
	use 'David-Kunz/gen.nvim'
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
		enable = true,
		disable = { "javascript" },
		-- additional_vim_regex_highlighting = true,
		additional_vim_regex_highlighting = false,
	},

	indent = {
		enable = true,
	},
}

require 'gen'.setup {
	model = 'dolphin-mixtral',
}

require 'gen'.prompts = {
	Generate = {
		prompt = "$input",
		replace = true,
	},
	Comment = {
		prompt = "Explain the following code snippet and write it as a comment, just output the final text without additional quotes around it:\n$text",
		replace = true,
	},
	Ask = {
		prompt = "Regarding the following text, $input:\n$text",
	},
	Summarize = {
		prompt = "Summarize the following text:\n$text",
	},
	Rewrite = {
		prompt = "Change the following text, $input, just output the final text without additional quotes around it:\n$text",
		replace = true,
	},
	Review = {
		prompt = "Review the following code and make concise suggestions:\n```$filetype\n$text\n```",
	},
	Fix_Grammar = {
		prompt = "Modify the following text to improve grammar and spelling, just output the final text without additional quotes around it:\n$text",
		replace = true,
	},
	Fix_Wording = {
		prompt = "Modify the following text to use better wording, just output the final text without additional quotes around it:\n$text",
		replace = true,
	},
}

vim.keymap.set({ 'n', 'v' }, '<space>', ':Gen<CR>')

-- Disable all diagnositcs
vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
