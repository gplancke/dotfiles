return {
	{
		-- Respect editor config
		'gpanders/editorconfig.nvim',
	},
	{
		-- Set Root at the right spot based on key files
		'notjedi/nvim-rooter.lua',
	},
	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/vim-vsnip',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-vsnip',
			'petertriho/cmp-git',
		}
	},
	{
		-- binaries management
		'williamboman/mason.nvim',
		dependencies = {
			{
				'neovim/nvim-lspconfig',
			},
			{
				-- Hijack LSP for non LSP daemons (like eslint)
				'nvimtools/none-ls.nvim',
			},
			{
				-- Understand the debugging protocol
				'mfussenegger/nvim-dap',
				lazy = true,
				dependencies = {
					"nvim-neotest/nvim-nio",
					"rcarriga/nvim-dap-ui",
					"theHamsta/nvim-dap-virtual-text",
					"mxsdev/nvim-dap-vscode-js",
					-- lazy spec to build "microsoft/vscode-js-debug" from source
					{
						"microsoft/vscode-js-debug",
						version = "1.x",
						build = "npm i --force && npm run compile dapDebugServer"
					}
				}
			},
			{
				-- Use LSPConfig to automatically configure installed LSP
				'williamboman/mason-lspconfig.nvim',
			},
			{
				-- Integrate mason with null ls
				'jay-babu/mason-null-ls.nvim',
			},
			{
				-- Integrate mason with nvim-dap
				'jay-babu/mason-nvim-dap.nvim',
			},
			{
				-- Additional lua configuration, makes nvim stuff amazing!
				'folke/neodev.nvim',
				opts = {}
			},
			{
				-- Better LSP messages with icons
				'onsails/lspkind-nvim',
			},
			{
				-- Navic to show LSP symbols in a breadcrumb
				'SmiteshP/nvim-navic',
			},
			{
				-- Useful plugin to show you pending keybinds.
				'folke/which-key.nvim',
			}
		},
	},
	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		event = "VeryLazy",
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		dependencies = {
			-- add new text object to move faster
			'nvim-treesitter/nvim-treesitter-textobjects',
			-- Keep current code context on top (sticky)
			'nvim-treesitter/nvim-treesitter-context',
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
		},
	},
	{
		-- Add diff signs in the gutter
		'lewis6991/gitsigns.nvim',
	},
	{
		-- Show git blame in the gutter
		'f-person/git-blame.nvim',
	},
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter"
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false,
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				'MeanderingProgrammer/render-markdown.nvim',
				ft = { "markdown", "Avante" },
			},
		},
	},
	-- {
	-- 	-- Brings color cues to css
	-- 	'norcalli/nvim-colorizer.lua',
	-- },
	-- {
	-- 	-- Dart and Flutter
	-- 	"nvim-flutter/flutter-tools.nvim"
	-- }
	-- {
	--	-- Superseded by folke/snacks.nvim
	-- 	-- Indent guides
	-- 	'lukas-reineke/indent-blankline.nvim',
	-- 	main = "ibl",
	-- }
	-- {
	--	-- Old but gold git integration
	-- 	'tpope/vim-fugitive',
	-- },
	-- {
	--  -- Full github integration
	-- 	'pwntester/octo.nvim',
	-- 	config = function ()
	-- 		require('octo').setup()
	-- 	end
	-- },
	-- {
	-- 	-- Copilot
	-- 	'github/copilot.vim'
	-- },
}
