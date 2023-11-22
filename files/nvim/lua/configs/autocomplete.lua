local lsp = require('lspconfig')
local lspUtils = require('utils.lsp')
local lspCmp = require('cmp_nvim_lsp')
local lspMason = require('mason-lspconfig')

local lspServers = require('vars.servers')

local capabilities = vim.lsp.protocol.make_client_capabilities()

lspUtils.setLSPAppearance {
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
}

lspMason.setup_handlers {
	function(server_name)
		lsp[server_name].setup {
			capabilities = lspCmp.default_capabilities(capabilities),
			on_attach = function(client, bufnr)
				lspUtils.setLSPKeymaps(bufnr)
				lspUtils.setNavicWithLSP(client, bufnr)
			end,
			settings = lspServers.servers[server_name],
		}
	end,
}
