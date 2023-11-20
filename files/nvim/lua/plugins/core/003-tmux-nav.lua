return {
	-- Play nice with TMUX
	'alexghergh/nvim-tmux-navigation',
	config = function()
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
	end
}

-- return {
-- 	-- Play nice with TMUX, Wezterm, Kitty, etc.
-- 	'numToStr/Navigator.nvim',
-- 	config = function()
-- 		vim.keymap.set({'n', 't'}, '<C-h>', '<CMD>NavigatorLeft<CR>')
-- 		vim.keymap.set({'n', 't'}, '<C-l>', '<CMD>NavigatorRight<CR>')
-- 		vim.keymap.set({'n', 't'}, '<C-k>', '<CMD>NavigatorUp<CR>')
-- 		vim.keymap.set({'n', 't'}, '<C-j>', '<CMD>NavigatorDown<CR>')
-- 	end
-- }
