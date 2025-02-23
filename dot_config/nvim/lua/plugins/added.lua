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
    event = "VeryLazy",
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
      },
      {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
      },
      {
        "nvim-lua/plenary.nvim",
        event = "VeryLazy",
      },
      {
        -- UI tools
        "MunifTanjim/nui.nvim",
        event = "VeryLazy",
      },
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        event = "VeryLazy",
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "claude",
      mappings = {
        ask = "<leader>ia", -- ask
        edit = "<leader>ie", -- edit
        refresh = "<leader>ir", -- refresh
      },
    },
  },
}
