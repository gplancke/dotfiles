local ut = require("utils.common")

local Module = {}

function Module.setup_debugger()
	local dap = ut.prequire("dap")
	local dapui = ut.prequire("dapui")
	local dapVirt = ut.prequire("nvim-dap-virtual-text")
	-- local dapVsCode = ut.prequire("dap-vscode-js")

	if not dap or not dapui then
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
				vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/dist/src/dapDebugServer.js",
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
				vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/dist/src/dapDebugServer.js",
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
