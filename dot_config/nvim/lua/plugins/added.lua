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
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          disable_tools = false, -- disable tools!
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },
      },
      mappings = {
        ask = "<leader>ia", -- ask
        edit = "<leader>ie", -- edit
        refresh = "<leader>ir", -- refresh
      },
    },
  },
}
