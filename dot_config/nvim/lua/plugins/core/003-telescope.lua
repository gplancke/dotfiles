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
}
