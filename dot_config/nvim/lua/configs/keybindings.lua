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
wk.add(keybindings.buffers, { noremap = true, silent = true })
wk.add(keybindings.search)
wk.add(keybindings.show)
wk.add(keybindings.harpoons)
wk.add(keybindings.explain)
wk.add(keybindings.noice)
wk.add(keybindings.undo)
-- wk.add(keybindings.aichat) -- Done in plugin config
-- wk.add(keybindings.terminals)
