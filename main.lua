local level = require("level")
local camera = require("camera")
local Image = require("image")

local screen
local dbg = false
local motion = 1

-- global helper functions
function math.v2_normalize(x, y)
	local len = math.sqrt(x*x+y*y)
	if len > 0 then
		return x/len, y/len
	end
	return x, y
end

function math.lerp(v1, v2, t)
	return v1 + (v2-v1)*t
end

function love.load()
	-- game frame buffer
	love.graphics.setLineStyle("rough")
	screen = love.graphics.newCanvas(WIDTH, HEIGHT)
	screen:setFilter("nearest", "nearest")

	-- load game assets
	IMG_PLAYER_IDLE = Image("assets/player-idle.png")
	IMG_HEART_BULLET = Image("assets/heart-bullet.png")

	level.init()
	level.add_entity(require("entities.player")(100, 100))
end

function love.keypressed(key)
	-- quit the game <ESCAPE>
	if key == "escape" then love.event.quit() end
	-- toggle debug <TAB>
	if key == "tab" then dbg = not dbg end
end

function love.update(dt)
	dt = dt * motion
	camera.update(dt)
	level.update(dt)
 end

local function draw_debug_info()
	local gc_mb = collectgarbage("count")*1e-3
	local fps = love.timer.getFPS()
	local padding = love.graphics.getFont():getHeight()

	love.graphics.setColor(1, 1, 1)
	love.graphics.print(string.format("fps: %d", fps), 5, 0)
	love.graphics.print(string.format("mem: %.2f mb", gc_mb), 5, padding)
	love.graphics.print(string.format("ett: %d", #level.entities), 5, padding*2)
end

local function draw_grid()
	for y=0, HEIGHT-TILE_SIZE, TILE_SIZE do
		for x=0, WIDTH-TILE_SIZE, TILE_SIZE do
			if (x/TILE_SIZE+y/TILE_SIZE)%2 == 0 then
				love.graphics.setColor(0.2, 0, 0.4)
			else
				love.graphics.setColor(0.1, 0.2, 0.3)
			end
			love.graphics.rectangle("fill", x, y, TILE_SIZE, TILE_SIZE)
		end
	end
end

function love.draw()
	love.graphics.setCanvas(screen)
	love.graphics.clear(0, 0, 0)
    camera.viewport(screen)
    camera.attach()
	draw_grid()
	level.draw()
	if dbg then level.debug() end
	camera.dettach()

	-- draw "fake" screen buffer to real backbuffer
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(screen, camera.view_x,
        camera.view_y, 0, camera.view_scale, camera.view_scale)

    if dbg then draw_debug_info() end
end