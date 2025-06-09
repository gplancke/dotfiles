-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set
local nvim_tmux_nav = require("nvim-tmux-navigation")

map({ "n", "i" }, "<C-q>", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

map({ "n" }, "<C-e>", function()
  Snacks.explorer()
end, { desc = "Toggle file tree" })

map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)

-- Terminal management is done via tmux when in a tmux session
if vim.env.TMUX then
  vim.keymap.del({ "n", "t" }, "<c-/>")
  vim.keymap.del({ "n", "t" }, "<c-_>")
end
