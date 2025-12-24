-- ============================================================================
-- Modern Neovim Configuration (v0.12+)
-- Uses: vim.pack (built-in package manager), vim.lsp.config/enable (new LSP API)
-- ============================================================================

-- Capture startup time
local start_time = vim.loop.hrtime()

--------------------------------------------------------------------------------
-- Globals
--------------------------------------------------------------------------------

local plugins = {
	-- Core utilities
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",

	-- TMUX navigation
	"https://github.com/alexghergh/nvim-tmux-navigation",

	-- UI enhancements
	"https://github.com/folke/noice.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/echasnovski/mini.nvim", -- includes mini.bufremove, mini.icons, mini.ai
	"https://github.com/nvim-lualine/lualine.nvim",

	-- File explorer
	"https://github.com/nvim-neo-tree/neo-tree.nvim",

	-- Editing
	"https://github.com/mg979/vim-visual-multi",
	"https://github.com/gbprod/yanky.nvim",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/folke/flash.nvim",
	"https://github.com/stevearc/quicker.nvim",
	"https://github.com/folke/which-key.nvim",

	-- -- Treesitter (base)
	"https://github.com/nvim-treesitter/nvim-treesitter",

	-- LSP
	"https://github.com/williamboman/mason.nvim",

	-- Git
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/f-person/git-blame.nvim",
	"https://github.com/esmuellert/vscode-diff.nvim",

	-- LSP extras
	"https://github.com/SmiteshP/nvim-navic",
	"https://github.com/folke/trouble.nvim",

	-- Copilot
	"https://github.com/zbirenbaum/copilot.lua",

	-- Completion (blink.cmp)
	{ src = "https://github.com/saghen/blink.cmp", version = "main" },
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/fang2hou/blink-copilot",

	-- Colorscheme
	"https://github.com/tinted-theming/tinted-nvim",

	-- Images (kitty terminal)
	"https://github.com/3rd/image.nvim",

	-- DAP (Debug Adapter Protocol)
	-- "https://github.com/mfussenegger/nvim-dap",
	-- "https://github.com/rcarriga/nvim-dap-ui",
	-- "https://github.com/nvim-neotest/nvim-nio", -- required by nvim-dap-ui
	-- "https://github.com/theHamsta/nvim-dap-virtual-text",
	-- "https://github.com/mxsdev/nvim-dap-vscode-js",
	-- { src = "https://github.com/nicholasjs/vscode-js-debug", name = "vscode-js-debug" }, -- Fork that works with nvim-dap-vscode-js
}

local no_cursor_ft = {
	"snacks_dashboard",
	"dashboard",
	"neo-tree-preview",
	"neo-tree",
	"neo-tree-popup",
	"dapui_hover",
	"dapui_scopes",
	"dapui_stacks",
	"dapui_watches",
	"dapui_breakpoints",
	"dapui_console",
	"dap-repl",
	"Avante",
	"help",
}

local no_blame_ft = {
	"help",
	"gitcommit",
	"gitrebase",
	"minimap",
	"dashboard",
	"snacks_dashboard",
	"neo-tree-preview",
	"neo-tree",
	"neo-tree-popup",
}

local no_line_ft = {
	"snacks_dashboard",
	"dashboard",
	"neo-tree-preview",
	"neo-tree",
	"neo-tree-popup",
	"dapui_hover",
	"dapui_scopes",
	"dapui_stacks",
	"dapui_watches",
	"dapui_breakpoints",
	"dapui_console",
	"dap-repl",
	"Avante",
}

local lsp_servers = {
	"lua_ls",
	"ts_ls",
	"svelte",
	"cssls",
	"pyright",
	"rust_analyzer",
	"clangd",
	"ansiblels",
	"dartls",
}

local mason_ensure_installed = {
	"lua-language-server",
	"typescript-language-server",
	"svelte-language-server",
	"css-lsp",
	"pyright",
	"rust-analyzer",
	"clangd",
	"ansible-language-server",
}

--------------------------------------------------------------------------------
-- Leader Key (must be set before plugins)
--------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------
local opt = vim.opt

-- EditorConfig (built-in since nvim 0.9)
vim.g.editorconfig = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 0 -- Use tabstop value
opt.expandtab = true
opt.breakindent = true

