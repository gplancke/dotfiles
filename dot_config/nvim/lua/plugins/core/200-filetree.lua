--
return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		-- {
		-- 	"s1n7ax/nvim-window-picker",
		-- 	event = 'VeryLazy',
		-- 	version = '2.*',
		-- 	config = function ()
		-- 		require'window-picker'.setup({
		-- 			filter_rules = {
		-- 				include_current_win = false,
		-- 				autoselect_one = true,
		-- 				bo = {
		-- 					filetype = { 'neo-tree', "neo-tree-popup", "notify" },
		-- 					buftype = { 'terminal', "quickfix" },
		-- 				},
		-- 			},
		-- 			-- other_win_hl_color = '#e35e4f',
		-- 		})
		-- 	end
		-- }
	},
	config = function ()
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
	end
}

-- return {
-- 	-- File Tree explorer
-- 	'nvim-tree/nvim-tree.lua',
-- 	config = function ()
-- 		local function nvim_tree_on_attach(bufnr)
-- 			local api = require('nvim-tree.api')
--
-- 			local function opts(desc)
-- 				return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
-- 			end
--
--
-- 			vim.keymap.set('n', '<C-e>', '', { buffer = bufnr })
-- 			vim.keymap.del('n', '<C-e>', { buffer = bufnr })
-- 			vim.keymap.set('n', '-', '', { buffer = bufnr })
-- 			vim.keymap.del('n', '-', { buffer = bufnr })
--
-- 			-- Mappings migrated from view.mappings.list
-- 			--
-- 			-- You will need to insert "your code goes here" for any mappings with a custom action_cb
-- 			vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
-- 			vim.keymap.set('n', '<CR>', api.tree.change_root_to_node, opts('CD'))
-- 			vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
-- 			vim.keymap.set('n', 'g?', api.tree.change_root_to_node, opts('CD'))
-- 			vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
-- 			vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
-- 		end
--
-- 		local nvim_tree_config = {
-- 			auto_reload_on_write = true,
-- 			hijack_netrw = false,
-- 			disable_netrw = false,
-- 			hijack_cursor = true,
-- 			sort_by = "name",
-- 			sync_root_with_cwd = true,
-- 			respect_buf_cwd = false,
-- 			on_attach = nvim_tree_on_attach,
-- 			update_focused_file = {
-- 				enable = false
-- 			},
-- 			view = {
-- 				width = 30,
-- 			},
-- 			renderer = {
-- 				group_empty = false,
-- 			},
-- 			filters = {
-- 				dotfiles = true,
-- 			},
-- 		}
--
-- 		require('nvim-tree').setup(nvim_tree_config)
-- 	end
-- }

