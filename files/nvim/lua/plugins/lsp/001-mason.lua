return {
	-- bin management
	'williamboman/mason.nvim',
	dependencies = {
		{
			'neovim/nvim-lspconfig',
		},
		{
			-- Useful status updates for LSP
			'j-hui/fidget.nvim',
			tag = "legacy",
			opts = {}
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
			-- Some useful utils apparently
			'jose-elias-alvarez/nvim-lsp-ts-utils',
		},
		{
			-- Use LSPConfig to automatically configure installed LSP
			'williamboman/mason-lspconfig.nvim',
			dependencies = {
				'williamboman/mason.nvim',
			}
		},
		{
			-- Hijack LSP for non LSP daemons (like eslint)
			'jose-elias-alvarez/null-ls.nvim',
			dependencies = {
				-- Install and manage daemons for null-ls
				'jay-babu/mason-null-ls.nvim',
			},
		},
		{
			-- Understand the debugging protocol
			'mfussenegger/nvim-dap',
			dependencies = {
				-- Install and manage debuggers
				'jay-babu/mason-nvim-dap.nvim',
			},
		},
	},
	config = function ()
		local navic = require('nvim-navic')

		local setLSPAppearance = function(config)
			vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
				vim.lsp.diagnostic.on_publish_diagnostics,
				config
			)

			if config.virtual_text == false
			then
				vim.o.updatetime = 250
				vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
			end

			local signs = { Error = "", Warning = "", Hint = "", Information = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				local numhl = "DiagnosticDefault" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = "SignColumn", numhl = numhl })
			end
		end

		local nmapProvider = function(buffer)
			return function(keys, func, desc)
				if desc then
					desc = 'LSP: ' .. desc
				end

				vim.keymap.set('n', keys, func, { buffer = buffer, desc = desc })
			end
		end

		--  This function gets run when an LSP connects to a particular buffer.
		local on_attach = function(client, bufnr)
			local nmap = nmapProvider(bufnr)

			nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
			nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

			nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
			nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
			nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
			nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
			nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
			nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
				'[W]orkspace [S]ymbols')

			-- See `:help K` for why this keymap
			nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
			nmap('<C-S>', vim.lsp.buf.signature_help, 'Signature Documentation')

			-- Lesser used LSP functionality
			nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
			nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
			nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
			nmap('<leader>wl', function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, '[W]orkspace [L]ist Folders')

			if client.server_capabilities.documentSymbolProvider and navic then
				navic.attach(client, bufnr)
			end

			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
				vim.lsp.buf.format()
			end, { desc = 'Format current buffer with LSP' })
		end

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. They will be passed to
		--  the `settings` field of the server config. You must look up that documentation yourself.
		local servers = {
			ansiblels = {},
			clangd = {},
			tsserver = {},
			svelte = {},
			cssls = {},
			vuels = {},
			prismals = {},
			tailwindcss = {},
			-- gopls = {},
			-- pyright = {},
			-- rust_analyzer = {},

			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		}

		local nullServers = {
			eslint_d = {},
			prettierd = {},
			jq = {},
			yamlfmt = {},
		}

		local dapServers = {
			delve = {},
			["node-debug2-adapter"] = {},
			["chrome-debug-adapter"] = {},
			["bash-debug-adapter"] = {}
		}

		setLSPAppearance {
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
		}

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

		-- Setup mason so it can manage external tooling
		local mason = require 'mason'
		local null_ls = require 'null-ls'
		local mason_null_ls = require 'mason-null-ls'
		local mason_lspconfig = require 'mason-lspconfig'
		local mason_dap = require 'mason-nvim-dap'

		mason.setup()
		null_ls.setup()
		mason_lspconfig.setup {
			ensure_installed = vim.tbl_keys(servers)
		}
		mason_null_ls.setup({
			ensure_installed = vim.tbl_keys(nullServers),
			automatic_installation = true,
			automatic_setup = true,
		})
		mason_dap.setup({
			automatic_installation = true,
			ensure_installed = vim.tbl_keys(dapServers)
		})

		mason_lspconfig.setup_handlers {
			function(server_name)
				require('lspconfig')[server_name].setup {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
				}
			end,
		}
	end
}
