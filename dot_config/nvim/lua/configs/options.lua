vim.o.tabstop = 2
vim.o.shiftwidth = 0
-- Set highlight on search
vim.o.hlsearch = false
-- Make those ugly ~ char disappear
vim.opt.fillchars = {
	vert = "│", -- -- alternatives "▕"
	fold = " ",
	eob = " ",  -- suppress ~ at EndOfBuffer
	diff = "⣿", -- alternatives = ⣿ ░ ╱ ─
	msgsep = "‾",
	foldopen = "▾",
	foldsep = "│",
	foldclose = "▸",
}
vim.o.showbreak = '___'
-- Make line numbers default
vim.wo.number = true
-- Enable mouse mode
vim.o.mouse = 'a'
-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'
-- Enable break indent
vim.o.breakindent = true
-- Save undo history
vim.o.undofile = true
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'
-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
-- Make an hyphen not a word boundary
vim.o.isKeyword:append('-')
