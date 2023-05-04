require("love")
room = require("room")

dungeon = {
    size = 0,
    rooms = {}
}

function dungeon:new ()
    self.size = love.math.random(5, 10)
    for i = 1, self.size do
        local new_room = room:new()
        table.insert(self.rooms, new_room)
    end
    return self
end

return dungeon

--mkae dungeon aout of tables and lists ig, it could work,
--also doors will just load the draw scene based on the number of room you are in, the room will have some random atributes

