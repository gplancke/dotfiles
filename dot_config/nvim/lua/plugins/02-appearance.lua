return {
	{
		-- Status line
		'nvim-lualine/lualine.nvim',
		event = "VeryLazy",
		dependencies = {
			'SmiteshP/nvim-navic',
			'f-person/git-blame.nvim',
		},
	},
	{
		-- Web Icons to be fancy
		'nvim-tree/nvim-web-devicons',
	},
	{
		-- Colorscheme
		'catppuccin/nvim',
		lazy = true,
		name = 'catppuccin'
	},
-- {
--   -- Superseded by folke/snacks
--   "luukvbaal/statuscol.nvim"
-- },
-- {
--   -- Don't like it so much
--   'akinsho/bufferline.nvim',
--   version = "*",
--   dependencies = 'nvim-tree/nvim-web-devicons',
-- },
-- {
--   -- Superseded by folke/snacks.nvim scroll
--   -- Physics scrolling
--   'yuttie/comfortable-motion.vim',
-- },
-- {
--	-- Superseeded by snacks dashboard
--	'nvimdev/dashboard-nvim',
--	event = 'VimEnter',
--	config = function()
--		require('dashboard').setup {
--			theme = 'hyper',
--			section = {}
--		}
--   end,
--   dependencies = { {'nvim-tree/nvim-web-devicons'}}
-- },
-- {
--	-- Superseded by `folke/snacks.nvim`
-- 	'folke/zen-mode.nvim',
-- 	dependencies = {
-- 		{ "folke/twilight.nvim" }
-- 	}
-- }
}
