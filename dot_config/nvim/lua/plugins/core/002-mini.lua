return {
	-- pack of niceties
	'echasnovski/mini.nvim',
	version = '*',
	config = function ()
		-- require('mini.move').setup()
		-- require('mini.starter').setup()
		require('mini.comment').setup()
		require('mini.bufremove').setup()
		require('mini.pairs').setup()
		require('mini.bracketed').setup()
		-- require('mini.cursorword').setup()
		-- require('mini.surround').setup()
	end
}
