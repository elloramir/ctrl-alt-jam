local Actor = require("entities.actor")
local Blood = Actor:extend()

function Blood:new(x, y)
	Blood.super.new(self, x, y, 16, 16, -8, -8)

	-- blood over wall looks weird
	if self:place_meeting() then
		self:destroy()
		return
	end

	self:set_order(-1)
	self:set_image(IMG_BLOOD, 0)

	self.pivot_x = 0.5
	self.pivot_y = 0.5
	self.scale_x = rand_float(0.8, 1)
	self.scale_y = rand_float(0.8, 1)
	self.flip_x = rand_bool()
	self.frame = math.random(1, #self.image.quads)
	self.alpha = rand_float(0.8, 1)
	self.fade_speed = rand_float(0.5, 1)
	self.disperse_speed = rand_float(0.5, 1)
end

function Blood:update(dt)
	Blood.super.update(self, dt)

	-- fade out
	self.alpha = self.alpha - self.fade_speed*dt
	if self.alpha <= 0 then
		self:destroy()
	end

	-- disperse blood over time
	self.scale_x = self.scale_x + self.disperse_speed*dt
	self.scale_y = self.scale_y + self.disperse_speed*dt
end

return Blood