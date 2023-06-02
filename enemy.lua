Enemy = {}

Enemy.__index = Enemy

function Enemy:new(world, x, y)
    local e = setmetatable({}, Enemy)
    e.x = x
    e.y = y
    e.width = 32
    e.height = 32

    e.type = "Enemy"
    e.health = 1
    e.speed = love.math.random(60, 90)
    e.damage = 1
    e.mass = 5

    e.collider = world:newRectangleCollider(e.x, e.y, e.width, e.height)
    --e.collider:setType('kinematic')
    e.collider:setType('dynamic')
    e.collider:setCollisionClass('Enemy')
    e.collider:setFixedRotation(true)
    e.collider:setLinearDamping(e.mass * 2.5)
    e.collider:setUserData(e)
    e.collider:setObject(e)

    return e
end

function Enemy:move(target_x, target_y)
    if self.collider then
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
end

function Enemy:die()
    self.collider:destroy()
end

return Enemy