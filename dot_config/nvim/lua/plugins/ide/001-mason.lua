return {
	-- bin management
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
				"mxsdev/nvim-dap-vscode-js",
				-- lazy spec to build "microsoft/vscode-js-debug" from source
				{
					"microsoft/vscode-js-debug",
					version = "1.x",
					build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
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
	config = function ()
		-- Setup mason so it can manage external tooling
		local allServers = require 'vars.servers'
		local mason = require 'mason'
		local null_ls = require 'null-ls'
		local mason_null_ls = require 'mason-null-ls'
		local mason_lspconfig = require 'mason-lspconfig'
		local mason_dap = require 'mason-nvim-dap'

		mason.setup()
		null_ls.setup()
		mason_lspconfig.setup {
			ensure_installed = vim.tbl_keys(allServers.servers)
		}
		mason_null_ls.setup({
			ensure_installed = vim.tbl_keys(allServers.nullServers),
			automatic_installation = true,
			automatic_setup = true,
		})
		mason_dap.setup({
			automatic_installation = true,
			ensure_installed = vim.tbl_keys(allServers.dapServers)
		})
	end
}
