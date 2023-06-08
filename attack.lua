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
    a.is_attacking = false
    a.duration = 0.2
    a.timer = 0

    return a
end

function Attack:update(dt)
    self.collider:setActive(self.is_attacking)
    if self.has_started then
        self.timer = self.timer + dt
        if self.timer >= self.duration then
            self.timer = 0
            self.is_attacking = true
        end
    else
        self.is_attacking = false
    end
    
end

function Attack:isActive()
    return self.timer < self.duration
end

return Attack