local camera = {}

camera.x = 0
camera.y = 0
camera.to_x = 0
camera.to_y = 0
camera.speed = 10
camera.rotation = 0
camera.zoom = 1
camera.view_x = 0
camera.view_y = 0
camera.view_w = 0
camera.view_h = 0
camera.view_scale = 1
camera.margin_x = WIDTH/2
camera.margin_y = HEIGHT/2

function camera.follow(x, y)
	camera.to_x = x
	camera.to_y = y
end

function camera.update(dt)
	camera.x = math.lerp(camera.x, camera.to_x, camera.speed*dt)
	camera.y = math.lerp(camera.y, camera.to_y, camera.speed*dt)
end

function camera.attach()
	love.graphics.push()
	love.graphics.translate(camera.margin_x, camera.margin_y)
	love.graphics.scale(camera.zoom, camera.zoom)
	love.graphics.rotate(camera.rotation)
	love.graphics.translate(-camera.x, -camera.y)
end

function camera.dettach()
	love.graphics.pop()
end

function camera.viewport(screen)
    local w, h = love.graphics.getDimensions()
    local scale = math.min(w/WIDTH, h/HEIGHT)
    
	camera.view_x = (w - WIDTH * scale) / 2
	camera.view_y = (h - HEIGHT * scale) / 2
	camera.view_w = WIDTH
	camera.view_h = HEIGHT
    camera.view_scale = scale
end

function camera.mouse_world_pos()
    local mx, my = love.mouse.getPosition()
    return
        camera.x + mx/camera.view_scale + camera.view_x - camera.margin_x,
        camera.y + my/camera.view_scale + camera.view_y - camera.margin_y
end

return camera