-- Search
opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.mouse = "a"
opt.showbreak = "___"
opt.fillchars = {
	vert = "│",
	fold = " ",
	eob = " ", -- suppress ~ at EndOfBuffer
	diff = "⣿",
	msgsep = "‾",
	foldopen = "▾",
	foldsep = "│",
	foldclose = "▸",
}

-- Completion
opt.completeopt = "menuone,noselect,fuzzy"

-- Timing
opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 300

-- Persistence
opt.undofile = true
opt.clipboard = "unnamedplus"

-- Make hyphen part of word
opt.iskeyword:append("-")

-- Git blame plugin settings
vim.g.gitblame_enabled = 1
vim.g.gitblame_display_virtual_text = 0
vim.g.gitblame_message_template = "<summary> • <date> • <author>"
vim.g.gitblame_date_format = "%c"
vim.g.gitblame_message_when_not_committed = "Not committed yet"
vim.g.gitblame_highlight_group = "Comment"
vim.g.gitblame_delay = 0
vim.g.gitblame_ignored_filetypes = no_blame_ft

-- ============================================================================
-- ============================================================================
-- Autocommands
-- ============================================================================
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserAutocommands", { clear = true })

--------------------------------------------------------------------------------
-- Cursor Column
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("ColorScheme", {
	group = augroup,
	callback = function()
		local cursorline = vim.api.nvim_get_hl(0, { link = false, name = "CursorLine" })
		vim.api.nvim_set_hl(0, "CursorColumn", { bg = cursorline.bg })
	end,
})

--------------------------------------------------------------------------------
-- Cursor Line (only in active window and for certain filetypes)
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
	group = augroup,
	callback = function()
		if not vim.tbl_contains(no_cursor_ft, vim.bo.filetype) then
			vim.wo.cursorline = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
	group = augroup,
	callback = function()
		vim.wo.cursorline = false
	end,
})

--------------------------------------------------------------------------------
-- Hook for post-install/update actions
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		-- Run treesitter update after install/update (defer to ensure plugin is loaded)
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			vim.defer_fn(function()
				if vim.fn.exists(":TSUpdate") == 2 then
					vim.cmd("TSUpdate")
				end
			end, 100)
		end
		-- Build blink.cmp fuzzy matcher (requires Rust nightly)
		if name == "blink.cmp" and (kind == "install" or kind == "update") then
			vim.notify("Building blink.cmp fuzzy matcher (requires Rust nightly)...", vim.log.levels.INFO)
			local obj = vim.system({ "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
			if obj.code == 0 then
				vim.notify("blink.cmp build complete!", vim.log.levels.INFO)
			else
				vim.notify("blink.cmp build failed. Install Rust nightly: rustup install nightly", vim.log.levels.ERROR)
			end
		end
		-- Build vscode-js-debug
		if name == "vscode-js-debug" and (kind == "install" or kind == "update") then
			vim.system({ "npm", "i", "--force" }, { cwd = ev.data.path })
			vim.system({ "npm", "run", "compile", "dapDebugServer" }, { cwd = ev.data.path })
		end
	end,
})

--------------------------------------------------------------------------------
-- Enable Treesitter features via autocommands
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	callback = function(args)
		local bufnr = args.buf
		local ft = vim.bo[bufnr].filetype

		-- Skip for certain UI filetypes
		if vim.tbl_contains(no_cursor_ft, ft) then return end

		-- Check if a parser exists for this filetype
		local ok, _ = pcall(vim.treesitter.get_parser, bufnr)
		if not ok then return end

		-- 1. Highlighting (with 100KB performance guard)
		local max_filesize = 100 * 1024
		local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr))
		if not (stats and stats.size > max_filesize) then
			vim.treesitter.start(bufnr)
		end

		-- 2. Indentation (experimental but improved)
		vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

		-- 3. Folding
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo.foldlevel = 99
	end,
})

--------------------------------------------------------------------------------
-- Attach LSP server to buffer
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf
		local navic = (function()
			local ok, mod = pcall(require, "nvim-navic")
			return ok and mod or nil
		end)()

		-- Attach navic for breadcrumbs
		if client and navic and client.server_capabilities.documentSymbolProvider then
			navic.attach(client, bufnr)
		end

		-- NOTE: blink.cmp handles completion, no need for built-in LSP completion

		-- Auto-format on save if server supports it
		if client and client:supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, { clear = true }),
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
				end,
			})
		end

		-- Create Format command
		vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
			vim.lsp.buf.format()
		end, { desc = "Format current buffer with LSP" })
	end,
})


