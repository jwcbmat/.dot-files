local bind = require("keybinder")

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
require("lazy").setup({
	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- Sessions
	"tpope/vim-obsession",

	-- Some sensible defaults
	"tpope/vim-sensible",

	-- Zen mode
	"folke/zen-mode.nvim",

	-- Detach `updatetime` from the frequency of `CursorHold`
	"antoinemadec/FixCursorHold.nvim",

	-- Auto pairs for brackets, parens, quotes
	"jiangmiao/auto-pairs",

	-- editorconfig
	"editorconfig/editorconfig-vim",

	-- Remember editing position
	"farmergreg/vim-lastplace",

	-- lua `fork` of vim-web-devicons for neovim
	"nvim-tree/nvim-web-devicons",

	-- styled-jsx
	"alampros/vim-styled-jsx",

	-- Prisma
	"prisma/vim-prisma",

	{
		-- Kanagawa theme
		"rebelot/kanagawa.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("kanagawa").setup({
				theme = "dragon",
			})
			vim.cmd.colorscheme("kanagawa")
		end,
	},

	{
		-- undo history visualizer
		"mbbill/undotree",
		config = function()
			bind.n("<leader><F5>", vim.cmd.UndotreeToggle, "Toggle undo tree")
		end,
	},

	{ import = "plugins" },
})

-- [[ Setting options ]]
-- Set highlight on search
vim.o.hlsearch = false

-- Hybrid numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Enables 24-bit RGB color
vim.o.termguicolors = true

-- Disable line wrapping
vim.o.wrap = false

-- Highlight the 80th column
vim.o.colorcolumn = "80"

-- Keep at least two lines above and below the cursor
vim.o.scrolloff = 2

-- Neovide configuration
vim.o.guifont = "Iosevka NF,Noto Color Emoji:h10"
vim.opt.linespace = 1

-- Persistent undo
local undo_dir = vim.fn.expand("~/.cache/undodir")

if not vim.fn.isdirectory(undo_dir) then
	vim.fn.mkdir(undo_dir, "p", 0700)
end

vim.o.undodir = undo_dir
vim.o.undofile = true

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
bind.nv("<leader>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
bind.n("k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
bind.n("j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Update buffer
bind.n("<leader>u", "<Cmd>update<CR>", "Update buffer")

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- [[ Configure Coc ]]
-- Install language servers
vim.defer_fn(function()
	require("coc-config").ensure_installed_and_cleanup_npm({
		"coc-css",
		"coc-eslint",
		"coc-html",
		"coc-json",
		"coc-prisma",
		"coc-sh",
		"coc-snippets",
		"coc-sumneko-lua",
		"coc-tsserver",
		"coc-git",
		"coc-emmet",
		"coc-prettier",
		"coc-stylua",
		"coc-yaml",
		"coc-highlight",
		"coc-diagnostic",
		-- Additional sources
		"coc-dictionary",
		"coc-tag",
		"coc-word",
		"coc-emoji",
		"coc-omni",
		"coc-syntax",
		"coc-ultisnips",
		"coc-neosnippet",
	})
end, 0)