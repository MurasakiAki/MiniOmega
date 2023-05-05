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

    new_room.width = love.math.random(500, 1600)
    new_room.height = love.math.random(500, 1000)
    new_room.number_of_doors = love.math.random(1, 4)

    return new_room
end

function room:gen_position_x(screen_width)
    position_x = (screen_width/2) - (self.width/2)
    return position_x
end

function room:gen_position_y(screen_height)
    position_y = (screen_height/2) - (self.height/2)
    return position_y
end

return room