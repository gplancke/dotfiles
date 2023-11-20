local wk = require('which-key')

-- This is to make sure that the leader key is set to space
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Search
wk.register({
  s = {
    name = '+search',
    e = { '<cmd>Telescope file_browser<cr>', 'File Browser' },
    f = { '<cmd>lua require("telescope.builtin").find_files()<cr>', 'Find File' },
    b = { '<cmd>lua require("telescope.builtin").buffers()<cr>', 'Buffers' },
    h = { '<cmd>lua require("telescope.builtin").help_tags()<cr>', 'Help' },
    d = { '<cmd>lua require("telescope.builtin").lsp_document_diagnostics()<cr>', 'Document Diagnostics' },
    D = { '<cmd>lua require("telescope.builtin").lsp_workspace_diagnostics()<cr>', 'Workspace Diagnostics' },
    g = { '<cmd>lua require("telescope.builtin").live_grep()<cr>', 'Grep' },
    w = { '<cmd>lua require("telescope.builtin").grep_string()<cr>', 'Search Word' },
    -- s = { '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>', 'Search Buffer' },
    s = { function()
      require('telescope.builtin').current_buffer_fuzzy_find(
        require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        }
      ) end,
      'Search Buffer'
    },
  },
}, { prefix = '<leader>' })

-- Buffer and Files manipulation
wk.register({
  ['<C-e>'] = { '<cmd>Neotree toggle<cr>', 'Toggle File Explorer' },
  ['<C-q>'] = { '<cmd>lua MiniBufremove.wipeout()<cr>', 'Close Buffer' },
  ['<leader><C-q>'] = { '<cmd>bufdo lua MiniBufremove.wipeout()<cr>', 'Close All Buffers' },
}, { noremap = true, silent = true })

wk.register({
	h = {
		name = '+harpoon',
		s = { '<cmd>lua require("harpoon.mark").add_file()<cr>', 'Set Mark' },
		c = { '<cmd>lua require("harpoon.mark").clear_all_marks()<cr>', 'Clear All Marks' },
		f = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', 'Toggle Quick Menu' },
		e = { '<cmd>Telescope harpoon marks<cr>', 'Toggle Quick Menu with Telescope' },
		p = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', 'Previous Harpoon' },
		n = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', 'Next Harpoon' },
	}
}, { prefix = '<leader>' })

-- Git
wk.register({
	v = {
		f = { '<cmd>lua Lazygit_toggle()<cr>', 'Toggle LazyGit' }
	}
}, { prefix = '<leader>' })

-- Diagnostic
wk.register({
  ['[d'] = { '<cmd>lua vim.diagnostic.goto_prev<cr>' },
  [']d'] = { '<cmd>lua vim.diagnostic.goto_next<cr>' },
  ['<leader>e'] = { '<cmd>lua vim.diagnostic.open_float<cr>' },
  ['<leader>q'] = { '<cmd>lua vim.diagnostic.setloclist<cr>' },
})

-- Projects
wk.register({
	p = {
		name = '+project',
		o = {
			function()
				require('telescope').extensions.opener.opener({
					hidden=false,
					respect_gitignore=true,
					root_dir="~",
				})
			end,
			'Open Project',
		},
	},
}, { prefix = '<leader>' })

-- Tmux emulation
wk.register({
	['<C-a>'] = {
		name = '+tmux-like',
		['%'] = { '<cmd>vsplit<cr>', 'Split Vertical' },
		['"'] = { '<cmd>split<cr>', 'Split Horizontal' },
	}
})
