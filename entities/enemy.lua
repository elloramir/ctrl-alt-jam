local level = require("level")
local Item = require("entities.item")
local Actor = require("entities.actor")
local Enemy = Actor:extend()

local STATE_NORMAL = 1
local STATE_HIT = 2

local function approach(a, b, amount)
	return a < b and math.min(a+amount, b) or math.max(a-amount, b)
end

function Enemy:new(x, y)
	Enemy.super.new(self, x, y, 16, 16, -8, -16)

	-- NOTE(ellora): same problem from is_actor
	self.is_enemy = true
	self.state = STATE_NORMAL

	self.pivot_x = 0.5
	self.pivot_y = 1
	self:set_image(IMG_ENEMY_IDLE, 0.1)

	self.initial_hearts = 10
	self.hearts = self.initial_hearts

	self.bounce_speed = 200
	self.max_speed = 60
	self.friction = 1000
	self.acceleration = 500

	self.stun_time = 0.25
	self.stun_timer = 0
end

function Enemy:hit()
	self.state = STATE_HIT
	self.hearts = self.hearts-1

	-- bounce back
	self.speed_x = self.bounce_speed*(self.x < level.player.x and -1 or 1)
	self.speed_y = self.bounce_speed*(self.y < level.player.y and -1 or 1)

	if self.hearts <= 0 then
		self:destroy()

		-- decrease enemy count
		level.enemies = level.enemies-1
		if level.enemies <= 0 then
			-- drop key
			level.add_entity(Item(self.x, self.y, Item.KEY))
		end

		-- TODO(ellora): visual particles like on god of war
		-- give player hearts
		local percent = rand_float(0.2, 0.3)
		local total_hearts = math.floor(self.initial_hearts*percent)
		level.player.hearts = level.player.hearts + total_hearts
	end
end

function Enemy:update(dt)
	Enemy.super.update(self, dt)

	if self.state == STATE_NORMAL then
		local px, py = level.player:tile()
		local ex, ey = self:tile()
		local dx, dy = sign(px-ex), sign(py-ey)

		-- move towards player
		self.speed_x = approach(self.speed_x, dx*self.max_speed, self.acceleration*dt)
		self.speed_y = approach(self.speed_y, dy*self.max_speed, self.acceleration*dt)

	elseif self.state == STATE_HIT then
		-- stun timer
		self.stun_timer = self.stun_timer+dt
		if self.stun_timer >= self.stun_time then
			self.state = STATE_NORMAL
			self.stun_timer = 0
		end

		-- apply friction
		self.speed_x = approach(self.speed_x, 0, self.friction*dt)
		self.speed_y = approach(self.speed_y, 0, self.friction*dt)
	end
end

return Enemy