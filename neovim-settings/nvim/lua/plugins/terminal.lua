return {
	-- Manage multiple terminal windows
	"akinsho/toggleterm.nvim",
	config = function()
		local bind = require("keybinder")
		local opts = { buffer = 0 }

		require("toggleterm").setup({
			open_mapping = "<leader>\\",
		})

		function _G.set_terminal_keymaps()
			bind.t("<esc>", [[<C-\><C-n>]], opts)
			bind.t("<C-h>", [[<Cmd>wincmd h<CR>]], opts)
			bind.t("<C-j>", [[<Cmd>wincmd j<CR>]], opts)
			bind.t("<C-k>", [[<Cmd>wincmd k<CR>]], opts)
			bind.t("<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			bind.t("<C-w>", [[<C-\><C-n><C-w>]], opts)
		end

		-- Add mappings to make moving in and out of a terminal easier once
		-- toggled, whilst still keeping it open.
		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
	end,
}