--the game
love = require('love')
player = require("player")
dungeon = require("dungeon")
room = require('room')
Door = require('door')

local w, h = love.window.getDesktopDimensions(1)

local world = love.physics.newWorld(0, 0, true)

function love.load()
  -- This function is called once at the beginning of the game
  love.window.setFullscreen(true, "desktop")
  print(world:type())
  dung = dungeon:new(world)

  p = player:new(world, w/2, h/2)

  door_w = 60
  door_h = 5
  
  forwarddoor = Door:new(world, 0, 0, door_w, door_h)
  backdoor = Door:new(world, 0, 0, door_w, door_h)
  print(dung.rooms[dung.current_room].forward_door.x)
  world:setCallbacks(beginContact, nil, nil, nil)
end

function love.update(dt)
  world:update(dt)

  --updating position of doors
  forwarddoor.body:setPosition(dung.rooms[dung.current_room].forward_door.x, dung.rooms[dung.current_room].forward_door.y)
  forwarddoor.leads_to = dung.current_room + 1
  local forwardUD = forwarddoor.fixture:getUserData()
  forwardUD.leads_to = forwarddoor.leads_to
  forwarddoor.fixture:setUserData(forwardUD)
  --print(forwarddoor.leads_to)

  backdoor.body:setPosition(dung.rooms[dung.current_room].back_door.x, dung.rooms[dung.current_room].back_door.y)
  backdoor.leads_to = dung.current_room - 1

  if dung.current_room ~= 1 and dung.changing_room then
    p:shift(dung.rooms[dung.current_room])
    dung.changing_room = false
  end

  p:move(dt, dung.rooms[dung.current_room])

end

function love.draw()
  -- This function is called every frame and is used for drawing to the screen
  love.graphics.setBackgroundColor(0, 0.4, 0.4)

  p:draw()

  local draw_room = function()
    love.graphics.rectangle("fill", dung.rooms[dung.current_room]:gen_position_x(w), dung.rooms[dung.current_room]:gen_position_y(h), dung.rooms[dung.current_room].width, dung.rooms[dung.current_room].height)
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

  if dung.rooms[dung.current_room].forward_door.is_active == true then
    forwarddoor:draw()
  end

  if dung.rooms[dung.current_room].back_door.is_active == true then
    backdoor:draw()
  end

  -- drawing info
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(string.format("screen width: %d , height: %d", w, h))
  love.graphics.print(string.format("current room: %d", dung.current_room), 0, 15)
  love.graphics.print(string.format("room width: %f , height: %f", dung.rooms[dung.current_room].width, dung.rooms[dung.current_room].height), 0, 30)
  love.graphics.print(string.format("room x: %f , y: %f", dung.rooms[dung.current_room]:gen_position_x(w), dung.rooms[dung.current_room]:gen_position_y(h)), 0, 45)
  love.graphics.print(string.format("door position: %d, %d", dung.rooms[dung.current_room].forward_door.x, dung.rooms[dung.current_room].forward_door.y), 0, 60)
  
end

function beginContact(fixa, fixb, coll)
  local obj1 = fixa:getUserData()
  local obj2 = fixb:getUserData()

  if obj1 and obj1.type == "Player" and obj2 and obj2.type == "Door" then
    dung.current_room = obj2.leads_to
    dung.changing_room = true
    --print(obj2.leads_to)
    --print(dung.current_room)
    
  elseif obj2 and obj2.type == "Player" and obj1 and obj1.type == "Door" then
    dung.current_room = obj1.leads_to
    dung.changing_room = true
    --print(obj2.leads_to)
    --print(dung.current_room)
  end
end

