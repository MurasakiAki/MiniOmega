local wf = require 'lib/windfield'
local Crop = require('crop')

local Tiles = {}
local grassImages = {"grass1.png", "grass2.png", "grass3.png", "grass4.png", "grass5.png", "grass6.png", "grass7.png", "grass8.png"}
local imageScale = 4 -- Scale factor for the images

function Tiles:new(world, tileWidth, tileHeight, numCols, numRows, x, y)
    local tiles = {}
  
    tiles.tileWidth = tileWidth
    tiles.tileHeight = tileHeight
    tiles.x = x
    tiles.y = y
  
    -- Initialize the tiles table with default values
    for i = 1, numCols do
      tiles[i] = {}
      for j = 1, numRows do
        local randomImage = love.graphics.newImage("textures/tiles/" .. grassImages[love.math.random(1, #grassImages)])
        randomImage:setFilter("nearest", "nearest") -- Set filter mode to "nearest"
        local tileX = x + (i - 1) * tileWidth
        local tileY = y + (j - 1) * tileHeight
        tiles[i][j] = {x = tileX, y = tileY, tileWidth = tileWidth, tileHeight = tileHeight, image = randomImage, saved_image = nil, is_plowed = false, is_watered = false, has_seed = false, is_obscured = false, planted_seed = nil}
        --tiles[i][j].collider = world:newRectangleCollider(tileX, tileY, tileWidth, tileHeight)
        --tiles[i][j].collider:setSensor(true)
        --tiles[i][j].collider:setCollisionClass('Tile') -- Set the collision class to 'Tile'
      end
    end
  
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

function Tiles:mousepressed(world, x, y, button, player)

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
            if tile.is_obscured == false then
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
                
                if tile.has_seed == false then
                    tile.has_seed = true
                    seed = Crop:new(world, tile.x + tile.tileWidth/2 - 8, tile.y + tile.tileHeight/2 - 8, "Crop", 2 )
                    tile.planted_seed = seed
                    seed:start_growth(tile)
                end
            end
        end
    end

end

--detecting obstacle on field
--[[
function Tiles:update()
    for i = 1, #self do
      for j = 1, #self[i] do
        local tile = self[i][j]
  
        if tile.collider:enter('Obstacle') then -- Check if there is a collision with the 'Obstacle' collision class
          tile.is_obscured = true
        elseif tile.collider:exit('Obstacle') then -- Check if the collision with the 'Obstacle' collision class ended
          tile.is_obscured = false
        end
      end
    end
end
]]

return Tiles