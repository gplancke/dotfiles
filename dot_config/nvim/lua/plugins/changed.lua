return {
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "tokyonight",
  --   },
  -- },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.enabled = function()
        local constants = require("config.custom.constants")
        return not vim.tbl_contains(constants.excluded_filetypes, vim.bo.filetype)
          and vim.bo.buftype ~= "prompt"
          and vim.b.completion ~= false
      end

      opts.keymap = {
        preset = "default",
        ["<C-n>"] = { "show", "select_next", "fallback" },
        ["<Tab>"] = { "snippet_forward", "select_and_accept", "fallback" },
        ["<C-space>"] = {
          function(cmp)
            cmp.show({ providers = { "copilot" } })
          end,
        },
      }

      return opts
    end,
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   opts = function(_, opts)
  --     opts.filesystem = opts.filesystem or {}
  --     opts.filesystem.hijack_netrw_behavior = "open_default"
  --   end,
  -- },
  {
    "yetone/avante.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.provider = "claude"

      opts.mode = "legacy" -- could be 'legacy' or 'agentic'

      opts.providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-haiku-4-5",
          disable_tools = true,
          timeout = 30000,
          extra_request_body = {
            temperature = 0,
            max_tokens = 4096,
          },
        },
      }

      opts.acp_providers = {
        ["opencode"] = {
          command = "opencode",
          args = { "acp" },
          env = {
            ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
          },
        },
        ["cursor"] = {
          command = "npx",
          args = { "@blowmage/cursor-agent-acp" },
          env = {},
        },
        ["goose"] = {
          command = "goose",
          args = { "acp" },
          env = {},
        },
      }

      return opts
    end,
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    -- init = function()
    --   local bufline = require("catppuccin.groups.integrations.bufferline")
    --   function bufline.get()
    --     return bufline.get_theme()
    --   end
    -- end,
    opts = function(_, opts)
      -- Try to always show bufferline
      opts.options = opts.options or {}
      opts.options.always_show_bufferline = true

      -- Integration with catppuccin
      if (vim.g.colors_name or ""):find("catppuccin") then
        opts.highlights = require("catppuccin.groups.integrations.bufferline").get_theme()
      end

      return opts
    end,
  },
  -- {
  --   "catppuccin/nvim",
  --   enabled = false,
  --   lazy = true,
  --   name = "catppuccin",
  --   opts = {
  --     flavour = "frappe",
  --     integrations = {
  --       aerial = true,
  --       alpha = true,
  --       blink_cmp = true,
  --       cmp = true,
  --       dashboard = true,
  --       flash = true,
  --       fzf = true,
  --       grug_far = true,
  --       gitsigns = true,
  --       headlines = true,
  --       illuminate = true,
  --       indent_blankline = { enabled = true },
  --       leap = true,
  --       lsp_trouble = true,
  --       mason = true,
  --       markdown = true,
  --       mini = true,
  --       native_lsp = {
  --         enabled = true,
  --         underlines = {
  --           errors = { "undercurl" },
  --           hints = { "undercurl" },
  --           warnings = { "undercurl" },
  --           information = { "undercurl" },
  --         },
  --       },
  --       navic = { enabled = true, custom_bg = "lualine" },
  --       neotest = true,
  --       neotree = true,
  --       noice = true,
  --       notify = true,
  --       semantic_tokens = true,
  --       snacks = true,
  --       telescope = true,
  --       treesitter = true,
  --       treesitter_context = true,
  --       which_key = true,
  --     },
  --   },
  -- },
}
