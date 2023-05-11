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
        local new_door_w = 100
        local new_door_h = 50

        if i == 1 then
            self.rooms[i].forward_door.x = sw/2
            self.rooms[i].forward_door.y = self.rooms[i]:gen_position_y(sh)
            self.rooms[i].back_door.x = 0
            self.rooms[i].back_door.y = 0
        end

        if i ~= 1 and i ~= self.size then
            self.rooms[i].forward_door.x = sw/2
            self.rooms[i].forward_door.y = self.rooms[i]:gen_position_y(sh)
            self.rooms[i].back_door.x = sw/2
            self.rooms[i].back_door.y = self.rooms[i]:gen_position_y(sh) + self.rooms[i].height 
        end

        if i == self.size then
            self.rooms[i].forward_door.x = 0
            self.rooms[i].forward_door.y = 0
            self.rooms[i].back_door.x = sw/2
            self.rooms[i].back_door.y = self.rooms[i]:gen_position_y(sh) + self.rooms[i].height 
        end
            
    end

    return self
end

function Dungeon:change_room()
end

return Dungeon


