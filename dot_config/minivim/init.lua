-- ============================================================================
-- Modern Neovim Configuration (v0.12+)
-- Uses: mini.deps (package manager), mini.nvim modules, vim.lsp.config/enable
-- ============================================================================

-- Capture startup time
local start_time = vim.uv.hrtime()

--------------------------------------------------------------------------------
-- Leader Key (must be set before plugins)
--------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------------------------------------------------------------------
-- Bootstrap mini.nvim and mini.deps
--------------------------------------------------------------------------------
local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing mini.nvim..." | redraw')
  local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed mini.nvim" | redraw')
end

-- Setup mini.deps package manager
local MiniDeps = require("mini.deps")
MiniDeps.setup()

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

--------------------------------------------------------------------------------
-- Globals
--------------------------------------------------------------------------------

local no_cursor_ft = {
  "ministarter",
  "minifiles",
  "minipick",
  "dapui_hover",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
  "dapui_breakpoints",
  "dapui_console",
  "dap-repl",
  "help",
}

local no_blame_ft = {
  "help",
  "gitcommit",
  "gitrebase",
  "minimap",
  "ministarter",
  "minifiles",
  "minipick",
}

local no_line_ft = {
  "ministarter",
  "minifiles",
  "minipick",
  "dapui_hover",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
  "dapui_breakpoints",
  "dapui_console",
  "dap-repl",
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
  eob = " ",
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

--------------------------------------------------------------------------------
-- Autocommands
--------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup("UserAutocommands", { clear = true })

-- Cursor Column highlight sync
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = function()
    local cursorline = vim.api.nvim_get_hl(0, { link = false, name = "CursorLine" })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = cursorline.bg })
  end,
})

-- Cursor Line (only in active window and for certain filetypes)
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

-- ============================================================================
-- ============================================================================
-- PLUGINS
-- ============================================================================
-- ============================================================================

--------------------------------------------------------------------------------
-- External Plugins (non-mini)
--------------------------------------------------------------------------------

-- TMUX navigation
now(function()
  add("alexghergh/nvim-tmux-navigation")
  require("nvim-tmux-navigation").setup({
    disable_when_zoomed = false,
    keybindings = {
      left = "<C-h>",
      down = "<C-j>",
      up = "<C-k>",
      right = "<C-l>",
    },
  })
end)

