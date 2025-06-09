-- Common constants used across Neovim configuration

local M = {}

-- Filetypes to exclude from various plugin features
M.excluded_filetypes = {
  "snacks_dashboard",
  "dashboard",
  "neo-tree-preview",
  "neo-tree",
  "neo-tree-popup",
  "dapui_hover",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
  "dapui_breakpoints",
  "dapui_console",
  "dap-repl",
  "Avante",
  "AvanteInput",
  "AvanteSelectedFiles",
  "help",
  "NvimTree",
}

return M
