local ut = require("utils.common")

local Module = {}

local function get_js_debugger()
	-- Try to get js-debugger from mason
	-- Then from a vscode-js-debug packages
	local jsDebug = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
	local jsDebugVsCode = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/dist/src/dapDebugServer.js"

	return vim.fn.filereadable(jsDebugVsCode) == 1
		and jsDebugVsCode
		or (vim.fn.filereadable(jsDebug) and jsDebug or "")
end

function Module.setup_debugger()
	local dap = ut.prequire("dap")
	local dapui = ut.prequire("dapui")
	local dapVirt = ut.prequire("nvim-dap-virtual-text")
	local jsDebug = get_js_debugger()

	if not dap or not dapui then
		return
	end

	if jsDebug == "" then
		print("No js-debugger found")
		return
	end

	dapui.setup()

	if dapVirt then
		dapVirt.setup()
	end

	dap.adapters["pwa-chrome"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = {
				jsDebug,
				"${port}",
			},
		},
	}

	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = {
				jsDebug,
				"${port}",
			},
		},
	}

	-- Setup dap for JavaScript and TypeScript
	for _, language in ipairs({ "typescript", "javascript", "svelte", "vue", "typescriptreact" }) do
		dap.configurations[language] = {
			-- for client side debugging with chrome
			{
				type = "pwa-chrome",
				name = "Launch Chrome to debug client",
				request = "launch",
				sourceMaps = true,
				protocol = "inspector",
				port = 9222,
				webRoot = "${workspaceFolder}/src",
				url = language == "svelte" and "http://localhost:5173" or "http://localhost:3000",
				skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
			},
			-- for attaching to node js process
			{
				type = "pwa-node",
				request = "attach",
				processId = require 'dap.utils'.pick_process,
				name = "Attach debugger to existing `node --inspect` process",
				cwd = "${workspaceFolder}/src",
				sourceMaps = true,
				resolveSourceMapLocations = {
					"${workspaceFolder}/**",
					"!**/node_modules/**" },
				skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
			},
			-- For launching and debugging js files
			language == "javascript" and {
				type = "pwa-node",
				request = "launch",
				name = "Launch file in new node process",
				program = "${file}",
				cwd = "${workspaceFolder}",
			} or nil,
		}
	end

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({ reset = true })
	end
	dap.listeners.before.event_terminated["dapui_config"] = dapui.close
	dap.listeners.before.event_exited["dapui_config"] = dapui.close

end

return Module
