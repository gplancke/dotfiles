return {
	buffers = {
    { "<C-q>", "<cmd>lua MiniBufremove.wipeout()<cr>", desc = "Close Buffer", remap = false },
    { "<C-e>", "<cmd>Neotree toggle<cr>", desc = "Toggle File Explorer", remap = false },
    { "<leader><C-e>", "<cmd>Neotree reveal<cr>", desc = "Reveal File Explorer", remap = false },
    { "<leader><C-q>", "<cmd>bufdo lua MiniBufremove.wipeout()<cr>", desc = "Close All Buffers", remap = false },
    { "[h", '<cmd>lua require("harpoon.ui").nav_prev()<cr>', desc = "Previous Harpoon", remap = false },
    { "]h", '<cmd>lua require("harpoon.ui").nav_next()<cr>', desc = "Previous Harpoon", remap = false },
	},
	explain = { "<leader>e", '<cmd>lua vim.diagnostic.open_float()<cr>', desc = '[E]xplain Diagnostic' },
	undo = { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undo Tree" },
	terminals = { "<leader>t", '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal' },
	search = {
    { "<leader>s", group = "search" },
    { "<leader>sD", '<cmd>lua require("telescope.builtin").diagnostics()<cr>', desc = "Workspace Diagnostics" },
    { "<leader>sb", '<cmd>lua require("telescope.builtin").buffers()<cr>', desc = "Buffers" },
    { "<leader>sd", '<cmd>lua require("telescope.builtin").diagnostics({ bufnr = 0 })<cr>', desc = "Document Diagnostics" },
    { "<leader>sf", '<cmd>lua require("telescope.builtin").find_files()<cr>', desc = "Find File" },
    { "<leader>sF", "<cmd>Telescope file_browser<cr>", desc = "Toggle File Browser" },
    { "<leader>sh", "<cmd>Telescope harpoon marks<cr>", desc = "Toggle Quick Menu with Telescope" },
    { "<leader>so", '<cmd>lua require("telescope.builtin").live_grep({grep_open_files=true})<cr>', desc = "String in Open Buffers" },
    { "<leader>sp", '<cmd>lua require("telescope.builtin").resume()<cr>', desc = "Previous Search" },
    { "<leader>st", '<cmd>lua require("telescope.builtin").live_grep()<cr>', desc = "String in Project" },
    { "<leader>sw", '<cmd>lua require("telescope.builtin").grep_string()<cr>', desc = "Word under cursor in Project" },
    { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undo Tree" },
		-- { "<leader>ss", '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>', desc = 'Search Buffer' },
		{ "<leader>ss", function()
			require('telescope.builtin').current_buffer_fuzzy_find(
				require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				}
			) end,
			desc = 'String in current Buffer'
		},
	},
	show = {
    { "<leader>S", group = "Show" },
    { "<leader>Sb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
    { "<leader>Sd", "<cmd>Trouble diagnostics<cr>", desc = "Toggle Document Diagnostics" },
    { "<leader>Se", "<cmd>Neotree toggle<cr>", desc = "Toggle File Explorer" },
    { "<leader>Sg", '<cmd>lua require("snacks").lazygit()<cr>', desc = "Toggle File Explorer" },
    { "<leader>Sz", '<cmd>lua require("snacks").zen()<cr>', desc = "Toggle ZenMode" },
	},
	harpoons = {
    { "<leader>h", group = "harpoon" },
    { "<leader>hc", '<cmd>lua require("harpoon.mark").clear_all()<cr>', desc = "Clear All Marks" },
    { "<leader>he", "<cmd>Telescope harpoon marks<cr>", desc = "Toggle Quick Menu with Telescope" },
    { "<leader>hf", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', desc = "Toggle Quick Menu" },
    { "<leader>hn", '<cmd>lua require("harpoon.ui").nav_next()<cr>', desc = "Next Harpoon" },
    { "<leader>hp", '<cmd>lua require("harpoon.ui").nav_prev()<cr>', desc = "Previous Harpoon" },
    { "<leader>hs", '<cmd>lua require("harpoon.mark").add_file()<cr>', desc = "Set Mark" },
	},
	code_actions = {
    { "<leader>c", buffer = 1, group = "code" },
    { "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", buffer = 1, desc = "Code Action" },
    { "<leader>cc", "<cmd>lua vim.lsp.buf.hover()<cr>", buffer = 1, desc = "Clear References" },
    { "<leader>cs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", buffer = 1, desc = "Signature Help" },
	},
	replace = {
    { "<leader>r", buffer = 1, group = "replace" },
    { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", buffer = 1, desc = "Replace" },
	},
	goto = {
    { "<leader>g", buffer = 1, group = "goto" },
    { "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", buffer = 1, desc = "Goto Declaration" },
    { "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<cr>", buffer = 1, desc = "Goto Definition" },
    { "<leader>gh", "<cmd>lua vim.lsp.buf.hover()<cr>", buffer = 1, desc = "Hover Definition" },
    { "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", buffer = 1, desc = "Goto Implementation" },
    { "<leader>gr", '<cmd>lua require("telescope.builtin").lsp_references()<cr>', buffer = 1, desc = "Goto References" },
    { "<leader>gtd", "<cmd>lua vim.lsp.buf.type_definition()<cr>", buffer = 1, desc = "Goto Type Definition" },
	},
	noice = {
    { "<leader>n", group = "noice" },
    { "<leader>nd", '<cmd>lua require("noice").cmd("dismiss")<cr>', desc = "Dismiss Noice" },
	},
	aichat = {
		{ "<leader>i", group = "aichat" },
		{ "<leader>ia", '<cmd>lua require("avante.api").ask()<cr>', desc = "Show AI Chat" },
		{ "<leader>ie", '<cmd>lua require("avante.api").edit()<cr>', desc = "Edit AI Chat" },
		{ "<leader>ir", '<cmd>lua require("avante.api").refresh()<cr>', desc = "Refresh AI Chat" }
	},
	debug = {
		{ "<leader>d", group = "debug" },
		{ "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
		{ "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
		{ "<leader>dd", "<cmd>lua require('dap').disconnect()<cr>", desc = "Disconnect" },
		{ "<leader>da", "<cmd>lua require('dap').step_over()<cr>", desc = "Step Over" },
		{ "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "Step Into" },
		{ "<leader>do", "<cmd>lua require('dap').step_out()<cr>", desc = "Step Out" },
		{ "<leader>dt", "<cmd>lua require('dapui').toggle()<cr>", desc = "Toggle UI" },
		-- { "<leader>dh", "<cmd>lua require('dapui').eval()<cr>", desc = "Hover Debug Info" },
	}
}
