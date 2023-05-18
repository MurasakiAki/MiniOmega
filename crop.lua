love = require('love')
windfield = require('lib/windfield')

local Crop = {}

Crop.__index = Crop

function Crop:new(world, x, y, width, height)
    local c = setmetatable({}, Crop)

    c.x = x
    c.y = y
    c.width = width
    c.height = height
    
    
end