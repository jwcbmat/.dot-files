return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"haydenmeade/neotest-jest",
	},
	opts = {},
	config = function()
		local neotest_jest = require("neotest-jest")
		local neotest = require('neotest')

		neotest.setup({
			adapters = {
				neotest_jest({
					jestCommand = "jest -w",
				}),
			},
		})
	end,
}