local Tiles = {}
local grassImages = {"grass1.png", "grass2.png", "grass3.png", "grass4.png", "grass5.png", "grass6.png", "grass7.png", "grass8.png"}
local imageScale = 4 -- Scale factor for the images

function Tiles:new(tileWidth, tileHeight, numCols, numRows, x, y)
    local tiles = {}

    -- Initialize the tiles table with default values
    for i = 1, numCols do
        tiles[i] = {}
        for j = 1, numRows do
            local randomImage = love.graphics.newImage("textures/tiles/" .. grassImages[love.math.random(1, #grassImages)])
            randomImage:setFilter("nearest", "nearest") -- Set filter mode to "nearest"
            tiles[i][j] = {x = x + (i - 1) * tileWidth, y = y + (j - 1) * tileHeight, image = randomImage, saved_image = nil, is_plowed = false, is_watered = false, has_seed = false}
        end
    end

    tiles.tileWidth = tileWidth
    tiles.tileHeight = tileHeight
    tiles.x = x
    tiles.y = y

    tiles.field1Image = love.graphics.newImage("textures/tiles/field1.png")

    tiles.is_clickable = true

    setmetatable(tiles, self)
    self.__index = self

    return tiles
end

function Tiles:draw()
    -- Draw each tile
    for i = 1, #self do
        for j = 1, #self[i] do
            local tile = self[i][j]
            local imageWidth = tile.image:getWidth() * imageScale
            local imageHeight = tile.image:getHeight() * imageScale

            -- Set the filter mode for the "field1.png" image
            if tile.is_plowed == true then
                tile.image:setFilter("nearest", "nearest")
            end

            love.graphics.draw(tile.image, tile.x, tile.y, 0, imageScale, imageScale)
        end
    end
end

function Tiles:mousepressed(x, y, button, player)

    local px, py = player.collider:getPosition()
    local mx, my = love.mouse.getPosition()

    local distance = math.sqrt((my - py)^2 + (px - mx)^2) --lol my pie

    if self.is_clickable == true and player.in_hand == "hoe" and button == 2 and distance <= 128 then -- Right mouse button
        -- Find the tile that was clicked
        local col = math.floor((x - self.x) / self.tileWidth) + 1
        local row = math.floor((y - self.y) / self.tileHeight) + 1

        -- Ensure the tile exists before modifying it
        if self[col] and self[col][row] then
            -- Change the image of the clicked tile
            local tile = self[col][row]
            if tile.saved_image == nil or tile.image == tile.saved_image then
                tile.saved_image = tile.image -- Save the current image
                tile.image = love.graphics.newImage("textures/tiles/field1.png") -- Load and assign the new image
                tile.is_plowed = true
            elseif tile.has_seed == false then
                tile.image = tile.saved_image -- Restore the saved image
                tile.saved_image = nil -- Clear the saved image
                tile.is_plowed = false
                tile.is_watered = false
            end
        end
    end
    
    if self.is_clickable == true and player.in_hand == "water" and button == 2 and distance <= 128 then
        -- Find the tile that was clicked
        local col = math.floor((x - self.x) / self.tileWidth) + 1
        local row = math.floor((y - self.y) / self.tileHeight) + 1
        
        -- Ensure the tile exists before modifying it
        if self[col] and self[col][row] then
            -- Change the image of the clicked tile
            local tile = self[col][row]
            if tile.is_watered == false and tile.is_plowed == true then
                tile.image = love.graphics.newImage("textures/tiles/field2.png") -- Assign the "field2.png" image to the tile
                tile.is_watered = true
            else
                -- If the tile doesn't have the "field1.png" image, do nothing
            end
        end
    end

    if self.is_clickable == true and player.in_hand == "seed" and button == 2 and distance <= 128 then
        -- Find the tile that was clicked
        local col = math.floor((x - self.x) / self.tileWidth) + 1
        local row = math.floor((y - self.y) / self.tileHeight) + 1
        
        -- Ensure the tile exists before modifying it
        if self[col] and self[col][row] then
            -- Change the image of the clicked tile
            local tile = self[col][row]
            if tile.is_watered == true and tile.is_plowed == true then

                tile.has_seed = true
            else
                -- If the tile doesn't have the "field1.png" image, do nothing
            end
        end
    end

end
return Tiles