local wk = require('which-key')
local keybindings = require "vars.keybindings"
local surround = require("nvim-surround")

-- This is to make sure that the leader key is set to space
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Surround motions
surround.setup()

-- Buffer and Files manipulation
wk.register(keybindings.buffers, { noremap = true, silent = true })

-- Search and Show
wk.register({
	u = keybindings.undo,
	s = keybindings.search,
	S = keybindings.show,
	h = keybindings.harpoons,
	e = keybindings.explain,
	n = keybindings.noice,
	-- t = keybindings.terminals,
}, { prefix = '<leader>' })