-- Which-key (per your request to keep)
later(function()
  add("folke/which-key.nvim")
  require("which-key").setup({
    win = {
      width = { min = 30, max = 60 },
      height = { min = 4, max = 25 },
      col = 99999,
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
      { "<leader>e", group = "Explore/Edit" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>m", group = "Map" },
      { "<leader>o", group = "Other" },
      { "<leader>q", group = "Quit" },
      { "<leader>s", group = "Session/Search" },
      { "<leader>t", group = "Terminal" },
      { "<leader>u", group = "UI" },
      { "<leader>v", group = "Visits" },
      { "<leader>w", group = "Window" },
      { "<leader>x", group = "Diagnostics" },
    },
  })
end)

-- Mason (LSP/DAP/Linter/Formatter installer)
now_if_args(function()
  add("williamboman/mason.nvim")
  require("mason").setup({
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })
end)

-- Gitsigns (per your request to keep)
later(function()
  add("lewis6991/gitsigns.nvim")
  require("gitsigns").setup({
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
end)

-- Git blame
later(function()
  add("f-person/git-blame.nvim")
end)

-- VSCode-style diff
later(function()
  add("esmuellert/vscode-diff.nvim")
  require("vscode-diff").setup({
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
end)

-- Copilot (ghost text suggestions)
later(function()
  add("zbirenbaum/copilot.lua")
  require("copilot").setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = false, -- We handle this in our custom Tab mapping
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  })
end)

-- Colorscheme (per your request to keep tinted)
now(function()
  add("tinted-theming/tinted-nvim")
  require("tinted-colorscheme").setup()
end)

-- Image.nvim (kitty terminal)
later(function()
  add("3rd/image.nvim")
  require("image").setup({
    backend = "kitty",
    processor = "magick_cli",
  })
end)

-- Multi-cursor
later(function()
  add("mg979/vim-visual-multi")
end)

-- -- Tree-sitter
-- now_if_args(function()
--   add({
--     source = "nvim-treesitter/nvim-treesitter",
--     hooks = {
--       post_checkout = function()
--         vim.cmd("TSUpdate")
--       end,
--     },
--   })
--   add({
--     source = "nvim-treesitter/nvim-treesitter-textobjects",
--     checkout = "main",
--   })
--
--   -- Install parsers for common languages
--   local languages = { "lua", "vimdoc", "markdown", "javascript", "typescript", "python", "rust", "c", "cpp", "css", "html", "json", "yaml", "toml", "bash", "svelte", "dart" }
--   local isnt_installed = function(lang)
--     return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
--   end
--   local to_install = vim.tbl_filter(isnt_installed, languages)
--   if #to_install > 0 then
--     pcall(function()
--       require("nvim-treesitter").install(to_install)
--     end)
--   end
--
--   -- Enable tree-sitter highlighting
--   local filetypes = {}
--   for _, lang in ipairs(languages) do
--     for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
--       table.insert(filetypes, ft)
--     end
--   end
--   vim.api.nvim_create_autocmd("FileType", {
--     group = augroup,
--     pattern = filetypes,
--     callback = function(ev)
--       pcall(vim.treesitter.start, ev.buf)
--     end,
--     desc = "Start tree-sitter",
--   })
-- end)

-- ============================================================================
-- ============================================================================
-- MINI MODULES
-- ============================================================================
-- ============================================================================

--------------------------------------------------------------------------------
-- Step One: Immediate setup (needed for first draw)
--------------------------------------------------------------------------------

-- Icons
now(function()
  local ext3_blocklist = { scm = true, txt = true, yml = true }
  local ext4_blocklist = { json = true, yaml = true }
  require("mini.icons").setup({
    use_file_extension = function(ext, _)
      return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
    end,
  })
  -- Mock nvim-web-devicons for compatibility
  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

-- Common configuration presets
now(function()
  require("mini.basics").setup({
    options = { basic = false }, -- We manage options ourselves
    mappings = {
      windows = true, -- <C-hjkl> for window navigation (overridden by tmux-navigation)
      move_with_alt = true, -- <M-hjkl> for Insert/Command mode navigation
    },
  })
end)

-- Miscellaneous utilities
now_if_args(function()
  require("mini.misc").setup()
  MiniMisc.setup_auto_root({ ".git", "pnpm-lock.yaml", "bun.lock", "Makefile" })
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)

-- Notifications
now(function()
  require("mini.notify").setup()
  vim.notify = MiniNotify.make_notify()
end)

-- Sessions
now(function()
  require("mini.sessions").setup()
end)

-- Starter (dashboard)
now(function()
  local starter = require("mini.starter")
  starter.setup({
    header = [[
   ██████╗ ██████╗ ██╗     ██╗  ██╗
  ██╔════╝ ██╔══██╗██║     ██║ ██╔╝
  ██║  ███╗██████╔╝██║     █████╔╝
  ██║   ██║██╔═══╝ ██║     ██╔═██╗
  ╚██████╔╝██║     ███████╗██║  ██╗
   ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝
            ]],
    items = {
      starter.sections.builtin_actions(),
      starter.sections.recent_files(8, true),
      starter.sections.recent_files(8, false),
    },
    footer = function()
      return "Loaded in " .. string.format("%.0f", (vim.uv.hrtime() - start_time) / 1e6) .. "ms"
    end,
  })
end)

-- Statusline (with git-blame integration)
now(function()
  local statusline = require("mini.statusline")

  -- Custom section for git blame
  local function section_git_blame()
    local ok, gitblame = pcall(require, "gitblame")
    if ok and gitblame.is_blame_text_available() then
      local text = gitblame.get_current_blame_text()
      if text and text ~= "" then
        return text
      end
    end
    return ""
  end

  statusline.setup({
    content = {
      active = function()
        local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
        local git = statusline.section_git({ trunc_width = 40 })
        local diff = statusline.section_diff({ trunc_width = 75 })
        local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
        local lsp = statusline.section_lsp({ trunc_width = 75 })
        local filename = statusline.section_filename({ trunc_width = 140 })
        local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
        local location = statusline.section_location({ trunc_width = 75 })
        local search = statusline.section_searchcount({ trunc_width = 75 })
        local blame = section_git_blame()

        return statusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
          "%<", -- Truncate point
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=", -- End left alignment
          { hl = "MiniStatuslineFileinfo", strings = { blame } },
          { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
          { hl = mode_hl, strings = { search, location } },
        })
      end,
      inactive = function()
        return "%f %m"
      end,
    },
    set_vim_settings = false,
  })
end)

-- Tabline
now(function()
  require("mini.tabline").setup()
end)

--------------------------------------------------------------------------------
-- Step Two: Deferred setup
--------------------------------------------------------------------------------

-- Extra functionality (pickers, etc.)
later(function()
  require("mini.extra").setup()
end)

-- Text objects
later(function()
  local ai = require("mini.ai")
  ai.setup({
    custom_textobjects = {
      B = MiniExtra.gen_ai_spec.buffer(),
      F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    },
    search_method = "cover",
  })
end)

-- Align text
later(function()
  require("mini.align").setup()
end)

-- Bracketed navigation
later(function()
  require("mini.bracketed").setup()
end)

-- Buffer removal
later(function()
  require("mini.bufremove").setup()
end)

-- Command line tweaks
later(function()
  require("mini.cmdline").setup()
end)

-- Commenting
later(function()
  require("mini.comment").setup()
end)

-- Completion
later(function()
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end
  require("mini.completion").setup({
    lsp_completion = {
      source_func = "omnifunc",
      auto_setup = false,
      process_items = process_items,
    },
  })

  -- Set omnifunc for LSP completion
  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
    end,
    desc = "Set omnifunc for LSP",
  })

  -- Advertise completion capabilities to LSP servers
  vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

-- Git diff hunks
later(function()
  require("mini.diff").setup()
end)

-- File explorer
later(function()
  require("mini.files").setup({
    windows = { preview = true },
  })

  -- Add bookmarks
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesExplorerOpen",
    callback = function()
      MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
      MiniFiles.set_bookmark("p", vim.fn.stdpath("data") .. "/site/pack/deps/opt", { desc = "Plugins" })
      MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
    end,
  })
end)

