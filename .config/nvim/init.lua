local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","
vim.keymap.set("n", "\\", ",")

-- Don't use mouse
vim.o.mouse = ""

-- Don't waste line for command
vim.o.ch = 0

-- Allow backspacing over everything
vim.o.backspace = "indent,eol,start"

-- Enable line numbers
vim.o.relativenumber = true
vim.o.number = true

-- Global status line
vim.o.laststatus = 3

-- Don't show default mode indicator
vim.o.showmode = false

-- ":substitute" flag 'g' is default on
vim.o.gdefault = true

-- Ignore case in search patterns
vim.o.ignorecase = true

-- Switch off ignore-case when pattern contains upper case chars
vim.o.smartcase = true

-- Don't wait to much for mappings/key codes
vim.o.timeoutlen = 3000
vim.o.ttimeoutlen = 100

-- Highlight current line
vim.o.cursorline = true

-- Don't beep!
vim.o.visualbell = true

-- Messages tweaks
vim.o.shortmess = "atToOI"

-- Don't put the first matched word and always show menu
vim.o.completeopt = "menu,menuone,longest"

-- Use bash-like completion
vim.o.wildmode = "list:longest"

-- Ignore a bunch of files
vim.o.wildignore = ".git/*,.hg/*,.svn/*,*.o,*.a,*.class,*.pyc,.DS_Store,*.orig"

-- Show non-ASCII
vim.o.isprint = ""

-- Don't use swap files
vim.o.swapfile = false

-- Don't search includes and tags
vim.o.complete = ".,w,b,u"

vim.keymap.set("n", "<C-\\>", ":tab split <CR><C-]>")

-- Enable spell check
vim.o.spelllang = "en_us"
vim.o.spell = true

for _, v in ipairs({ "help", "qf", "gitendemail", }) do
	vim.api.nvim_create_autocmd("FileType", {
		pattern = v,
		command = "setlocal nospell"
	})
end

vim.o.grepprg = "g $*"
vim.keymap.set("n", "<Leader>g", ":Grep<space>")

vim.api.nvim_create_user_command(
	"Grep",
	"execute 'silent grep <args>' | botright copen | redraw",
	{nargs = "+"}
)

-- Color 80 column
vim.o.colorcolumn = 80

-- Use persistent undo
vim.o.undofile = true
vim.o.undolevels = 1000

vim.o.termguicolors = true
-- Uncomment on mosh
-- https://github.com/mobile-shell/mosh/commit/fa9335f737a057c0b43fe9165dc0ef0f32a5887f
-- https://github.com/mobile-shell/mosh/commit/ce7ba37ad4e493769a126db2b39b8a9aa9121278
vim.o.termguicolors = false

local quicfix = vim.api.nvim_create_augroup("quickfix", {clear = true})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "quickfix",
	group = quickfix,
	command = "nnoremap <buffer> q :close<CR>"
})


-- Disable search highlight
vim.keymap.set("n", "<Leader>/", ":silent :nohlsearch<CR>")

-- Toggle list option
vim.o.listchars = "tab:> ,trail:-,nbsp:+,eol:$"
vim.keymap.set("n", "<Leader>l", ":set nolist!<CR>")

-- Use sudo to save file
vim.keymap.set("c", "w!!", "w !sudo tee % > /dev/null")

-- Moving with Up/Down/Left/Right over wrapped lines
vim.keymap.set("n", "<Left>", "gh")
vim.keymap.set("n", "<Down>", "gj")
vim.keymap.set("n", "<Up>", "gk")
vim.keymap.set("n", "<Right>", "gl")

-- Jump between windows easily
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
	pattern = "*mutt-*",
	command = "setlocal filetype=mail"
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
	pattern = "*.md",
	command = "setlocal filetype=markdown"
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
	pattern = "*.cls",
	command = "setlocal filetype=tex"
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
	pattern = "*.h",
	command = "setlocal filetype=c"
})

require("lazy").setup({
	-- "will133/vim-dirdiff"
	-- "fatih/vim-go"
	"tinted-theming/base16-vim",
	"neovim/nvim-lspconfig",
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function ()
			require("telescope").load_extension "frecency"
		end,
	},
	{
		"David-Kunz/gen.nvim",
		opts = {
			model = "dolphin-mixtral",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function ()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "c", "vim", "rust", "go" },
				sync_install = true,
				auto_install = true,

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				indent = {
					enable = true,
				},
			})
		end
	},
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/nvim-cmp',
})

local cmp = require'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
		end,
	},
	window = {},
	mapping = cmp.mapping.preset.insert({
		['<C-Space>'] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		}, {
			{ name = 'buffer' },
	})
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'lspconfig'.clangd.setup{
	capabilities = capabilities
}

require'lspconfig'.rust_analyzer.setup{
	capabilities = capabilities
}

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '<leader>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

-- Disable all diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

-- Fuzzy finder
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})

vim.keymap.set("n", "<leader>r", function()
	require("telescope").extensions.frecency.frecency {
		workspace = "CWD",
	}
end)

require "gen".prompts = {
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

-- Map normal and visual mode SPACE to ollama
vim.keymap.set({ "n", "v" }, "<space>", ":Gen<CR>")

-- Load base16 color scheme
vim.g.base16colorspace = 256
vim.cmd("source $HOME/.vimrc_background")

-- Local local vimrc
vim.cmd[[
	if filereadable(expand($HOME) . "/local/.vimrc")
	source $HOME/local/.vimrc
	endif
]]
