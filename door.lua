-- Door object module
local Door = {}

function Door:new(world, x, y, width, height)
    local door = {}

    -- Create a door physics body
    door.body = love.physics.newBody(world, x, y, "static")
    door.shape = love.physics.newRectangleShape(width, height)
    door.fixture = love.physics.newFixture(door.body, door.shape)

    -- Set door properties
    door.fixture:setUserData({type = "Door", leads_to = door.leads_to})
    -- Draw the door
    function door.draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("fill", door.body:getWorldPoints(door.shape:getPoints()))
  end

  return door
end

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
