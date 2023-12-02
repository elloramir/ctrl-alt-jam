local level = require("level")
local Entity = require("entity")
local Actor = Entity:extend()

-- Actor is a god class, if this hurt your feelings,
-- I'm sorry, but it is what it is ¯\_(ツ)_/¯.
function Actor:new(x, y)
	Entity.new(self, 1)

	self.x = x
	self.y = y
	self.pivot_x = 0
	self.pivot_y = 0
	self.scale_x = 1
	self.scale_y = 1
	self.flip_x = false
	self.flip_y = false
	self.rotation = 0
end

function Actor:set_image(img)
	if self.image ~= img then
		self.image = img
		self.frame_speed = speed or DEFAULT_IMAGE_SPEED
		self.frame_timer = 0
		self.frame = 1
	end
end

-- TODO(ellora): add body to bumbp world
-- NOTE(ellora): offsets are normalized [0, 1]
function Actor:set_body(w, h, ox, oy)
	self.has_body = true
	self.body_w = w
	self.body_h = h
	self.body_ox = math.floor((px or 0) * w)
	self.body_oy = math.floor((py or 0) * h)
	self.speed_x = 0
	self.speed_y = 0
end

function Actor:move(dt)
	self.x = self.x + self.speed_x*dt
	self.y = self.y + self.speed_y*dt
end

function Actor:update(dt)
	if self.has_body and (self.speed_x ~= 0 or self.speed_y ~= 0) then
		self:move(dt)
	end

	-- update frame index
	if self.image and self.frame_speed > 0 then
		self.frame_timer = self.frame_timer+dt
		if self.frame_timer > self.frame_speed then
			self.frame = self.frame+1
			self.frame_timer = 0
		end
	end
end

function Actor:draw()
	if not self.image then
		return
	end

	local scale_x = (self.flip_x and -1 or 1) * self.scale_x
	local scale_y = (self.flip_y and -1 or 1) * self.scale_y
	local pivot_x = math.floor(self.image.width * self.pivot_x)
	local pivot_y = math.floor(self.image.height * self.pivot_y)

	love.graphics.setColor(1, 1, 1)
	self.image:draw_index(self.frame, self.x, self.y, self.rotation,
		scale_x, scale_y, pivot_x, pivot_y)
end

function Actor:debug()
	if self.has_body then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("line", self.x+self.body_ox,
			self.y+self.body_oy, self.body_w, self.body_h)
	end
end

return Actor