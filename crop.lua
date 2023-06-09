local Crop = {}

Crop.__index = Crop

function Crop:new(world, x, y, name, dry_chance, tile, cost)
    local c = setmetatable({}, Crop)

    c.x = x
    c.y = y
    c.width = 16
    c.height = 16
    
    c.name = name
    c.cost = cost
    c.tile = tile
    c.dry_chance = dry_chance
    c.current_phase = 0
    c.is_grown = false
    c.collider = world:newRectangleCollider(c.x, c.y, c.width, c.height)
    c.collider:setCollisionClass('Crop')
    c.type = "Crop"
    c.collider:setType('static')
    c.collider:setSensor(true)
    c.collider:setUserData(c)
    return c
end

function Crop:grown_check()
    if self.current_phase == 3 then
        self.is_grown = true
    end
end

function Crop:grow(tile)
    if self.is_grown ~= true then
        self.current_phase = self.current_phase + 1
        change_field_state(tile)
    
        self:grown_check()
        -- Print the current phase
        print("Current phase:", self.current_phase)
    end
end

return Crop