local level = require("level")
local Actor = require("entities.actor")
local Bullet = Actor:extend()

function Bullet:new(x, y)
	Actor.new(self, x, y, 8, 8, -4, -4)

	self.pivot_x = 0.5
	self.pivot_y = 0.5
	self:set_image(IMG_HEART_BULLET)

	self.restitution = 0.9

	-- shoot towards mouse position
	do
		local mx, my = level.mouse_pos()
		local rads = math.atan2(my-y, mx-x)

		self.speed_x = math.cos(rads)*500
		self.speed_y = math.sin(rads)*500
	end

	self.max_life_time = 1
end

function Bullet:update(dt)
	Actor.update(self, dt)

	self.max_life_time = self.max_life_time-dt
	if self.max_life_time <= 0 then
		self:destroy()
	end
end

return Bullet