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

-- Eagerly load vim.uri to avoid intermittent lazy-load failures on HEAD builds
pcall(require, 'vim.uri')

-- Snacks image detection can miss Ghostty behind tmux when tmux uses
-- `extended-keys always`; force the known outer terminal for image previews.
if (vim.env.GHOSTTY_BIN_DIR or vim.env.GHOSTTY_RESOURCES_DIR) and not vim.env.SNACKS_GHOSTTY then
	vim.env.SNACKS_GHOSTTY = "true"
end

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
	"https://github.com/mg979/vim-visual-multi",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/folke/snacks.nvim",

	-- Nice to have utilities
	"https://github.com/folke/which-key.nvim",
	"https://github.com/stevearc/quicker.nvim",

	-- UI enhancements
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/saghen/blink.indent",

	-- File explorer
	"https://github.com/nvim-neo-tree/neo-tree.nvim",

	-- Treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

	-- Git
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/f-person/git-blame.nvim",
	"https://github.com/tpope/vim-fugitive", -- Still the goat

	-- LSP extras
	"https://github.com/SmiteshP/nvim-navic",

	-- Completion (blink.cmp)
	{ src = "https://github.com/saghen/blink.cmp", version = "main" },
	-- (removed: copilot.lua, blink-copilot)

	-- DAP (Debug Adapter Protocol)
	-- "https://github.com/mfussenegger/nvim-dap",
	-- "https://github.com/rcarriga/nvim-dap-ui",
	-- "https://github.com/nvim-neotest/nvim-nio", -- required by nvim-dap-ui
	-- "https://github.com/theHamsta/nvim-dap-virtual-text",
	-- "https://github.com/mxsdev/nvim-dap-vscode-js",
	-- { src = "https://github.com/nicholasjs/vscode-js-debug", name = "vscode-js-debug" }, -- Fork that works with nvim-dap-vscode-js

	-- Terminal
	-- "https://github.com/willothy/flatten.nvim",
	-- "https://github.com/3rd/image.nvim",
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

local ts_parsers = {
	"svelte", "typescript", "javascript", "python", "dart", "ruby", "rust",
	"c", "cpp", "yaml", "json", "html", "css", "vue", "tsx", "zig",
	"lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
}
local ts_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site")

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
	png = true,
	jpg = true,
	jpeg = true,
	gif = true,
	bmp = true,
	webp = true,
	ico = true,
	tiff = true,
	pdf = true,
	doc = true,
	docx = true,
	xls = true,
	xlsx = true,
	ppt = true,
	pptx = true,
	mp3 = true,
	mp4 = true,
	avi = true,
	mkv = true,
	mov = true,
	flac = true,
	wav = true,
	ogg = true,
	webm = true,
	zip = true,
	tar = true,
	gz = true,
	bz2 = true,
	xz = true,
	["7z"] = true,
	rar = true,
	exe = true,
	dll = true,
	so = true,
	dylib = true,
	o = true,
	a = true,
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

-- Markdown: soft wrap, no hard line breaks
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.textwidth = 0
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

--------------------------------------------------------------------------------
-- Neovide settings
--------------------------------------------------------------------------------
if vim.g.neovide then
	vim.o.guifont = "FiraMono Nerd Font:h10:b"

	-- GUI apps on macOS don't inherit shell PATH.
	-- Ensure mise shims are available for LSP servers and tools.
	local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
	local mise_bin = vim.fn.expand("~/.local/bin")
	for _, dir in ipairs({ mise_bin, mise_shims }) do
		if vim.fn.isdirectory(dir) == 1 and not vim.env.PATH:find(dir, 1, true) then
			vim.env.PATH = dir .. ":" .. vim.env.PATH
		end
	end
	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_left = 0
	vim.g.neovide_hide_mouse_when_typing = true
	-- vim.g.neovide_cursor_animation_length = 0.05
	-- vim.g.neovide_scroll_animation_length = 0.1
end

-- ============================================================================
-- ============================================================================
-- Global Helpers
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

