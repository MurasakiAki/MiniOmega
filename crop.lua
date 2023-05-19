love = require('love')
windfield = require('lib/windfield')

local Crop = {}

Crop.__index = Crop

function Crop:new(world, x, y, name, phase_time)
    local c = setmetatable({}, Crop)

    c.x = x
    c.y = y
    c.width = 16
    c.height = 16
    
    c.name = name
    c.phase_time = phase_time
    c.current_phase = 1 --phase 1 = seed, phase 2 = middle, phase 3 = crop
    c.collider = world:newRectangleCollider(c.x, c.y, c.width, c.height)
    c.collider:setType('static')
    c.collider:setSensor(true)
    return c
end

function Crop:start_growth()
    local thread_code = [[

    local wait_time, phase = ...

    

    ]]
    local thread = love.thread.newThread()

end

return Crop