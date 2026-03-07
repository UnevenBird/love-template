local love = require 'love'
love.ext = require 'lib.love-ext'
love.ext.appendRecuirePaths({'src', 'lib'})

log = require 'log'

local game = require 'game'
game.init()

-- fast exit, debug/dev only
game.attachEventListener('key_down', function(_, key)
	if key == 'escape' then
		love.event.quit()
	end
end)

local TICK_RATE = 1 / 90
local MAX_FRAME_SKIP = 25
local timer_step, timer_sleep = love.timer.step, love.timer.sleep
local event_pump, event_poll = love.event.pump, love.event.poll
local game_load, game_draw = game.load, game.draw
local game_update, game_update_fixed = game.update, game.update_fixed
local raise_event = game.raiseEvent
local math_min = math.min

function love.run()
	game_load()

	local lag = 0.0
	local dt = timer_step()
	return function()
		event_pump()
		for name, a,b,c,d,e,f in event_poll() do
			return raise_event(name, a,b,c,d,e,f)
		end

		dt = timer_step()
		lag = math_min(lag + dt, TICK_RATE * MAX_FRAME_SKIP)

		while lag >= TICK_RATE do
			game_update_fixed(TICK_RATE)
			lag = lag - TICK_RATE
		end

		game_update(dt)
		game_draw()

		timer_sleep(0.001)
	end
end