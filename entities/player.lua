local level = require("level")
local Bullet = require("entities.bullet")
local Actor = require("entities.actor")
local Player = Actor:extend()

function Player:new(x, y)
	Actor.new(self, x, y)

	self.pivot_x = 0.5
	self.pivot_y = 1

	self:set_image(IMG_PLAYER_IDLE)
	self:set_body(16, 16, -0.5, -1)
end

function Player:update(dt)
	Actor.update(self, dt)

	-- directional controls
	do
		local dx, dy = 0, 0

		if love.keyboard.isDown("d") then dx = dx + 1 end
		if love.keyboard.isDown("a") then dx = dx - 1 end
		if love.keyboard.isDown("w") then dy = dy - 1 end
		if love.keyboard.isDown("s") then dy = dy + 1 end

		dx, dy = math.v2_normalize(dx, dy)

		self.x = self.x+dx
		self.y = self.y+dy
	end

	-- shoot bullets
	if love.mouse.isDown(1) then
		level.add_entity(Bullet(self.x, self.y))
	end
end

return Player