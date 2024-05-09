return {
	buffers = {
		['<C-e>'] = { '<cmd>Neotree toggle<cr>', 'Toggle File Explorer' },
		['<C-q>'] = { '<cmd>lua MiniBufremove.wipeout()<cr>', 'Close Buffer' },
		['<leader><C-q>'] = { '<cmd>bufdo lua MiniBufremove.wipeout()<cr>', 'Close All Buffers' },
		['[h'] = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', 'Previous Harpoon' },
		[']h'] = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', 'Previous Harpoon' },
	},

	undo = { "<cmd>lua require('undotree').toggle()<cr>", "Undo Tree" },
	terminals = { '<cmd>ToggleTerm<cr>', 'Toggle Terminal' },
	search = {
		name = '+search',
		p = { '<cmd>lua require("telescope.builtin").resume()<cr>', 'Previous Search' },
		f = { '<cmd>lua require("telescope.builtin").find_files()<cr>', 'Find File' },
		b = { '<cmd>lua require("telescope.builtin").buffers()<cr>', 'Buffers' },
		h = { '<cmd>Telescope harpoon marks<cr>', 'Toggle Quick Menu with Telescope' },
		-- t = { '<cmd>lua require("telescope.builtin").help_tags()<cr>', 'Help' },
		d = { '<cmd>lua require("telescope.builtin").lsp_document_diagnostics()<cr>', 'Document Diagnostics' },
		D = { '<cmd>lua require("telescope.builtin").lsp_workspace_diagnostics()<cr>', 'Workspace Diagnostics' },
		t = { '<cmd>lua require("telescope.builtin").live_grep()<cr>', 'String in Project' },
		o = { '<cmd>lua require("telescope.builtin").live_grep({grep_open_files=true})<cr>', 'String in Open Buffers' },
		w = { '<cmd>lua require("telescope.builtin").grep_string()<cr>', 'Word under cursor in Project' },
		-- s = { '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>', 'Search Buffer' },
		s = { function()
			require('telescope.builtin').current_buffer_fuzzy_find(
				require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				}
			) end,
			'String in current Buffer'
		},
	},
	show = {
		name = '+Show',
		f = { '<cmd>Telescope file_browser<cr>', 'Toggle File Browser' },
		d = { '<cmd>TroubleToggle document_diagnostics<cr>', 'Toggle Document Diagnostics' },
		D = { '<cmd>TroubleToggle workspace_diagnostics<cr>', 'Toggle Workspace Diagnostics' },
		b = { '<cmd>GitBlameToggle<cr>', 'Toggle Git Blame' },
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
		z = { '<cmd>lua require("zen-mode").toggle()<cr>', 'Toggle ZenMode' },
	},
	harpoons = {
		name = '+harpoon',
		s = { '<cmd>lua require("harpoon.mark").add_file()<cr>', 'Set Mark' },
		c = { '<cmd>lua require("harpoon.mark").clear_all()<cr>', 'Clear All Marks' },
		f = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', 'Toggle Quick Menu' },
		e = { '<cmd>Telescope harpoon marks<cr>', 'Toggle Quick Menu with Telescope' },
		p = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', 'Previous Harpoon' },
		n = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', 'Next Harpoon' },
	},
	explain = { '<cmd>lua vim.diagnostic.open_float()<cr>', '[E]xplain Diagnostic' },
	code_actions = {
		name = '+code',
		a = { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code Action' },
		c = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'Clear References' },
		s = { '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'Signature Help' },
	},
	replace = {
		name = '+replace',
		n = { '<cmd>lua vim.lsp.buf.rename()<cr>', 'Replace' },
	},
	goto = {
		name = '+goto',
		d = { '<cmd>lua vim.lsp.buf.definition()<cr>', 'Goto Definition' },
		['td'] = { '<cmd>lua vim.lsp.buf.type_definition()<cr>', 'Goto Type Definition' },
		D = { '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Goto Declaration' },
		i = { '<cmd>lua vim.lsp.buf.implementation()<cr>', 'Goto Implementation' },
		-- r = { '<cmd>lua vim.lsp.buf.references()<cr>', 'Goto References' },
		r = { '<cmd>lua require("telescope.builtin").lsp_references()<cr>', 'Goto References' },
		h = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'Hover Definition' },
	},
	noice = {
		name = '+noice',
		d = { '<cmd>lua require("noice").cmd("dismiss")<cr>', 'Dismiss Noice' },
	},
}
