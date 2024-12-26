-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Tmux Integration
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

require'nvim-tmux-navigation'.setup {
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


-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Mini Plugins
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

require('mini.icons').setup()
require('mini.comment').setup()
require('mini.bufremove').setup()
require('mini.pairs').setup()
require('mini.bracketed').setup()
-- require('mini.move').setup()
-- require('mini.starter').setup()
-- require('mini.cursorword').setup()
-- require('mini.surround').setup()

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Telescope Configuration
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local telescope = require('telescope')
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


telescope.setup(telescope_config)
pcall(telescope.load_extension, 'fzf')
pcall(telescope.load_extension, 'harpoon')
pcall(telescope.load_extension, 'file_browser')


-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Neo Tree Configuration
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
--
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

local tree = require('neo-tree')

tree.setup({
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
})

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Flatten => open nvim from inside an nvim terminal
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

require('flatten').setup({
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
})

-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- Undo Tree
-- -----------------------------------------------------------
-- -----------------------------------------------------------
-- -----------------------------------------------------------

local undotree = require('undotree')

if not undotree then
	return
end

undotree.setup({
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
})