-- ============================================================================
-- ============================================================================
-- Plugin Installation
-- ============================================================================
-- ============================================================================

vim.pack.add(plugins)

-- ============================================================================
-- ============================================================================
-- Plugin Setup (wrapped in pcall for resilience during initial install)
-- ============================================================================
-- ============================================================================

-- Helper to safely require and setup plugins
local function setup(name, opts, config)
	local ok, mod = pcall(require, name)
	if ok and mod and mod.setup then
		mod.setup(opts or {})
	end

	if config and ok and mod then
		config(mod, opts)
	end

	return ok and mod or nil
end

-- TMUX navigation
setup("nvim-tmux-navigation", {
	disable_when_zoomed = false,
	keybindings = {
		left = "<C-h>",
		down = "<C-j>",
		up = "<C-k>",
		right = "<C-l>",
	},
})

-- Noice (command line and messages UI)
-- vim.cmd("messages clear") -- Clear all messages before init
setup("noice", {
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
		inc_rename = false,
		lsp_doc_border = false,
	},
	routes = {
		-- Hide written messages
		{ filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
	},
})

-- Icons
setup('mini.icons', {}, function (mini_icons)
	package.preload["nvim-web-devicons"] = function()
		mini_icons.mock_nvim_web_devicons()
		return package.loaded["nvim-web-devicons"]
	end
end)

-- Buffer utilities
setup("mini.bufremove")

-- Treesitter extensions
setup('mini.ai')

-- Treesitter (syntax highlighting, indentation, folding)
setup("nvim-treesitter", {
	install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
}, function (ts)
	ts.install({
		"svelte", "typescript", "javascript", "python", "dart", "ruby", "rust",
		"c", "cpp", "yaml", "json", "html", "css", "vue", "tsx", "zig",
		"lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
	})
end)

