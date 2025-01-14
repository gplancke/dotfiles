return {
	{
		-- Play nice with TMUX
		'alexghergh/nvim-tmux-navigation',
	},
	{
		-- lazy.nvim
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		}
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
	},
	{
		-- pack of niceties
		'echasnovski/mini.nvim',
		version = false,
	},
	{
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
				-- Use fzf for listing stuff
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			-- { "<leader>f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "<leader>f", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			-- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
			-- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
	},
	{
		-- Multi cursors
		'mg979/vim-visual-multi',
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
	},
	{
		'stevearc/quicker.nvim',
		event = "FileType qf",
		opts = {},
	},
	{
		-- Useful plugin to show you pending keybinds.
		'folke/which-key.nvim',
		opts = {}
	},
	--
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	},
	{
		'ThePrimeagen/harpoon',
	},
	-- {
	-- 	-- Play nice with TMUX, Wezterm, Kitty, etc.
	-- 	'numToStr/Navigator.nvim',
	-- 	config = function()
	-- 		vim.keymap.set({'n', 't'}, '<C-h>', '<CMD>NavigatorLeft<CR>')
	-- 		vim.keymap.set({'n', 't'}, '<C-l>', '<CMD>NavigatorRight<CR>')
	-- 		vim.keymap.set({'n', 't'}, '<C-k>', '<CMD>NavigatorUp<CR>')
	-- 		vim.keymap.set({'n', 't'}, '<C-j>', '<CMD>NavigatorDown<CR>')
	-- 	end
	-- },

	-- Deactivated as broken
	-- {
	-- 	-- Open file in nvim from within nvim
	-- 	'willothy/flatten.nvim',
	-- }
}
