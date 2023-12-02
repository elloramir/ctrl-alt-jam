local Actor = require("entities.actor")
local Player = Actor:extend()

function Player:new(x, y)
	Actor.new(self, x, y)

	self:set_image(IMG_PLAYER_IDLE)
end

function Player:update(dt)
	Actor.update(self, dt)

	local dx, dy = 0, 0

	if love.keyboard.isDown("d") then dx = dx + 1 end
	if love.keyboard.isDown("a") then dx = dx - 1 end
	if love.keyboard.isDown("w") then dy = dy - 1 end
	if love.keyboard.isDown("s") then dy = dy + 1 end

	dx, dy = math.v2_normalize(dx, dy)

	self.x = self.x+dx
	self.y = self.y+dy
end

return Player