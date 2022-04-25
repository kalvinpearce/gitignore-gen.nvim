local M = {}

local a = require("plenary.async")

M.get_selection = a.wrap(function(prompt, list, callback)
	vim.ui.select(list, { prompt = prompt }, callback)
end, 3)

return M
