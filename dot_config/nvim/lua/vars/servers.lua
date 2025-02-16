return {
	servers = {
		lua_ls = {
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			}
		},
		ts_ls = {
			root_dir = require('lspconfig').util.root_pattern("tsconfig.json", "jsconfig.json", "package.json"),
			single_file_support = false
		},
		denols = {
			root_dir = require('lspconfig').util.root_pattern("deno.json", "deno.jsonc")
		},
		svelte = {},
		cssls = {},
		vuels = {},
		prismals = {},
		-- tailwindcss = {},
		-- gopls = {},
		dartls = {
			-- root_dir = require('lspconfig').util.root_pattern("pubspec.yaml"),
			cmd = { "dart", "language-server", "--protocol=lsp" },
			filetypes = { "dart" },
			init_options = {
				closingLabels = true,
				flutterOutline = true,
				onlyAnalyzeProjectsWithOpenFiles = true,
				outline = true,
				suggestFromUnimportedLibraries = true,
			},
			settings = {
				dart = {
					completeFunctionCalls = true,
					showTodos = true,
				},
			},

		},
		ansiblels = {},
		clangd = {},
		pyright = {},
		rust_analyzer = {},
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