-- Git integration
later(function()
  require("mini.git").setup()
end)

-- Highlight patterns
later(function()
  local hipatterns = require("mini.hipatterns")
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
      hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
      todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
      note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

-- Indent scope visualization
later(function()
  require("mini.indentscope").setup()
end)

-- Enhanced f/F/t/T
later(function()
  require("mini.jump").setup()
end)

-- 2D jumping (replaces flash.nvim)
later(function()
  local jump2d = require("mini.jump2d")
  jump2d.setup({
    mappings = {
      start_jumping = "", -- We'll map manually
    },
  })

  -- Map s/S for jump2d (like flash.nvim)
  vim.keymap.set({ "n", "o", "x" }, "s", function()
    jump2d.start(jump2d.builtin_opts.single_character)
  end, { desc = "Jump to character" })

  vim.keymap.set({ "n", "o", "x" }, "S", function()
    jump2d.start(jump2d.builtin_opts.word_start)
  end, { desc = "Jump to word" })
end)

-- Multi-step keymaps (for completion)
later(function()
  require("mini.keymap").setup()

  -- Helper to check if copilot suggestion is visible
  local function copilot_visible()
    local ok, copilot = pcall(require, "copilot.suggestion")
    return ok and copilot.is_visible()
  end

  -- Helper to accept copilot suggestion
  local function copilot_accept()
    local ok, copilot = pcall(require, "copilot.suggestion")
    if ok then
      copilot.accept()
    end
  end

  -- Tab: Accept copilot OR accept completion OR fallback
  vim.keymap.set("i", "<Tab>", function()
    if copilot_visible() then
      copilot_accept()
    elseif vim.fn.pumvisible() == 1 then
      return "<C-y>"
    else
      return "<Tab>"
    end
  end, { expr = true, desc = "Accept copilot/completion or tab" })

  -- S-Tab: Previous completion item
  MiniKeymap.map_multistep("i", "<S-Tab>", { "pmenu_prev" })

  -- C-n: Enter menu (if ghost text) or next item
  vim.keymap.set("i", "<C-n>", function()
    if vim.fn.pumvisible() == 1 then
      return "<C-n>"
    else
      -- Trigger completion
      return "<C-x><C-o>"
    end
  end, { expr = true, desc = "Next completion or open menu" })

  -- C-p: Previous completion item
  vim.keymap.set("i", "<C-p>", function()
    if vim.fn.pumvisible() == 1 then
      return "<C-p>"
    else
      return "<C-x><C-o>"
    end
  end, { expr = true, desc = "Previous completion or open menu" })

  -- CR: Accept completion with pairs awareness
  MiniKeymap.map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })

  -- BS: Account for pairs
  MiniKeymap.map_multistep("i", "<BS>", { "minipairs_bs" })