local function setup(name, opts, config)
	local ok, mod = pcall(require, name)
	if not (ok and mod) then
		return nil
	end

	if config then
		local config_ok, configured = pcall(config, mod, opts or {})
		if not config_ok then
			vim.notify(("Failed to configure %s: %s"):format(name, configured), vim.log.levels.ERROR)
			return mod
		elseif configured == false then
			return mod
		elseif configured ~= nil then
			opts = configured
		end
	end

	if mod.setup then
		local setup_ok, err = pcall(mod.setup, opts or {})
		if not setup_ok then
			vim.notify(("Failed to setup %s: %s"):format(name, err), vim.log.levels.ERROR)
		end
	end

	return mod
end

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
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave", "FocusGained" }, {
	group = augroup,
	callback = function()
		if not vim.tbl_contains(no_cursor_ft, vim.bo.filetype) then
			vim.wo.cursorline = true
			vim.wo.cursorcolumn = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter", "FocusLost" }, {
	group = augroup,
	callback = function()
		vim.wo.cursorline = false
		vim.wo.cursorcolumn = false
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
			pcall(vim.treesitter.start, bufnr)
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
-- Plugin Setup
-- ============================================================================
-- ============================================================================

--------------------------------------------------------------------------------
-- Configure Breadcrumbs in cmdline area when idle
--------------------------------------------------------------------------------
do
	local last_cmd_time = 0

	local function truncate_cmdline_message(text)
		text = tostring(text):gsub("[%r\n]+", " ")

		local max_width = tonumber(vim.v.echospace) or 0
		if max_width <= 0 then
			max_width = vim.o.columns - 1
		else
			max_width = math.min(max_width, vim.o.columns - 1)
		end
		max_width = math.max(max_width, 0)

		if max_width == 0 then return "" end
		if vim.api.nvim_strwidth(text) <= max_width then return text end

		local prefix = "…"
		if max_width <= vim.api.nvim_strwidth(prefix) then return "" end

		while vim.api.nvim_strwidth(prefix .. text) > max_width do
			local rest = vim.fn.strcharpart(text, 1)
			if rest == "" or rest == text then break end
			text = rest
		end

		return prefix .. text
	end

	vim.api.nvim_create_autocmd("CmdlineLeave", {
		group = vim.api.nvim_create_augroup("NavicCmdline", { clear = true }),
		callback = function()
			last_cmd_time = vim.uv.hrtime()
		end,
	})

	vim.api.nvim_create_autocmd("CursorHold", {
		group = "NavicCmdline",
		callback = function()
			-- Don't overwrite recent command output (1s grace period)
			if (vim.uv.hrtime() - last_cmd_time) / 1e9 < 1 then return end

			local ok, navic = pcall(require, "nvim-navic")
			if ok and navic.is_available() then
				local loc = navic.get_location()
				if loc and loc ~= "" then
					loc = truncate_cmdline_message(loc)
					if loc == "" then return end

					vim.cmd("redraw")
					vim.api.nvim_echo({ { loc, "Comment" } }, false, { id = "user.navic.cmdline" })
				end
			end
		end,
	})
end

--------------------------------------------------------------------------------
-- Configure snacks Terminal with info at startup
--------------------------------------------------------------------------------
local function preseed_snacks_ghostty_terminal(force)
	if not (force or vim.env.TMUX) then return end
	if vim.env.SNACKS_GHOSTTY == "0" or vim.env.SNACKS_GHOSTTY == "false" then return end
	if not (force or vim.env.SNACKS_GHOSTTY or vim.env.GHOSTTY_BIN_DIR or vim.env.GHOSTTY_RESOURCES_DIR) then return end

	local ok, terminal = pcall(require, "snacks.image.terminal")
	if ok then
		terminal._terminal = { terminal = "ghostty", version = "unknown" }
		pcall(vim.fn.system, { "tmux", "set", "-p", "allow-passthrough", "all" })
		terminal.transform = function(data)
			return ("\027Ptmux;" .. data:gsub("\027", "\027\027")) .. "\027\\"
		end
		terminal._env = {
			name = "ghostty/tmux",
			env = {},
			supported = true,
			placeholders = true,
			transform = terminal.transform,
		}
	end
end

_G.UserPreseedSnacksGhosttyTerminal = preseed_snacks_ghostty_terminal
preseed_snacks_ghostty_terminal()

