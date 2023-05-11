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
  fdoor = Door:new(world, 0, 0, "Forward")
  bdoor = Door:new(world, 0, 0, "Back")
  
  world:setCallbacks(beginContact, nil, nil, nil)
end

function love.update(dt)
  world:update(dt)

  p:move(dungeon.rooms[dungeon.current_room])


  --updating position of doors
  fdoor.collider:setPosition(dungeon.rooms[dungeon.current_room].forward_door.x, dungeon.rooms[dungeon.current_room].forward_door.y)
  bdoor.collider:setPosition(dungeon.rooms[dungeon.current_room].back_door.x, dungeon.rooms[dungeon.current_room].back_door.y)
  
end

function love.draw()
  -- This function is called every frame and is used for drawing to the screen
  love.graphics.setBackgroundColor(0, 0.4, 0.4)

  world:draw()
  p:draw()

  fdoor:draw()
  bdoor:draw()

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

  -- drawing info
  if love.keyboard.isDown("f1") then
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("screen width: %d , height: %d", w, h))
    love.graphics.print(string.format("current room: %d", dungeon.current_room), 0, 15)
    love.graphics.print(string.format("room width: %f , height: %f", dungeon.rooms[dungeon.current_room].width, dungeon.rooms[dungeon.current_room].height), 0, 30)
    love.graphics.print(string.format("room x: %f , y: %f", dungeon.rooms[dungeon.current_room]:gen_position_x(w), dungeon.rooms[dungeon.current_room]:gen_position_y(h)), 0, 45)
    --love.graphics.print(string.format("door position: %d, %d", forwarddoor.body:getX(), forwarddoor.body:getY()), 0, 60)
  end
  
end

function beginContact(collider1, collider2, collision)
  local object1 = collider1:getUserData()
  local object2 = collider2:getUserData()

  if object1 and object1.type == "Player" and object2 and object2.type == "Door" or
  object2 and object2.type == "Player" and object1 and object1.type == "Door" then
    
		if object1.special_type and object1.special_type == "Forward" or
		object2.special_type and object2.special_type == "Forward" then
    	--dungeon.current_room = obj2.leads_to
      if dungeon.current_room == dungeon.size then
        dungeon.changing_room = false
      else
        dungeon.changing_room = true
    	  dungeon.current_room = dungeon.current_room + 1

        p.collider:applyLinearImpulse(p.collider:getX(), dungeon.rooms[dungeon.current_room]:gen_position_y(h) + dungeon.rooms[dungeon.current_room].height - 100)
        print(p.y, p.collider:getY())
      end

    else 
      if dungeon.current_room == 1 then
        dungeon.changing_room = false
      else
        dungeon.changing_room = true
    	  dungeon.current_room = dungeon.current_room - 1

        p.y = dungeon.rooms[dungeon.current_room]:gen_position_y(h) + dungeon.rooms[dungeon.current_room].height + 100

		  end

	  end

  end

end




