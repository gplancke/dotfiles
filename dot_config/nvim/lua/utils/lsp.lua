local keybindings = require('vars.keybindings')
local wk = require('which-key')
local navic = require('nvim-navic')

local Module = {}

function Module.setLSPAppearance(config)
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

function Module.setLSPKeyMaps(bufnr)
	wk.register({
		c = keybindings.code_actions,
		r = keybindings.replace,
		g = keybindings.goto,
	}, { prefix = '<leader>', buffer = bufnr })

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end


function Module.setNavicWithLSP(client, bufnr)
	if client.server_capabilities.documentSymbolProvider and navic then
		navic.attach(client, bufnr)
	end
end

return Module
