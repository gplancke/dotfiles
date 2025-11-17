-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Change working directory to project root on startup
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("change_to_root", { clear = true }),
  callback = function()
    local root = LazyVim.root()
    print("Project root: ", root)
    if root and root ~= vim.fn.getcwd() then
      vim.cmd.cd(root)
    end
  end,
})

vim.filetype.add({
  extension = {
    ["env.json"] = "json",
  },
  pattern = {
    [".*%.env%.json"] = "json",
  },
  filename = {
    [".env.json"] = "json",
  },
})

-- local theme_script_path = vim.fn.expand("~/.local/share/tinted-theming/tinty/base16-vim-colors-file.vim")
--
-- local function file_exists(file_path)
--   return vim.fn.filereadable(file_path) == 1 and true or false
-- end
--
-- local function handle_focus_gained()
--   if file_exists(theme_script_path) then
--     vim.cmd("source " .. theme_script_path)
--   end
-- end
--
-- if file_exists(theme_script_path) then
--   vim.o.termguicolors = true
--   vim.g.tinted_colorspace = 256
--
--   vim.cmd("source " .. theme_script_path)
--
--   vim.api.nvim_create_autocmd("FocusGained", {
--     callback = handle_focus_gained,
--   })
-- end
