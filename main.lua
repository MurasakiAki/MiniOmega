--the game
love = require('love')
player = require("player")
windfield = require('lib/windfield')
Dungeon = require("dungeon")
room = require('room')
Door = require('door')

local w, h = love.window.getDesktopDimensions(1)

local world = windfield.newWorld(0, 0, true)

function love.load()
  -- This function is called once at the beginning of the game
  love.window.setFullscreen(true, "desktop")

  dungeon = Dungeon:new(world)

  p = player:new(world, w/2, h/2)

  door_w = 60
  door_h = 6
  
  --forwarddoor = Door:new(world, 0, 0, door_w, door_h)
  --assert(forwarddoor, "Failed to create forward door")
  --backdoor = Door:new(world, 0, 0, door_w, door_h)

  --test = Door:new(world, 0, 0, 50, 50)
  
  world:setCallbacks(beginContact, nil, nil, nil)
end

function love.update(dt)
  world:update(dt)
--[[
  if love.keyboard.isDown("f") then
    test.body:setPosition(500, 500)
  else
    test.body:setPosition(0, 0)
  end
  

  --updating position of doors
  --forwarddoor.body:setPosition(dungeon.rooms[dungeon.current_room].forward_door.x, dungeon.rooms[dungeon.current_room].forward_door.y)
  
  forwarddoor.leads_to = dungeon.current_room + 1
  local forwardUD = forwarddoor.fixture:getUserData()
  forwardUD.leads_to = forwarddoor.leads_to
  forwarddoor.fixture:setUserData(forwardUD)
  --print(forwarddoor.leads_to)

  backdoor.body:setPosition(dungeon.rooms[dungeon.current_room].back_door.x, dungeon.rooms[dungeon.current_room].back_door.y)
  backdoor.leads_to = dungeon.current_room - 1

  if dungeon.current_room ~= 1 and dungeon.changing_room then
    p:shift(dungeon.rooms[dungeon.current_room])
    dungeon.changing_room = false
  end
  ]]
  p:move(dungeon.rooms[dungeon.current_room])

end

function love.draw()
  -- This function is called every frame and is used for drawing to the screen
  love.graphics.setBackgroundColor(0, 0.4, 0.4)

  world:draw()
  p:draw()

  --test:draw()

  local draw_room = function()
    love.graphics.rectangle("fill", dungeon.rooms[dungeon.current_room]:gen_position_x(w), dungeon.rooms[dungeon.current_room]:gen_position_y(h), dungeon.rooms[dungeon.current_room].width, dungeon.rooms[dungeon.current_room].height)
  end

  -- set up the stencil buffer
  love.graphics.stencil(draw_room, "replace", 1)
  love.graphics.setStencilTest("notequal", 1)

  -- draw the black rectangle with a room
  love.graphics.setColor(love.math.colorFromBytes(34, 32, 52))
  love.graphics.rectangle("fill", 0, 0, w, h)

  -- reset the stencil buffer
  love.graphics.setStencilTest()
  love.graphics.stencil(function() end)

-- Draw the door

  if dungeon.rooms[dungeon.current_room].forward_door.is_active == true then
    --forwarddoor:draw()
    --love.graphics.setColor(0.594, 0.145, 0.864)
    --love.graphics.rectangle("fill", forwarddoor.body:getX(), forwarddoor.body:getY(), forwarddoor.width, forwarddoor.height)
  end

  if dungeon.rooms[dungeon.current_room].back_door.is_active == true then
    backdoor:draw()
  end

  -- drawing info
  if love.keyboard.isDown("f1") then
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("screen width: %d , height: %d", w, h))
    love.graphics.print(string.format("current room: %d", dungeon.current_room), 0, 15)
    love.graphics.print(string.format("room width: %f , height: %f", dungeon.rooms[dungeon.current_room].width, dungeon.rooms[dungeon.current_room].height), 0, 30)
    love.graphics.print(string.format("room x: %f , y: %f", dungeon.rooms[dungeon.current_room]:gen_position_x(w), dungeon.rooms[dungeon.current_room]:gen_position_y(h)), 0, 45)
    love.graphics.print(string.format("door position: %d, %d", forwarddoor.body:getX(), forwarddoor.body:getY()), 0, 60)
  end
  
end

function beginContact(fixa, fixb, coll)
  local obj1 = fixa:getUserData()
  local obj2 = fixb:getUserData()

  if obj1 and obj1.type == "Player" and obj2 and obj2.type == "Door" then
    --dungeon.current_room = obj2.leads_to
    dungeon.changing_room = true
    --print(obj2.leads_to)
    --print(dungeon.current_room)
    
  elseif obj2 and obj2.type == "Player" and obj1 and obj1.type == "Door" then
    --dungeon.current_room = obj1.leads_to
    dungeon.changing_room = true
    --print(obj2.leads_to)
    --print(dungeon.current_room)
  end
end