end)

-- Window minimap
later(function()
  local map = require("mini.map")
  map.setup({
    symbols = { encode = map.gen_encode_symbols.dot("4x2") },
    integrations = {
      map.gen_integration.builtin_search(),
      map.gen_integration.diff(),
      map.gen_integration.diagnostic(),
    },
  })
end)

-- Move lines/selections
later(function()
  require("mini.move").setup()
end)

-- Text operators
later(function()
  require("mini.operators").setup()
end)

-- Auto pairs
later(function()
  require("mini.pairs").setup({ modes = { command = true } })
end)

-- Fuzzy picker
later(function()
  require("mini.pick").setup()
  vim.ui.select = MiniPick.ui_select
end)

-- Snippets
later(function()
  local snippets = require("mini.snippets")
  snippets.setup({
    snippets = {
      snippets.gen_loader.from_lang(),
    },
  })
end)

-- Split/join arguments
later(function()
  require("mini.splitjoin").setup()
end)

-- Surround actions
later(function()
  require("mini.surround").setup()
end)

-- Trailing whitespace
later(function()
  require("mini.trailspace").setup()
end)

-- Visit tracking
later(function()
  require("mini.visits").setup()
end)

-- ============================================================================
-- ============================================================================
-- LSP Configuration
-- ============================================================================
-- ============================================================================

-- Global LSP settings
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

-- LSP Attach configuration
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

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

-- ============================================================================
-- ============================================================================
-- Keybindings
-- ============================================================================
-- ============================================================================

local map = vim.keymap.set

