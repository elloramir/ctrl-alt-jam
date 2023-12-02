local level = {}

function level.init()
    level.entities = {}
end

function level.add_entity(entity)
    assert(entity.active)
    table.insert(level.entities, entity)
end

local function sort_entities(a, b)
    return a.order < b.order
end

function level.update(dt)
    -- random calls makes it lighter and the visual
    -- gap are not noticeable at all.
    if math.random() > 0.5 then
        table.sort(level.entities, sort_entities)
    end

    -- backwards loop will prevent index swaps
    -- and will allow us to avoid newcomings entities
    -- to be updated on the same frame they are created.
    for i = #level.entities, 1, -1 do
        local entity = level.entities[i]
        if entity.active then
            entity:update(dt)
        else
            table.remove(level.entities, i)
        end
    end
end

-- TODO(ellora): camera occlusion
function level.draw()
    for _, entity in ipairs(level.entities) do
        if entity.active then
            entity:draw()
        end
    end
end

function level.debug()
    for _, entity in ipairs(level.entities) do
        entity:debug()
    end
end

return level