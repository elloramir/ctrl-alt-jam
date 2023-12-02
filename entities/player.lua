local level = require("level")
local camera = require("camera")
local Bullet = require("entities.bullet")
local Actor = require("entities.actor")
local Player = Actor:extend()

function Player:new(x, y)
	Actor.new(self, x, y)

	self.pivot_x = 0.5
	self.pivot_y = 1

	self:set_image(IMG_PLAYER_IDLE)
	self:set_body(16, 16, -0.5, -1)

	self.fire_rate = 0.25
	self.fire_timer = 0
end

function Player:update(dt)
	Actor.update(self, dt)

	-- follow player position
	camera.follow(self.x, self.y)

	-- directional controls
	do
		local dx, dy = 0, 0

		if love.keyboard.isDown("d") then dx = dx + 1 end
		if love.keyboard.isDown("a") then dx = dx - 1 end
		if love.keyboard.isDown("w") then dy = dy - 1 end
		if love.keyboard.isDown("s") then dy = dy + 1 end

		dx, dy = math.v2_normalize(dx, dy)

		self.speed_x = dx*100
		self.speed_y = dy*100
	end

	-- shoot bullets
	self.fire_timer = self.fire_timer + dt
	if self.fire_timer >= self.fire_rate and love.mouse.isDown(1) then
		self.fire_timer = 0
		level.add_entity(Bullet(self.x, self.y-self.body_h/2))
	end
end

return Player