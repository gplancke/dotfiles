return {
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
		},
	},
	-- Add diff signs in the gutter
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},
	-- Show git blame in the gutter
	{
		'f-person/git-blame.nvim',
	}
	-- Old but gold git integration
	-- {
	-- 	'tpope/vim-fugitive',
	-- },
	-- Full github integration
	-- {
	-- 	'pwntester/octo.nvim',
	-- 	config = function ()
	-- 		require('octo').setup()
	-- 	end
	-- },
}
