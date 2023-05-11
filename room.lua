require('love')
Tiles = require('tiles')

local screen_width, screen_height = love.window.getDesktopDimensions(1)

room = {
    width = 0,
    height = 0,
    tileset = nil
}

function room:new()
    local new_room = {}
    setmetatable(new_room, self)
    self.__index = self

    new_room.width = love.math.random(math.floor(screen_width * 0.2 / 64), math.floor(screen_width * 0.95 / 64)) * 64
    new_room.height = love.math.random(math.floor(screen_height * 0.4 / 64), math.floor(screen_height * 0.95 / 64)) * 64

    new_room.forward_door = {x = 0, y = 0}
    new_room.back_door = {x = 0, y = 0}

    local numRows = math.floor(new_room.height / 64)
    local numCols = math.floor(new_room.width / 64)
    

    print(new_room:gen_position_x(screen_width))

    new_room.tileset = Tiles:new(64, 64, numCols, numRows, new_room:gen_position_x(screen_width), new_room:gen_position_y(screen_height))

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