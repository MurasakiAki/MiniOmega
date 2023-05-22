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

function on_change_room(tileset)
    for i = 1, #tileset do
        for j = 1, #tileset[i] do
            local tile = tileset[i][j]

            -- Destroy crop if player forgets to harvest them
            if tile.has_seed then
                tile.planted_seed.collider:destroy()
                tile.has_seed = false
            end
        end
    end
end