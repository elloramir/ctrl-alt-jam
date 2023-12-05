WIDTH = 480
HEIGHT = WIDTH * 9 / 16
SCALE = 2
TILE_SIZE = 16
DEFAULT_IMAGE_SPEED = 0.1

function love.conf(t)
	t.window.title = "sweeat heart"
	t.window.width = WIDTH * SCALE
	t.window.height = HEIGHT * SCALE
	t.window.resizable = true
	t.window.vsync = false
end

function sign(x)
	return x == 0 and 0 or (x > 0 and 1 or -1)
end