love = require('love')
room = require('room')
Door = require('door')

sw, sh = love.window.getDesktopDimensions(1)

Dungeon = {
    size = 0,
    rooms = {},
    current_room = 1,
    changing_room = false
}

function Dungeon:new (world)
    self.size = love.math.random(5, 10)
    for i = 1, self.size do
        local new_room = room:new()
        table.insert(self.rooms, new_room)
    end

    --adding doors to rooms cycle
    for i = 1, self.size, 1 
    do
        local new_door_w = 60
        local new_door_h = 6

        if i == 1 then
            self.rooms[i].forward_door.x = sw/2 - 100/2
            self.rooms[i].forward_door.y = self.rooms[i]:gen_position_y(sh) - 100/2
            self.rooms[i].forward_door.is_active = true
            self.rooms[i].back_door.is_active = false
        end

        if i ~= 1 and i ~= self.size then
            self.rooms[i].forward_door.x = sw/2 - new_door_w/2
            self.rooms[i].forward_door.y = self.rooms[i]:gen_position_y(sh)
            self.rooms[i].forward_door.is_active = true
            self.rooms[i].back_door.is_active = false
        end
            
    end

    return self
end

function Dungeon:change_room()
end

return Dungeon


