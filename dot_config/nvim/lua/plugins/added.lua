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
  -- {
  --   "notjedi/nvim-rooter.lua",
  --   opts = {
  --     rooter_patterns = { ".git", ".hg", ".svn" },
  --     trigger_patterns = { "*" },
  --     manual = false,
  --   },
  -- },
  {
    "sindrets/diffview.nvim",
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    version = false,
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
      },
      {
        "stevearc/dressing.nvim",
      },
      {
        "nvim-lua/plenary.nvim",
      },
      {
        -- UI tools
        "MunifTanjim/nui.nvim",
      },
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "Avante", "AvanteInput" },
      },
    },
    opts = {
      provider = "claude",
      claude = {
        model = "claude-3-7-sonnet-20250219",
        endpoint = "https://api.anthropic.com",
        temperature = 1,
        max_tokens = 8192,
        thinking = {
          type = "enabled",
          budget_tokens = 2048,
        },
        -- disabled_tools = { "python" },
      },
      mappings = {
        ask = "<leader>ia", -- ask
        edit = "<leader>ie", -- edit
        refresh = "<leader>ir", -- refresh
      },
    },
  },
}
