return {
	-- Open file in nvim from within nvim
	'willothy/flatten.nvim',
	opts = {
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
}
