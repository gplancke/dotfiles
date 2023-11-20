return {
	-- Set Root at the right spot based on key files
	'notjedi/nvim-rooter.lua',
	opts = {
		rooter_patterns = { '.git', '.hg', '.svn' },
		trigger_patterns = { '*' },
		manual = false,
	}
}