-- Flatten (prevent nested neovim - must load early)
-- setup("flatten", {
-- 	window = { open = "alternate" },
-- 	hooks = {
-- 		should_block = function(argv)
-- 			return vim.tbl_contains(argv, "-b")
-- 		end,
-- 		post_open = function(_, _, _, is_blocking)
-- 			if is_blocking then
-- 				Snacks.terminal.toggle()
-- 			end
-- 		end,
-- 		block_end = function()
-- 			Snacks.terminal.toggle()
-- 		end,
-- 	},
-- })


-- TMUX navigation (plugin falls back to native <C-w> navigation when $TMUX is unset)
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

setup("nvim-treesitter", { install_dir = ts_install_dir }, function(ts)
	ts.setup({ install_dir = ts_install_dir })
	ts.install(ts_parsers)
	return false
end)

setup("nvim-treesitter-textobjects", {
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v",
			["@parameter.inner"] = "v",
			["@function.outer"] = "V",
			["@function.inner"] = "V",
			["@class.outer"] = "V",
			["@class.inner"] = "V",
			["@loop.outer"] = "V",
			["@loop.inner"] = "V",
			["@conditional.outer"] = "V",
			["@conditional.inner"] = "V",
		},
		include_surrounding_whitespace = false,
	},
	move = {
		set_jumps = true,
	},
})

setup("snacks", {
	picker = {
		ui_select = true,
	},
	image = {
		enabled = true,
	},
	terminal = {
		win = {
			border = "rounded",
		},
	},
	lazygit = {
		enabled = true,
	},
	bufdelete = {
		enabled = true,
	},
}, function(snacks, opts)
	local function item_path(item)
		if not item then return nil end
		local ok, util = pcall(require, "snacks.picker.util")
		if ok then
			local path = util.path(item)
			if path then return path end
		end
		return item.file or item.path
	end

	local function picker_system_open(picker)
		for _, item in ipairs(picker:selected({ fallback = true })) do
			local path = item_path(item)
			if path then system_open(path) end
		end
		picker:close()
	end

	local function file_confirm(picker, item, action)
		local actions = require("snacks.picker.actions")
		local selected = picker:selected({ fallback = true })
		local external, editable = false, {}

		for _, selected_item in ipairs(selected) do
			local path = item_path(selected_item)
			if path and is_binary(path) then
				external = true
				system_open(path)
			elseif path then
				table.insert(editable, path)
			end
		end

		if not external then
			return actions.jump(picker, item, action)
		end

		picker:close()
		for _, path in ipairs(editable) do
			vim.cmd.edit(vim.fn.fnameescape(path))
		end
	end

	local file_picker = {
		confirm = "smart_confirm",
		win = {
			input = {
				keys = {
					["<c-o>"] = { "system_open", mode = { "i", "n" } },
				},
			},
			list = {
				keys = {
					["<c-o>"] = "system_open",
				},
			},
		},
	}

	return vim.tbl_deep_extend("force", opts, {
		picker = {
			actions = {
				smart_confirm = file_confirm,
				system_open = picker_system_open,
			},
			sources = {
				files = vim.deepcopy(file_picker),
				git_files = vim.deepcopy(file_picker),
				recent = vim.deepcopy(file_picker),
			},
		},
	})
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
		{ "<leader>a", group = "AI" },
		{ "<leader>b", group = "Buffer" },
		{ "<leader>c", group = "Code" },
		{ "<leader>d", group = "Debug" },
		{ "<leader>f", group = "Find" },
		{ "<leader>g", group = "Git" },
		{ "<leader>q", group = "Quit" },
		{ "<leader>s", group = "Search" },
		{ "<leader>t", group = "Tab" },
		{ "<leader>n", group = "Notification" },
		{ "<leader>o", group = "Objects" },
		{ "<leader>u", group = "UI" },
		{ "<leader>w", group = "Window" },
		{ "<leader>x", group = "Diagnostics" },
		{ "<leader>p", group = "Project" },
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
		follow_current_file = { enabled = false },
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

-- Indent guides
setup('blink-indent')

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
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {
			-- copilot = {
			-- 	name = "copilot",
			-- 	module = "blink-copilot",
			-- 	score_offset = 100, -- Prioritize copilot suggestions
			-- 	async = true,
			-- 	opts = {
			-- 		max_completions = 3,
			-- 		max_attempts = 4,
			-- 	},
			-- },
		},
	},

	fuzzy = { implementation = "prefer_rust" },
})


