local bind = require("keybinder")

return {
	-- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	config = function()
		local telescope = require("telescope")
		local telescope_builtin = require("telescope.builtin")
		local telescope_themes = require("telescope.themes")
		telescope.setup()

		-- Enable telescope fzf native, if installed
		pcall(telescope.load_extension, "fzf")

		-- Telescope live_grep in git root
		-- Function to find the git root directory based on the current buffer's path
		local function find_git_root()
			-- Use the current buffer's path as the starting point for the git search
			local current_file = vim.api.nvim_buf_get_name(0)
			local current_dir
			local cwd = vim.fn.getcwd()

			-- If the buffer is not associated with a file, return nil
			if current_file == "" then
				current_dir = cwd
			else
				-- Extract the directory from the current file's path
				current_dir = vim.fn.fnamemodify(current_file, ":h")
			end

			-- Find the Git root directory from the current file's path
			local git_root =
				vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
			if vim.v.shell_error ~= 0 then
				print("Not a git repository. Searching on current working directory")
				return cwd
			end
			return git_root
		end

		-- Custom live_grep function to search in git root
		local function live_grep_git_root()
			local git_root = find_git_root()
			if git_root then
				telescope_builtin.live_grep({
					search_dirs = { git_root },
				})
			end
		end

		local function fuzzy_find_buffer()
			telescope_builtin.current_buffer_fuzzy_find(telescope_themes.get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end

		bind.n("<leader>f", telescope_builtin.find_files, "Find files")
		bind.n("<leader>?", telescope_builtin.oldfiles, "Find recently opened files")
		bind.n("<leader><leader>", telescope_builtin.buffers, "Find existing buffers")
		bind.n("<leader>/", fuzzy_find_buffer, "Fuzzily search in current buffer")

		bind.n("<leader>gf", telescope_builtin.git_files, "Search git files")
		bind.n("<leader>sh", telescope_builtin.help_tags, "Search help")
		bind.n("<leader>sw", telescope_builtin.grep_string, "Search current word")
		bind.n("<leader>sg", telescope_builtin.live_grep, "Search by grep")
		bind.n("<leader>sG", live_grep_git_root, "Search by grep on Git Root")
		bind.n("<leader>sd", telescope_builtin.diagnostics, "Search diagnostics")
		bind.n("<leader>sr", telescope_builtin.resume, "Search Resume")
	end,
}