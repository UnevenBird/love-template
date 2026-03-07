--
-- log.lua
--
-- Copyright (c) 2016 rxi
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
-- Modified by Uneven Bird 2026

local log = { _version = "0.1.0" }

log.usecolor = true
log.outfile = nil

local modes = {
	{ name = "debug", tag = "DEBUG", color = "\27[36m", },
	{ name = "info",  tag = "INFO", color = "\27[32m", },
	{ name = "warn",  tag = "WARN", color = "\27[33m", },
	{ name = "error", tag = "ERROR", color = "\27[31m", },
	{ name = "fatal", tag = "FATAL", color = "\27[34m", },
}

local round = function(x, increment)
	increment = increment or 1
	x = x / increment
	return (x > 0 and math.floor(x + .5) or math.ceil(x - .5)) * increment
end

local _tostring = tostring

local tostring = function(...)
	local t = {}
	for i = 1, select('#', ...) do
		local x = select(i, ...)
		if type(x) == "number" then
			x = round(x, .01)
		end
		t[#t + 1] = _tostring(x)
	end
	return table.concat(t, " ")
end

for i, x in ipairs(modes) do
	log[x.name] = function(...)
		local msg = tostring(...)
		local info = debug.getinfo(2, "Sl")
		-- local lineinfo = info.short_src .. ":" .. info.currentline

		-- Output to console
		local date = os.date("%d/%m/%y %H:%M:%S")
		print(string.format("%s %s%-5s%s %s",
												date,
												log.usecolor and x.color or "",
												x.tag,
												log.usecolor and "\27[0m" or "",
												msg))

		-- Output to log file
		if log.outfile then
			local fp = io.open(log.outfile, "a")
			local str = string.format("%s|%-5s| %s\n", date, x.tag, msg)
			fp:write(str)
			fp:close()
		end
	end
end

return log