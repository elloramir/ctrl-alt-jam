WIDTH = 320
HEIGHT = 240
SCALE = 2
TILE_SIZE = 16
DEFAULT_IMAGE_SPEED = 0.1

function love.conf(t)
	t.window.title = "Sweet Hearts"
	t.window.width = WIDTH * SCALE
	t.window.height = HEIGHT * SCALE
	t.window.vsync = false
	t.window.resizable = true
end

function math.v2_normalize(x, y)
	local len = math.sqrt(x*x+y*y)
	if len > 0 then
		return x/len, y/len
	end
	return x, y
end

-- TODO(ellora): move it to camera module
function temp_mouse_pos()
	local mx, my = love.mouse.getPosition()
	return mx/SCALE, my/SCALE
end