local player = {}

w, h = love.window.getDesktopDimensions(1)

player.properties = {
    x = w/2,
    y = h/2,
    speed = 350,
    width = 50,
    height = 50
}

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
  
    player.properties.x = player.properties.x + dx * player.properties.speed * delta
    player.properties.y = player.properties.y + dy * player.properties.speed * delta
  
    -- Keep player within bounds of the screen
    if player.properties.x < 0 then
      player.properties.x = 0
    elseif player.properties.x + player.properties.width > w then
      player.properties.x = w - player.properties.width
    end
  
    if player.properties.y < 0 then
      player.properties.y = 0
    elseif player.properties.y + player.properties.height > h then
      player.properties.y = h - player.properties.height
    end

    if player.properties.x < room:gen_position_x(w) then
      player.properties.x = room:gen_position_x(w)
    elseif player.properties.x + player.properties.width > room:gen_position_x(w) + room.width then
      player.properties.x = room:gen_position_x(w) + room.width - player.properties.width
    end

    if player.properties.y < room:gen_position_y(h) then
      player.properties.y = room:gen_position_y(h)
    elseif player.properties.y + player.properties.height > room:gen_position_y(h) + room.height then
      player.properties.y = room:gen_position_y(h) + room.height - player.properties.height
    end
    
    return player.properties
end

return player
