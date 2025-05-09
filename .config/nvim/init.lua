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

--vim.g.copilot_proxy = 'http://localhost:11435'
--vim.g.copilot_proxy_strict_ssl = false

-- Only use copilot suggestions for public work
--vim.g.copilot_filetypes = {
--	["*"] = false,
--	mail = true,
--}

require("lazy").setup({
	"will133/vim-dirdiff",
	"tinted-theming/base16-vim",
	{
		'saghen/blink.cmp',
		version = '*',

		opts = {
			keymap = { preset = 'default' },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = 'mono',
			},
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
				cmdline = {},
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { 'saghen/blink.cmp' },
		config = function ()
			local capabilities = require('blink.cmp').get_lsp_capabilities()

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
					"m",
					function ()
						builtin.buffers{
							sort_mru = true,
							sort_lastused = true,
							initial_mode = "normal",

						}
					end,
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

			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					vimgrep_arguments = {
							  "g",
							  "--color=never",
							  "--no-heading",
							  "--with-filename",
							  "--line-number",
							  "--column",
							  "--smart-case"
					},
					mappings = {
						n = {
							["dd"] = require("telescope.actions").delete_buffer,
							["q"] = require("telescope.actions").close,

						},
					},
				},
			})
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
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
						":CodeCompanionChat Toggle<CR>",
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
	-- "github/copilot.vim",
})

require("oil").setup({
	use_default_keymaps = false,
	keymaps = {
		["<CR>"] = "actions.select",
		["t"] = { "actions.select", opts = { tab = true } },
		["p"] = "actions.preview",
		["<C-r>"] = "actions.refresh",
		["-"] = "actions.parent",
		["g."] = "actions.toggle_hidden",
		["g\\"] = "actions.toggle_trash",
	},
	view_options = {
		show_hidden = true,
	},
})

local adapter = "ollama"

require("codecompanion").setup({
	strategies = {
		chat = {
			adapter = adapter,
		},
		inline = {
			adapter = adapter,
		},
		agent = {
			adapter = adapter,
		},
	},
	adapters = {
		ollama = function()
			local model = "llama3.1"
			local handle = io.popen("ol -i")
			if handle then
				model = handle:read("*a"):gsub("\n", "")
				handle:close()
			else
				print("Failed to execute ol -i`" )
			end

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
						default = model,
					},
				},
			})
		end,
	},
})

require('lualine').setup({
	sections = {
		lualine_a = {
			'mode',
		},
		lualine_b = {
			{ 'filename', path = 1 },
			'branch',
		},
		lualine_c = { '%=', },
		lualine_x = {},
		lualine_y = {
			'filetype',
			'progress',
		},
		lualine_z = {
			'location',
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})

require('codecompanion-lualine')

-- Load base16 color scheme
local current_theme_name = os.getenv('BASE16_THEME')
if current_theme_name and vim.g.colors_name ~= 'base16-'..current_theme_name then
	vim.cmd('let base16_colorspace=256')
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

-- Local local vimrc
vim.cmd[[
	if filereadable(expand($HOME) . "/local/nvim.lua")
		luafile $HOME/local/nvim.lua
	endif
]]

local wk = require("which-key")
wk.add({
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
	{
		"<leader>ia",
		function()
			vim.api.nvim_put({'Acked-by: Stanislav Fomichev <sdf@fomichev.me>'}, 'l', true, true)
		end,
		desc = "Acked-by",
	},
	{
		"<leader>i/",
		function()
			vim.api.nvim_put({'---'}, 'l', true, true)
		end,
		desc = "---",
	},
	{
		"<leader>ir",
		function()
			vim.api.nvim_put({'Reviewed-by: Stanislav Fomichev <sdf@fomichev.me>'}, 'l', true, true)
		end,
		desc = "Reviewed-by",
	},
	{
		"<leader>it",
		function()
			vim.api.nvim_put({'Tested-by: Stanislav Fomichev <sdf@fomichev.me>'}, 'l', true, true)
		end,
		desc = "Tested-by",
	},
	{
		"<leader>ic",
		function()
			vim.api.nvim_put({'---', 'pw-bot: cr'}, 'l', true, true)
		end,
		desc = "pw-bot: cr",
	},
	{
		"<leader>il",
		function()
			vim.api.nvim_put({'-----BEGIN COVER LETTER-----', '-----END COVER LETTER-----'}, 'l', true, true)
		end,
		desc = "BEGIN COVER LETTER",
	},
})

vim.api.nvim_create_user_command("Explore", function()
	local current_file = vim.fn.expand("%:p")
	local current_dir = vim.fn.fnamemodify(current_file, ":h")
	vim.cmd("silent! lua require('oil').open('" .. current_dir .. "')")
end, {})
