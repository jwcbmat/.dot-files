return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Creates a beautiful debugger UI
		{ "rcarriga/nvim-dap-ui", opts = {} },

		{
			"Joakker/lua-json5",
			build = "./install.sh",
			cond = function()
				return vim.fn.executable("cargo") == 1
			end,
		},

		{
			"microsoft/vscode-chrome-debug",
			build = "npm i --ci && npm run build",
			cond = function()
				return vim.fn.executable("npm") == 1
			end,
			config = function()
				local dap = require("dap")
				local chrome_adapter_configuration = {
					type = "executable",
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/lazy/vscode-chrome-debug/out/src/chromeDebug.js",
					},
				}

				for _, adapter in pairs({ "chrome", "pwa-chrome" }) do
					dap.adapters[adapter] = chrome_adapter_configuration
				end
			end,
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_ext_vscode = require("dap.ext.vscode")
		local dap_ui_widgets = require("dap.ui.widgets")
		local bind = require("keybinder")
		local json5 = require("json5")
		local js_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
		local keymap_restore = {}

		-- Enable debug logs
		dap.set_log_level("debug")

		-- Override the json decode function to support json5 features like
		-- trailing comma
		if json5 then
			dap_ext_vscode.json_decode = json5.parse
		end

		-- Override sign definition for fancy breakpoints
		vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })

		local function hover()
			dap_ui_widgets.hover()
		end

		-- Support for .vscode/launch.json
		local function continue()
			dap_ext_vscode.load_launchjs(nil, {
				chrome = js_languages,
				["pwa-chrome"] = js_languages,
			})
			dap.continue()
		end

		local function set_breakpoint()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end

		-- Map K to hover while session is active
		dap.listeners.after["event_initialized"]["me"] = function()
			for _, buf in pairs(vim.api.nvim_list_bufs()) do
				local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")
				for _, keymap in pairs(keymaps) do
					if keymap.lhs == "K" then
						table.insert(keymap_restore, keymap)
						vim.api.nvim_buf_del_keymap(buf, "n", "K")
					end
				end
			end

			bind.n("K", hover, { silent = true })
		end
		dap.listeners.after["event_terminated"]["me"] = function()
			for _, keymap in pairs(keymap_restore) do
				vim.api.nvim_buf_set_keymap(
					keymap.buffer,
					keymap.mode,
					keymap.lhs,
					keymap.rhs,
					{ silent = keymap.silent == 1 }
				)
			end

			keymap_restore = {}
		end

		dap.listeners.after.event_initialized.dapui_config = dapui.open
		dap.listeners.before.event_terminated.dapui_config = dapui.close
		dap.listeners.before.event_exited.dapui_config = dapui.close

		-- Basic debugging keymaps
		bind.n("<F5>", continue, "Debug: Start/Continue")
		bind.n("<F1>", dap.step_into, "Debug: Step Into")
		bind.n("<F2>", dap.step_over, "Debug: Step Over")
		bind.n("<F3>", dap.step_out, "Debug: Step Out")
		bind.n("<leader>b", dap.toggle_breakpoint, "Debug: Toggle Breakpoint")
		bind.n("<leader>B", set_breakpoint, "Debug: Set Breakpoint")

		-- Toggle to see last session result. Without this, you can't see
		-- session output in case of unhandled exception.
		bind.n("<F7>", dapui.toggle, "Debug: See last session result.")
	end,
	opts = {},
}