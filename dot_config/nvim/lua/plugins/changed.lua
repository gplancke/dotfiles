return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      -- "Kaiser-Yang/blink-cmp-avante",
    },
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

      -- table.insert(opts.sources.default, "avante")
      -- table.insert(opts.sources.providers, {
      --   avante = {
      --     module = "blink-cmp-avante",
      --     name = "Avante",
      --   },
      -- })

      return opts
    end,
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "frappe",
      integrations = {
        aerial = true,
        alpha = true,
        blink_cmp = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    init = function()
      local bufline = require("catppuccin.groups.integrations.bufferline")
      function bufline.get()
        return bufline.get_theme()
      end
    end,
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
}
