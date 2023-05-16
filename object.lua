love = require('love')
windfield = require('lib/windfield')

Object = {
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    object_type = '',
    is_breakable = false,
    can_deal_damage = false,
    is_movable = false,
    health = 0,
    damage_range_min = 0,
    damage_range_max = 1,
    image = ''
}

Object.__index = Object

function Object:new(x, y, width, height, object_type, is_breakable,
    can_deal_damage, is_movable, health, damage_range_min, damage_range_max, 
    image)

    --can make entirely new object

    local o = setmetatable({}, Object)

    o.x = x
    o.y = y
    o.width = width
    o.height = height
    o.object_type = object_type
    o.is_breakable = is_breakable
    o.can_deal_damage = can_deal_damage
    o.is_movable = is_movable
    o.health = health
    o.damage_range_min = damage_range_min
    o.damage_range_max = damage_range_max
    o.image = image

    --collider

end

function Object:new_from_prefab()

    --based on object_type will be set up new object

end