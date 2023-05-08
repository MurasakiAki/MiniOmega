require('love')
room = require('room')
door = require('door')

sw, sh = love.window.getDesktopDimensions(1)

dungeon = {
    size = 0,
    rooms = {},
    current_room = 1
}

function dungeon:new (world)
    self.size = love.math.random(5, 10)
    for i = 1, self.size do
        local new_room = room:new()
        table.insert(self.rooms, new_room)
    end

    --adding doors to rooms cycle
    for i = 1, self.size, 1 
    do
        local new_door_w = 60
        local new_door_h = 5

        if i == 1 then
            self.rooms[i].forward_door.x = self.rooms[i]:gen_position_x(sw) + (self.rooms[i].width/2 - new_door_w/2)
            self.rooms[i].forward_door.y = self.rooms[i]:gen_position_y(sh) + 0
            self.rooms[i].forward_door.is_active = true
            self.rooms[i].back_door.is_active = false
        end

        if i ~= 1 and i ~= self.size then
            self.rooms[i].forward_door.x = self.rooms[i]:gen_position_y(sh) + 0
            self.rooms[i].forward_door.y = self.rooms[i]:gen_position_x(sw) + (self.rooms[i].width/2 - new_door_w/2)
            self.rooms[i].forward_door.is_active = true
            self.rooms[i].back_door.is_active = false
        end
            
    end

    return self
end

return dungeon

--mkae dungeon aout of tables and lists ig, it could work,
--also doors will just load the draw scene based on the number of room you are in, the room will have some random atributes

