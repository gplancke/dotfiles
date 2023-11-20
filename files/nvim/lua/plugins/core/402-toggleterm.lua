return {
	-- Terminal
	'akinsho/toggleterm.nvim',
	version = "*",
	config = function ()
		require("toggleterm").setup {
			open_mapping = [[<c-\>]],
			start_in_insert = true,
			hide_numbers = true,
			direction = "float",
			close_on_exit = true,
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			float_opts = {
				-- The border key is *almost* the same as 'nvim_open_win'
				-- see :h nvim_open_win for details on borders however
				-- the 'curved' border is a custom border type
				-- not natively supported but implemented in this plugin.
				border = 'curved',
			},
		}
	end
}
