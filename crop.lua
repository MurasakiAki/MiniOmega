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
    local thread = love.thread.newThread('crop_thread.lua') -- Create a new thread using the 'crop_thread.lua' file
    
    thread:start(self.phase_time, function()
        -- This function will be executed in the thread
        while self.current_phase < 3 do
            if self.phase_time <= 0 then
                self.current_phase = self.current_phase + 1
                -- Do any other necessary actions for phase change
                print("phase:", self.current_phase)
            end
            love.timer.sleep(1) -- Sleep for 1 second before checking phase_time again
        end
    end)

end

return Crop