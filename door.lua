-- Define the door object
Door = {}
Door.__index = Door

function Door:new(world, x, y, special_type)
    local d = setmetatable({}, Door)

    --door properties
    d.type = "Door"
    d.special_type = special_type
    d.x = x
    d.y = y
    d.width = 100
    d.height = 20
    d.collider = world:newRectangleCollider(d.x, d.y, d.width, d.height)
    d.collider:setFixedRotation(true)
    d.collider:setType('static')

    d.collider:setUserData(d)

    return d
end

-- Drawing function
function Door:draw()
    
    love.graphics.setColor(255, 255, 255)  -- Set the color for drawing the door
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

--inverting door position for transition effect in rooms
function Door:invert_position(x, y, w, h, rw, rh)
    inverted_positions = {x, y}
    --invert top/down
    if y == 0 then
        inverted_positions.x = x
        inverted_positions.y =  rh - h
    elseif y > rh/2 then
        inverted_positions.x = x
        inverted_positions.y = 0
    end

    --invert left/right
    if x == 0 then
        inverted_positions.x = rw - w
        inverted_positions.y = y
    elseif x > rw/2 then
        inverted_positions.x = 0
        inverted_positions.y = y
    end

    return inverted_positions
end

return Door
