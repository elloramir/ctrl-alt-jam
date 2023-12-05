local Item = require("entities.item")
local Image = require("image")
local level = require("level")

function love.load()
	love.graphics.setLineStyle("rough")
	love.graphics.setDefaultFilter("nearest", "nearest")

	IMG_PLAYER_IDLE = Image("assets/player-idle.png", 16, 16)
	IMG_ENEMY_IDLE = Image("assets/enemy-idle.png", 16, 16)
	IMG_HEART_BULLET = Image("assets/heart-bullet.png", 8, 8)
	IMG_ITEM_KEY = Image("assets/item-key.png")

	level.load("assets/test_room.txt")
end

function love.update(dt)
	level.update(dt)
end

function love.draw()
	do
		local w, h = love.graphics.getDimensions()
		local scale = math.min(w / WIDTH, h / HEIGHT)
		local x = (w - WIDTH * scale) / 2
		local y = (h - HEIGHT * scale) / 2

		love.graphics.push()
		love.graphics.translate(x, y)
		love.graphics.scale(scale)

		-- draw our game here
		level.draw()

		-- draw player hearts
		love.graphics.setColor(1, 0, 0)
		love.graphics.print("x" .. level.player.hearts, 10, 10)

		-- draw player itens (right coner)
		love.graphics.setColor(1, 1, 1)
		for i, item in ipairs(level.player.itens) do
			Item.draw_icon(item, (WIDTH-26)-(i-1)*26, 10)
		end

		love.graphics.pop()
	end

	-- debug info
	-- love.graphics.setColor(1, 1, 1)
	-- love.graphics.print("fps: " .. love.timer.getFPS(), 10, 10)
	-- love.graphics.print("mem: " .. math.floor(collectgarbage("count")) .. "kb", 10, 30)
	-- love.graphics.print("ent: " .. #level.entities, 10, 50)
end