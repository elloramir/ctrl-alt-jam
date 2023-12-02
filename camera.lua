local camera = {}

camera.x = 0
camera.y = 0
camera.to_x = 0
camera.to_y = 0
camera.speed = 10
camera.rotation = 0
camera.zoom = 1

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
	love.graphics.translate(WIDTH/2, HEIGHT/2)
	love.graphics.scale(camera.zoom, camera.zoom)
	love.graphics.rotate(camera.rotation)
	love.graphics.translate(-camera.x, -camera.y)
end

function camera.dettach()
	love.graphics.pop()
end

return camera