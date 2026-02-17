---@diagnostic disable: undefined-global
-- ============================================================================
-- Modern Neovim Configuration (v0.12+)
-- Uses: vim.pack (built-in package manager), vim.lsp.config/enable (new LSP API)
-- ============================================================================
--
-- PSA:
-- 1. We need tree-sitter-cli for nvim treesitter to compile things (which in turn needs gcc)
-- 2. We need rust, with rust nightly to compile blink.cmp
-- 3. We need to authenticate to Github for copilot to work
-- 4. We need to install lsp server separately (Done via mise)

-- Capture startup time
local start_time = vim.loop.hrtime()

--------------------------------------------------------------------------------
--Globals
--------------------------------------------------------------------------------

local plugins = {
	-- Core utilities
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",

	-- Navigation
	"https://github.com/alexghergh/nvim-tmux-navigation",

	-- Icons
	"https://github.com/nvim-tree/nvim-web-devicons",

	-- Colorscheme
	"https://github.com/tinted-theming/tinted-nvim",

	-- Necessary utilities
	"https://github.com/nvim-mini/mini.bufremove",
	"https://github.com/mg979/vim-visual-multi",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/ibhagwan/fzf-lua",

	-- Nice to have utilities
	"https://github.com/folke/which-key.nvim",
	"https://github.com/stevearc/quicker.nvim",

	-- UI enhancements
	"https://github.com/nvim-lualine/lualine.nvim",

	-- File explorer
	"https://github.com/nvim-neo-tree/neo-tree.nvim",

	-- -- Treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",

	-- Git
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/f-person/git-blame.nvim",
	"https://github.com/tpope/vim-fugitive", -- Still the goat
	-- "https://github.com/sindrets/diffview.nvim",
	-- "https://github.com/esmuellert/codediff.nvim",

	-- LSP extras
	"https://github.com/SmiteshP/nvim-navic",

	-- Copilot
	"https://github.com/zbirenbaum/copilot.lua",

	-- Completion (blink.cmp)
	{ src = "https://github.com/saghen/blink.cmp", version = "main" },
	"https://github.com/fang2hou/blink-copilot",

	-- Images (kitty terminal)
	-- "https://github.com/3rd/image.nvim",

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
	"dashboard",
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
	"vtsls",
	"svelte",
	"cssls",
	"pyright",
	"rust_analyzer",
	"clangd",
	"ansiblels",
	"dartls",
}

