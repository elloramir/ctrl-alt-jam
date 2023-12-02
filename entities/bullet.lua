local camera = require("camera")
local Actor = require("entities.actor")
local Bullet = Actor:extend()

function Bullet:new(x, y)
	Actor.new(self, x, y)

	self:set_image(IMG_HEART_BULLET)
	self:set_body(8, 8, -0.5, -0.5)

	self.pivot_x = 0.5
	self.pivot_y = 0.5

	-- shoot towards mouse position
	do
		local mx, my = camera.mouse_world_pos()
		local rads = math.atan2(my-y, mx-x)

		self.rotation = rads
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