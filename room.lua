require("love")

room = {
    width = 0,
    height = 0,
    number_of_doors = 0
}

function room:new()
    local new_room = {}
    setmetatable(new_room, self)
    self.__index = self

    new_room.width = love.math.random(200, 1000)
    new_room.height = love.math.random(200, 1000)
    new_room.number_of_doors = love.math.random(1, 4)

    return new_room
end

return room