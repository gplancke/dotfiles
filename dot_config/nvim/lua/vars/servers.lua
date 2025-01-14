return {
	servers = {
		ansiblels = {},
		clangd = {},
		ts_ls = {
			root_dir = require('lspconfig').util.root_pattern("tsconfig.json", "jsconfig.json", "package.json"),
			single_file_support = false
		},
		svelte = {},
		cssls = {},
		vuels = {},
		prismals = {},
		denols = {
			root_dir = require('lspconfig').util.root_pattern("deno.json", "deno.jsonc")
		},
		-- tailwindcss = {},
		-- gopls = {},
		pyright = {},
		rust_analyzer = {},
		lua_ls = {
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			}
		},
	},

	nullServers = {
		eslint_d = {},
		prettierd = {},
		jq = {},
		yamlfmt = {},
	},

	dapServers = {
		delve = {},
		["node-debug2-adapter"] = {},
		["chrome-debug-adapter"] = {},
		["bash-debug-adapter"] = {},
		["js-debug-adapter"] = {}
	}
}