-- Disable space in normal/visual mode (leader key)
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Better movement with word wrap
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Keep visual selection after indent/outdent
map("v", "<", "<gv", { desc = "Outdent" })
map("v", ">", ">gv", { desc = "Indent" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Quit all
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- File explorer (mini.files)
map("n", "<C-e>", "<cmd>lua MiniFiles.open()<cr>", { desc = "Explorer (cwd)" })
map("n", "<leader>ed", "<cmd>lua MiniFiles.open()<cr>", { desc = "Explorer (cwd)" })
map("n", "<leader>ef", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>", { desc = "Explorer (file dir)" })
map("n", "<leader>ei", "<cmd>edit $MYVIMRC<cr>", { desc = "Edit init.lua" })
map("n", "<leader>en", "<cmd>lua MiniNotify.show_history()<cr>", { desc = "Notifications" })
map("n", "<leader>eq", function()
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.fn.getwininfo(win_id)[1].quickfix == 1 then
      return vim.cmd("cclose")
    end
  end
  vim.cmd("copen")
end, { desc = "Toggle Quickfix" })

-- Buffers
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<C-q>", "<cmd>lua MiniBufremove.delete()<cr>", { desc = "Delete Buffer" })
map("n", "<leader>ba", "<cmd>b#<cr>", { desc = "Alternate Buffer" })
map("n", "<leader>bb", "<cmd>Pick buffers<cr>", { desc = "Pick Buffers" })
map("n", "<leader>bd", "<cmd>lua MiniBufremove.delete()<cr>", { desc = "Delete Buffer" })
map("n", "<leader>bD", "<cmd>lua MiniBufremove.delete(0, true)<cr>", { desc = "Delete Buffer (Force)" })
map("n", "<leader>bs", function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, { desc = "Scratch Buffer" })
map("n", "<leader>bw", "<cmd>lua MiniBufremove.wipeout()<cr>", { desc = "Wipeout Buffer" })
map("n", "<leader>bW", "<cmd>lua MiniBufremove.wipeout(0, true)<cr>", { desc = "Wipeout Buffer (Force)" })
map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      pcall(MiniBufremove.delete, buf)
    end
  end
end, { desc = "Delete Other Buffers" })

-- Find (mini.pick)
map("n", "<leader><space>", "<cmd>Pick files<cr>", { desc = "Find Files" })
map("n", "<leader>/", "<cmd>Pick grep_live<cr>", { desc = "Grep" })
map("n", "<leader>:", "<cmd>Pick history scope=':'<cr>", { desc = "Command History" })
map("n", "<leader>n", "<cmd>lua MiniNotify.show_history()<cr>", { desc = "Notification History" })

map("n", "<leader>f/", "<cmd>Pick history scope='/'<cr>", { desc = "Search History" })
map("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fc", function()
  MiniPick.builtin.files({}, { source = { cwd = vim.fn.stdpath("config") } })
end, { desc = "Find Config File" })
map("n", "<leader>fd", "<cmd>Pick diagnostic scope='all'<cr>", { desc = "Diagnostics (workspace)" })
map("n", "<leader>fD", "<cmd>Pick diagnostic scope='current'<cr>", { desc = "Diagnostics (buffer)" })
map("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Pick git_files<cr>", { desc = "Git Files" })
map("n", "<leader>fG", function()
  MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Grep Current Word" })
map("n", "<leader>fh", "<cmd>Pick help<cr>", { desc = "Help Tags" })
map("n", "<leader>fH", "<cmd>Pick hl_groups<cr>", { desc = "Highlight Groups" })
map("n", "<leader>fk", "<cmd>Pick keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>fl", "<cmd>Pick buf_lines scope='all'<cr>", { desc = "Lines (all buffers)" })
map("n", "<leader>fL", "<cmd>Pick buf_lines scope='current'<cr>", { desc = "Lines (buffer)" })
map("n", "<leader>fm", "<cmd>Pick git_hunks<cr>", { desc = "Git Hunks (all)" })
map("n", "<leader>fM", "<cmd>Pick git_hunks path='%'<cr>", { desc = "Git Hunks (buffer)" })
map("n", "<leader>fr", "<cmd>Pick resume<cr>", { desc = "Resume Picker" })
map("n", "<leader>fR", "<cmd>Pick lsp scope='references'<cr>", { desc = "LSP References" })
map("n", "<leader>fs", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "LSP Symbols (buffer)" })
map("n", "<leader>fS", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = "LSP Symbols (workspace)" })
map("n", "<leader>fv", function()
  MiniExtra.pickers.visit_paths({ cwd = "" })
end, { desc = "Visit Paths (all)" })
map("n", "<leader>fV", "<cmd>Pick visit_paths<cr>", { desc = "Visit Paths (cwd)" })

-- Git
map("n", "<leader>ga", "<cmd>Git diff --cached<cr>", { desc = "Staged Diff" })
map("n", "<leader>gA", "<cmd>Git diff --cached -- %<cr>", { desc = "Staged Diff (buffer)" })
map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Toggle Git Blame" })
map("n", "<leader>gB", "<cmd>Pick git_branches<cr>", { desc = "Git Branches" })
map("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git Commit" })
map("n", "<leader>gC", "<cmd>Git commit --amend<cr>", { desc = "Git Commit Amend" })
map("n", "<leader>gd", "<cmd>Git diff<cr>", { desc = "Git Diff" })
map("n", "<leader>gD", "<cmd>Git diff -- %<cr>", { desc = "Git Diff (buffer)" })
map("n", "<leader>gf", "<cmd>Pick git_commits path='%'<cr>", { desc = "Git Log (file)" })
map("n", "<leader>gl", "<cmd>Pick git_commits<cr>", { desc = "Git Log" })
map("n", "<leader>gL", [[<cmd>Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order --follow -- %<cr>]], { desc = "Git Log (buffer)" })
map("n", "<leader>go", "<cmd>lua MiniDiff.toggle_overlay()<cr>", { desc = "Toggle Diff Overlay" })
map("n", "<leader>gs", "<cmd>lua MiniGit.show_at_cursor()<cr>", { desc = "Show at Cursor" })
map("n", "<leader>gS", "<cmd>Pick git_hunks scope='staged'<cr>", { desc = "Staged Hunks" })