local binary_extensions = {
	-- images
	png = true,
	jpg = true,
	jpeg = true,
	gif = true,
	bmp = true,
	webp = true,
	ico = true,
	tiff = true,
	-- documents
	pdf = true,
	doc = true,
	docx = true,
	xls = true,
	xlsx = true,
	ppt = true,
	pptx = true,
	-- media
	mp3 = true,
	mp4 = true,
	avi = true,
	mkv = true,
	mov = true,
	flac = true,
	wav = true,
	ogg = true,
	webm = true,
	-- archives
	zip = true,
	tar = true,
	gz = true,
	bz2 = true,
	xz = true,
	["7z"] = true,
	rar = true,
	-- binaries
	exe = true,
	dll = true,
	so = true,
	dylib = true,
	o = true,
	a = true,
	-- fonts
	ttf = true,
	otf = true,
	woff = true,
	woff2 = true,
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

-- augroup AutoEqualizeSplits
--   autocmd!
--   autocmd FocusGained,FocusLost,VimResized * wincmd =
-- augroup END
vim.api.nvim_create_autocmd({ "FocusGained", "FocusLost", "VimResized" }, {
	group = augroup,
	callback = function()
		vim.api.nvim_command("wincmd =")
	end
})

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
---
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
			local obj = vim.system({ "rustup", "run", "nightly", "cargo", "build", "--release" }, { cwd = ev.data.path }):wait()
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

local function system_open(filepath)
	local cmd
	if vim.fn.has("mac") == 1 then
		cmd = { "open", filepath }
	elseif vim.fn.has("unix") == 1 then
		cmd = { "xdg-open", filepath }
	elseif vim.fn.has("win32") == 1 then
		cmd = { "cmd", "/c", "start", "", filepath }
	end
	if cmd then vim.fn.jobstart(cmd, { detach = true }) end
end

local function is_binary(path)
	local ext = (path:match("%.([^%.]+)$") or ""):lower()
	if binary_extensions[ext] then return true end
	local f = io.open(path, "rb")
	if not f then return false end
	local bytes = f:read(512)
	f:close()
	return bytes ~= nil and bytes:find("\0") ~= nil
end

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

-- Icons
setup('nvim-web-devicons')

-- Utils
setup('mini.bufremove')

-- Treesitter (syntax highlighting, indentation, folding)
setup("nvim-treesitter", {
	install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
}, function(ts)
	ts.install({
		"svelte", "typescript", "javascript", "python", "dart", "ruby", "rust",
		"c", "cpp", "yaml", "json", "html", "css", "vue", "tsx", "zig",
		"lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
	})
end)

-- fzf-lua (fuzzy finder)
setup("fzf-lua", {
	fzf_colors = true,
	winopts = { border = "rounded" },
}, function(fzf)
	-- Add ctrl-q to send selections to quickfix (extends defaults, doesn't replace)
	fzf.config.defaults.actions.files["ctrl-q"] = fzf.actions.file_sel_to_qf
	-- Add ctrl-o to open files with OS default app (force-open externally)
	fzf.config.defaults.actions.files["ctrl-o"] = function(selected)
		for _, file in ipairs(selected) do
			system_open(fzf.path.entry_to_file(file).path)
		end
	end
	-- Smart enter: auto-detect binary files and open externally
	fzf.config.defaults.actions.files["enter"] = function(selected, opts)
		local to_open_externally = {}
		local to_edit = {}
		for _, sel in ipairs(selected) do
			local path = fzf.path.entry_to_file(sel).path
			if is_binary(path) then
				table.insert(to_open_externally, path)
			else
				table.insert(to_edit, sel)
			end
		end
		for _, path in ipairs(to_open_externally) do
			system_open(path)
		end
		if #to_edit > 0 then
			fzf.actions.file_edit_or_qf(to_edit, opts)
		end
	end
end)

-- Simple setups
setup("nvim-surround")
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
		{ "<leader>b", group = "Buffer" },
		{ "<leader>c", group = "Code" },
		{ "<leader>d", group = "Debug" },
		{ "<leader>f", group = "Find" },
		{ "<leader>g", group = "Git" },
		{ "<leader>q", group = "Quit" },
		{ "<leader>s", group = "Search" },
		{ "<leader>t", group = "Tab" },
		{ "<leader>n", group = "Notification" },
		{ "<leader>u", group = "UI" },
		{ "<leader>w", group = "Window" },
		{ "<leader>x", group = "Diagnostics" },
	},
})

