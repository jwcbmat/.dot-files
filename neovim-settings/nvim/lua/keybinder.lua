local function string_to_table(s)
	local t = {}

	for i = 1, #s do
		local c = s:sub(i, i)
		table.insert(t, c)
	end

	return t
end

local keybinder = {
	__index = function(_, key)
		local modes = string_to_table(key)

		return function(lhs, rhs, desc_or_opts, other_opts)
			local desc, opts

			if type(desc_or_opts) == "string" then
				desc = desc_or_opts
				opts = other_opts or {}

				if opts.desc == nil then
					opts.desc = desc
				end
			else
				opts = desc_or_opts
			end

			return vim.keymap.set(modes, lhs, rhs, opts)
		end
	end,
}

return setmetatable({}, keybinder)