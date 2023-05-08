love = require('love')

local player = {}
player.__index = player
    
function player:new(world, x, y)
  local p = setmetatable({}, player)
  
  -- Set player properties
  p.x = x
  p.y = y
  p.speed = 350
  p.width = 50
  p.height = 50

  -- Create the physics body, shape, and fixture
  p.body = love.physics.newBody(world, p.x, p.y, "dynamic")
  p.shape = love.physics.newRectangleShape(p.width, p.height)
  p.fixture = love.physics.newFixture(p.body, p.shape)
    
  -- Set fixture properties
  --p.fixture:setCategory(1)
  --p.fixture:setMask(2)
  p.fixture:setUserData({type = "Player"})
    
  return p
end

function player:move(delta, room)
  -- Player movement
  local dx = 0
  local dy = 0
  
  if love.keyboard.isDown("w") then
    dy = -1
  elseif love.keyboard.isDown("s") then
    dy = 1
  end
  
  if love.keyboard.isDown("a") then
    dx = -1
  elseif love.keyboard.isDown("d") then
    dx = 1
  end
  
  local magnitude = math.sqrt(dx^2 + dy^2)
  
  if magnitude > 0 then
    dx = dx / magnitude
    dy = dy / magnitude
  end
  
  local velocityX, velocityY = dx * self.speed, dy * self.speed
  self.body:setLinearVelocity(velocityX, velocityY)
  
  -- Keep player within bounds of the screen and room
  local x, y = self.body:getPosition()
  local minX = math.max(0, room:gen_position_x(love.graphics.getWidth()))
  local minY = math.max(0, room:gen_position_y(love.graphics.getHeight()))
  local maxX = math.min(minX + room.width - self.width, love.graphics.getWidth())
  local maxY = math.min(minY + room.height - self.height, love.graphics.getHeight())
  
  
  x = math.max(minX, math.min(x, maxX))
  y = math.max(minY, math.min(y, maxY))
  self.body:setPosition(x, y)
end

function player:draw()
  love.graphics.setColor(0.8, 1, 0.1)

  local x,y = self.body:getPosition()
  love.graphics.rectangle("fill", x, y, self.width, self.height)

end

return player