local M = {}

local header = "# Generated with gitignore-gen.nvim"
local api = "https://www.toptal.com/developers/gitignore/api/"
local filepath = vim.fn.getcwd() .. "/.gitignore"

local a = require("plenary.async")

local write_file = function(fd, data, trunc)
	if trunc then
		local err = a.uv.fs_ftruncate(fd, 0)
		assert(not err, err)
	end
	local err = a.uv.fs_write(fd, data)
	assert(not err, err)
	print("Generated gitignore in " .. filepath)
end

local backup_old = function(contents)
	local backup_path = filepath .. ".backup"
	local err, fd = a.uv.fs_open(backup_path, "xw+", 438)
	assert(not err, err)
	err = a.uv.fs_write(fd, contents)
	assert(not err, err)
	err = a.uv.fs_close(fd)
	assert(not err, err)
	print("Backed up existing gitignore to " .. backup_path)
end

local write_gitignore = function(data)
	local err, fd = a.uv.fs_open(filepath, "a+", 438)
	assert(not err, err)
	local err, stat = a.uv.fs_fstat(fd)
	assert(not err, err)
	if stat.size == 0 then
		write_file(fd, data, false)
	else
		local err, contents = a.uv.fs_read(fd, string.len(header), 0)
		assert(not err, err)
		if contents ~= header then
			backup_old(contents)
		end

		write_file(fd, data, true)
	end
	err = a.uv.fs_close(fd)
	assert(not err, err)
end

local generate = a.void(function()
	local curl = require("plenary.curl")
	local listRequest = curl.get(api .. "list")
	if not listRequest.status == 200 then
		print("Failed to fetch list of ignores")
		return
	end

	local list = vim.split(listRequest.body, "[,\n]+")
	local language = a.wrap(function(_, _, callback)
		vim.ui.select(list, { prompt = "Select language to generate" }, callback)
	end, 3)()
	if language == nil then
		return
	end

	local langRequest = curl.get(api .. language)
	if not langRequest.status == 200 then
		print("Failed to fetch gitignore for selected language: " .. language)
		return
	end
	write_gitignore(header .. langRequest.body)
end)

M.generate = generate
M.generate()

return M
