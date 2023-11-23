local get_packages = function()
	local coc_data_home = vim.api.nvim_eval("coc#util#get_data_home()")
	local package_json_path = coc_data_home .. "/extensions/package.json"
	local file = io.open(package_json_path)

	if file ~= nil then
		local content = file:read("a")
		local package_json = vim.json.decode(content)
		local packages = package_json.dependencies

		file:close()

		if type(packages) == "table" then
			return packages
		end
	end
end

return {
	ensure_installed_and_cleanup_npm = function(extensions)
		local packages = get_packages()
		local extensions_to_install, extensions_to_uninstall = "", ""

		for _, extension in pairs(extensions) do
			if not packages[extension] then
				extensions_to_install = extensions_to_install .. extension .. " "
			else
				packages[extension] = nil
			end
		end

		for package in pairs(packages) do
			extensions_to_uninstall = extensions_to_uninstall .. package .. " "
		end

		if extensions_to_install ~= "" then
			vim.cmd("CocInstall " .. extensions_to_install)
		end

		if extensions_to_uninstall ~= "" then
			vim.cmd("CocUninstall " .. extensions_to_uninstall)
		end
	end,
}