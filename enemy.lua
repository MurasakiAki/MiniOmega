Enemy = {}

Enemy.__index = Enemy

function Enemy:new(world, x, y)
    local e = setmetatable({}, Enemy)
    e.x = x
    e.y = y
    e.width = 32
    e.height = 32

    e.tpe = "Enemy"
    e.health = 1
    e.speed = love.math.random(60, 90)
    e.damage = 1

    e.collider = world:newRectangleCollider(e.x, e.y, e.width, e.height)
    --e.collider:setType('kinematic')
    e.collider:setCollisionClass('Enemy')
    e.collider:setFixedRotation(true)
    e.collider:setUserData(e)

    return e
end

function Enemy:move(target_x, target_y)
    local dx = target_x - self.x
    local dy = target_y - self.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance > 1 then
        local vx = (dx / distance) * self.speed
        local vy = (dy / distance) * self.speed

        self.collider:setLinearVelocity(vx, vy)
    else
        self.collider:setLinearVelocity(0, 0)
    end
end

return Enemy