require("tinted-nvim").setup({
	default_scheme = "base16-eighties",
	selector = {
		enabled = true,
		mode = 'cmd',
		cmd = "tinty current",
	},
	ui = {
		transparent = not vim.g.neovide,
		dim_inactive = vim.g.neovide,
	},
})

setup("lualine", nil, function()
	local git_blame = (function()
		local ok, mod = pcall(require, "gitblame")
		return ok and mod or nil
	end)()

	local lualine_c_section = {}

	if git_blame then
		table.insert(lualine_c_section, {
			git_blame.get_current_blame_text,
			cond = git_blame.is_blame_text_available,
		})
	end

	local lualine_b_section = {
		{
			function()
				local bufname = vim.api.nvim_buf_get_name(0)
				if bufname == "" then return "[ No Name ]" end
				if bufname:match("^%w+://") then return vim.fn.fnamemodify(bufname, ":t") end

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

	return {
		options = {
			icons_enabled = true,
			theme = "tinted",
			component_separators = "|",
			section_separators = "",
			disabled_filetypes = no_line_ft,
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
	}
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
-- Treesitter text objects
local function ts_select(query, source)
	return function()
		require("nvim-treesitter-textobjects.select").select_textobject(query, source or "textobjects")
	end
end

local function ts_move(method, query, source)
	return function()
		require("nvim-treesitter-textobjects.move")[method](query, source or "textobjects")
	end
end

local function ts_swap(method, query)
	return function()
		require("nvim-treesitter-textobjects.swap")[method](query)
	end
end

map({ "x", "o" }, "af", ts_select("@function.outer"), { desc = "Outer Function" },
	{ "nvim-treesitter-textobjects.select" })
map({ "x", "o" }, "if", ts_select("@function.inner"), { desc = "Inner Function" },
	{ "nvim-treesitter-textobjects.select" })
map({ "x", "o" }, "ac", ts_select("@class.outer"), { desc = "Outer Class" },
	{ "nvim-treesitter-textobjects.select" })
map({ "x", "o" }, "ic", ts_select("@class.inner"), { desc = "Inner Class" },
	{ "nvim-treesitter-textobjects.select" })
map({ "x", "o" }, "aa", ts_select("@parameter.outer"), { desc = "Outer Argument" },
	{ "nvim-treesitter-textobjects.select" })
map({ "x", "o" }, "ia", ts_select("@parameter.inner"), { desc = "Inner Argument" },
	{ "nvim-treesitter-textobjects.select" })
map({ "x", "o" }, "al", ts_select("@loop.outer"), { desc = "Outer Loop" },
	{ "nvim-treesitter-textobjects.select" })
map({ "x", "o" }, "il", ts_select("@loop.inner"), { desc = "Inner Loop" },
	{ "nvim-treesitter-textobjects.select" })
map({ "x", "o" }, "ad", ts_select("@conditional.outer"), { desc = "Outer Conditional" },
	{ "nvim-treesitter-textobjects.select" })
map({ "x", "o" }, "id", ts_select("@conditional.inner"), { desc = "Inner Conditional" },
	{ "nvim-treesitter-textobjects.select" })

map({ "n", "x", "o" }, "]m", ts_move("goto_next_start", "@function.outer"), { desc = "Next Function Start" },
	{ "nvim-treesitter-textobjects.move" })
map({ "n", "x", "o" }, "[m", ts_move("goto_previous_start", "@function.outer"), { desc = "Prev Function Start" },
	{ "nvim-treesitter-textobjects.move" })
map({ "n", "x", "o" }, "]M", ts_move("goto_next_end", "@function.outer"), { desc = "Next Function End" },
	{ "nvim-treesitter-textobjects.move" })
map({ "n", "x", "o" }, "[M", ts_move("goto_previous_end", "@function.outer"), { desc = "Prev Function End" },
	{ "nvim-treesitter-textobjects.move" })
map({ "n", "x", "o" }, "]]", ts_move("goto_next_start", "@class.outer"), { desc = "Next Class Start" },
	{ "nvim-treesitter-textobjects.move" })
map({ "n", "x", "o" }, "[[", ts_move("goto_previous_start", "@class.outer"), { desc = "Prev Class Start" },
	{ "nvim-treesitter-textobjects.move" })
map({ "n", "x", "o" }, "][", ts_move("goto_next_end", "@class.outer"), { desc = "Next Class End" },
	{ "nvim-treesitter-textobjects.move" })
map({ "n", "x", "o" }, "[]", ts_move("goto_previous_end", "@class.outer"), { desc = "Prev Class End" },
	{ "nvim-treesitter-textobjects.move" })

map("n", "<leader>oa", ts_swap("swap_next", "@parameter.inner"), { desc = "Swap Next Argument" },
	{ "nvim-treesitter-textobjects.swap" })
map("n", "<leader>oA", ts_swap("swap_previous", "@parameter.outer"), { desc = "Swap Previous Argument" },
	{ "nvim-treesitter-textobjects.swap" })

do
	local ok, ts_repeat_move = pcall(require, "nvim-treesitter-textobjects.repeatable_move")
	if ok then
		map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat Next Move" })
		map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { desc = "Repeat Prev Move" })
		map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true, desc = "Find Forward" })
		map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true, desc = "Find Backward" })
		map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true, desc = "Till Forward" })
		map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true, desc = "Till Backward" })
	end
