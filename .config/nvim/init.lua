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

vim.g.mapleader = " "

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

-- Disable folding
vim.o.foldenable = false

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

-- Conflicts with treesitter
vim.o.smartindent = false

-- Enable spell check
vim.o.spelllang = "en_us"
vim.o.spell = true

for _, v in ipairs({ "help", "qf", "gitendemail", }) do
	vim.api.nvim_create_autocmd("FileType", {
		pattern = v,
		command = "setlocal nospell"
	})
end

vim.o.grepprg = "g --vimgrep --no-heading"

-- Color 80 column
vim.o.colorcolumn = "80"

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

-- Don't jump on * & #
vim.keymap.set("n", "*", ":keepjumps normal! mi*`i<CR>")
vim.keymap.set("n", "#", ":keepjumps normal! mi#`i<CR>")

-- Use convenient regular expressions
vim.keymap.set("n", "/", "/\\v")
vim.keymap.set("n", "?", "?\\v")

-- Toggle list option
vim.o.listchars = "tab:> ,trail:-,nbsp:+,eol:$"

-- Use sudo to save file
vim.keymap.set("c", "w!!", "w !sudo tee % > /dev/null")

-- Jump between windows easily
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Cursor stays in the middle when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- E (Explore) clashes with something else
vim.api.nvim_create_user_command("E", "Explore", { nargs = 0})

--vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
	--pattern = "*mutt-*",
	--command = "setlocal filetype=mail"
--})

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

-- CursorHold timeout
vim.o.updatetime = 500

-- Quickfix navigation
vim.keymap.set("n", "<C-p>", ":silent cprev<CR>")
vim.keymap.set("n", "<C-n>", ":silent cnext<CR>")

-- No LSP info on the side
vim.o.signcolumn = "no"

local lsp_buffer_augroup = vim.api.nvim_create_augroup("lsp-buffer", {})

local lsp_on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	local function aucmd(event, callback)
		vim.api.nvim_create_autocmd(event, { group = lsp_buffer_augroup, buffer = bufnr, callback = callback })
	end

	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true)
	end

	local wk = require("which-key")
	wk.add({
		{
			"<leader>k",
			vim.lsp.buf.hover,
			desc = "LSP hover",
		},
		{
			"gD",
			vim.lsp.buf.declaration,
			desc = "Go to declaration",
		},
		{
			"gd",
			vim.lsp.buf.definition,
			desc = "Go to definition",
		},
		{
			"gi",
			vim.lsp.buf.implementation,
			desc = "Go to implementation",
		},
		{
			"gr",
			vim.lsp.buf.references,
			desc = "Show references",
		},
		{
			mode = { "n", "v" },
			{
				"<leader>a",
				vim.lsp.buf.code_action,
				desc = "LSP action",
			},
			{
				"<leader>.",
				vim.lsp.buf.format,
				desc = "LSP format",
			},
		},
	})

--	if client.server_capabilities.documentFormattingProvider then
--		if vim.bo[bufnr].filetype ~= "c" then
--			aucmd("BufWritePre", vim.lsp.buf.format)
--		end
--	end

	-- Highlight symbol under cursor in other parts of the document.
	if client.server_capabilities.documentHighlightProvider then
		aucmd("CursorHold", vim.lsp.buf.document_highlight)
		aucmd("CursorMoved", vim.lsp.buf.clear_references)
	end
end

