local M = {}

local a = require("plenary.async")

M.read_file = function(path)
	local err, fd = a.uv.fs_open(path, "a+", 438)
	assert(not err, err)
	local err, stat = a.uv.fs_fstat(fd)
	assert(not err, err)
	local err, contents = a.uv.fs_read(fd, stat.size, 0)
	assert(not err, err)
	err = a.uv.fs_close(fd)
	assert(not err, err)

	return contents
end

M.write_file = function(path, contents)
	local err, fd = a.uv.fs_open(path, "w", 438)
	assert(not err, err)
	err = a.uv.fs_write(fd, contents)
	assert(not err, err)
	err = a.uv.fs_close(fd)
	assert(not err, err)
end

return M
