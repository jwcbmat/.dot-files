return {
	-- Set lualine as statusline
	"nvim-lualine/lualine.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			component_separators = "|",
			section_separators = "",
		},
	},
}