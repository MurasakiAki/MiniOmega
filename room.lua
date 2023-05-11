require('love')

local screen_width, screen_height = love.window.getDesktopDimensions(1)

room = {
    width = 0,
    height = 0,
}

function room:new()
    local new_room = {}
    setmetatable(new_room, self)
    self.__index = self

    new_room.width = love.math.random(screen_width * 0.2, screen_width * 0.95)
    new_room.height = love.math.random(screen_height * 0.4, screen_height * 0.95)
    new_room.forward_door = {x = 0, y = 0}
    new_room.back_door = {x = 0, y = 0}
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