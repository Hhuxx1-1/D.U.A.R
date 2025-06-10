-- Math helper: Rotate a 2D vector (x,z) by `angle` degrees
local function rotateVector(x, z, angle)
    local rad = math.rad(angle)  -- Convert degrees to radians
    local cos, sin = math.cos(rad), math.sin(rad)
    return x * cos - z * sin, x * sin + z * cos
end

-- Register a scripted event at 30 seconds
ActionProcedure:NEW(30, function() 
    print("A meteor strikes at 30s!") 
end)

ActionProcedure:NEW(0, function()

    for i, player in ipairs(PLAYER_READY.IPLAYER) do
        -- 1. Get player position and facing direction
        local _, x, y, z = Player:getPosition(player.id)
        local _, dx, _, dz = Player:getFaceDirection(player.id)  -- Ignore vertical (dy)

        -- 2. Rotate direction 30° left and right
        local dxLeft, dzLeft = rotateVector(dx, dz, 30)    -- 30° left
        local dxRight, dzRight = rotateVector(dx, dz, -30)  -- 30° right

        -- 3. Spawn drops at both angles (5 units away)
        local distance = 5
        local function spawnDrop(dirX, dirZ,load)
            local cx, cy, cz = 
                x + dirX * distance, 
                y,  -- Keep original Y (or adjust if needed)
                z + dirZ * distance
           DROP:createDrop(cx,cy,cz,load)
        end

        local d =  GET_PLAYER_LOADOUT(player.id);
        if d then
            -- Spawn left + right drops
            spawnDrop(dxLeft, dzLeft,d.drop[math.random(1,3)]);
            spawnDrop(dxRight, dzRight,d.drop[math.random(1,3)]);
        end 
    end
end)

ActionProcedure:NEW(0, function()

    for i, player in ipairs(PLAYER_READY.IPLAYER) do
        -- 1. Get player position and facing direction
        local _, x, y, z = Player:getPosition(player.id)
        local _, dx, _, dz = Player:getFaceDirection(player.id)  -- Ignore vertical (dy)

        -- 2. Rotate direction 30° left and right
        local dxLeft, dzLeft = rotateVector(dx, dz, 45)    -- 30° left
        local dxRight, dzRight = rotateVector(dx, dz, -45)  -- 30° right

        -- 3. Spawn drops at both angles (5 units away)
        local distance = 12;
        local function spawnZombie(dirX, dirZ,load)
            local cx, cy, cz = 
                x + dirX * distance, 
                y,  -- Keep original Y (or adjust if needed)
                z + dirZ * distance
           local r , obj =  World:spawnCreature(cx,cy, cz, 3872, 2) 
        end

        local d =  GET_PLAYER_LOADOUT(player.id);
        if d then
            -- Spawn left + right drops
            spawnZombie(-dxLeft, -dzLeft)
            spawnZombie(-dxRight, -dzRight)
        end 
    end
end)


ActionProcedure:NEW(0, function()

    for i, player in ipairs(PLAYER_READY.IPLAYER) do
        -- 1. Get player position and facing direction
        local _, x, y, z = Player:getPosition(player.id)
        local _, dx, _, dz = Player:getFaceDirection(player.id)  -- Ignore vertical (dy)

        -- 2. Rotate direction 30° left and right
        local dxLeft, dzLeft = rotateVector(dx, dz, 70)    -- 30° left
        local dxRight, dzRight = rotateVector(dx, dz, -75)  -- 30° right

        -- 3. Spawn drops at both angles (5 units away)
        local distance = 12;
        local function spawnZombie(dirX, dirZ,load)
            local cx, cy, cz = 
                x + dirX * distance, 
                y,  -- Keep original Y (or adjust if needed)
                z + dirZ * distance
           local r , obj =  World:spawnCreature(cx,cy, cz, 3872, 1) 
        end

        local d =  GET_PLAYER_LOADOUT(player.id);
        if d then
            -- Spawn left + right drops
            spawnZombie(dxLeft, dzLeft)
            spawnZombie(dxRight, dzRight)
        end 
    end
end)