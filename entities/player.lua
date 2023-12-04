local level = require("level")
local Bullet = require("entities.bullet")
local Actor = require("entities.actor")
local Player = Actor:extend()

function Player:new(x, y)
	Player.super.new(self, x, y, 16, 16, -8, -16)

	self.pivot_x = 0.5
	self.pivot_y = 1
	self:set_image(IMG_PLAYER_IDLE, 0.1)

	self.hearts = 100
	self.fire_rate = 0.25
	self.fire_timer = 0
end

-- NOTE(ellora): last holpe shoot if at least 1 heart
function Player:pay_hearts(amount)
	if self.hearts <= 0 then return false end
	self.hearts = self.hearts - amount
	return self.hearts >= 0
end

function Player:update(dt)
	Player.super.update(self, dt)

	-- horizontal controler
	do
		local dx, dy = 0, 0

		if love.keyboard.isDown("a") then dx = dx-1 end
		if love.keyboard.isDown("d") then dx = dx+1 end
		if love.keyboard.isDown("w") then dy = dy-1 end
		if love.keyboard.isDown("s") then dy = dy+1 end

		-- normalize diagonal movement
		if dx ~= 0 and dy ~= 0 then
			dx = dx * 0.70710678118655
			dy = dy * 0.70710678118655
		end

		self.speed_x = dx * 100
		self.speed_y = dy * 100
	end

	-- shoot bullets
	self.fire_timer = self.fire_timer + dt
	if self.fire_timer >= self.fire_rate and love.mouse.isDown(1) and self:pay_hearts(1) then
		self.fire_timer = 0
		level.add_entity(Bullet(self.x, self.y-self.body_h/2))
	end
end

return Player