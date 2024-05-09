return {
	-- Neovim now has a title bar to show stuff (buffers or file path)
	'fgheng/winbar.nvim',
	config = function ()
		local winbar = require('winbar')
		winbar.setup({
			enabled = true,
			show_file_path = true,
			show_symbols = true,
			colors = {
				path = '', -- You can customize colors like #c946fd
				file_name = '',
				symbols = '',
			},
			icons = {
				file_icon_default = '',
				seperator = '>',
				editor_state = '●',
				lock_icon = '',
			},
			exclude_filetype = {
				'help',
				'startify',
				'dashboard',
				'packer',
				'neogitstatus',
				'NvimTree',
				'neo-tree',
				'neo-tree-popup',
				'notify',
				'Trouble',
				'alpha',
				'lir',
				'Outline',
				'spectre_panel',
				'toggleterm',
				'terminal',
				'qf',
			}
		})
	end
}
