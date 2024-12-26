local ut = require('utils.common')

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Snacks Plugins
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
require('snacks').setup({
	bigfile = { enabled = true },
	dashboard = { enabled = true },
	indent = { enabled = false },
	input = { enabled = false },
	lazygit = { enabled = true },
	notifier = { enabled = false },
	quickfile = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = false },
	words = { enabled = true },
	zenmode = { enabled = true },
})

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Mini Plugins
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

require('mini.ai').setup()
require('mini.icons').setup()
require('mini.comment').setup()
require('mini.bufremove').setup()
require('mini.pairs').setup()
require('mini.bracketed').setup()
-- require('mini.move').setup()
-- require('mini.starter').setup()
-- require('mini.cursorword').setup()

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Tmux Integration
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local tm_nav = ut.prequire('nvim-tmux-navigation')

local tmux_nav_config = {
	disable_when_zoomed = false, -- defaults to false
	keybindings = {
		left = "<C-h>",
		down = "<C-j>",
		up = "<C-k>",
		right = "<C-l>",
		-- last_active = "<C-\\>",
		-- next = "<C-Space>",
	}
}

if tm_nav then
	tm_nav.setup(tmux_nav_config)
end


-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Telescope Configuration
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local telescope = ut.prequire('telescope')
local actions = require('telescope.actions')

local telescope_config = {
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
				['<C-s>'] = actions.smart_send_to_qflist + actions.open_qflist,
			},
		},
	},
	extensions = {
		file_browser = {
			theme = "ivy",
			hijack_netrw = false, -- wether to hijack netrw window or not
			mappings = {
				["i"] = {
					["<C-l>"] = function(prompt_bufnr)
						vim.api.nvim_command('wall')
						vim.api.nvim_command('bufdo lua MiniBufremove.wipeout()')
						require('telescope-file-browser').actions.change_cwd(prompt_bufnr)
					end
				},
			},
		},
	},
}


if telescope then
	telescope.setup(telescope_config)
	telescope.load_extension('fzf')
	telescope.load_extension('harpoon')
	telescope.load_extension('file_browser')
end


-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Neo Tree Configuration
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
--

local tree = ut.prequire('neo-tree')
local tree_config = {
	close_if_last_window = true,
	window = {
		width = 40,
		position = "left",
	},
	filesystem = {
		-- hijack_netrw_behavior = "disabled",
		use_libuv_file_watcher = true,
		filtered_items = {
			visible = true,
			-- hide_dotfiles = true,
			-- hide_gitignored = true,
			never_show = {
				".DS_Store",
			},
		},
	},

}

if tree then
	vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
	tree.setup(tree_config)
end

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Flatten => open nvim from inside an nvim terminal
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local flatten = ut.prequire('flatten')
local flatten_config = {
	callbacks = {
		pre_open = function()
			-- Close toggleterm when an external open request is received
			require("toggleterm").toggle(0)
		end,
		post_open = function(bufnr, winnr, ft)
			local close = function() vim.api.nvim_buf_delete(bufnr, {}) end

			-- Close new window
			vim.api.nvim_win_close(winnr, true)
			-- Set the buffer as active in the default window
			vim.api.nvim_win_set_buf(0, bufnr)

			if ft == "gitcommit" then
				-- If the file is a git commit, create one-shot autocmd to delete it on write
				-- If you just want the toggleable terminal integration, ignore this bit and only use the
				-- code in the else block
				vim.api.nvim_create_autocmd(
					"BufWritePost",
					{
						buffer = bufnr,
						once = true,
						callback = function()
							-- This is a bit of a hack, but if you run bufdelete immediately
							-- the shell can occasionally freeze
							vim.defer_fn(close, 50)
						end
					}
				)
			end
		end,
		block_end = function()
			-- After blocking ends (for a git commit, etc), reopen the terminal
			require("toggleterm").toggle(0)
		end
	}
}

if flatten then
	flatten.setup(flatten_config)
end

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Undo Tree
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local undotree = ut.prequire('undotree')
local undotree_config = {
	float_diff = true,
	layout = "left_bottom",
	position = "left",
	ignore_filetype = {
		'qf',
		'undotree',
		'undotreeDiff',
		'TelescopePrompt',
		'spectre_panel',
		'tsplayground',
		'NvimTree',
		'neo-tree',
		'dashboard',
		'Term'
	},
	window = {
		winblend = 30,
	},
}

if undotree then
	undotree.setup(undotree_config)
end

