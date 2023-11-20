return {
	-- Status line
	'nvim-lualine/lualine.nvim',
	dependencies = {
		'SmiteshP/nvim-navic',
	},
	config = function ()
		local lualine = require('lualine')
		local navic = require('nvim-navic')

		lualine.setup({
			options = {
				icons_enabled = true,
				theme = 'auto',
				component_separators = '|',
				section_separators = '',
				disabled_filetypes = { 'packer', 'NvimTree' },
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch' },
				-- lualine_c = { { 'filename', color = {} } },
				lualine_c = { { navic.get_location, cond = navic.is_available } },
				lualine_x = { 'filetype' },
				lualine_y = {
					{
						'diagnostics',
						sources = { 'nvim_diagnostic' },
					}
				},
				lualine_z = { 'location' }
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
	end
}
