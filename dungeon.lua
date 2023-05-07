require('love')
room = require('room')
door = require('door')

dungeon = {
    size = 0,
    rooms = {}
}

function dungeon:new ()
    world = love.physics.newWorld(0, 0, true)

    self.size = love.math.random(5, 10)
    for i = 1, self.size do
        local new_room = room:new()
        table.insert(self.rooms, new_room)
    end

    for i = 1, self.size, 1 
    do
        local new_door_w = 10
        local new_door_h = 10
        local inner_for_interpolations = 2

        if i == 1 or i == self.size then
            inner_for_interpolations = 1
        end

        for j = 1, inner_for_interpolations, 1
        do
            if #self.rooms[i].doors == 0 then
                if i == 1 then
                    --starter door, on top
                    local new_forvard_door = door:new(world, self.rooms[i].width/2 - new_door_w/2, 0, new_door_w, new_door_h, i + 1)
                    table.insert(self.rooms[i].doors, new_forvard_door)
                end

                if i != 1 and i != self.size then
                    --room's back door
                    if self.rooms[i-1].doors[]
                    --brain.exe stopped working

                    local new_back_door = door:new(world, )
                end

            end
            

        then
        
        inner_for_interpolations = 2
    end

    return self
end

return dungeon

--mkae dungeon aout of tables and lists ig, it could work,
--also doors will just load the draw scene based on the number of room you are in, the room will have some random atributes

