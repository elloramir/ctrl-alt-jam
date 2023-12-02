WIDTH = 320
HEIGHT = 180
SCALE = 3
TILE_SIZE = 16
DEFAULT_IMAGE_SPEED = 0.1

function love.conf(t)
	t.window.title = "Sweet Hearts"
	t.window.width = WIDTH * SCALE
	t.window.height = HEIGHT * SCALE
	t.window.vsync = false
	t.window.resizable = true
end
