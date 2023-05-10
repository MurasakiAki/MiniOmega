-- Define the door object
Door = {}
Door.__index = Door

-- Constructor
function Door:new(world, x, y, width, height)
    local self = setmetatable({}, Door)
    self.leads_to = 0
    self.width = width
    self.height = height
    self.body = love.physics.newBody(world, x, y, "static")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData({type = "Door", leads_to = self.leads_to})
    
    return self
end

-- Drawing function
function Door:draw()
    love.graphics.setColor(255, 255, 255)  -- Set the color for drawing the door
    local x, y = self.body:getPosition()
    love.graphics.rectangle("fill", x, y, self.width, self.height)
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
