require('love')
Tiles = require('tiles')

local screen_width, screen_height = love.window.getDesktopDimensions(1)

room = {
    width = 0,
    height = 0,
    tileset = nil,
    is_special = false
}

function room:new()
    local new_room = {}
    setmetatable(new_room, self)
    self.__index = self

    new_room.width = love.math.random(math.floor(screen_width * 0.2 / 64), math.floor(screen_width * 0.95 / 64)) * 64
    new_room.height = love.math.random(math.floor(screen_height * 0.4 / 64), math.floor(screen_height * 0.95 / 64)) * 64

    new_room.active_doors = false
    new_room.forward_door = {x = 0, y = 0}
    new_room.back_door = {x = 0, y = 0}

    new_room.has_started = false
    new_room.encounter_time = math.random(60, 120)

    --setting the rooms tileset
    local numRows = math.floor(new_room.height / 64)
    local numCols = math.floor(new_room.width / 64)
    
    new_room.tileset = Tiles:new(64, 64, numCols, numRows, new_room:gen_position_x(screen_width), new_room:gen_position_y(screen_height))
    
    --if room will be special room
    math.randomseed(os.time())
    local special_chance = math.random(1, 10)

    if special_chance == 7 then
        new_room.is_special = true
    end

    if new_room.is_special == true then
        new_room.tileset.is_clickable = false
        new_room.active_doors = true
    end

    return new_room
end

function room:draw_prepare_counter()
    if not self.has_started and not self.is_special then
        self.has_started = true
        self.counter = 8
        self.timer = 0
    end

    if self.has_started then
        self.timer = self.timer + love.timer.getDelta()

        if self.counter > 0 then
            if self.timer >= 1 then
                self.timer = self.timer - 1
                self.counter = self.counter - 1
            end

            love.graphics.setColor(0.75, 0.2, 0.1)
            love.graphics.print(tostring(self.counter), screen_width / 2, 0)
        else
            love.graphics.setColor(0.75, 0.2, 0.1)
            love.graphics.print("Encounter!", screen_width / 2, 0)
            self.active_doors = true
        end
    end
    print(self.active_doors)
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