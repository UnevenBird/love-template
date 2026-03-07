local listeners = {}
local callbacks = {}

function callbacks.focus(focus)
end

function callbacks.mousefocus(focus)
end

function callbacks.visible(visible)
end

function callbacks.displayrotated(display, orient)
end

function callbacks.threaderror(t, err)
end

function callbacks.lowmemory()
	log.warn("[game]","low memory")
	collectgarbage()
	collectgarbage()
end

function callbacks.resize(w, h)
	collectgarbage()
end

function callbacks.quit()
	log.info("[game]","quitting")
	return true
end

local M = {}
M.listeners = listeners
M.callbacks = callbacks

M.attachEventListener = function(event_type, callback)
	if not listeners[event_type] then return nil end
	local handler = {
		object = nil,
		callback = callback
	}
	listeners[event_type][handler] = handler
	return handler
end

M.registerEventType = function(new_name, src_name, handler)
	listeners[new_name] = {}
	callbacks[src_name or new_name] = handler or function(...)
		for _,e in pairs(listeners[new_name]) do
			e.callback(e.object, ...)
		end
	end
end

M.detachEventListener = function(event_type, handler)
	if listeners[event_type] then
		listeners[event_type][handler] = nil
	end
end

M.resumeEventListener = function(event_type, handler)
	if listeners[event_type] then
		listeners[event_type][handler] = handler
	end
end

M.raiseEvent = function(event_type, ...)
	return M.handlers[event_type](...)
end

local empty = function() end
function M.init()
	for new_name, src_name in pairs({
		key_down = 'keypressed',
		key_up = 'keyreleased',
		text_input = 'textinput',
		text_edit = 'textedited',
		mouse_move = 'mousemoved',
		mouse_down = 'mousepressed',
		mouse_up = 'mousereleased',
		mouse_wheel = 'wheelmoved',
		touch_down = 'touchpressed',
		touch_up = 'touchreleased',
		touch_move = 'touchmoved',
	}) do
		M.registerEventType(new_name, src_name)
	end
	M.handlers = setmetatable(callbacks, {
		__index = function(self, name)
			log.debug("[event]","no callback for event: "..name)
			return empty
		end
	})
end

return M