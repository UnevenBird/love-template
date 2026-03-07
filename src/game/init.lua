local event = require 'game.event'
local scenes = require 'game.scenes'

local game = {}
game.attachEventListener = event.attachEventListener
game.detachEventListener = event.detachEventListener
game.resumeEventListener = event.resumeEventListener
game.raiseEvent = event.raiseEvent
game.switchScene = scenes.switchScene

function game.registerEventType(name, handler)
	event.registerEventType(name, nil, handler)
end

function game.init()
	local major, minor, revision = love.getVersion()
	log.info("[sytem]", string.format("%s. LOVE %d.%d.%d", _VERSION, major, minor, revision))
	if jit then
		log.info("[sytem]", "LuaJIT version:", jit.version)
		log.info("[sytem]", "JIT enabled:", jit.status())
	end
	event.init()
	scenes.init()
end

function game.load()
	scenes.registerScene(require 'scenes.main_scene')
	scenes.loadScene('main')
end

function game.update(dt)
	scenes.update(dt)
end

function game.update_fixed(dt)
	scenes.update_fixed(dt)
end

function game.draw()
	scenes.draw()
end

return game