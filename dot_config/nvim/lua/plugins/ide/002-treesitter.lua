return {
	-- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		-- add new text object to move faster
		'nvim-treesitter/nvim-treesitter-textobjects',
		-- Keep current code context on top (sticky)
		'nvim-treesitter/nvim-treesitter-context',
	},
}
