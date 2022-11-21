setmetatable(_G, { __index = rl })

local ffi = require "ffi"
local screenWidth, screenHeight = 600, 400

local PlayerPosition = new("Vector2", screenWidth/2, screenHeight/2)
local BuildingRectangle = new("Rectangle", screenWidth/2 + 20, screenHeight/2, 20, 20)

InitWindow(screenWidth, screenHeight, "Simple Lighting System")
SetTargetFPS(60)

local Textures = {
    ["GrassTexture"] = LoadTexture("Resources/Grass.png")
}

local Colors = {
    ["BuildingColor"] = ffi.new("Color", 255, 0, 0, 255),
}

local function calculateMagnitude(Vector, AnotherVector)
    return math.sqrt((Vector.x - AnotherVector.x) * (Vector.x - AnotherVector.x) + (Vector.y - AnotherVector.y) * (Vector.y - AnotherVector.y))
end

local function CalculateTransparency(rectValue, CurrentColor)
    local Center = new("Vector2", rectValue.x + rectValue.width / 2, rectValue.y + rectValue.height / 2)
    local Distance = calculateMagnitude(Center, PlayerPosition)
    local ColorPower = 255

    if Distance > 0 then
        ColorPower = 255 - Distance * 2
    else
        ColorPower = 255 + Distance * 2
    end

    if ColorPower < 0 then
        ColorPower = 0
    end

    return ffi.new("Color", CurrentColor.r, CurrentColor.g, CurrentColor.b, ColorPower)
end

local function CalculateColor(rectValue, CurrentColor)
    local Center = new("Vector2", rectValue.x + rectValue.width / 2, rectValue.y + rectValue.height / 2)

    local realDistance = calculateMagnitude(Center, PlayerPosition)
    local ColorPower = 255

    if realDistance > 0 then
        ColorPower = 255 - realDistance * 2
    else
        ColorPower = 255 + realDistance * 2
    end

    if ColorPower < 0 then
        ColorPower = 0
    end

    -- DrawRectangleRec(new("Rectangle", 0, 0, 20, 20), ffi.new("Color", 255, 0, ColorPower, 255)) for debug
    return ffi.new("Color", ColorPower, ColorPower, ColorPower, 255)
end

local function drawTiles()
    
    for i = 1, 10 do
        for i2 = 1, 15 do
            local currentTexture = Textures["GrassTexture"]
            local rectValue = new("Rectangle", (40 * i2) - 40, (40 * i) - 40, 40, 40)
            local Color = CalculateColor(rectValue, ffi.new("Color", 0, 0, 0, 255))
            -- print(40 * i2)
            DrawTextureRec(currentTexture, rectValue, new("Vector2", (40 * i2) - 40, (40 * i) - 40), Color)
        end
    end

end

while not WindowShouldClose() do

    if IsKeyDown(KEY_W) then
        PlayerPosition = new("Vector2", PlayerPosition.x, PlayerPosition.y - 1)
    end

    if IsKeyDown(KEY_S) then
        PlayerPosition = new("Vector2", PlayerPosition.x, PlayerPosition.y + 1)
    end

    if IsKeyDown(KEY_A) then
        PlayerPosition = new("Vector2", PlayerPosition.x - 1, PlayerPosition.y)
    end

    if IsKeyDown(KEY_D) then
        PlayerPosition = new("Vector2", PlayerPosition.x + 1, PlayerPosition.y)
    end

    BeginDrawing()
    drawTiles()

    ClearBackground(ffi.new("Color", 0, 0, 0)) -- Clear background
    
    DrawCircle(PlayerPosition.x, PlayerPosition.y, 10, RED) -- Player circle

    local Color = CalculateTransparency(BuildingRectangle, Colors["BuildingColor"])
    DrawRectangleRec(BuildingRectangle, Color)

    EndDrawing()
end

CloseWindow()