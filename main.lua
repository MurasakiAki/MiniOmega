--the game
love = require('love')
player = require("player")
windfield = require('lib/windfield')
Dungeon = require("dungeon")
room = require('room')
Door = require('door')
Tiles = require('tiles')
 
local w, h = love.window.getDesktopDimensions(1)
 
local world = windfield.newWorld(0, 0, true)
 
function love.load()
  -- This function is called once at the beginning of the game
  love.window.setFullscreen(true, "desktop")
  
  world:addCollisionClass('Player')
  world:addCollisionClass('Door')

  dungeon = Dungeon:new(world)
 
  p = player:new(world, w/2, h/2)
  fdoor = Door:new(world, 0, 0, "Forward")
  bdoor = Door:new(world, 0, 0, "Back")
   
  world:setCallbacks(beginContact, nil, nil, nil)
end
 
--collision detection between player and door
function beginContact(collider1, collider2, collision)
  local object1 = collider1:getUserData()
  local object2 = collider2:getUserData()
 
  if dungeon.rooms[dungeon.current_room].active_doors == true and object1 and object1.type == "Player" and object2 and object2.type == "Door" or
    object2 and object2.type == "Player" and object1 and object1.type == "Door" then
 
    local p = object1.type == "Player" and object1 or object2 -- Get the player object
 
    if object1.special_type and object1.special_type == "Forward" or
      object2.special_type and object2.special_type == "Forward" then
 
      if dungeon.current_room == dungeon.size then
        dungeon.changing_room = false
      else
        --local nextRoom = dungeon.rooms[dungeon.current_room + 1]
        --p.collider:setLinearVelocity(0, 0) -- Stop player's current movement
        --p.collider:setPosition(p.collider:getX(), nextRoom:gen_position_y(h) + nextRoom.height - 100)
        dungeon.changing_room = true
        dungeon.current_room = dungeon.current_room + 1
      end
 
    else
      if dungeon.current_room == 1 then
        dungeon.changing_room = false
      else
        --local prevRoom = dungeon.rooms[dungeon.current_room - 1]
        --p.collider:setLinearVelocity(0, 0) -- Stop player's current movement
        --p.collider:setPosition(p.collider:getX(), prevRoom:gen_position_y(h) + prevRoom.height + 100)
        dungeon.changing_room = true
        dungeon.current_room = dungeon.current_room - 1
      end
    end
  end
end
 
 --mouse controller
function love.mousepressed(x, y, button)
  dungeon.rooms[dungeon.current_room].tileset:mousepressed(x, y, button, p)
end

--keypress detection
function love.keypressed(key, scancode, isrepeat)
  p:update_hand(key)
end
 
function love.update(dt)
  world:update(dt)
  
  p:update(dungeon)
  
  p:move(dungeon.rooms[dungeon.current_room])
  
  --updating position of doors
  fdoor.collider:setPosition(dungeon.rooms[dungeon.current_room].forward_door.x, dungeon.rooms[dungeon.current_room].forward_door.y)
  bdoor.collider:setPosition(dungeon.rooms[dungeon.current_room].back_door.x, dungeon.rooms[dungeon.current_room].back_door.y)


  --fdoor.collider:setEnabled(dungeon.rooms[dungeon.current_room].active_doors)
  --bdoor.collider:setEnabled(dungeon.rooms[dungeon.current_room].active_doors)

end
 
function love.draw()
  -- This function is called every frame and is used for drawing to the screen
  --drawing objects in the scene
  love.graphics.setBackgroundColor(0, 0.4, 0.4)

  dungeon.rooms[dungeon.current_room].tileset:draw()
  
  world:draw()
  p:draw()
 
  if dungeon.rooms[dungeon.current_room].active_doors == true then
    fdoor:draw()
    bdoor:draw()
  end

  --draw room function
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

  dungeon.rooms[dungeon.current_room]:draw_prepare_counter()

  -- drawing info
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(string.format("screen width: %d , height: %d", w, h))
  love.graphics.print(string.format("current room: %d / dungeon size: %d", dungeon.current_room, dungeon.size), 0, 15)
  love.graphics.print(string.format("room width: %f , height: %f", dungeon.rooms[dungeon.current_room].width, dungeon.rooms[dungeon.current_room].height), 0, 30)
  love.graphics.print(string.format("room x: %f , y: %f", dungeon.rooms[dungeon.current_room]:gen_position_x(w), dungeon.rooms[dungeon.current_room]:gen_position_y(h)), 0, 45)
  love.graphics.print(string.format("tileset x: %d , y: %d", dungeon.rooms[dungeon.current_room].tileset.x, dungeon.rooms[dungeon.current_room].tileset.y), 0, 60)
  love.graphics.print(string.format("is room special: %s", tostring(dungeon.rooms[dungeon.current_room].is_special)), 0, 75)
  love.graphics.print(string.format("active doors: %s", tostring(dungeon.rooms[dungeon.current_room].active_doors)), 0, 90) 
  love.graphics.print(string.format("player's hand: %s", p.in_hand), 0, 105)

end