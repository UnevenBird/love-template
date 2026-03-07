local filesystem = require 'love.filesystem'
local min, max = math.min, math.max

local M = {}

M.appendRecuirePaths = function(p)
	local list = {}
	for path in package.path:gmatch("[^;]+") do
		table.insert(list, path)
	end
	for _,path in ipairs(p) do
		table.insert(list, path.."/?.lua")
		table.insert(list, path.."/?/init.lua")
	end
	local result = table.concat(list, ";")
	filesystem.setRequirePath(result)
	package.path = result
end

M.check = function(condition, message, level)
	if condition == nil or condition == false then
		error(message or 'check failed!', level+1 or 2)
	end
	return condition
end

M.class = function(baseclass)
	local class = {}
	local base = baseclass or {}
	-- copy base class contents into the new class
	for key, value in pairs(base) do
		class[key] = value
	end

	class.__index = class
	class.baseclass = base
	setmetatable(class, {
		__call = function(c, ...)
			local instance = setmetatable({}, c)
			if instance.init then instance.init(instance, ...) end
			return instance
		end
	})
	return class
end

M.clamp = function(x, min_val, max_val)
	return max(min_val, min(x, max_val))
end

M.lerp = function(a, b, t)
	return a + (b - a) * t
end

return M