love = require('love')

door = {}

function door:new(world, x, y, w, h, leads_to)
    local self = {
        x = x
        y = y  

        w = w
        h = h

        leads_to = leads_to

        body = love.physics.newBody(world, x, y, "static"),
        shape = love.physics.newRectangleShape(w, h),
        fixture = love.physics.newFixture(self.body, self.shape)
    }
    
    setmetatable(self, {__index = door})
    return self
end

function door:draw()
    love.graphics.setColor(0.8, 0.1, 0.3)
    love.graphics.rectangle("fill", door.x, door.y, door. w, door.h)
end

 

