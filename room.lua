love = require("love")

room = {
    width = 0,
    height = 0,
    number_of_doors = 0
}

function room:new()
    self.width = love.math.random(200, 1000)
    self.height = love.math.random(200, 1000)
    self.number_of_doors = love.math.random(1, 4)
end

return room