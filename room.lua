require('love')
Tiles = require('tiles')
Enemy = require('enemy')
Object = require('object')

local screen_width, screen_height = love.window.getDesktopDimensions(1)

math.randomseed(os.time()) -- Set the random seed only once at the start

room = {
    width = 0,
    height = 0,
    tileset = nil,
    is_special = false,
    objects = {},
    counter = 0,
    timer = 0,
    countdown_timer = 0,
    enemies = {}
}

function room:new(world)
    local new_room = {}
    setmetatable(new_room, self)
    self.__index = self

    new_room.width = love.math.random(math.floor(screen_width * 0.2 / 64), math.floor(screen_width * 0.95 / 64)) * 64
    new_room.height = love.math.random(math.floor(screen_height * 0.4 / 64), math.floor(screen_height * 0.95 / 64)) * 64

    new_room.active_doors = false
    new_room.forward_door = {x = 0, y = 0}
    new_room.back_door = {x = 0, y = 0}

    new_room.traps = {}

    new_room.has_started = false
    new_room.encounter_time = math.random(60, 120)

    -- Setting the room's tileset
    local numRows = math.floor(new_room.height / 64)
    local numCols = math.floor(new_room.width / 64)
    
    new_room.tileset = Tiles:new(world, 64, 64, numCols, numRows, new_room:gen_position_x(screen_width), new_room:gen_position_y(screen_height))
    
    -- If the room will be a special room
    local special_chance = math.random(1, 10)

    if special_chance == 7 then
        new_room.is_special = true
    end

    if new_room.is_special then
        new_room.tileset.is_clickable = false
        new_room.active_doors = true
    else
        local num_of_traps = math.random(0, 3)
        print("number of traps:" ..num_of_traps)
        for i = 1, num_of_traps, 1 do
            local trap = Object:new(world,
            math.random(0, screen_width),
            math.random(0, screen_height),
            16, 16,
            'Trap',
            false,
            true,
            2,
            false,
            0,
            5, 10)

            table.insert(new_room.traps, trap)
        end

    end

    return new_room
end

function room:draw_prepare_counter(world)
    if not self.has_started and not self.is_special then
        self.has_started = true
        self.counter = 10
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
            self:start_encounter(world)
        end
    end
end

function room:start_encounter(world)
    if self.encounter_time == 0 then
        love.graphics.setColor(0.75, 0.2, 0.1)
        love.graphics.print("Room Cleared!", screen_width / 2, 15)
        self.active_doors = true
    else
        if self.countdown_timer <= 0 then
            self.encounter_time = self.encounter_time - 1
            self.countdown_timer = 1  -- Reset countdown timer to 1 second

            -- Iterate through the tileset
            for i = 1, #self.tileset do
                for j = 1, #self.tileset[i] do
                    local tile = self.tileset[i][j]

                    local chance = love.math.random(0, 100)

                    if tile.has_seed and tile.is_watered then
                        if chance <= tile.planted_seed.dry_chance then
                            tile.planted_seed:grow(tile)
                        end
                    end
                end
            end

            

            -- Spawning random number of enemies each second
            local enemy_chance = love.math.random(1, 100)
            local enemy_count = love.math.random(1, 2)

            if enemy_chance <= 25 then
                for i = 1, enemy_count do
                    -- picking side, on which side should enemy spawn
                    -- 1 left, 2 top, 3 right, 4 bottom
                    local room_side = love.math.random(1, 4)

                    if room_side == 1 then
                        local enemy_x = love.math.random(0, self:gen_position_x(screen_width) - 32)
                        local enemy_y = love.math.random(0, screen_height)
                        enemy = Enemy:new(world, enemy_x, enemy_y)
                        table.insert(self.enemies, enemy)
                    elseif room_side == 2 then
                        local enemy_x = love.math.random(0, screen_width)
                        local enemy_y = love.math.random(0, self:gen_position_y(screen_height) - 32)
                        enemy = Enemy:new(world, enemy_x, enemy_y)
                        table.insert(self.enemies, enemy)
                    elseif room_side == 3 then
                        local enemy_x = love.math.random(self.width + self:gen_position_x(screen_width), screen_width)
                        local enemy_y = love.math.random(0, screen_height)
                        enemy = Enemy:new(world, enemy_x, enemy_y)
                        table.insert(self.enemies, enemy)
                    elseif room_side == 4 then
                        local enemy_x = love.math.random(0, screen_width)
                        local enemy_y = love.math.random(self.height + self:gen_position_y(screen_height), screen_height)
                        enemy = Enemy:new(world, enemy_x, enemy_y)
                        table.insert(self.enemies, enemy)
                    end
                    
                end
            end

        end
        self.countdown_timer = self.countdown_timer - love.timer.getDelta()
        love.graphics.setColor(0.75, 0.2, 0.1)
        love.graphics.print(tostring(self.encounter_time), screen_width / 2, 15)
    end
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