local lsp = require('lspconfig')
local lspUtils = require('utils.lsp')
local lspCmp = require('cmp_nvim_lsp')
local lspMason = require('mason-lspconfig')
local lspServers = require('vars.servers')

local capabilities = vim.lsp.protocol.make_client_capabilities()

local tst_install = require('nvim-treesitter.install')
local tst_configs = require('nvim-treesitter.configs')
local tst_context = require('treesitter-context')

local cmp = require 'cmp'
local cmp_git = require 'cmp_git'

pcall(tst_install.update { with_sync = true })
tst_install.compilers = { "gcc-13" }
tst_context.setup{
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	line_numbers = true,
	multiline_threshold = 5, -- Maximum number of lines to show for a single context
	trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- Separator between context and content. Should be a single character string, like '-'.
	-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
	separator = nil,
	zindex = 20, -- The Z-index of the context window
	on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}
tst_configs.setup {
	sync_install = true,
	modules = {},
	ignore_install = {},
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = {
		'c',
		'go',
		'lua',
		'python',
		'rust',
		'tsx',
		'typescript',
		'help',
		'vim',
		'javascript',
		'svelte',
		'nix',
		'regex',
		'markdown_inline'
	},

	-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true, disable = { 'python' } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = '<c-space>',
			node_incremental = '<c-space>',
			scope_incremental = '<c-s>',
			node_decremental = '<M-space>',
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				['aa'] = '@parameter.outer',
				['ia'] = '@parameter.inner',
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				[']m'] = '@function.outer',
				[']]'] = '@class.outer',
			},
			goto_next_end = {
				[']M'] = '@function.outer',
				[']['] = '@class.outer',
			},
			goto_previous_start = {
				['[m'] = '@function.outer',
				['[['] = '@class.outer',
			},
			goto_previous_end = {
				['[M'] = '@function.outer',
				['[]'] = '@class.outer',
			},
		},
		swap = {
			enable = true,
			swap_next = {
				['<leader>a'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>A'] = '@parameter.inner',
			},
		},
	},
}


cmp.setup {
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete({}),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
		{ name = 'buffer' },
		{ name = 'git' }
	},
}

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

cmp_git.setup()

-- vim.api.nvim_set_hl(0, "@type.typescript", { link = "Comment" })
-- vim.api.nvim_set_hl(0, "@type.definition.typescript", { link = "Comment" })

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
				lspUtils.setLSPKeyMaps(bufnr)
				lspUtils.setNavicWithLSP(client, bufnr)
			end,
			settings = lspServers.servers[server_name],
		}
	end,
}
