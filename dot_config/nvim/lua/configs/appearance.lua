-- NOTE: Make sure the terminal supports this
vim.o.termguicolors = true
-- vim.o.base16colorspace = 256

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- ColorScheme
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

-- local frappe = require("catppuccin.palettes").get_palette("frappe")
local catpuccin = require("catppuccin")
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

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- BufferLine
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

-- local bufferline = require('bufferline')
-- bufferline.setup({
-- 	highlights = require("catppuccin.groups.integrations.bufferline").get {
-- 		custom = {
-- 			all = {
-- 				fill = { bg = frappe.base, fg = frappe.base },
-- 				separator = { bg = frappe.none, fg = frappe.base },
-- 				separator_selected = { bg = frappe.none, fg = frappe.base },
-- 			},
-- 		},
-- 	},
-- 	options = {
-- 		separator_style = "slant",
-- 		offsets = {
-- 			{
-- 				filetype = "neo-tree",
-- 				highlight = "Directory",
-- 				separator = true
-- 			},
-- 		}
-- 	}
-- })
--

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Indentation lines
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local indentation = require('ibl')

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


-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- StatusColumn
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local builtin = require("statuscol.builtin")
local statuscol = require("statuscol")
local statuscol_cfg = {
	-- Builtin line number string options for ScLn() segment
	thousands = false,   -- or line number thousands separator string ("." / ",")
	relculright = false, -- whether to right-align the cursor line number with 'relativenumber' set
	-- Builtin 'statuscolumn' options
	setopt = true,       -- whether to set the 'statuscolumn', providing builtin click actions
	ft_ignore = nil,     -- lua table with filetypes for which 'statuscolumn' will be unset
	bt_ignore = nil,     -- lua table with 'buftype' values for which 'statuscolumn' will be unset
	-- Default segments (fold -> sign -> line number + separator)
	segments = {
		{ text = { "%C" }, click = "v:lua.ScFa" },
		{ text = { "%s" }, click = "v:lua.ScSa" },
		{
			text = { builtin.lnumfunc, "  " },
			condition = { true, true },
			click = "v:lua.ScLa",
		}
	},
	clickhandlers = {
		Lnum                   = builtin.lnum_click,
		FoldClose              = builtin.foldclose_click,
		FoldOpen               = builtin.foldopen_click,
		FoldOther              = builtin.foldother_click,
		DapBreakpointRejected  = builtin.toggle_breakpoint,
		DapBreakpoint          = builtin.toggle_breakpoint,
		DapBreakpointCondition = builtin.toggle_breakpoint,
		DiagnosticSignError    = builtin.diagnostic_click,
		DiagnosticSignHint     = builtin.diagnostic_click,
		DiagnosticSignInfo     = builtin.diagnostic_click,
		DiagnosticSignWarn     = builtin.diagnostic_click,
		GitSignsTopdelete      = builtin.gitsigns_click,
		GitSignsUntracked      = builtin.gitsigns_click,
		GitSignsAdd            = builtin.gitsigns_click,
		GitSignsChange         = builtin.gitsigns_click,
		GitSignsChangedelete   = builtin.gitsigns_click,
		GitSignsDelete         = builtin.gitsigns_click,
	}
}

statuscol.setup(statuscol_cfg)

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- StatusLine
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local git_blame = require('gitblame')
local navic = require('nvim-navic')
local lualine = require('lualine')
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


-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Top Bar
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local winbar = require('winbar')
winbar.setup({
	enabled = true,
	show_file_path = true,
	show_symbols = true,
	colors = {
		path = '', -- You can customize colors like #c946fd
		file_name = '',
		symbols = '',
	},
	icons = {
		file_icon_default = '',
		seperator = '>',
		editor_state = '●',
		lock_icon = '',
	},
	exclude_filetype = {
		'help',
		'startify',
		'dashboard',
		'packer',
		'neogitstatus',
		'NvimTree',
		'neo-tree',
		'neo-tree-popup',
		'notify',
		'Trouble',
		'alpha',
		'lir',
		'Outline',
		'spectre_panel',
		'toggleterm',
		'terminal',
		'qf',
	}
})

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Windows and Command Palette
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local noice = require('noice')
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

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Zen Mode
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local zenmode = require('zen-mode')
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
