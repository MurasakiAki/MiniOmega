local Tiles = {}

function Tiles:new(tileWidth, tileHeight, numCols, numRows, x, y)
    local tiles = {}

    -- Initialize the tiles table with default values
    for i = 1, numCols do
        tiles[i] = {}
        for j = 1, numRows do
            tiles[i][j] = {x = x + (i - 1) * tileWidth, y = y + (j - 1) * tileHeight, color = {0.8, 0.6, 0.4, 0}} -- Default: Transparent
        end
    end

    tiles.tileWidth = tileWidth
    tiles.tileHeight = tileHeight
    tiles.x = x
    tiles.y = y

    setmetatable(tiles, self)
    self.__index = self

    return tiles
end

function Tiles:draw()
    -- Draw each tile
    for i = 1, #self do
        for j = 1, #self[i] do
            love.graphics.setColor(self[i][j].color)
            love.graphics.rectangle("fill", self[i][j].x, self[i][j].y, self.tileWidth, self.tileHeight)
        end
    end
end

function Tiles:mousepressed(x, y, button, player)

    local px, py = player.collider:getPosition()
    local mx, my = love.mouse.getPosition()

    local distance = math.sqrt((my - py)^2 + (px - mx)^2) --lol my pie

    if player.in_hand == "hoe" and button == 2 and distance <= 128 then -- Right mouse button
        -- Find the tile that was clicked
        local col = math.floor((x - self.x) / self.tileWidth) + 1
        local row = math.floor((y - self.y) / self.tileHeight) + 1

        -- Ensure the tile exists before modifying it
        if self[col] and self[col][row] then
            -- Change the color of the clicked tile
            local tile = self[col][row]
            if tile.color == nil or tile.color[4] == 0 then
                tile.color = {0.839, 0.698, 0.553, 1} -- Pastel Brown
            else
                tile.color = {0.8, 0.6, 0.4, 0} -- Default: Transparent
            end
        end
    end
end
return Tiles