function change_field_state(tile)
    if tile.is_watered then
        print(tile.is_watered)
        tile.image = love.graphics.newImage("textures/tiles/field1.png")
        tile.is_watered = false
        print(tile.is_watered)
    else 
        print(tile.is_watered)
        tile.image = love.graphics.newImage("textures/tiles/field2.png")
        tile.is_watered = true
    end
end
