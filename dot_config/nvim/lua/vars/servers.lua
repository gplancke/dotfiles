return {
	servers = {
		ansiblels = {},
		clangd = {},
		tsserver = {},
		svelte = {},
		cssls = {},
		vuels = {},
		prismals = {},
		-- tailwindcss = {},
		-- gopls = {},
		-- pyright = {},
		-- rust_analyzer = {},

		lua_ls = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
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
		["bash-debug-adapter"] = {}
	}
}
