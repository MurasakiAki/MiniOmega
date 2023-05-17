love = require('love')
windfield = require('lib/windfield')

math.randomseed(os.time())

Object = {
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    object_type = '',
    is_breakable = false,
    can_deal_damage = false,
    mass = 0,
    is_movable = false,
    health = 0,
    damage_range_min = 0,
    damage_range_max = 1,
    image = ''
}

Object.__index = Object

function Object:new(world, x, y, width, height, object_type, is_breakable,
    can_deal_damage, mass, is_movable, health, damage_range_min, damage_range_max, 
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
    o.mass = mass
    o.health = health
    o.damage_range_min = damage_range_min
    o.damage_range_max = damage_range_max
    o.image = image

    o.collider = world:newRectangleCOllider(o.x, o.y, o.width, o.height)
    

    if is_breakable then
        if health <= 0 then
            health = 1
        end
    end

    if can_deal_damage then
        o.collider:setSensor(true)
        o.collider:setCollisionClass('Trap')
        if damage_range_min <= 0 then
            damage_range_min = 1
        end

        if damage_range_max <= 0 then
            damage_range_max = damage_range_min + 1
        end

        if damage_range_max == damage_range_min then
            damage_range_max = damage_range_max + 1
        end
    else 
        o.collider:setCollisonClass('Object')
    end

    if is_movable then
        o.collider:setType('dynamic')
        o.collider:getBody():setMass(o.mass)
    else
        o.collider:setType('static')
    end
    return o
end

function Object:new_from_prefab(world, x, y, object_type)

    local o = setmetatable({}, Object)
    local world = world
    o.x = x
    o.y = y

    --based on object_type will be set up new object

    if object_type == "MovableBox" then
        o.width = 64
        o.height = 64
        o.mass = 10
        o.is_breakable = false
        o.can_deal_damage = false
        o.is_movable = true

        o.collider = o:set_collider(world, o.is_movable)

    end

    if object_type == "Rock" then
        o.width = 128
        o.height = 128
        o.is_breakable = false
        o.can_deal_damage = false
        o.is_movable = false
        o.collider = o:set_collider(world, o.is_movable)
    end
    return o
end

function Object:set_collider(world, is_movable)
    local collider = world:newRectangleCollider(self.x, self.y, self.width, self.height)

    if is_movable then
        collider:setCollisionClass('Object')
        collider:setType('dynamic')
        collider:getBody():setMass(self.mass)
        collider:setFixedRotation(true)
        collider:setLinearDamping(self.mass * 2.5)
    else 
        collider:setCollisionClass('Obstacle')
        collider:setType('static')
    end

    return collider
end

function Object:deal_damage()
end

function Object:take_damage()
end



return Object