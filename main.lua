local screen
local motion = 1

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")

	screen = love.graphics.newCanvas(WIDTH, HEIGHT)
end

function love.keypressed(key)
	if key == "escape" then love.event.quit() end
end

function love.update(dt)
	dt = dt * motion
end

function love.draw()
	love.graphics.setCanvas(screen)
	love.graphics.clear(0, 0, 0)

	-- TODO: render game

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