require("lazy").setup({
	"will133/vim-dirdiff",
	"tinted-theming/base16-vim",
	{
		"neovim/nvim-lspconfig",
		config = function ()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require"lspconfig".clangd.setup{
				capabilities = capabilities,
				on_attach = lsp_on_attach,
			}

			-- rustup component add rust-analyzer
			require"lspconfig".rust_analyzer.setup{
				capabilities = capabilities,
				on_attach = lsp_on_attach,
				cmd = { "rustup", "run", "stable", "rust-analyzer" },
			}

			-- pacman -S pyright
			--require"lspconfig".pyright.setup{
			--	capabilities = capabilities,
			--	on_attach = lsp_on_attach,
			--}

			-- pacman -S gopls
			--require"lspconfig".golps.setup{
			--	capabilities = capabilities,
			--	on_attach = lsp_on_attach,
			--}

			-- pacman -S lua-language-server
			--require"lspconfig".lua_ls.setup{
			--	capabilities = capabilities,
			--	on_attach = lsp_on_attach,
			--}

			-- npm i -g bash-language-server
			-- pacman -S bash-language-server
			--require"lspconfig".bashls.setup{
			--	capabilities = capabilities,
			--	on_attach = lsp_on_attach,
			--}

			-- Disable all diagnostics
			vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function ()
			local builtin = require("telescope.builtin")
			local wk = require("which-key")
			wk.add({
				{
					"<leader>f",
					builtin.find_files,
					desc = "Telescope files",
				},
				{
					"<leader>g",
					builtin.live_grep,
					desc = "Telescope grep",
				},
				{
					"<leader>G",
					builtin.grep_string,
					desc = "Telescope grep cursor",
				},
				{
					"<leader>b",
					builtin.buffers,
					desc = "Telescope buffers",
				},
				{
					"<leader>h",
					builtin.help_tags,
					desc = "Telescope help",
				},
				{
					"<leader>r",
					builtin.oldfiles,
					desc = "Telescope recent",
				},
			})
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
			{
				"stevearc/dressing.nvim",
				opts = {},
			},
			"nvim-telescope/telescope.nvim",
		},
		config = function ()
			local wk = require("which-key")
			wk.add({
				{
					mode = { "n", "v" },
					{
						"<leader>x",
						":CodeCompanionToggle<CR>",
						desc = "Code companion",
						icon = " ",
					},
				},
				{
					mode = { "v" },
					{
						"ga",
						":CodeCompanionAdd<CR>",
						desc = "Code companion add",
						icon = " ",
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function ()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "c", "vim", "rust", "go", "lua" },
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
		end,
	},
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
	},
	-- {
	-- 	"epwalsh/obsidian.nvim",
	-- 	lazy = false,
	-- 	event = {
	-- 		"BufReadPre ~/Documents/Obsidian/Main/**.md",
	-- 		"BufNewFile ~/Documents/Obsidian/Main/**.md",
	-- 		"BufReadPre ~/src/kernel-scripts/Kernel/**.md",
	-- 		"BufNewFile ~/src/kernel-scripts/Kernel/**.md",
	-- 	},
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	opts = {
	-- 		workspaces = {
	-- 			{
	-- 				name = "Main",
	-- 				path = "~/Documents/Obsidian/Main/",
	-- 			},
	-- 			{
	-- 				name = "Kernel",
	-- 				path = "~/src/kernel-scripts/Kernel/",
	-- 			},
	-- 		},
	-- 		daily_notes = {
	-- 			folder = "Journal/",
	-- 			date_format = "%Y-%m-%d",
	-- 			template = 'journal.md'
	-- 		},
	-- 		templates = {
	-- 			subdir = ".templates",
	-- 		},
	-- 		ui = {
	-- 			checkboxes = {
	-- 				[" "] = { char = "☐", hl_group = "ObsidianTodo" },
	-- 				["x"] = { char = "✔", hl_group = "ObsidianDone" },
	-- 			},
	-- 			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
	-- 		},
	-- 		note_path_func = function(spec)
	-- 			local path = spec.dir / tostring(spec.title)
	-- 			return path:with_suffix(".md")
	-- 		end,
	-- 	},
	-- },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{
		'stevearc/oil.nvim',
		opts = {},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
})

require("codecompanion").setup({
	strategies = {
		chat = {
			adapter = "ollama",
		},
		inline = {
			adapter = "ollama",
		},
		agent = {
			adapter = "ollama",
		},
	},
	adapters = {
		ollama = function()
			return require("codecompanion.adapters").extend("ollama", {
				env = {
					url = "http://localhost:11434",
				},
				headers = {
					["Content-Type"] = "application/json",
				},
				parameters = {
					sync = true,
				},
				schema = {
					model = {
						default = "deepseek-coder-v2:16b",
					},
				},
			})
		end,
	},
})

require('lualine').setup({
	options = {
		theme = 'base16',
		--component_separators = '',
		--section_separators = { left = '', right = '' },
	},
	sections = {
		lualine_a = { { 'mode', right_padding = 2 }, },
		lualine_b = { { 'filename', path = 1 }, 'branch', },
		lualine_c = { '%=', },
		lualine_x = {},
		lualine_y = { 'filetype', 'progress' },
		lualine_z = { { 'location', left_padding = 2 }, },
	},
	inactive_sections = {
		lualine_a = { 'filename' },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { 'location' },
	},
	tabline = {},
	extensions = {},
})

require('codecompanion-lualine')

local harpoon = require('harpoon')
harpoon:setup({})

local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			vim.snippet.expand(args.body)
		end,
	},
	window = {},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
	}, {
		{ name = "buffer" },
	})
})

