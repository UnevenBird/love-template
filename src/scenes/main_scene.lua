local love = require 'love'
local g = love.graphics
local tag = "[main_scene]"

local MainScene = love.ext.class(require 'game.scene_base')
MainScene.name = 'main'

function MainScene:load()
	self:attachEventListener('mouse_down')
	self:attachEventListener('key_down')
end

function MainScene:destroy()
	log.info(tag,"scene destroyed")
end

function MainScene:draw()
	g.setColor(1,1,1)
	g.print(love.timer.getFPS())
end

function MainScene:update(dt)
end

function MainScene:update_fixed(dt)
end

function MainScene:on_mouse_down(x, y, key, istouch, presses)
	log.info(tag, "mouse down:", x, y, key)
end

function MainScene:on_key_down(key, scancode, isrepeat)
	log.info(tag, "key down:", key)
end

return MainScene