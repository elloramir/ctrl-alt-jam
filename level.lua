local level = {}

function level.load(filename)
	local content = love.filesystem.read(filename)

	level.tiles = {}
	level.entities = {}
	level.cols = 20
	level.rows = 14

	local j = 1
	for row in content:gmatch("[^\r\n]+") do
		local i = 1
		for char in row:gmatch(".") do
			local x = i*TILE_SIZE
			local y = j*TILE_SIZE
			local tile = 0 -- empty as default

			if char == "#" then tile = 1
			elseif char == "p" then
				level.player = require("entities/player")(x, y)
				level.add_entity(level.player)
			elseif char == "e" then
				level.add_entity(require("entities/enemy")(x, y))
			end

			table.insert(level.tiles, tile)
			i = i+1
		end
		j = j+1
	end

	assert(#level.tiles == level.cols*level.rows)
end

function level.get_tile(x, y)
	return level.tiles[y*level.cols+x+1]
end

-- TODO(ellora): make it based on clip area
function level.mouse_pos()
	local mx, my = love.mouse.getPosition()
	local margin_x = (WIDTH - level.cols*TILE_SIZE) / 2
	local margin_y = (HEIGHT - level.rows*TILE_SIZE) / 2

	return mx/SCALE - margin_x, my/SCALE - margin_y
end

function level.add_entity(en)
	assert(en.active)
	table.insert(level.entities, en)
end

local function sort_entities(a, b)
	return a.order < b.order
end

function level.update(dt)
	if math.random() > 0.7 then
		table.sort(level.entities, sort_entities)
	end

	-- loop entities in reverse order so we can remove them
	-- without indexing issues
	for i = #level.entities, 1, -1 do
		local en = level.entities[i]
		if en.active then
			en:update(dt)
		else
			table.remove(level.entities, i)
		end
	end
end

function level.draw()
	local margin_x = (WIDTH - level.cols*TILE_SIZE) / 2
	local margin_y = (HEIGHT - level.rows*TILE_SIZE) / 2

	love.graphics.push()
	love.graphics.translate(margin_x, margin_y)

	for y = 0, level.rows-1 do
		for x = 0, level.cols-1 do
			local tile = level.get_tile(x, y)
			if tile == 1 then
				love.graphics.rectangle(
					"fill", x*TILE_SIZE, y*TILE_SIZE, TILE_SIZE, TILE_SIZE)
			end
		end
	end

	for _, en in ipairs(level.entities) do
		if en.active then
			en:draw()
		end
	end

	love.graphics.pop()
end

return level