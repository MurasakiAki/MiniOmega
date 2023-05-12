love = require('love')

local screen_width, screen_height = love.window.getDesktopDimensions(1)

local player = {}
player.__index = player
    
function player:new(world, x, y)
  local p = setmetatable({}, player)
  
  --player properties
  p.type = "Player"
  p.speed = 300
  p.x = x
  p.y = y
  p.width = 50
  p.height = 50

  p.in_hand = "hoe"

  p.collider = world:newRectangleCollider(p.x, p.y, p.width, p.height)
  p.collider:setFixedRotation(true)

  p.collider:setUserData(p)
  
  return p
end

function player:move(room)

  self.x = self.collider:getX()
  self.y = self.collider:getY()

  -- Player movement
  local dx = 0
  local dy = 0

  if love.keyboard.isDown("w") then
    dy = dy - 1
  end
  if love.keyboard.isDown("s") then
    dy = dy + 1
  end
  if love.keyboard.isDown("a") then
    dx = dx - 1
  end
  if love.keyboard.isDown("d") then
    dx = dx + 1
  end

  -- Normalize the direction vector
  local length = math.sqrt(dx * dx + dy * dy)
  if length > 0 then
    dx = dx / length
    dy = dy / length
  end

  -- Apply the desired speed
  local desiredSpeed = self.speed
  local currentSpeed = math.sqrt(self.collider:getLinearVelocity())  -- Get current speed
  if currentSpeed > desiredSpeed then
    -- Limit the speed if it exceeds the desired speed
    dx = dx * desiredSpeed / currentSpeed
    dy = dy * desiredSpeed / currentSpeed
  else
    -- Apply the desired speed
    dx = dx * desiredSpeed
    dy = dy * desiredSpeed
  end

  self.collider:setLinearVelocity(dx, dy)

  -- Keep player within bounds of the room
  local minX = room:gen_position_x(screen_width)
  local minY = room:gen_position_y(screen_height)
  local maxX = minX + room.width
  local maxY = minY + room.height 

  if self.x < minX or self.x > maxX or self.y < minY or self.y > maxY then
    self.x = math.max(minX, math.min(self.x, maxX))
    self.y = math.max(minY, math.min(self.y, maxY))
    self.collider:setPosition(self.x, self.y)
  end

end

function player:update_hand(key)
  local item_list = {"hoe", "water", "seed"}
  local current_item_index = 1

  if key == "tab" then
    if current_item_index ~= #item_list then
      current_item_index = current_item_index + 1
      self.in_hand = item_list[current_item_index]
    end    
  end
end


function player:draw()
  love.graphics.setColor(0.8, 1, 0.1)

  love.graphics.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)
end

return player