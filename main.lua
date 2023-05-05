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
  local properties = player.move(dt, dung.rooms[current_room])
  player.properties = properties
end

function love.draw()
  -- This function is called every frame and is used for drawing to the screen
  love.graphics.setBackgroundColor(0, 0.4, 0.4)

  love.graphics.setColor(0.8, 1, 0.1)
  love.graphics.rectangle("fill", player.properties.x, player.properties.y, player.properties.width, player.properties.height)

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", dung.rooms[current_room]:gen_position_x(w), dung.rooms[current_room]:gen_position_y(h), dung.rooms[current_room].width, dung.rooms[current_room].height)
  love.graphics.print(string.format("room width: %d", dung.rooms[current_room].width), 0, 0)
  love.graphics.print(string.format("room height: %d",dung.rooms[current_room].height), 0, 10)
end