end

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
map("n", "<leader>e", "<cmd>Neotree reveal<cr>", { desc = "Reveal file in NeoTree" }, { "neo-tree" })

-- ========================================================
-- Top-level pickers
map("n", "<leader><space>", function() Snacks.picker.files() end, { desc = "Find Files" }, { "snacks" })
map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" }, { "snacks" })
map("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" }, { "snacks" })

-- ========================================================
-- Windows
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window" })

-- Terminal splits
map("n", "<leader>wh", function()
	vim.cmd("leftabove vsplit | terminal")
end, { desc = "Terminal Left" })
map("n", "<leader>wj", function()
	vim.cmd("rightbelow split | terminal")
end, { desc = "Terminal Below" })
map("n", "<leader>wk", function()
	vim.cmd("leftabove split | terminal")
end, { desc = "Terminal Above" })
map("n", "<leader>wl", function()
	vim.cmd("rightbelow vsplit | terminal")
end, { desc = "Terminal Right" })

-- ========================================================
-- Tab
map("n", "[t", "<cmd>tabprev<cr>", { desc = "Prev Tab" })
map("n", "]t", "<cmd>tabnext<cr>", { desc = "Next Tab" })

map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>tp", "<cmd>tabprev<cr>", { desc = "Prev Tab" })
map("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next Tab" })

