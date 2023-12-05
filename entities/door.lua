local level = require("level")
local Item = require("entities.item")
local Actor = require("entities.actor")
local Door = Actor:extend()

function Door:new(x, y)
	Door.super.new(self, x, y, 16, 16, -16, -16)

	self.pivot_x = 1
	self.pivot_y = 1

	self:set_image(IMG_DOOR, 0)

	self.open = false
end

function Door:update(dt)
	Door.super.update(self, dt)

	-- image frame based on door state
	self.frame = self.open and 2 or 1

	if self:overlaps(level.player) and not self.open then
		-- open door and remove key from inventory
		if level.player:find_item(Item.KEY) then
			self.open = true
			level.player:remove_item(Item.KEY)
		else
			-- prevent player from going through
			level.player.y = self.y+16
		end
	end
end

return Door