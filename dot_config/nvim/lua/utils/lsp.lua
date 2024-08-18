local keybindings = require('vars.keybindings')
local wk = require('which-key')
local navic = require('nvim-navic')

local function update_buffer_in_code_actions(code_actions, bufnb)
	local new_code_actions = {}

	for _, action in ipairs(code_actions) do
		-- Create a new copy of the action table
		local new_action = {}
		for key, value in pairs(action) do
			new_action[key] = value
		end

		-- Update the buffer value in the new action table
		new_action.buffer = bufnb

		-- Insert the new action into the new_code_actions table
		table.insert(new_code_actions, new_action)
	end

	return new_code_actions
end

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
	wk.add(
		update_buffer_in_code_actions(keybindings.code_actions, bufnr)
	)
	wk.add(
		update_buffer_in_code_actions(keybindings.replace, bufnr)
	)
	wk.add(
		update_buffer_in_code_actions(keybindings.goto, bufnr)
	)

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
