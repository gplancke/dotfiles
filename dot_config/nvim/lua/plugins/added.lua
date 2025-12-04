return {
  {
    "mg979/vim-visual-multi",
    lazy = true,
  },
  {
    "gpanders/editorconfig.nvim",
    lazy = true,
  },
  {
    "alexghergh/nvim-tmux-navigation",
    opts = { disable_when_zoomed = false },
  },
  {
    "tinted-theming/tinted-nvim",
    lazy = false,
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
  -- {
  --   "sudo-tee/opencode.nvim",
  --   config = function()
  --     require("opencode").setup({})
  --   end,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     {
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         anti_conceal = { enabled = false },
  --         file_types = { "markdown", "opencode_output" },
  --       },
  --       ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
  --     },
  --     "saghen/blink.cmp",
  --     "folke/snacks.nvim",
  --     -- 'nvim_mini/mini.nvim',
  --   },
  -- },
}
