return {
	-- A vim-vinegar like file explorer
	"stevearc/oil.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local oil = require("oil")
		local bind = require("keybinder")

		-- Run certain actions only when oil is not open, or open in a floating
		-- panel. We do this because some keys don't make sense to be bound
		-- when Oil is open as a normal buffer.
		local function run_if_not_float(action)
			return function()
				if vim.bo.filetype ~= "oil" or (vim.bo.filetype == "oil" and vim.w.is_oil_win) then
					action()
				end
			end
		end

		-- Configure oil
		oil.setup({
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			keymaps = {
				["<esc>"] = run_if_not_float(oil.close),
				["q"] = run_if_not_float(oil.close),
				["L"] = "actions.select",
				["H"] = "actions.parent",
				["g\\."] = "actions.toggle_trash",
			},
		})

		-- File explorer
		bind.n("<leader>o", run_if_not_float(oil.toggle_float), "Toggle explorer")
	end,
}