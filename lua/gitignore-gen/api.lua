local M = {}

local a = require("plenary.async")
local curl = require("plenary.curl")
local config = require("gitignore-gen.config")

M.get_list = function()
	a.util.scheduler()
	local curl = require("plenary.curl")
	local request = curl.get(config.api_url .. "list")
	if not request.status == 200 then
		return
	end

	return vim.split(request.body, "[,\n]+")
end

M.get_gitignore_for_items = function(items)
	local selection = table.concat(items, ",")
	local request = curl.get(config.api_url .. selection)
	if not request.status == 200 then
		return
	end

	return request.body
end

return M
