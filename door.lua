love = require('love')

local door = {}

function door:new(world, x, y, w, h)
    local obj = {
        x = x,
        y = y, 
        w = w,
        h = h,
        body = love.physics.newBody(world, x, y, "static"),
        shape = love.physics.newRectangleShape(w, h),
    }
    obj.fixture = love.physics.newFixture(obj.body, obj.shape)
    --obj.fixture:setCategory(2)
    --obj.fixture:setMask(1)
    obj.fixture:setUserData({type = "Door", leads_to = obj.leads_to})
    
    setmetatable(obj, {__index = door})
    return obj
end

function door:invert_position(x, y, w, h, rw, rh)
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

function door:draw(current_room)
    love.graphics.setColor(0.8, 0.1, 0.3)
    love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), self.w, self.h)
end

return door