-- ========================================================
-- Buffers
map("n", "<C-q>", function()
	if vim.bo.buftype == "terminal" then return end
	Snacks.bufdelete()
end, { desc = "Delete Buffer" }, { "snacks" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

map("n", "<leader>bb", function() Snacks.picker.buffers() end, { desc = "Buffers" }, { "snacks" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" }, { "snacks" })
map("n", "<leader>bD", function() Snacks.bufdelete({ force = true }) end, { desc = "Delete Buffer (Force)" },
	{ "snacks" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" }, { "snacks" })

-- ========================================================
-- Find
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" }, { "snacks" })
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" }, { "snacks" })
map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" }, { "snacks" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" }, { "snacks" })

-- ========================================================
-- Git
map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Git Blame Line" }, { "gitblame" })
map("n", "<leader>gB", function() Snacks.picker.git_branches() end, { desc = "Git Branches" }, { "snacks" })
map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" }, { "snacks" })
map("n", "<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" }, { "snacks" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" }, { "snacks" })
map("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" }, { "snacks" })
map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" }, { "snacks" })
map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" }, { "snacks" })

-- ========================================================
-- Terminal
local function snacks_float_terminal_toggle()
	Snacks.terminal.toggle(nil, {
		win = {
			position = "float",
			border = "rounded",
		},
	})
end

local function snacks_current_terminal()
	local buf = vim.api.nvim_get_current_buf()
	for _, term in ipairs(Snacks.terminal.list()) do
		if term.buf == buf and term:valid() then
			return term
		end
	end
end

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("n", [[<C-\>]], snacks_float_terminal_toggle, { desc = "Terminal" }, { "snacks" })
map("t", [[<C-\>]], function()
	local term = snacks_current_terminal()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, false, true), "n", false)
	if term then
		vim.schedule(function()
			term:hide()
		end)
	end
end, { desc = "Terminal" }, { "snacks" })

-- Lazygit (stateful floating terminal)
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" }, { "snacks" })

-- Claude Code (stateful vertical terminal)
map("n", "<leader>ai", function()
	Snacks.terminal.toggle("env -u NVIM codex --yolo", {
		win = {
			position = "right",
			width = 0.4,
			border = "rounded",
		},
	})
end, { desc = "Claude Code" }, { "snacks" })
map("v", "<leader>ay", function()
	local start_pos = vim.fn.getpos("'<")
	local start_line = start_pos[2]
	local start_col = start_pos[3]
	local end_line = vim.fn.line("'>")
	local file = vim.fn.expand("%:.")
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	local selection = table.concat(lines, "\n")
	local result = string.format("File: %s\nLine: %d,%d\nSelection:\n%s", file, start_line, end_line, selection)
	vim.fn.setreg("+", result)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	vim.schedule(function()
		vim.api.nvim_win_set_cursor(0, { start_line, math.max(start_col - 1, 0) })
	end)
	vim.notify("Copied selection with context")
end, { desc = "Yank for AI" })


-- ========================================================
-- Search
map("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" }, { "snacks" })
-- map("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" }, { "snacks" })
-- map("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" }, { "snacks" })
map("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" }, { "snacks" })
map("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" }, { "snacks" })
map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" }, { "snacks" })
map("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" },
	{ "snacks" })
map("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep Root Files" }, { "snacks" })
map("n", "<leader>sG", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" }, { "snacks" })
map("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" }, { "snacks" })
-- map("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" }, { "snacks" })
map("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" }, { "snacks" })
-- map("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" }, { "snacks" })
map("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" }, { "snacks" })
map("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" }, { "snacks" })
-- map("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" }, { "snacks" })
map("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" }, { "snacks" })
map("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" }, { "snacks" })
map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" }, { "snacks" })
map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" },
	{ "snacks" })
-- map("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Grep Word" }, { "snacks" })
-- map("x", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Grep Word" }, { "snacks" })

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
-- LSP keymaps - Snacks picker overrides gd, gD, gI, gy, gr below
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" }, { "snacks" })
map("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" }, { "snacks" })
map("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" }, { "snacks" })
map("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" }, { "snacks" })
map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" }, { "snacks" })

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
		---@diagnostic disable-next-line: undefined-field
		local url = type(spec) == "string" and spec or (spec.src or spec[1])
		---@diagnostic disable-next-line: undefined-field
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

