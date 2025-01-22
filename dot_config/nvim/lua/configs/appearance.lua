local ut = require('utils.common')
--
-- NOTE: Make sure the terminal supports this
vim.o.termguicolors = true
-- vim.o.base16colorspace = 256
--
--

-- This makes the cursorline and cursorcolumn have the same color
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local cursorline = vim.api.nvim_get_hl(
					0,
					{ link = false, name = "CursorLine" }
				)
        vim.api.nvim_set_hl(0, "CursorColumn", { bg = cursorline.bg })
    end,
})

-- This activates the cursorline and cursorcolumn only in normal mode
-- Applied only to the active window and for some filetypes
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
  callback = function()
    local excluded_filetypes = {
			'snacks_dashboard',
			'dashboard',
			'neo-tree-preview',
			'neo-tree',
			'neo-tree-popup',
			'dapui_hover',
			'dapui_scopes',
			'dapui_stacks',
			'dapui_watches',
			'dapui_breakpoints',
			'dapui_console',
			'dap-repl',
			'Avante',
      'help',
      'NvimTree'
    }
    local current_ft = vim.bo.filetype
    if not vim.tbl_contains(excluded_filetypes, current_ft) then
      vim.wo.cursorline = true
      -- vim.o.cursorcolumn = true
    end
  end,
})
-- Deactivate everything when leaving the window or buffer
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
  callback = function()
    vim.wo.cursorline = false
		-- vim.o.cursorcolumn = false
  end,
})

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- ColorScheme
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

-- local frappe = require("catppuccin.palettes").get_palette("frappe")
local catpuccin = ut.prequire("catppuccin")
local catpuccin_config = {
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
		snacks = true,
		-- nvim_cmp = true,
		-- nvim_dap = true,
		-- nvim_dap_signs = true,
		telescope = {
			enabled = true,
		},
		which_key = true,
	}
}

if catpuccin then
	catpuccin.setup(catpuccin_config)
	vim.cmd.colorscheme "catppuccin"
end


-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Icons
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local mini_icons = ut.prequire('mini.icons')
local web_icons = ut.prequire('nvim-web-devicons')

if mini_icons then mini_icons.setup() end
if web_icons then web_icons.setup() end

local trouble = ut.prequire('trouble')
local trouble_cfg = {}

if trouble then trouble.setup(trouble_cfg) end

local gitsigns = ut.prequire('gitsigns')

if gitsigns then
	gitsigns.setup({
		signs = {
			add = { text = '' },
			change = { text = '' },
			delete = { text = '' },
			topdelete = { text = '󰘣' },
			changedelete = { text = '' },
		},
		signs_staged = {
			add = { text = '' },
			change = { text = '' },
			delete = { text = '' },
			topdelete = { text = '󰘣' },
			changedelete = { text = '' },
			untracked    = { text = "" },
		}
	})
end

local lspUtils = ut.prequire('utils.lsp')
local lsp_cfg = {
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
}

if lspUtils then lspUtils.setLSPAppearance(lsp_cfg) end

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- BufferLine
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local palettes = ut.prequire("catppuccin.palettes")
local bufferline = ut.prequire('bufferline')
local bufferline_config = {}

if palettes then
	local frappe = palettes.get_palette("frappe")
	bufferline_config = {
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
	}
else
	bufferline_config = {
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
	}
end

if bufferline then
	bufferline.setup(bufferline_config)
end


-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Indentation lines
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local ibl = ut.prequire('ibl')
local indent_config = {
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
			'neo-tree-popup',
			'Avante'
		},
	}
}

if ibl then
	ibl.setup(indent_config)
end


-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- StatusColumn
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local builtin = ut.prequire("statuscol.builtin")
local statuscol = ut.prequire("statuscol")
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
			text = builtin and { builtin.lnumfunc, "  " } or nil,
			condition = { true, true },
			click = "v:lua.ScLa",
		}
	},
	clickhandlers = builtin and {
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
	} or nil,
}

if statuscol then
	statuscol.setup(statuscol_cfg)
end

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- StatusLine
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local git_blame = ut.prequire('gitblame')
local navic = ut.prequire('nvim-navic')
local lualine = ut.prequire('lualine')

local function breadcrumbs()
	if navic then
		return navic.get_location()
	end
end

local lualine_config = {
	options = {
		icons_enabled = true,
		theme = 'catppuccin',
		component_separators = '|',
		section_separators = '',
		disabled_filetypes = {
			'snacks_dashboard',
			'dashboard',
			'neo-tree-preview',
			'neo-tree',
			'neo-tree-popup',
			'dapui_hover',
			'dapui_scopes',
			'dapui_stacks',
			'dapui_watches',
			'dapui_breakpoints',
			'dapui_console',
			'dap-repl',
			'Avante'
		},
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch' },
		lualine_c = {
			{ git_blame and git_blame.get_current_blame_text, cond = git_blame and git_blame.is_blame_text_available }
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
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				'filename',
				path = 4,
				file_status = true,
				newfile_status = false,
				draw_empty = false,
				symbols = {
					modified = '  ',
					readonly = '  ',
					unnamed = '[ No Name ]',
					newfile = '',
				},
			}
		},
		lualine_x = {
			{ breadcrumbs, cond = navic and navic.is_available },
		},
		lualine_y = {},
		lualine_z = {}
	},
	inactive_winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				'filename',
				path = 1,
				newfile_status = false,
				draw_empty = false,
				symbols = {
					modified = '  ',
					readonly = '  ',
					unnamed = '[ No Name ]',
					newfile = '',
				},
			}
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {}
	},
}

if navic then
	navic.setup()
end

if lualine then
	lualine.setup(lualine_config)
end

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Windows and Command Palette
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local noice = ut.prequire('noice')
local noice_config = {
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
}

if noice then
	noice.setup(noice_config)
end

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Zen Mode
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local zenmode = ut.prequire('zen-mode')
local zenmode_config = {
	window = {
    backdrop = 0.8,
    width = 160,
    height = 1
	},
	plugins = {
		tmux = { enabled = true },
	}
}

if zenmode then
	zenmode.setup(zenmode_config)
end
