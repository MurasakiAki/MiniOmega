local Attack = {}

Attack.__index = Attack

function Attack:new(world, x, y)
    local a = setmetatable({}, Attack)
    a.size = 32
    a.type = "Attack"
    a.collider = world:newCircleCollider(x, y, a.size)
    a.collider:setSensor(true)
    a.collider:setType('static')
    a.collider:setCollisionClass('Attack')
    a.collider:setUserData(a)
    a.collider:setObject(a)
    a.has_started = false
    a.duration = 0.2
    a.timer = 0

    return a
end

function Attack:update(dt)
    if self.is_attacking then
        self.collider:setActive(true)
        self.timer = self.timer + dt
        if self.timer >= self.duration then
            self.timer = 0
            self.is_attacking = false
            self.collider:setActive(false)
        end
    end
end

function Attack:isActive()
    return self.timer < self.duration
end

return Attack