-- Snacks (collection of utilities)
setup("snacks", {
	bigfile = { enabled = true },
	dashboard = {
		enabled = true,
		preset = {
			header = [[
   ██████╗ ██████╗ ██╗     ██╗  ██╗
  ██╔════╝ ██╔══██╗██║     ██║ ██╔╝
  ██║  ███╗██████╔╝██║     █████╔╝
  ██║   ██║██╔═══╝ ██║     ██╔═██╗
  ╚██████╔╝██║     ███████╗██║  ██╗
   ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝
            ]],
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.live_grep()" },
				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
				{ icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
				{ icon = "󰒲 ", key = "p", desc = "Plugins", action = ":e " .. vim.fn.stdpath("data") .. "/site/pack/core/opt" },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
		-- Custom sections without lazy.nvim startup stats
		sections = {
			{ section = "header" },
			{ section = "keys",         gap = 1,   padding = 1 },
			{ section = "recent_files", limit = 8, padding = 1, title = "Recent Files", cwd = true },
			{
				text = { "⚡ Loaded in " .. string.format("%.0f", (vim.loop.hrtime() - start_time) / 1e6) .. "ms", align = "center" },
				padding = 1,
			},
		},
	},
	indent = { enabled = true },
	input = { enabled = false },
	lazygit = { enabled = true },
	notifier = { enabled = true },
	picker = { enabled = true },
	quickfile = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = {
		enabled = true,
		left = { "mark", "sign" }, -- priority of signs on the left (high to low)
		right = { "fold", "git" }, -- priority of signs on the right (high to low)
		folds = {
			open = false,          -- show open fold icons
			git_hl = false,        -- use Git Signs hl for fold icons
		},
		git = {
			patterns = { "GitSign", "MiniDiffSign" },
		},
		refresh = 50,
	},
	words = { enabled = true },
	zen = { enabled = true },
})

-- Simple setups
setup("yanky")
setup("nvim-surround")
setup("flash")
setup("quicker")
setup("which-key", {
	win = {
		width = { min = 30, max = 60 },
		height = { min = 4, max = 25 },
		col = 99999, -- push to right edge
		border = "rounded",
		title = false,
	},
	layout = {
		align = "right",
	},
	spec = {
		{ "<leader>b",  group = "Buffer" },
		{ "<leader>c",  group = "Code" },
		{ "<leader>d",  group = "Debug" },
		{ "<leader>f",  group = "Find" },
		{ "<leader>g",  group = "Git" },
		{ "<leader>q",  group = "Quit" },
		{ "<leader>s",  group = "Search" },
		{ "<leader>sn", group = "Noice" },
		{ "<leader>u",  group = "UI" },
		{ "<leader>w",  group = "Window" },
		{ "<leader>x",  group = "Diagnostics" },
	},
})

-- Neo-tree (file explorer)
setup("neo-tree", {
	close_if_last_window = true,
	popup_border_style = "rounded",
	filesystem = {
		follow_current_file = { enabled = true },
		use_libuv_file_watcher = true,
		filtered_items = {
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
	window = {
		width = 35,
		mappings = {
			["<space>"] = "none", -- disable space so it doesn't conflict with leader
		},
	},
	default_component_configs = {
		indent = {
			with_expanders = true,
		},
	},
})

-- Gitsigns
setup("gitsigns", {
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
		untracked = { text = "▎" },
	},
	signs_staged = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
	},
})

-- VSCode-style diff
setup("vscode-diff", {
	diff = {
		disable_inlay_hints = true,
	},
	explorer = {
		position = "left",
		width = 40,
		view_mode = "tree",
	},
	keymaps = {
		view = {
			quit = "q",
			toggle_explorer = "<leader>b",
			next_hunk = "]c",
			prev_hunk = "[c",
			next_file = "]f",
			prev_file = "[f",
		},
	},
})

-- Mason (LSP/DAP/Linter/Formatter installer)
setup("mason", {
	ui = {
		border = "rounded",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- Trouble
setup("trouble")

-- Copilot (disable suggestion/panel since we use blink-copilot)
setup("copilot", {
	suggestion = { enabled = false },
	panel = { enabled = false },
	filetypes = {
		markdown = true,
		help = true,
	},
})

-- Blink.cmp (completion)
setup("blink.cmp", {
	-- Keymap preset: 'default' (C-y to accept), 'super-tab', or 'enter'
	keymap = {
		preset = "enter",
		["<C-e>"] = { "hide" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		["<CR>"] = { "accept", "fallback" },
	},

	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "mono",
	},

	completion = {
		accept = {
			auto_brackets = { enabled = true },
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		ghost_text = { enabled = true },
		list = {
			selection = { preselect = true, auto_insert = false },
		},
		menu = {
			draw = {
				columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
			},
		},
	},

	signature = { enabled = true },

	sources = {
		default = { "copilot", "lsp", "path", "snippets", "buffer" },
		providers = {
			copilot = {
				name = "copilot",
				module = "blink-copilot",
				score_offset = 100, -- Prioritize copilot suggestions
				async = true,
				opts = {
					max_completions = 3,
					max_attempts = 4,
				},
			},
		},
	},

	fuzzy = { implementation = "prefer_rust" },
})

-- Image.nvim
setup("image", {
	backend = "kitty",
	processor = "magick_cli",
})

-- Colorscheme
require("tinted-colorscheme").setup()

-- =============================================================================
-- =============================================================================
-- Lualine (statusline)
-- =============================================================================
-- =============================================================================

pcall(function()
	local git_blame = (function()
		local ok, mod = pcall(require, "gitblame")
		return ok and mod or nil
	end)()

	-- Navic (breadcrumbs) - store reference for later use
	local navic = (function()
		local ok, mod = pcall(require, "nvim-navic")
		return ok and mod or nil
	end)()

	local function breadcrumbs()
		if navic and navic.is_available() then
			return navic.get_location()
		end
		return ""
	end

	local lualine_c_section = {}

	if git_blame then
		table.insert(lualine_c_section, {
			git_blame.get_current_blame_text,
			cond = git_blame.is_blame_text_available,
		})
	end

	-- Build lualine_b: filename (parent/file) + breadcrumbs
	local lualine_b_section = {
		{
			"filename",
			path = 4, -- parent/filename
			file_status = true,
			symbols = { modified = "  ", readonly = "  ", unnamed = "[ No Name ]" },
		},
	}

	if navic then
		table.insert(lualine_b_section, { breadcrumbs, cond = navic.is_available })
	end

	setup("lualine", {
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = "|",
			section_separators = "",
			disabled_filetypes = no_line_ft
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = lualine_b_section,
			lualine_c = lualine_c_section,
			lualine_x = { "filetype" },
			lualine_y = { { "diagnostics", sources = { "nvim_diagnostic" } } },
			lualine_z = { "location", "progress" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { { "filename", path = 4, color = {} } },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
	})
end)

-- =============================================================================
-- =============================================================================
-- DAP (Debug Adapter Protocol)
-- =============================================================================
-- =============================================================================

pcall(function()
	local dap = require("dap")
	local dapui = require("dapui")

	dapui.setup()
	require("nvim-dap-virtual-text").setup()

	-- JS/TS debugging
	require("dap-vscode-js").setup({
		debugger_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/vscode-js-debug",
		adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
	})

	for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
		dap.configurations[lang] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach",
				processId = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
		}
	end
end)

-- =============================================================================
-- =============================================================================
-- LSP Configuration (vim.lsp.config/enable - nvim 0.11+)
-- =============================================================================
-- =============================================================================

-- Global LSP settings (apply to all servers)
vim.lsp.config("*", {
	root_markers = { ".git", "pnpm-lock.yaml", "bun.lock" },
})

-- Lua Language Server
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
	settings = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			runtime = { version = "LuaJIT" },
		},
	},
})

-- TypeScript/JavaScript
vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
	single_file_support = false,
})

