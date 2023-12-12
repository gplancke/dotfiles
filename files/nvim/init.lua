--
-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'plugins.core' },
  { import = 'plugins.treesitter' },
  { import = 'plugins.lsp' },
  { import = 'plugins.ide' },
  { import = 'plugins.appearance' },
}, {})
require('xtensions.lazygit')
require('configs.options')
require('configs.keybindings')
require('configs.autocomplete')
require('configs.appearance')

-- NOTE: Make sure the terminal supports this
vim.o.termguicolors = true
vim.o.base16colorspace = 256
-- vim.cmd('colorscheme base16-catppuccin')
vim.cmd('colorscheme catppuccin-macchiato')
