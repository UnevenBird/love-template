local love = require 'love'
local g = love.graphics

local class_registry = {}
local scene_registry = {}
local render_stack = {}
local update_stack = {}
local suspended = {}

local M = {}

local function pop_scene(stack, scene)
	for i = #stack, 1, -1 do
		if stack[i] == scene then
			table.remove(stack, i)
			return
		end
	end
end

local function push_scene(stack, scene)
	table.insert(stack, scene)
end

M.registerScene = function(scene_cls, scene_name)
	local name = assert(scene_cls.name or scene_name)
	class_registry[name] = scene_cls
end

M.getCurrent = function()
	return render_stack[#render_stack]
end

M.getByName = function(name)
	for i=#render_stack, 1, -1 do
		if render_stack[i].name == name then
			return render_stack[i]
		end
	end
end

M.loadScene = function(name, ...)
	local scene_cls = love.ext.check(class_registry[name], "scene not found: " .. tostring(name), 2)
	local current = M.getCurrent()
	if current and current.fake then
		pop_scene(render_stack, current)
		pop_scene(update_stack, current)
	end

	local scene = scene_cls(...)
	log.info("[scenes]", "created scene: " .. name)
	scene:load()
	scene_registry[scene.name] = scene
	push_scene(render_stack, scene)
	push_scene(update_stack, scene)
	return scene
end

M.switchScene = function(name, suspend_current)
	local prev_scene = M.getCurrent()
	local next_scene = suspended[name]

	if prev_scene and not prev_scene.fake then
		if suspend_current then
			log.info("[scenes]", "suspend scene: "..prev_scene.name)
			prev_scene:suspend()
			suspended[prev_scene.name] = prev_scene
		else
			log.info("[scenes]", "destroy scene: "..prev_scene.name)
			prev_scene:release()
			scene_registry[prev_scene.name] = nil
		end
		pop_scene(render_stack, prev_scene)
		pop_scene(update_stack, prev_scene)
	end

	if next_scene then
		suspended[name] = nil
		next_scene:resume()
		log.info("[scenes]", "resumed scene: " .. name)
	else
		local scene_cls = assert(class_registry[name], "Scene not found: " .. tostring(name))
		next_scene = scene_cls()
		log.info("[scenes]", "created scene: " .. name)
		next_scene:load()
		scene_registry[next_scene.name] = next_scene
	end
	log.info("[scenes]", "switching to scene: " .. name)
	push_scene(render_stack, next_scene)
	push_scene(update_stack, next_scene)
	return next_scene
end

function M.init()
	local placeholder = setmetatable({fake = true, empty = function() end}, {
		__index = function(t)
			return t.empty
		end
	})
	push_scene(render_stack, placeholder)
	push_scene(update_stack, placeholder)
end

function M.update(dt)
	for i=1, #update_stack do
		update_stack[i]:update(dt)
	end
end

function M.update_fixed(dt)
	for i=1, #update_stack do
		update_stack[i]:update_fixed(dt)
	end
end

function M.draw()
	g.origin()
	g.clear(g.getBackgroundColor())
		for i = 1, #render_stack do
			render_stack[i]:draw()
		end
	g.present()
end

function M.resize(w, h)
	for _,scene in pairs(scene_registry) do
		scene:on_window_resize(w, h)
	end
end

function M.quit()
	for _,scene in pairs(scene_registry) do
		scene:on_quit()
	end
end

return M