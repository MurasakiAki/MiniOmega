Enemy = {}

Enemy.__index = Enemy

function Enemy:new(world, x, y)
    local e = setmetatable({}, Enemy)
    e.x = x
    e.y = y
    e.width = 64
    e.height = 64

    e.tpe = "Enemy"
    e.health = 1
    e.speed = 150
    e.damage = 1

    e.collider = world:newRectangleCollider(e.x, e.y, e.width, e.height)
    e.collider:setType('dynamic')
    e.collider:setCollisionClass('Enemy')
    e.collider:setUserData(e)

    return e
end

return Enemy