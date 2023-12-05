local level = require("level")
local Actor = require("entities.actor")
local Item = Actor:extend()

Item.KEY = 1

local item_images = {
	[Item.KEY] = "IMG_ITEM_KEY",
}

function Item:new(x, y, kind)
	Item.super.new(self, x, y-8, 8, 8)

	self.kind = kind
	self:set_image(_G[item_images[kind]])

	self.timer = 0
end

function Item:update(dt)
	Item.super.update(self, dt)

	-- pickup item
	if self:overlaps(level.player) then
		level.player:add_item(self.kind)
		self:destroy()
	end

	-- bob up and down
	self.timer = self.timer + dt
	self.y = self.y - math.sin(self.timer*5)*dt*10
end

function Item.draw_icon(kind, x, y)
	_G[item_images[kind]]:draw_index(1, x, y, 0, 1.3, 1.3)
end

return Item