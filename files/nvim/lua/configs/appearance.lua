local lualine = require('lualine')
local navic = require('nvim-navic')
local git_blame = require('gitblame')
local ibl = require('ibl')

ibl.setup({
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
		theme = 'auto',
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
