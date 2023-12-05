local level = require("level")
local Actor = require("entities.actor")
local Item = Actor:extend()

Item.KEY = 1

local item_images = {
	[Item.KEY] = "IMG_ITEM_KEY",
}

function Item:new(x, y, kind)
	Item.super.new(self, x, y, 16, 16)

	-- prevent it from getting stuck in walls
	while self:place_meeting() do
		local dx = self.x < level.player.x and 1 or -1
		local dy = self.y < level.player.y and 1 or -1

		self.x = self.x + dx
		self.y = self.y + dy
	end

	self.kind = kind
	self:set_image(_G[item_images[kind]])
	self.timer = 0
	self.restitution = 0.5
	
	-- TODO(ellora): still that way or bobbing?
	self.speed_x = math.random(-100, 100)
	self.speed_y = math.random(-100, 100)
end

function Item:update(dt)
	Item.super.update(self, dt)

	-- pickup item
	if self:overlaps(level.player) then
		level.player:add_item(self.kind)
		self:destroy()
	end
end

function Item.draw_icon(kind, x, y)
	_G[item_images[kind]]:draw_index(1, x, y, 0, 1.3, 1.3)
end

return Item