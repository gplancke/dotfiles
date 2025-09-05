-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set
local nvim_tmux_nav = require("nvim-tmux-navigation")

map({ "n", "i" }, "<C-q>", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

map({ "n" }, "<C-e>", function()
  Snacks.explorer({ cwd = LazyVim.root() })
end, { desc = "Toggle file tree" })

map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)

-- map({ "n", "v" }, "<leader>iq", function()
--   vim.cmd("CodeCompanionActions")
-- end, { desc = "See IA Actions" })
-- map({ "n", "v" }, "<leader>ii", function()
--   vim.cmd("CodeCompanion")
-- end, { desc = "CodeCompanion Inline" })
-- map({ "n", "v" }, "<leader>ia", function()
--   vim.cmd("CodeCompanionChat Toggle")
-- end, { desc = "Toggle IA Chat" })
-- map("v", "<leader>is", function()
--   vim.cmd("CodeCompanionChat Add")
-- end, { desc = "Add selection to Chat" })

-- Terminal management is done via tmux when in a tmux session
if vim.env.TMUX then
  vim.keymap.del({ "n", "t" }, "<c-/>")
  vim.keymap.del({ "n", "t" }, "<c-_>")
end

vim.keymap.del({ "n" }, "<leader>D") -- DB ui
vim.keymap.del({ "n" }, "<leader>K") -- Keywordprg -- don't even know what it is
vim.keymap.del({ "n" }, "<leader>|") -- Split window
vim.keymap.del({ "n" }, "<leader>-") -- Split window
vim.keymap.del({ "n" }, "<leader>S") -- Select scratch buffer
vim.keymap.del({ "n" }, "<leader>l") -- Lazy
vim.keymap.del({ "n" }, "<leader>L") -- Lazy changelog
vim.keymap.del({ "n" }, "<leader>e") -- Snacks file picker
vim.keymap.del({ "n" }, "<leader>E") -- Snacks file picker at root
vim.keymap.del({ "n" }, "<leader>`") -- Switch buffer
-- vim.keymap.del({ "n" }, "<leader>?") -- Buffer keymap
