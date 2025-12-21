-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set
local nvim_tmux_nav = require("nvim-tmux-navigation")

-- Remove those shortcuts as they are polluting
vim.keymap.del({ "n" }, "<leader>n") -- message history
vim.keymap.del({ "n" }, "<leader>p") -- yank history
vim.keymap.del({ "n" }, "<leader>D") -- DB ui
vim.keymap.del({ "n" }, "<leader>K") -- Keywordprg -- don't even know what it is
vim.keymap.del({ "n" }, "<leader>S") -- Select scratch buffer
vim.keymap.del({ "n" }, "<leader>l") -- Lazy
vim.keymap.del({ "n" }, "<leader>L") -- Lazy changelog
vim.keymap.del({ "n" }, "<leader>e") -- Snacks file picker
vim.keymap.del({ "n" }, "<leader>E") -- Snacks file picker at root
vim.keymap.del({ "n" }, "<leader>`") -- Switch buffer

map({ "n", "i" }, "<C-q>", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map({ "n" }, "<C-e>", function()
  -- vim.cmd("Neotree toggle")
  Snacks.explorer()
end, { desc = "Toggle file tree" })

if vim.env.TMUX then
  -- use tmux navigation
  map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
  map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
  map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
  map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)

  -- Terminal management is done via tmux when in a tmux session
  vim.keymap.del({ "n", "t" }, "<c-/>")
  vim.keymap.del({ "n", "t" }, "<c-_>")

  -- Window splitting shortcuts are disable
  vim.keymap.del({ "n" }, "<leader>|") -- Split window
  vim.keymap.del({ "n" }, "<leader>-") -- Split window
end

map({ "n" }, "<leader>.", function()
  Snacks.scratch()
end, { desc = "Open a scratch buffer" })
map({ "n" }, "<leader>fs", function()
  Snacks.scratch.select()
end, { desc = "Open a scratch buffer" })
map({ "n" }, "<leader>uH", function()
  Snacks.notifier.show_history()
end, { desc = "Show notification history" })

-- vim.keymap.del({ "n" }, "<leader>?") -- Buffer keymap
