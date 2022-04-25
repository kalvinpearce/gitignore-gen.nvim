local M = {}

local config = require("gitignore-gen.config")

M.check_if_generated = function(contents)
	local match = string.find(contents, config.main_header, 0, true)
	if match ~= nil then
		return true
	end
	return false
end

M.get_current_items = function(contents)
	local match = string.match(contents, "# Created by [^%s\n]+/api/([%w,]+)")
	if match == nil then
		return {}
	end
	return vim.split(match, ",")
end

M.get_user_rules = function(contents)
	local rules = vim.split(contents, config.user_rules_header, { plain = true })
	if rules[2] == nil then
		return nil
	end
	local match = (rules[2]:gsub("^%s*(.-)%s*$", "%1"))
	return match
end

M.generate_file_contents = function(generatedRules, userRules)
	local output = string.format("# %s\n%s\n# %s\n", config.main_header, generatedRules, config.user_rules_header)
	if userRules ~= nil then
		output = output .. "\n" .. userRules
	end

	return output .. "\n"
end

return M
