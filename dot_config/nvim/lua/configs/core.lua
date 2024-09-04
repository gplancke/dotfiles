local undotree = require('undotree')

if not undotree then
	return
end

undotree.setup({
  float_diff = true,
  layout = "left_bottom",
  position = "left",
  ignore_filetype = {
		'qf',
		'undotree',
		'undotreeDiff',
		'TelescopePrompt',
		'spectre_panel',
		'tsplayground',
		'NvimTree',
		'neo-tree',
		'dashboard',
		'Term'
	},
  window = {
    winblend = 30,
  },
})
