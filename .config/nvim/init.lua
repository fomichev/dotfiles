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

-- Free leader keys:
-- qwe  yuiop[]\
--        k ;'
-- zx   nm .
--
-- ,1 Grapple #1
-- ,2 Grapple #2
-- ,3 Grapple #3
-- ,4 Grapple #4
-- ,4 Grapple #4
--
-- ,a LSP actions
-- ,b Telescope buffers
-- ,c Grapple prev tag
-- ,d LSP show diagnostics
-- ,f Telescope grep
-- ,g Grep
-- ,h Telescope help
-- ,j Grapple show
-- ,l Toggle list
-- ,r Telescope old files
-- ,s Disable spell checker
-- ,t Grapple tag
-- ,v Grapple next tag
-- ,/ Disable search
-- ,, Telescope files
-- ,. LSP format
--
-- gD Goto declaration
-- gd Goto definition
-- gi Goto implementation
-- gr Goto references
-- S-k LSP hover
-- C-k LSP signature

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

vim.keymap.set("n", "<Leader>s", ":set nospell!<CR>")

for _, v in ipairs({ "help", "qf", "gitendemail", }) do
	vim.api.nvim_create_autocmd("FileType", {
		pattern = v,
		command = "setlocal nospell"
	})
end

vim.o.grepprg = "g --vimgrep --no-heading"
vim.keymap.set("n", "<Leader>g", ":Grep<space>")

vim.api.nvim_create_user_command(
	"Grep",
	"execute 'silent grep <args>' | botright copen | redraw",
	{nargs = "+"}
)

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

-- Cursor stays in the middle when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- E (Explore) clashes with something else
vim.api.nvim_create_user_command("E", "Explore", { nargs = 0})

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

-- CursorHold timeout
vim.o.updatetime = 500

-- Quickfix navigation
vim.keymap.set("n", "<C-p>", ":silent cprev<CR>")
vim.keymap.set("n", "<C-n>", ":silent cnext<CR>")

local lsp_buffer_augroup = vim.api.nvim_create_augroup("lsp-buffer", {})

local lsp_on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set({ "n", "v" }, "<Leader>a", vim.lsp.buf.code_action, opts)
	vim.keymap.set({ "n", "v" }, "<Leader>.", vim.lsp.buf.format, opts)

	local function aucmd(event, callback)
		vim.api.nvim_create_autocmd(event, { group = lsp_buffer_augroup, buffer = bufnr, callback = callback })
	end

	if client.server_capabilities.documentFormattingProvider then
		if vim.bo[bufnr].filetype ~= "c" then
			aucmd("BufWritePre", vim.lsp.buf.format)
		end
	end

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

			if not vim.startswith(vim.fn.getcwd(), "/google/src/cloud") then
				require"lspconfig".clangd.setup{
					capabilities = capabilities,
					on_attach = lsp_on_attach,
				}
			end

			-- rustup component add rust-analyzer
			require"lspconfig".rust_analyzer.setup{
				capabilities = capabilities,
				on_attach = lsp_on_attach,
				cmd = { "rustup", "run", "stable", "rust-analyzer" },
			}

			-- pacman -S gopls
			--require"lspconfig".golps.setup{
			--	capabilities = capabilities,
			--	on_attach = lsp_on_attach,
			--}

			-- pacman -S pyright
			require"lspconfig".pyright.setup{
				capabilities = capabilities,
				on_attach = lsp_on_attach,
			}

			-- pacman -S lua-language-server
			--require"lspconfig".lua_ls.setup{
			--	capabilities = capabilities,
			--	on_attach = lsp_on_attach,
			--}

			-- npm i -g bash-language-server
			-- pacman -S bash-language-server
			require"lspconfig".bashls.setup{
				capabilities = capabilities,
				on_attach = lsp_on_attach,
			}

			-- Disable all diagnostics
			--vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function ()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<Leader>,", builtin.find_files, {})
			vim.keymap.set("n", "<Leader>f", builtin.live_grep, {})
			vim.keymap.set("n", "<Leader>b", builtin.buffers, {})
			vim.keymap.set("n", "<Leader>h", builtin.help_tags, {})
			vim.keymap.set("n", "<Leader>r", builtin.oldfiles, {})
		end,
	},
	{
		"David-Kunz/gen.nvim",
		opts = {
			model = "dolphin-mixtral",
		},
		config = function ()
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
	{
		"epwalsh/obsidian.nvim",
		version = "main",
		lazy = false,
		event = {
			"BufReadPre ~/Documents/Obsidian/Main/**.md",
			"BufNewFile ~/Documents/Obsidian/Main/**.md",
			"BufReadPre ~/src/kernel-scripts/Kernel/**.md",
			"BufNewFile ~/src/kernel-scripts/Kernel/**.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "Main",
					path = "~/Documents/Obsidian/Main/",
				},
				{
					name = "Kernel",
					path = "~/src/kernel-scripts/Kernel/",
				},
			},
			daily_notes = {
				folder = "Journal/",
				date_format = "%Y-%m-%d",
				template = 'journal.md'
			},
			templates = {
				subdir = ".templates",
			},
			ui = {
				checkboxes = {
					[" "] = { char = "☐", hl_group = "ObsidianTodo" },
					["x"] = { char = "✔", hl_group = "ObsidianDone" },
				},
				external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
			},
			note_path_func = function(spec)
				local path = spec.dir / tostring(spec.title)
				return path:with_suffix(".md")
			end,
		},
	},
	{
		"cbochs/grapple.nvim",
		opts = {
			scope = "lsp",
			icons = false,
			status = false,
		},
		keys = {
			{ "<leader>t", "<cmd>Grapple toggle<cr>" },
			{ "<leader>j", "<cmd>Grapple toggle_tags<cr>" },

			{ "<leader>1", "<cmd>silent Grapple select index=1<cr>" },
			{ "<leader>2", "<cmd>silent Grapple select index=2<cr>" },
			{ "<leader>3", "<cmd>silent Grapple select index=3<cr>" },
			{ "<leader>4", "<cmd>silent Grapple select index=4<cr>" },
			{ "<leader>5", "<cmd>silent Grapple select index=5<cr>" },

			{ "<leader>v", "<cmd>silent Grapple cycle_tags next<cr>" },
			{ "<leader>c", "<cmd>silent Grapple cycle_tags prev<cr>" },
		},
	},
})

vim.keymap.set('n', '<Leader>d', vim.diagnostic.setloclist)

local cmp = require"cmp"

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
vim.g.base16colorspace = 256
vim.cmd("source $HOME/.vimrc_background")

-- Local local vimrc
vim.cmd[[
	if filereadable(expand($HOME) . "/local/nvim.lua")
		luafile $HOME/local/nvim.lua
	endif
]]
