return {
  {
    "mg979/vim-visual-multi",
  },
  {
    "gpanders/editorconfig.nvim",
  },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup({
        disable_when_zoomed = false,
      })
    end,
  },
  {
    "tinted-theming/tinted-nvim",
    config = function()
      require("tinted-colorscheme").setup()
    end,
  },
  -- {
  --   "landerson02/ghostty-theme-sync.nvim",
  -- },
  -- {
  --   "chriskempson/base16-vim",
  -- },
  -- {
  --   "notjedi/nvim-rooter.lua",
  --   config = function()
  --     require("nvim-rooter").setup({
  --       rooter_patterns = { ".git", ".hg", ".svn", "pnpm-lock.yaml", "pnpm-workspace.yaml", "lazy-lock.json" },
  --       trigger_patterns = { "*" },
  --       manual = false,
  --       cd_scope = "global",
  --     })
  --   end,
  -- },
}
