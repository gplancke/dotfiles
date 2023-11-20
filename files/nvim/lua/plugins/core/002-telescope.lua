return {
	-- Fuzzy Finder (files, lsp, etc)
	'nvim-telescope/telescope.nvim',
	version = '*',
	dependencies = {
		{
			-- floating window library
			'nvim-lua/plenary.nvim',
		},
		{
			-- a file browser in a floating window
			'nvim-telescope/telescope-file-browser.nvim',
		},
		{
			-- Use fwf for listing stuff
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
		},
	},
	config = function ()
		local telescope_config = {
			defaults = {
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
					},
				},
			},
			extensions = {
				file_browser = {
					theme = "ivy",
					hijack_netrw = false, -- wether to hijack netrw window or not
					mappings = {
						["i"] = {
							["<C-l>"] = function(prompt_bufnr)
								vim.api.nvim_command('wall')
								vim.api.nvim_command('bufdo lua MiniBufremove.wipeout()')
								require('telescope-file-browser').actions.change_cwd(prompt_bufnr)
							end
						},
					},
				},
			},
		}

		local telescope = require('telescope')

		telescope.setup(telescope_config)
		telescope.load_extension 'file_browser'
		pcall(telescope.load_extension, 'fzf')
	end
}
