return {
	-- Show  pending keybinds.
	"folke/which-key.nvim",
	opts = {},
	config = function()
		-- document existing key chains
		require("which-key").register({
			["<leader>c"] = { name = "Code", _ = "which_key_ignore" },
			["<leader>d"] = { name = "Document", _ = "which_key_ignore" },
			["<leader>g"] = { name = "Git", _ = "which_key_ignore" },
			["<leader>h"] = { name = "More git", _ = "which_key_ignore" },
			["<leader>r"] = { name = "Rename", _ = "which_key_ignore" },
			["<leader>s"] = { name = "More search", _ = "which_key_ignore" },
		})
	end,
}