WIDTH = 320
HEIGHT = 240
SCALE = 2
TILE_SIZE = 16

function love.conf(t)
	t.window.title = "Sweet Hearts"
	t.window.width = WIDTH * SCALE
	t.window.height = HEIGHT * SCALE
	t.window.vsync = false
	t.window.resizable = true
end