--------------------------------------------------------------------------------
-- Resinstall treesitter parsers
--------------------------------------------------------------------------------
vim.api.nvim_create_user_command("TSReinstall", function()
	local parser_dir = vim.fs.joinpath(ts_install_dir, "parser")
	local files = vim.fn.glob(parser_dir .. "/*.so", false, true)
	for _, f in ipairs(files) do
		vim.uv.fs_unlink(f)
	end
	vim.notify("Deleted " .. #files .. " parsers. Reinstalling...", vim.log.levels.INFO)
	require("nvim-treesitter").install(ts_parsers)
end, { desc = "Delete and reinstall all Treesitter parsers" })

-- =============================================================================
-- =============================================================================
-- Project Picker
-- =============================================================================
-- =============================================================================

local projects_file = vim.fn.stdpath("data") .. "/projects.json"

local function load_projects()
	local f = io.open(projects_file, "r")
	if not f then return {} end
	local content = f:read("*a")
	f:close()
	local ok, data = pcall(vim.json.decode, content)
	if ok and type(data) == "table" then return data end
	return {}
end

local function save_projects(projects)
	local f = io.open(projects_file, "w")
	if not f then
		vim.notify("Failed to save projects", vim.log.levels.ERROR)
		return
	end
	f:write(vim.json.encode(projects))
	f:close()
end

local function apply_mise_env(dir)
	local result = vim.system({ "mise", "env", "-s", "bash", "-C", dir }):wait()
	if result.code == 0 and result.stdout then
		for line in result.stdout:gmatch("[^\n]+") do
			local key, value = line:match("^export ([%w_]+)=(.+)$")
			if key and value then
				-- Strip surrounding quotes
				value = value:gsub("^['\"]", ""):gsub("['\"]$", "")
				vim.env[key] = value
			end
		end
	else
		-- Fallback: ensure mise shims are on PATH
		local shims = vim.fn.expand("~/.local/share/mise/shims")
		if not vim.env.PATH:find(shims, 1, true) then
			vim.env.PATH = shims .. ":" .. vim.env.PATH
		end
	end
end

local function switch_project(dir)
	vim.cmd.cd(dir)
	apply_mise_env(dir)
	vim.notify("Switched to: " .. dir)
end

local function pick_project()
	local projects = load_projects()
	if #projects == 0 then
		vim.notify("No projects. Use <leader>pa to add one.", vim.log.levels.WARN)
		return
	end

	local entries = {}
	for _, p in ipairs(projects) do
		table.insert(entries, {
			text = p.name .. " :: " .. p.path,
			path = p.path,
		})
	end

	Snacks.picker.pick({
		items = entries,
		prompt = "Projects> ",
		format = "text",
		confirm = "switch_project",
		actions = {
			switch_project = function(picker, item)
				if not item or not item.path then return end
				picker:close()
				switch_project(item.path)
			end,
			delete_project = function(picker, item)
				if not item or not item.path then return end
				local current = load_projects()
				local filtered = vim.tbl_filter(function(p) return p.path ~= item.path end, current)
				save_projects(filtered)
				vim.notify("Removed: " .. item.path)
				picker:close()
				vim.schedule(pick_project)
			end,
		},
		win = {
			input = {
				keys = {
					["<c-d>"] = { "delete_project", mode = { "i", "n" } },
				},
			},
			list = {
				keys = {
					["<c-d>"] = "delete_project",
				},
			},
		},
	})
end

local function add_project(path)
	path = path or vim.fn.getcwd()
	path = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")
	local name = vim.fn.fnamemodify(path, ":h:t") .. "/" .. vim.fn.fnamemodify(path, ":t")
	local projects = load_projects()
	for _, p in ipairs(projects) do
		if p.path == path then
			vim.notify("Project already exists: " .. name, vim.log.levels.WARN)
			return
		end
	end
	table.insert(projects, { name = name, path = path })
	save_projects(projects)
	vim.notify("Added project: " .. name)
end

vim.keymap.set("n", "<leader>pp", pick_project, { desc = "Pick project" })
vim.keymap.set("n", "<leader>pa", function() add_project() end, { desc = "Add current dir as project" })
vim.keymap.set("n", "<leader>pA", function()
	vim.ui.input({ prompt = "Project path: ", completion = "dir" }, function(input)
		if input and input ~= "" then
			local expanded = vim.fn.expand(input)
			if vim.fn.isdirectory(expanded) == 1 then
				add_project(expanded)
			else
				vim.notify("Not a directory: " .. input, vim.log.levels.ERROR)
			end
		end
	end)
end, { desc = "Add project by path" })

if vim.g.neovide then
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			if vim.fn.argc() == 0 and #load_projects() > 0 then
				vim.schedule(pick_project)
			end
		end,
		once = true,
	})
end

-- =============================================================================
-- =============================================================================
-- THIS IS THE END
-- =============================================================================
-- =============================================================================

vim.defer_fn(function()
	local ms = (vim.loop.hrtime() - start_time) / 1e6
	vim.notify(string.format("Startup: %.0fms", ms))
	vim.defer_fn(function()
		vim.api.nvim_echo({ { "" } }, false, {})
	end, 3000)
end, 0)