map("x", "<leader>gs", "<cmd>lua MiniGit.show_at_cursor()<cr>", { desc = "Show at Selection" })

-- Search (using mini.pick)
map("n", "<leader>sa", "<cmd>Pick git_hunks scope='staged'<cr>", { desc = "Staged Hunks" })
map("n", "<leader>sb", "<cmd>Pick buf_lines scope='current'<cr>", { desc = "Buffer Lines" })
map("n", "<leader>sc", "<cmd>Pick commands<cr>", { desc = "Commands" })
map("n", "<leader>sd", "<cmd>Pick diagnostic<cr>", { desc = "Diagnostics" })
map("n", "<leader>sg", "<cmd>Pick grep_live<cr>", { desc = "Grep" })
map("n", "<leader>sh", "<cmd>Pick help<cr>", { desc = "Help Pages" })
map("n", "<leader>sH", "<cmd>Pick hl_groups<cr>", { desc = "Highlights" })
map("n", "<leader>sk", "<cmd>Pick keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>sm", "<cmd>Pick marks<cr>", { desc = "Marks" })
map("n", "<leader>so", "<cmd>Pick options<cr>", { desc = "Options" })
map("n", "<leader>sr", "<cmd>Pick resume<cr>", { desc = "Resume" })
map("n", "<leader>ss", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "LSP Symbols" })
map("n", "<leader>sS", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = "LSP Workspace Symbols" })
map("n", "<leader>su", "<cmd>lua MiniNotify.show_history()<cr>", { desc = "Notification History" })
map({ "n", "x" }, "<leader>sw", function()
  MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Grep Word" })

-- Sessions
map("n", "<leader>Sd", "<cmd>lua MiniSessions.select('delete')<cr>", { desc = "Delete Session" })
map("n", "<leader>Sn", function()
  local name = vim.fn.input("Session name: ")
  if name ~= "" then
    MiniSessions.write(name)
  end
end, { desc = "New Session" })
map("n", "<leader>Sr", "<cmd>lua MiniSessions.select('read')<cr>", { desc = "Read Session" })
map("n", "<leader>Sw", "<cmd>lua MiniSessions.write()<cr>", { desc = "Write Session" })

-- Windows
map("n", "<leader>w-", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window" })

-- Terminal
map("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Terminal" })
map("n", "<leader>tT", "<cmd>vertical terminal<cr>", { desc = "Terminal (vertical)" })

-- Map (mini.map)
map("n", "<leader>mf", "<cmd>lua MiniMap.toggle_focus()<cr>", { desc = "Toggle Map Focus" })
map("n", "<leader>mr", "<cmd>lua MiniMap.refresh()<cr>", { desc = "Refresh Map" })
map("n", "<leader>ms", "<cmd>lua MiniMap.toggle_side()<cr>", { desc = "Toggle Map Side" })
map("n", "<leader>mt", "<cmd>lua MiniMap.toggle()<cr>", { desc = "Toggle Map" })

-- Visits
map("n", "<leader>vc", function()
  local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 })
  MiniExtra.pickers.visit_paths({ cwd = "", filter = "core", sort = sort_latest }, { source = { name = "Core visits (all)" } })
