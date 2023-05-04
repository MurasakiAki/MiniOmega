--the game
love = require("love")
dungeon = require("dungeon")
player = require("player")

function love.load()
  -- This function is called once at the beginning of the game
  love.window.setFullscreen(true, "desktop")
  w, h = love.window.getDesktopDimensions(1)
  dung = dungeon:new()
end

function love.update(dt)
  -- This function is called every frame with the time since the last frame as the argument (dt)
  local properties = player.move(dt)
  player.properties = properties
end

function love.draw()
  -- This function is called every frame and is used for drawing to the screen
  love.graphics.setColor(0, 0.4, 0.4)
  love.graphics.rectangle("fill", 0, 0, w, h)

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", player.properties.x, player.properties.y, player.properties.width, player.properties.height)

  local move_by = 100
  for _, room in ipairs(dung.rooms) do
    local info = room.number_of_doors
    love.graphics.print(info, 500, 10 + move_by)
    move_by = move_by + 20
  end
  
end
