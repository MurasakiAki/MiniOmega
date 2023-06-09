--the game
love = require('love')
glob = require('global')
player = require("player")
windfield = require('lib/windfield')
Dungeon = require("dungeon")
room = require('room')
Door = require('door')
Tiles = require('tiles')
Object = require('object')
Crop = require('crop')
 
local w, h = love.window.getDesktopDimensions(1)
 
local world = windfield.newWorld(0, 0, true)
 
function love.load()
  -- This function is called once at the beginning of the game
  love.window.setFullscreen(true, "desktop")
  
  world:setQueryDebugDrawing(true)

  world:addCollisionClass('Player')
  world:addCollisionClass('Door')
  world:addCollisionClass('Crop')
  world:addCollisionClass('Enemy')
  world:addCollisionClass('Object')
  world:addCollisionClass('Obstacle')
  world:addCollisionClass('Trap')
  world:addCollisionClass('Tile')
  world:addCollisionClass('Attack')

  dungeon = Dungeon:new(world)
  
  p = player:new(world, w/2, h/2)

  fdoor = Door:new(world, 0, 0, "Forward")
  bdoor = Door:new(world, 0, 0, "Back")

  movable_box = Object:new_from_prefab(world, w/2 - 30, 250, 'MovableBox')
  table.insert(dungeon.rooms[dungeon.current_room].objects, movable_box)
  --rock = Object:new_from_prefab(world,  400, 400, 'Rock')

  world:setCallbacks(beginContact, nil, nil, nil)
end
 
function beginContact(collider1, collider2, collision)
  local object1 = collider1:getUserData()
  local object2 = collider2:getUserData()

  -- Collision between player and door
  if (object1 and object1.type == "Player" and object2 and object2.type == "Door") or
     (object2 and object2.type == "Player" and object1 and object1.type == "Door") then
    local p = object1.type == "Player" and object1 or object2 -- Get the player object

    if dungeon.rooms[dungeon.current_room].active_doors then -- Check if doors are active
      if object1.special_type and object1.special_type == "Forward" or
         object2.special_type and object2.special_type == "Forward" then
        if dungeon.current_room == dungeon.size then
          dungeon.changing_room = false
        else
          dungeon.changing_room = true
          on_change_room(dungeon.rooms[dungeon.current_room])
          dungeon.current_room = dungeon.current_room + 1
        end
      else
        if dungeon.current_room == 1 then
          dungeon.changing_room = false
        else
          dungeon.changing_room = true
          on_change_room(dungeon.rooms[dungeon.current_room])
          dungeon.current_room = dungeon.current_room - 1
        end
      end
    end
    return
  end

  -- Collision between crop and enemy
  if object1.type == "Crop" and object2.type == "Enemy" then
    object1.tile.has_seed = false
    object1.collider:destroy()
    return
  elseif object1.type == "Enemy" and object2.type == "Crop" then
    object2.tile.has_seed = false
    object2.collider:destroy()
    return
  end

  -- Collision between attack and enemy
  if object1.type == "Attack" and object2.type == "Enemy" or 
    object1.type == "Enemy" and object2.type == "Attack" then
    print('hit')
    
    local enemy
    if object2.type == "Enemy" then
      enemy = object2
    elseif object1.type == "Enemy" then
      enemy = object1
    end

    if enemy then
      enemy:die()
      --remove the enemy from the list of enemies in the current room
      local room = dungeon.rooms[dungeon.current_room]
      for i = #room.enemies, 1, -1 do
        if room.enemies[i] == enemy then
          table.remove(room.enemies, i)
          break
        end
      end
    end
    return
  end

  -- Collision between enemy and player
  if object1.type == "Player" and object2.type == "Enemy" or
     object1.type == "Enemy" and object2.type == "Player" or 
     object1.type == "Player" and object2.object_type == "Trap" or
     object1.object_type == "Trap" and object2.type == "Player" then

    local player = nil

    if object1.type == "Player" then
      player = object1
      object1:take_damage(object2.damage)
    else
      player = object2
      object2:take_damage(object1.damage)
    end

    return
  end

  -- Collision between crop and player
  if object1.type == "Crop" and object1.is_grown and object2.type == "Player" then
    object2:pick_crop(object1)
    return
  elseif object1.type == "Player" and object2.type == "Crop" and object2.is_grown then
    object1:pick_crop(object2)
    return
  end
end

--mouse controller
function love.mousepressed(x, y, button)
  dungeon.rooms[dungeon.current_room].tileset:mousepressed(world, x, y, button, p)

  p:perform_attack(world, x, y, button)
  
end

--keypress detection
function love.keypressed(key, scancode, isrepeat)
  p:update_hand(key)
end

function love.update(dt)
  world:update(dt)

  p:update(dungeon, dt)
  
  p:move(dungeon.rooms[dungeon.current_room])
  
  --spawning enemies
  if #dungeon.rooms[dungeon.current_room].enemies >= 1 then
    for i = 1, #dungeon.rooms[dungeon.current_room].enemies do
      local enemy = dungeon.rooms[dungeon.current_room].enemies[i]
      if enemy.collider then -- Check if collider exists
        enemy:move(p.collider:getX(), p.collider:getY())
      end
    end
  end
  
  --updating position of doors
  fdoor.collider:setPosition(dungeon.rooms[dungeon.current_room].forward_door.x, dungeon.rooms[dungeon.current_room].forward_door.y)
  bdoor.collider:setPosition(dungeon.rooms[dungeon.current_room].back_door.x, dungeon.rooms[dungeon.current_room].back_door.y)
  
end
 
--drawing objects in the scene
function love.draw()
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

  dungeon.rooms[dungeon.current_room]:draw_prepare_counter(world)

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
  love.graphics.print(string.format("player's money: %d", p.money), 0, 120)
  love.graphics.print(string.format("player's health: %d", p.curr_health), 0, 135)
end