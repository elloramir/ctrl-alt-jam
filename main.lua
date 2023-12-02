local level = require("level")

local screen
local dbg = false
local motion = 1

function love.load()
	-- game frame buffer
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")
	screen = love.graphics.newCanvas(WIDTH, HEIGHT)

	level.init()
end

function love.keypressed(key)
	-- <ESCAPE>: quit the game
	if key == "escape" then love.event.quit() end
	-- <TAB>: toggle debug
	if key == "tab" then dbg = not dbg end
end

function love.update(dt)
	dt = dt * motion
	level.update(dt)
end

local function draw_debug_info()
	local gc_mb = collectgarbage("count")*1e-3
	local fps = love.timer.getFPS()
	local padding = love.graphics.getFont():getHeight()

	love.graphics.setColor(1, 1, 1)
	love.graphics.print(string.format("fps: %d", fps), 5, 0)
	love.graphics.print(string.format("mem: %.2f mb", gc_mb), 5, padding)
end

function love.draw()
	love.graphics.setCanvas(screen)
	love.graphics.clear(0, 0, 0)
	level.draw()
	if dbg then
		level.debug()
		draw_debug_info()
	end

	-- draw "fake" screen buffer to real backbuffer
	do
		local w, h = love.graphics.getDimensions()
		local scale = math.min(w/WIDTH, h/HEIGHT)
		local x = (w - WIDTH * scale) / 2
		local y = (h - HEIGHT * scale) / 2
	
		love.graphics.setCanvas()
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(screen, x, y, 0, scale, scale)
	end
end