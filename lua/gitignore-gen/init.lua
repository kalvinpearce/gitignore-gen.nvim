local M = {}

local a = require("plenary.async")
local Path = require("plenary.path")
local config = require("gitignore-gen.config")
local helpers = require("gitignore-gen.helpers")
local ui = require("gitignore-gen.ui")
local api = require("gitignore-gen.api")
local filesystem = require("gitignore-gen.filesystem")

local generate = function()
	local filename = Path:new(config.filename):absolute()

	a.void(function()
		local contents = filesystem.read_file(filename)
		local is_generated = helpers.check_if_generated(contents)
		local current_items = {}
		local user_overrides = contents
		if is_generated then
			current_items = helpers.get_current_items(contents)
			user_overrides = helpers.get_user_rules(contents)
		elseif contents ~= "" then
			local choice = ui.get_selection(
				"Gitignore Generator: Retain existing rules?",
				{ "Retain existing", "Override existing (deletes all existing rules)" }
			)
			if choice == nil then
				return
			end
			if choice ~= "Retain existing" then
				user_overrides = nil
			end
		end

		local add_mode = true
		if vim.tbl_count(current_items) > 0 then
			local choice = ui.get_selection(
				"Gitignore Generator: Action",
				{ "Add to gitignore", "Remove from gitignore" }
			)
			if choice == nil then
				return
			end
			if choice == "Add to gitignore" then
				add_mode = true
			else
				add_mode = false
			end
		end

		local list = api.get_list()
		if list == nil then
			error("Failed to fetch list of available ignores")
			return
		end
		local choice_items = add_mode and list or current_items
		local choice = ui.get_selection("Gitignore Generator: Pick", choice_items)
		if choice == nil then
			return
		end

		if add_mode then
			if not vim.tbl_contains(current_items, choice) then
				table.insert(current_items, choice)
			end
		else
			current_items = vim.tbl_filter(function(i)
				return i ~= choice
			end, current_items)
		end

		local generated_rules = ""
		if vim.tbl_count(current_items) > 0 then
			generated_rules = api.get_gitignore_for_items(current_items)
			if generated_rules == nil then
				error("Failed to fetch gitignore rules for selected")
				return
			end
		end

		local output = helpers.generate_file_contents(generated_rules, user_overrides)
		filesystem.write_file(filename, output)
	end)()
end

M.generate = generate

return M