end, { desc = "Core Visits (all)" })
map("n", "<leader>vC", function()
  local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 })
  MiniExtra.pickers.visit_paths({ filter = "core", sort = sort_latest }, { source = { name = "Core visits (cwd)" } })
end, { desc = "Core Visits (cwd)" })
map("n", "<leader>vl", "<cmd>lua MiniVisits.add_label()<cr>", { desc = "Add Label" })
map("n", "<leader>vL", "<cmd>lua MiniVisits.remove_label()<cr>", { desc = "Remove Label" })
map("n", "<leader>vv", "<cmd>lua MiniVisits.add_label('core')<cr>", { desc = "Add 'core' Label" })
map("n", "<leader>vV", "<cmd>lua MiniVisits.remove_label('core')<cr>", { desc = "Remove 'core' Label" })

-- Other
map("n", "<leader>or", "<cmd>lua MiniMisc.resize_window()<cr>", { desc = "Resize to Default Width" })
map("n", "<leader>ot", "<cmd>lua MiniTrailspace.trim()<cr>", { desc = "Trim Trailspace" })
map("n", "<leader>oz", "<cmd>lua MiniMisc.zoom()<cr>", { desc = "Zoom Toggle" })

-- Quickfix / Diagnostics
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
map("n", "<leader>xx", "<cmd>Pick diagnostic<cr>", { desc = "Diagnostics" })
map("n", "<leader>xX", "<cmd>Pick diagnostic scope='current'<cr>", { desc = "Diagnostics (buffer)" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous Quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next Quickfix" })

-- Diagnostics navigation
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next Diagnostic" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev Diagnostic" })
map("n", "]e", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Next Error" })
map("n", "[e", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Prev Error" })
map("n", "]w", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })
end, { desc = "Next Warning" })
map("n", "[w", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })
end, { desc = "Prev Warning" })

-- LSP keymaps
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("n", "gd", "<cmd>Pick lsp scope='definition'<cr>", { desc = "Goto Definition" })
map("n", "gD", "<cmd>Pick lsp scope='declaration'<cr>", { desc = "Goto Declaration" })
map("n", "gr", "<cmd>Pick lsp scope='references'<cr>", { desc = "References" })
map("n", "gI", "<cmd>Pick lsp scope='implementation'<cr>", { desc = "Goto Implementation" })
map("n", "gy", "<cmd>Pick lsp scope='type_definition'<cr>", { desc = "Goto Type Definition" })

-- Code actions
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("x", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>cf", function()
  vim.lsp.buf.format()
end, { desc = "Format" })
map("x", "<leader>cf", function()
  vim.lsp.buf.format()
end, { desc = "Format" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>cl", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP clients attached", vim.log.levels.INFO)
    return
  end
  local lines = { "LSP Clients:" }
  for _, client in ipairs(clients) do
    table.insert(lines, string.format("  - %s (id: %d)", client.name, client.id))
  end
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "LSP Info" })
map("n", "<leader>cs", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "Symbols (document)" })
map("n", "<leader>cS", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = "Symbols (workspace)" })

-- UI toggles
map("n", "<leader>un", "<cmd>lua MiniNotify.clear()<cr>", { desc = "Dismiss Notifications" })

-- ============================================================================
-- ============================================================================
-- Custom Commands
-- ============================================================================
-- ============================================================================

-- Plugin update/clean commands (mini.deps)
vim.api.nvim_create_user_command("DepsUpdate", function()
  MiniDeps.update()
end, { desc = "Update all plugins" })

vim.api.nvim_create_user_command("DepsClean", function()
  MiniDeps.clean()
end, { desc = "Clean unused plugins" })

vim.api.nvim_create_user_command("DepsSnap", function()
  MiniDeps.snap_save()
end, { desc = "Save plugin snapshot" })

-- Command to install all configured LSP servers
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