-- Svelte
vim.lsp.config("svelte", {
	cmd = { "svelteserver", "--stdio" },
	filetypes = { "svelte" },
	root_markers = { "svelte.config.js", "svelte.config.ts", "package.json" },
})

-- CSS
vim.lsp.config("cssls", {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	root_markers = { "package.json", ".git" },
})

-- Python
vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyrightconfig.json", "pyproject.toml", "setup.py", "requirements.txt", ".git" },
})

-- Rust
vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json", ".git" },
})

-- C/C++
vim.lsp.config("clangd", {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
})

-- Ansible
vim.lsp.config("ansiblels", {
	cmd = { "ansible-language-server", "--stdio" },
	filetypes = { "yaml.ansible" },
	root_markers = { "ansible.cfg", ".ansible-lint", ".git" },
})

-- Dart
vim.lsp.config("dartls", {
	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	root_markers = { "pubspec.yaml" },
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
})

-- Enable all configured LSP servers
vim.lsp.enable(lsp_servers)

-- Configure Diagnostics
vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "●",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.INFO] = "■",
			[vim.diagnostic.severity.HINT] = "◆",
		},
	},
})

-- =============================================================================
-- =============================================================================
-- Keybindings
-- =============================================================================
-- =============================================================================

local builtin_map = vim.keymap.set

-- Checks for required modules
local function map(mode, lhs, rhs, opts, requires)
	if requires then
		for _, mod in ipairs(requires) do
			if not pcall(require, mod) then
				return
			end
		end
	end
	builtin_map(mode, lhs, rhs, opts)
end

-- Disable space in normal/visual mode (leader key)
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Better movement with word wrap (LazyVim style)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Keep visual selection after indent/outdent
map("v", "<", "<gv", { desc = "Outdent" })
map("v", ">", ">gv", { desc = "Indent" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Quit all
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Neo-tree (file explorer)
map("n", "<C-e>", "<cmd>Neotree toggle<cr>", { desc = "Explorer NeoTree (root dir)" }, { "neo-tree" })

-- Top-level pickers
map("n", "<leader><space>", function() Snacks.picker.files() end, { desc = "Find Files" }, { "snacks" })
map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" }, { "snacks" })
map("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" }, { "snacks" })
map("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" }, { "snacks" })

-- Buffers
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<C-q>", function() require("mini.bufremove").delete() end, { desc = "Delete Buffer" }, { "mini.bufremove" })

map("n", "<leader>bb", function() Snacks.picker.buffers() end, { desc = "Buffers" }, { "snacks" })
map("n", "<leader>bd", function() require("mini.bufremove").delete() end, { desc = "Delete Buffer" },
	{ "mini.bufremove" })
map("n", "<leader>bD", function() require("mini.bufremove").delete(0, true) end, { desc = "Delete Buffer (Force)" },
	{ "mini.bufremove" })
map("n", "<leader>bo", function()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
			pcall(require("mini.bufremove").delete, buf)
		end
	end
end, { desc = "Delete Other Buffers" }, { "mini.bufremove" })

