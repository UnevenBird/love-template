local love = require 'love'
local game = require 'game'

local Scene = love.ext.class()

function Scene:init()
	self.handlers = {}
end

function Scene:load()
end

function Scene:suspend()
	for event_type, handler in pairs(self.handlers or {}) do
		game.detachEventListener(event_type, handler)
	end
end

function Scene:resume()
	for event_type, handler in pairs(self.handlers or {}) do
		game.resumeEventListener(event_type, handler)
	end
end

function Scene:release()
	self:destroy()
	for event_type, handler in pairs(self.handlers or {}) do
		game.detachEventListener(event_type, handler)
	end
end

function Scene:destroy()
end

function Scene:draw()
end

function Scene:update(dt)
end

function Scene:update_fixed(dt)
end

function Scene:on_window_resize(width, height)
end

function Scene:on_quit()
end

function Scene:attachEventListener(event_type)
	local callback_name = 'on_'..event_type
	love.ext.check(self[callback_name], "callback '"..callback_name.."' for scene '"..self.name.."' not found.", 2)

	local handler = game.attachEventListener(event_type, self[callback_name])
	handler.object = self
	self.handlers[event_type] = handler
end

function Scene:detachEventListener(event_type)
	local handler = self.handlers[event_type]
	if handler then
		game.detachEventListener(event_type, handler)
		self.handlers[event_type] = nil
	end
end

return Scene