-- Load base16 color scheme
local current_theme_name = os.getenv('BASE16_THEME')
if current_theme_name and vim.g.colors_name ~= 'base16-'..current_theme_name then
  vim.cmd('let base16colorspace=256')
  vim.cmd('colorscheme base16-'..current_theme_name)
end

-- Use OCS 52 for clipboard
-- https://neovim.io/doc/user/provider.html#clipboard-osc52
-- https://github.com/tmux/tmux/wiki/Clipboard#quick-summary
--vim.g.clipboard = {
--  name = 'OSC 52',
--  copy = {
--    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--  },
--  paste = {
--    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--  },
--}

vim.cmd[[
	let @a = 'iAcked-by: Stanislav Fomichev <sdf@fomichev.me>'
	let @r = 'iReviewed-by: Stanislav Fomichev <sdf@fomichev.me>'
	let @t = 'iTested-by: Stanislav Fomichev <sdf@fomichev.me>'
	let @d = "i---\npw-bot: cr"
	let @c = "i-----BEGIN COVER LETTER-----\n-----END COVER LETTER-----"
]]

-- Local local vimrc
vim.cmd[[
	if filereadable(expand($HOME) . "/local/nvim.lua")
		luafile $HOME/local/nvim.lua
	endif
]]

local wk = require("which-key")
wk.add({
	{
		"<leader>y",
		function() harpoon:list():select(1) end,
		desc = "Harpoon #1",
		icon = "",
	},
	{
		"<leader>u",
		function() harpoon:list():select(2) end,
		desc = "Harpoon #2",
		icon = "",
	},
	{
		"<leader>i",
		function() harpoon:list():select(3) end,
		desc = "Harpoon #3",
		icon = "",
	},
	{
		"<leader>o",
		function() harpoon:list():select(4) end,
		desc = "Harpoon #4",
		icon = "",
	},
	{
		"<leader>t",
		function() harpoon:list():add() end,
		desc = "Harpoon toggle",
		--icon = "",
	},
	{
		"<leader>j",
		function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
		desc = "Harpoon jump",
		icon = "󱋿",
	},
	{
		"<leader>s",
		":set nospell!<CR>",
		desc = "Spellcheck",
		icon = "",
	},
	{
		"<leader>;",
		":silent :nohlsearch<CR>",
		desc = "Reset /",
	},
	{
		"<leader>l",
		":set nolist!<CR>",
		desc = "Special characters",
	},
	{
		"<leader>d",
		vim.diagnostic.setloclist,
		desc = "LSP diagnostics",
	},
})

vim.api.nvim_create_user_command("Explore", function()
  local current_file = vim.fn.expand("%:p")
  local current_dir = vim.fn.fnamemodify(current_file, ":h")
  vim.cmd("silent! lua require('oil').open('" .. current_dir .. "')")
end, {})
