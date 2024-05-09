local lualine = require('lualine')
local navic = require('nvim-navic')
local git_blame = require('gitblame')
local indentation = require('ibl')
local noice = require('noice')
local catpuccin = require("catppuccin")
local frappe = require("catppuccin.palettes").get_palette("frappe")
local bufferline = require('bufferline')
local zenmode = require('zen-mode')

-- NOTE: Make sure the terminal supports this
vim.o.termguicolors = true
vim.o.base16colorspace = 256

catpuccin.setup({
	flavour = 'frappe',
	integrations = {
		cmp = true,
		dashboard = true,
		flash = true,
		gitsigns = true,
		harpoon = true,
		lsp_trouble = true,
		mason = true,
		neotree = true,
		noice = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
			inlay_hints = {
				background = true,
			},
		},
		-- nvim_cmp = true,
		-- nvim_dap = true,
		-- nvim_dap_signs = true,
		telescope = {
			enabled = true,
		},
		which_key = true,
	}
})

vim.cmd.colorscheme "catppuccin"

bufferline.setup({
	highlights = require("catppuccin.groups.integrations.bufferline").get {
		custom = {
			all = {
				fill = { bg = frappe.base, fg = frappe.base },
				separator = { bg = frappe.none, fg = frappe.base },
				separator_selected = { bg = frappe.none, fg = frappe.base },
			},
		},
	},
	options = {
		separator_style = "slant",
		offsets = {
			{
				filetype = "neo-tree",
				highlight = "Directory",
				separator = true
			},
		}
	}
})

indentation.setup({
	scope = {
		enabled = false,
	},
	exclude = {
		filetypes = {
			'help',
			'minimap',
			'dashboard',
			'NvimTree',
			'neo-tree-preview',
			'neo-tree',
			'neo-tree-popup'
		},
	}
})

vim.g.gitblame_enabled = 1
vim.g.gitblame_display_virtual_text = 0
vim.g.gitblame_message_template = '<summary> • <date> • <author>'
vim.g.gitblame_date_format = '%c'
vim.g.gitblame_message_when_not_committed = 'Not committed yet'
vim.g.gitblame_highlight_group = 'Comment'
vim.g.gitblame_delay = 0
vim.g.gitblame_ignored_filetypes = {
	'help',
	'gitcommit',
	'gitrebase',
	'minimap',
	'dashboard',
	'NvimTree',
	'neo-tree-preview',
	'neo-tree',
	'neo-tree-popup'
}

lualine.setup({
	options = {
		icons_enabled = true,
		theme = 'catppuccin',
		component_separators = '|',
		section_separators = '',
		disabled_filetypes = {
			'dashboard',
			'neo-tree-preview',
			'neo-tree',
			'neo-tree-popup'
		},
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch' },
		-- lualine_c = { { 'filename', color = {} } },
		lualine_c = {
			{ navic.get_location, cond = navic.is_available },
			{ git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }
		},
		lualine_x = { 'filetype' },
		lualine_y = {
			{
				'diagnostics',
				sources = { 'nvim_diagnostic' },
			}
		},
		lualine_z = { 'location', 'progress' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { 'filename', color = {} } },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
})

noice.setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

zenmode.setup({
	window = {
    backdrop = 0.8,
    width = 160,
    height = 1
	},
	plugins = {
		tmux = { enabled = true },
	}
})
