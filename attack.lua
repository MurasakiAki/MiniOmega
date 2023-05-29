local Attack = {}

Attack.__index = Attack

function Attack:new(world, x, y)
    local a = setmetatable({}, Attack)
    a.size = 32
    a.type = "Attack"
    a.collider = world:newCircleCollider(x, y, a.size)
    a.collider:setSensor(true)
    a.collider:setCollisionClass("Attack")
    a.collider:setUserData(a)

    return a
end

return Attack