function change_field_state(tile)
    if tile.is_watered then
        tile.image = love.graphics.newImage("textures/tiles/field1.png")
        tile.is_watered = false
    else 
        tile.image = love.graphics.newImage("textures/tiles/field2.png")
        tile.is_watered = true
    end
end