-- Neo-tree (file explorer)
setup("neo-tree", {
	close_if_last_window = true,
	popup_border_style = "rounded",
	commands = {
		system_open = function(state)
			local node = state.tree:get_node()
			if node and node.type == "file" then
				system_open(node.path)
			end
		end,
	},
	filesystem = {
		commands = {
			open = function(state)
				local node = state.tree:get_node()
				if not node then return end
				if node.type == "file" and is_binary(node.path) then
					system_open(node.path)
				else
					require("neo-tree.sources.filesystem.commands").open(state)
				end
			end,
		},
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
			["gx"] = "system_open", -- open with OS default app
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

-- Git
setup('fugitive')

-- Copilot
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


-- -- Colorscheme
require("tinted-nvim").setup({
	default_scheme = "base16-eighties",
	selector = {
		enabled = true,
		mode = 'cmd',
		cmd = "tinty current",
	},
	ui = {
		transparent = true,
		dim_inactive = false,
	},
})

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
			function()
				local bufname = vim.api.nvim_buf_get_name(0)
				if bufname == "" then return "[ No Name ]" end

				local manifests = {
					{ file = "package.json",  use_json_name = true },
					{ file = "Cargo.toml" },
					{ file = "go.mod" },
					{ file = "pyproject.toml" },
					{ file = "setup.py" },
				}

				local function find_manifest(start_dir)
					local dir = start_dir
					while dir and dir ~= "/" do
						for _, m in ipairs(manifests) do
							local path = dir .. "/" .. m.file
							if vim.uv.fs_stat(path) then
								local pkg_name = vim.fn.fnamemodify(dir, ":t")
								if m.use_json_name then
									local f = io.open(path, "r")
									if f then
										local content = f:read("*a")
										f:close()
										local name = content:match('"name"%s*:%s*"([^"]+)"')
										if name then pkg_name = name end
									end
								end
								return dir, pkg_name
							end
						end
						dir = vim.fn.fnamemodify(dir, ":h")
					end
					return nil, nil
				end

				local file_dir = vim.fn.fnamemodify(bufname, ":h")
				local pkg_dir, pkg_name = find_manifest(file_dir)

				local display
				if pkg_dir then
					local parent = vim.fn.fnamemodify(bufname, ":h:t")
					local fname = vim.fn.fnamemodify(bufname, ":t")
					display = "(" .. pkg_name .. ")/" .. parent .. "/" .. fname
				else
					local parent = vim.fn.fnamemodify(bufname, ":h:t")
					local fname = vim.fn.fnamemodify(bufname, ":t")
					display = parent .. "/" .. fname
				end

				if vim.bo.modified then
					display = display .. " 󰛢 "
				elseif vim.bo.readonly then
					display = display .. " 󰈞 "
				end

				return display
			end,
		},
	}

	if navic then
		table.insert(lualine_b_section, { breadcrumbs, cond = navic.is_available })
	end

	setup("lualine", {
		options = {
			icons_enabled = true,
			theme = "tinted",
			component_separators = "|",
			section_separators = "",
			disabled_filetypes = no_line_ft
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = lualine_b_section,
			lualine_c = lualine_c_section,
			lualine_x = {
				{
					function()
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						if #clients == 0 then return "" end
						local names = {}
						for _, c in ipairs(clients) do
							table.insert(names, c.name)
						end
						return " " .. table.concat(names, ", ")
					end,
					cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end,
				},
				{
					function() return "●" end,
					color = function()
						return { fg = vim.bo.modified and "#ff5555" or "#555555" }
					end,
				},
				"filetype",
			},
			lualine_y = {
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					sections = { "error", "warn", "info", "hint" },
					symbols = { error = " ", warn = " ", info = " ", hint = "◆ " },
				},
			},
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

-- TypeScript/JavaScript (using vtsls - better inlay hints support)
vim.lsp.config("vtsls", {
	cmd = { "vtsls", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
	single_file_support = true,
	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = { completeFunctionCalls = true },
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
		javascript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = { completeFunctionCalls = true },
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
	},
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

-- ========================================================
-- Disable space in normal/visual mode (leader key)
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- ========================================================
-- Better movement with word wrap (LazyVim style)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- ========================================================
-- Move lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- ========================================================
-- Keep visual selection after indent/outdent
map("v", "<", "<gv", { desc = "Outdent" })
map("v", ">", ">gv", { desc = "Indent" })

-- ========================================================
-- Clear search and flash with <esc>
map("n", "<Esc>", function()
	vim.cmd("nohlsearch")
end, { desc = "Clear search and notifications", silent = true })

-- ========================================================
-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- ========================================================
-- Filetree (file explorer)
map("n", "<C-e>", "<cmd>Neotree toggle<cr>", { desc = "Explorer NeoTree (root dir)" }, { "neo-tree" })

-- ========================================================
-- Top-level pickers
map("n", "<leader><space>", function() require("fzf-lua").files() end, { desc = "Find Files" }, { "fzf-lua" })
map("n", "<leader>/", function() require("fzf-lua").live_grep() end, { desc = "Grep" }, { "fzf-lua" })
map("n", "<leader>:", function() require("fzf-lua").command_history() end, { desc = "Command History" }, { "fzf-lua" })

-- ========================================================
-- Windows
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window" })

-- ========================================================
-- Tab
map("n", "[t", "<cmd>tabprev<cr>", { desc = "Prev Tab" })
map("n", "]t", "<cmd>tabnext<cr>", { desc = "Next Tab" })

map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>tp", "<cmd>tabprev<cr>", { desc = "Prev Tab" })
map("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next Tab" })

-- ========================================================
-- Buffers
map("n", "<C-q>", function() require("mini.bufremove").delete() end, { desc = "Delete Buffer" }, { "mini.bufremove" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

map("n", "<leader>bb", function() require("fzf-lua").buffers() end, { desc = "Buffers" }, { "fzf-lua" })
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

-- ========================================================
-- Find
map("n", "<leader>fb", function() require("fzf-lua").buffers() end, { desc = "Buffers" }, { "fzf-lua" })
map("n", "<leader>ff", function() require("fzf-lua").files() end, { desc = "Find Files" }, { "fzf-lua" })
map("n", "<leader>fg", function() require("fzf-lua").git_files() end, { desc = "Find Git Files" }, { "fzf-lua" })
map("n", "<leader>fr", function() require("fzf-lua").oldfiles() end, { desc = "Recent" }, { "fzf-lua" })

-- ========================================================
-- Git
map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Git Blame Line" }, { "gitblame" })
map("n", "<leader>gB", function() require("fzf-lua").git_branches() end, { desc = "Git Branches" }, { "fzf-lua" })
map("n", "<leader>gl", function() require("fzf-lua").git_commits() end, { desc = "Git Log" }, { "fzf-lua" })
map("n", "<leader>gL", function() require("fzf-lua").git_bcommits() end, { desc = "Git Log Line" }, { "fzf-lua" })
map("n", "<leader>gs", function() require("fzf-lua").git_status() end, { desc = "Git Status" }, { "fzf-lua" })
map("n", "<leader>gS", function() require("fzf-lua").git_stash() end, { desc = "Git Stash" }, { "fzf-lua" })
map("n", "<leader>gd", function() require("fzf-lua").git_diff({ commit = "HEAD" }) end, { desc = "Git Diff (Hunks)" },
	{ "fzf-lua" })
map("n", "<leader>gf", function() require("fzf-lua").git_bcommits() end, { desc = "Git Log File" }, { "fzf-lua" })

-- ========================================================
-- Search
map("n", '<leader>s"', function() require("fzf-lua").registers() end, { desc = "Registers" }, { "fzf-lua" })
-- map("n", "<leader>sa", function() require("fzf-lua").autocmds() end, { desc = "Autocmds" }, { "fzf-lua" })
-- map("n", "<leader>sb", function() require("fzf-lua").blines() end, { desc = "Buffer Lines" }, { "fzf-lua" })
map("n", "<leader>sc", function() require("fzf-lua").command_history() end, { desc = "Command History" }, { "fzf-lua" })
map("n", "<leader>sC", function() require("fzf-lua").commands() end, { desc = "Commands" }, { "fzf-lua" })
map("n", "<leader>sd", function() require("fzf-lua").diagnostics_workspace() end, { desc = "Diagnostics" }, { "fzf-lua" })
map("n", "<leader>sD", function() require("fzf-lua").diagnostics_document() end, { desc = "Buffer Diagnostics" },
	{ "fzf-lua" })
map("n", "<leader>sg", function() require("fzf-lua").live_grep() end, { desc = "Grep Root Files" }, { "fzf-lua" })
map("n", "<leader>sG", function() require("fzf-lua").live_grep({ grep_open_files = true }) end,
	{ desc = "Grep Open Buffers" }, { "fzf-lua" })
map("n", "<leader>sh", function() require("fzf-lua").helptags() end, { desc = "Help Pages" }, { "fzf-lua" })
-- map("n", "<leader>sH", function() require("fzf-lua").highlights() end, { desc = "Highlights" }, { "fzf-lua" })
map("n", "<leader>sj", function() require("fzf-lua").jumps() end, { desc = "Jumps" }, { "fzf-lua" })
-- map("n", "<leader>sk", function() require("fzf-lua").keymaps() end, { desc = "Keymaps" }, { "fzf-lua" })
map("n", "<leader>sl", function() require("fzf-lua").loclist() end, { desc = "Location List" }, { "fzf-lua" })
map("n", "<leader>sm", function() require("fzf-lua").marks() end, { desc = "Marks" }, { "fzf-lua" })
-- map("n", "<leader>sM", function() require("fzf-lua").manpages() end, { desc = "Man Pages" }, { "fzf-lua" })
map("n", "<leader>sq", function() require("fzf-lua").quickfix() end, { desc = "Quickfix List" }, { "fzf-lua" })
map("n", "<leader>sR", function() require("fzf-lua").resume() end, { desc = "Resume" }, { "fzf-lua" })
map("n", "<leader>ss", function() require("fzf-lua").lsp_document_symbols() end, { desc = "LSP Symbols" }, { "fzf-lua" })
map("n", "<leader>sS", function() require("fzf-lua").lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" },
	{ "fzf-lua" })
-- map("n", "<leader>sw", function() require("fzf-lua").grep_cword() end, { desc = "Grep Word" }, { "fzf-lua" })
-- map("x", "<leader>sw", function() require("fzf-lua").grep_visual() end, { desc = "Grep Word" }, { "fzf-lua" })

-- ========================================================
-- Flash
-- map({ "n", "o", "x" }, "s", function() require("flash").jump() end, { desc = "Flash" }, { "flash" })
-- map({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" }, { "flash" })
-- map("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" }, { "flash" })
-- map({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" }, { "flash" })
-- map("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" }, { "flash" })

-- ========================================================
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

-- ========================================================
-- Quickfix/Loclist/Trouble
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous Quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next Quickfix" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
-- map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" }, { "trouble" })
-- map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" },
-- 	{ "trouble" })
-- map("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" }, { "trouble" })
-- map("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions/... (Trouble)" }, { "trouble" })
-- map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" }, { "trouble" })
-- map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" }, { "trouble" })

-- ========================================================
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

-- ========================================================
-- LSP keymaps - fzf-lua overrides gd, gD, gI, gy, gr below
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("n", "gd", function() require("fzf-lua").lsp_definitions() end, { desc = "Goto Definition" }, { "fzf-lua" })
map("n", "gD", function() require("fzf-lua").lsp_declarations() end, { desc = "Goto Declaration" }, { "fzf-lua" })
map("n", "gr", function() require("fzf-lua").lsp_references() end, { nowait = true, desc = "References" }, { "fzf-lua" })
map("n", "gI", function() require("fzf-lua").lsp_implementations() end, { desc = "Goto Implementation" }, { "fzf-lua" })
map("n", "gy", function() require("fzf-lua").lsp_typedefs() end, { desc = "Goto T[y]pe Definition" }, { "fzf-lua" })

-- ========================================================
-- Code actions
map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map({ "n", "x" }, "<leader>cf", function() vim.lsp.buf.format() end, { desc = "Format" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
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

-- ========================================================
-- UI Toggles
map("n", "<leader>uh", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, { desc = "Toggle Inlay Hints" })

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
	local installed = vim.fn.globpath(pack_path, "*", false, true)

	-- Extract active plugin names from the plugins table
	local active = {}
	for _, spec in ipairs(plugins) do
		local url = type(spec) == "string" and spec or (spec.src or spec[1])
		local name = spec.name or url:match("([^/]+)$")
		if name then active[name] = true end
	end

	-- Find plugins on disk that are not in the active list
	local to_remove = {}
	for _, path in ipairs(installed) do
		local name = vim.fn.fnamemodify(path, ":t")
		if not active[name] then
			table.insert(to_remove, name)
		end
	end

	if #to_remove == 0 then
		vim.notify("No unused plugins found", vim.log.levels.INFO)
		return
	end

	local confirm = vim.fn.confirm(
		"Remove " .. #to_remove .. " unused plugin(s)?\n" .. table.concat(to_remove, "\n"),
		"&Yes\n&No",
		2
	)

	if confirm == 1 then
		vim.pack.del(to_remove, { force = true })
		vim.notify("Cleanup complete! Removed: " .. table.concat(to_remove, ", "), vim.log.levels.INFO)
	end
end, { desc = "Remove unused plugins from pack/core/opt" })


--------------------------------------------------------------------------------
-- Plugin Update Command
--------------------------------------------------------------------------------
vim.api.nvim_create_user_command("PackUpdate", function()
	vim.pack.update()
end, { desc = "Update all managed plugins" })

-- =============================================================================
-- =============================================================================
-- THIS IS THE END
-- =============================================================================
-- =============================================================================

vim.defer_fn(function()
	local ms = (vim.loop.hrtime() - start_time) / 1e6
	vim.notify(string.format("Startup: %.0fms", ms))
end, 0)
