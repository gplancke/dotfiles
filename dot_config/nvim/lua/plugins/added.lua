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
    "sindrets/diffview.nvim",
  },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   opts = {},
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "ravitemer/mcphub.nvim",
  --   },
  --   config = function()
  --     require("codecompanion").setup({
  --       adapters = {
  --         anthropic = function()
  --           return require("codecompanion.adapters").extend("anthropic", {
  --             env = {
  -- 						api_key = "MY_OTHER_ANTHROPIC_KEY",
  --             },
  --           })
  --         end,
  --       },
  --       strategies = {
  --         chat = {
  --           adapter = "anthropic",
  --         },
  --         inline = {
  --           adapter = "copilot",
  --         },
  --         cmd = {
  --           adapter = "anthtopic",
  --         },
  --       },
  --       extensions = {
  --         mcphub = {
  --           callback = "mcphub.extensions.codecompanion",
  --           opts = {
  --             make_vars = true,
  --             make_slash_commands = true,
  --             show_result_in_chat = true,
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "notjedi/nvim-rooter.lua",
  --   opts = {
  --     rooter_patterns = { ".git", ".hg", ".svn" },
  --     trigger_patterns = { "*" },
  --     manual = false,
  --   },
  -- },
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
        "MunifTanjim/nui.nvim",
      },
      {
        "HakonHarnes/img-clip.nvim",
      },
      {
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