-- Find
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" }, { "snacks" })
map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
	{ desc = "Find Config File" }, { "snacks" })
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" }, { "snacks" })
map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" }, { "snacks" })
map("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" }, { "snacks" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" }, { "snacks" })

-- Git
map("n", "<leader>gB", function() Snacks.picker.git_branches() end, { desc = "Git Branches" }, { "snacks" })
map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" }, { "snacks" })
map("n", "<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" }, { "snacks" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" }, { "snacks" })
map("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" }, { "snacks" })
map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" }, { "snacks" })
map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" }, { "snacks" })

-- Search
map("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" }, { "snacks" })
map("n", '<leader>s/', function() Snacks.picker.search_history() end, { desc = "Search History" }, { "snacks" })
map("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" }, { "snacks" })
map("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" }, { "snacks" })
map("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" }, { "snacks" })
map("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" }, { "snacks" })
map("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" }, { "snacks" })
map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" }, { "snacks" })
map("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" }, { "snacks" })
map("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" }, { "snacks" })
map("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" }, { "snacks" })
map("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" }, { "snacks" })
map("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" }, { "snacks" })
map("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" }, { "snacks" })
map("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" }, { "snacks" })
map("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" }, { "snacks" })
map("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" }, { "snacks" })
map("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" }, { "snacks" })
map("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" }, { "snacks" })
map("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" }, { "snacks" })
map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Grep Word" }, { "snacks" })

-- Windows
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window" })

-- Quickfix
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous Quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next Quickfix" })

-- Flash
map({ "n", "o", "x" }, "s", function() require("flash").jump() end, { desc = "Flash" }, { "flash" })
map({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" }, { "flash" })
map("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" }, { "flash" })
map({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" }, { "flash" })
map("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" }, { "flash" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })
map("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true }) end,
	{ desc = "Next Error" })
map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true }) end,
	{ desc = "Prev Error" })
map("n", "]w", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true }) end,
	{ desc = "Next Warning" })
map("n", "[w", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true }) end,
	{ desc = "Prev Warning" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" }, { "trouble" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" },
	{ "trouble" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" }, { "trouble" })
map("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions/... (Trouble)" },
	{ "trouble" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" }, { "trouble" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" }, { "trouble" })

-- Git
map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Git Blame Line" }, { "gitblame" })

-- Noice
map("n", "<leader>snd", function() require("noice").cmd("dismiss") end, { desc = "Dismiss All" }, { "noice" })
map("n", "<leader>snh", function() require("noice").cmd("history") end, { desc = "Noice History" }, { "noice" })
map("n", "<leader>snl", function() require("noice").cmd("last") end, { desc = "Noice Last Message" }, { "noice" })
map("n", "<leader>un", function() require("noice").cmd("dismiss") end, { desc = "Dismiss All Notifications" },
	{ "noice" })

-- Undo tree
map("n", "<leader>su", "<cmd>Undotree<cr>", { desc = "Undotree" })

-- DAP (Debug)
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" }, { "dap" })
map("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
	{ desc = "Breakpoint Condition" }, { "dap" })
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Run/Continue" }, { "dap" })
map("n", "<leader>dC", function() require("dap").run_to_cursor() end, { desc = "Run to Cursor" }, { "dap" })
map("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" }, { "dap" })
map("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step Out" }, { "dap" })
map("n", "<leader>dO", function() require("dap").step_over() end, { desc = "Step Over" }, { "dap" })
map("n", "<leader>dP", function() require("dap").pause() end, { desc = "Pause" }, { "dap" })
map("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate" }, { "dap" })
map("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" }, { "dap" })
map("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run Last" }, { "dap" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Dap UI" }, { "dapui" })
map({ "n", "x" }, "<leader>de", function() require("dapui").eval() end, { desc = "Eval" }, { "dapui" })

-- LSP keymaps - Snacks picker overrides gd, gD, gI, gy, gr below
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" }, { "snacks" })
map("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" }, { "snacks" })
map("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" }, { "snacks" })
map("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" }, { "snacks" })
map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" }, { "snacks" })
map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" }, { "snacks" })
map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" },
	{ "snacks" })

