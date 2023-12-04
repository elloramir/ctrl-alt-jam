local level = require("level")
local Actor = require("entities.actor")
local Enemy = Actor:extend()

local function approach(a, b, amount)
	return a < b and math.min(a+amount, b) or math.max(a-amount, b)
end

function Enemy:new(x, y)
	Enemy.super.new(self, x, y, 16, 16, -8, -16)

	self.pivot_x = 0.5
	self.pivot_y = 1
	self:set_image(IMG_ENEMY_IDLE, 0.1)
end

-- it returns the block i, j that the enemy should go to.
-- path finding considering level.get_tile(x, y) == 0 as walkable.
function Enemy:find_path_to_player()
	local px, py = level.player:tile()
	-- local ex, ey = self:tile()
	
	return px, py
end

function Enemy:update(dt)
	Enemy.super.update(self, dt)

	-- follow player using the cheapest walkable path
	local next_x, next_y = self:find_path_to_player()
	local ex, ey = self:tile()

	self.speed_x = approach(self.speed_x, (next_x-ex)*100, 100*dt)
	self.speed_y = approach(self.speed_y, (next_y-ey)*100, 100*dt)
end

return Enemy