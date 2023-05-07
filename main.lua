--the game
love = require("love")
dungeon = require("dungeon")
player = require("player")

current_room = 1

function love.load()
  -- This function is called once at the beginning of the game
  love.window.setFullscreen(true, "desktop")
  w, h = love.window.getDesktopDimensions(1)
  dung = dungeon:new()
end

function love.update(dt)
  -- This function is called every frame with the time since the last frame as the argument (dt)
  player.move(dt, dung.rooms[current_room])
  
end

function love.draw()
  -- This function is called every frame and is used for drawing to the screen
  love.graphics.setBackgroundColor(0, 0.4, 0.4)

  love.graphics.setColor(0.8, 1, 0.1)
  love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

  local draw_room = function()
    love.graphics.rectangle("fill", dung.rooms[current_room]:gen_position_x(w), dung.rooms[current_room]:gen_position_y(h), dung.rooms[current_room].width, dung.rooms[current_room].height)
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
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(string.format("room width: %d", dung.rooms[current_room].width), 0, 0)
  love.graphics.print(string.format("room height: %d",dung.rooms[current_room].height), 0, 10)

  
end