-- Code actions
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>cf", function() vim.lsp.buf.format() end, { desc = "Format" })
map("x", "<leader>cf", function() vim.lsp.buf.format() end, { desc = "Format" })
map("n", "<leader>cl", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP clients attached", vim.log.levels.INFO)
		return
	end
	local lines = { "LSP Clients:" }
	for _, client in ipairs(clients) do
		table.insert(lines, string.format("  • %s (id: %d)", client.name, client.id))
	end
	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Lsp Info" })

--------------------------------------------------------------------------------
-- NOTE: Default LSP keymaps in nvim 0.11+ (no need to set manually)
-- grn -> vim.lsp.buf.rename()
-- grr -> vim.lsp.buf.references()
-- gri -> vim.lsp.buf.implementation()
-- gra -> vim.lsp.buf.code_action() (normal and visual mode)
-- grt -> vim.lsp.buf.type_definition()
-- gO  -> vim.lsp.buf.document_symbol()
-- K   -> vim.lsp.buf.hover()
-- CTRL-S (insert) -> vim.lsp.buf.signature_help()
-- [d, ]d -> vim.diagnostic.jump() (navigate diagnostics)
--------------------------------------------------------------------------------

-- =============================================================================
-- =============================================================================
-- CUSTOM COMMANDS
-- =============================================================================
-- =============================================================================

--------------------------------------------------------------------------------
-- Plugin Cleanup Command
--------------------------------------------------------------------------------
vim.api.nvim_create_user_command("PackClean", function()
	local pack_path = vim.fn.stdpath("data") .. "/site/pack/core/opt"
	local lock_path = vim.fn.stdpath("config") .. "/nvim-pack-lock.json"
	local installed = vim.fn.globpath(pack_path, "*", false, true)

	-- Extract plugin names from the plugins table
	local active = {}
	for _, spec in ipairs(plugins) do
		local url = type(spec) == "string" and spec or (spec.src or spec[1])
		local name = spec.name or url:match("([^/]+)$")
		if name then
			active[name] = true
		end
	end

	local to_remove = {}
	for _, path in ipairs(installed) do
		local name = vim.fn.fnamemodify(path, ":t")
		if not active[name] then
			table.insert(to_remove, { name = name, path = path })
		end
	end

	if #to_remove == 0 then
		vim.notify("No unused plugins found", vim.log.levels.INFO)
		return
	end

	local names = vim.tbl_map(function(item) return item.name end, to_remove)
	local confirm = vim.fn.confirm(
		"Remove " .. #to_remove .. " unused plugin(s)?\n" .. table.concat(names, "\n"),
		"&Yes\n&No",
		2
	)

	if confirm == 1 then
		-- Remove plugin directories
		for _, item in ipairs(to_remove) do
			vim.fn.delete(item.path, "rf")
			vim.notify("Removed: " .. item.name, vim.log.levels.INFO)
		end

		-- Update lockfile to remove unused plugins
		if vim.fn.filereadable(lock_path) == 1 then
			local lock_content = vim.fn.readfile(lock_path)
			local ok, lock_data = pcall(vim.json.decode, table.concat(lock_content, "\n"))
			if ok and lock_data and lock_data.plugins then
				for _, item in ipairs(to_remove) do
					lock_data.plugins[item.name] = nil
				end
				-- Write with proper formatting (vim.pack expects specific format)
				local lines = { "{", '  "plugins": {' }
				local plugin_lines = {}
				for name, data in pairs(lock_data.plugins) do
					local parts = { string.format('    "%s": {', name) }
					for k, v in pairs(data) do
						table.insert(parts, string.format('      "%s": "%s",', k, v))
					end
					parts[#parts] = parts[#parts]:gsub(",$", "") -- remove trailing comma
					table.insert(parts, "    }")
					table.insert(plugin_lines, table.concat(parts, "\n"))
				end
				table.insert(lines, table.concat(plugin_lines, ",\n"))
				table.insert(lines, "  }")
				table.insert(lines, "}")
				vim.fn.writefile(vim.split(table.concat(lines, "\n"), "\n"), lock_path)
				vim.notify("Updated lockfile", vim.log.levels.INFO)
			end
		end

		vim.notify("Cleanup complete! Restart nvim to apply changes.", vim.log.levels.INFO)
	end
end, { desc = "Remove unused plugins from pack/core/opt" })

--------------------------------------------------------------------------------
-- Command to install all configured LSP servers: :MasonInstallAll
--------------------------------------------------------------------------------
vim.api.nvim_create_user_command("MasonInstallAll", function()
	local registry = require("mason-registry")
	for _, name in ipairs(mason_ensure_installed) do
		local ok, pkg = pcall(registry.get_package, name)
		if ok and not pkg:is_installed() then
			vim.notify("Mason: Installing " .. name, vim.log.levels.INFO)
			pkg:install()
		end
	end
end, { desc = "Install all configured Mason packages" })
