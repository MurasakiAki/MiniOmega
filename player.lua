w, h = love.window.getDesktopDimensions(1)

local player = {}

player.x = w/2
player.y = h/2
player.speed = 350
player.width = 50
player.height = 50

function player.move(delta, room)
    --player movement
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
  
    player.x = player.x + dx * player.speed * delta
    player.y = player.y + dy * player.speed * delta
  
    -- Keep player within bounds of the screen
    if player.x < 0 then
      player.x = 0
    elseif player.x + player.width > w then
      player.x = w - player.width
    end
  
    if player.y < 0 then
      player.y = 0
    elseif player.y + player.height > h then
      player.y = h - player.height
    end

    if player.x < room:gen_position_x(w) then
      player.x = room:gen_position_x(w)
    elseif player.x + player.width > room:gen_position_x(w) + room.width then
      player.x = room:gen_position_x(w) + room.width - player.width
    end

    if player.y < room:gen_position_y(h) then
      player.y = room:gen_position_y(h)
    elseif player.y + player.height > room:gen_position_y(h) + room.height then
      player.y = room:gen_position_y(h) + room.height - player.height
    end
    
    return player
end

return player
