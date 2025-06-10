function MISSILE_SHOT_SPREAD(sourceObjId, projId, x, y, z, dirx, diry, dirz, speed, count, angleYawStep, anglePitchStep)
    -- Get forward yaw and pitch from direction
    local yaw = math.atan2(dirz, dirx)
    local horizontalDist = math.sqrt(dirx * dirx + dirz * dirz)
    local pitch = math.atan2(diry, horizontalDist)

    local half = math.floor(count / 2)
    for i = 0, count - 1 do
        for j = 0, count - 1 do
            local offsetYaw = i - half
            local offsetPitch = j - half

            local angleYaw = yaw + math.rad(offsetYaw * angleYawStep)
            local anglePitch = pitch + math.rad(offsetPitch * anglePitchStep)

            -- Convert spherical to direction vector
            local spreadDirX = math.cos(anglePitch) * math.cos(angleYaw)
            local spreadDirY = math.sin(anglePitch)
            local spreadDirZ = math.cos(anglePitch) * math.sin(angleYaw)

            World:spawnProjectileByDir(sourceObjId, projId, x, y, z, spreadDirX, spreadDirY, spreadDirZ, speed)
        end
    end
end
function MISSILE_SHOT_FAN(sourceObjId, projId, x, y, z, dirx, diry, dirz, speed, count, angleStep)
    -- Convert direction to angle
    local baseAngle = math.atan2(dirz, dirx)

    -- Symmetrical spread: center, left-right alternation
    local middle = math.floor(count / 2)

    for i = 0, count - 1 do
        local offset = i - middle
        local angle = baseAngle + math.rad(offset * angleStep)

        local spreadDirX = math.cos(angle)
        local spreadDirZ = math.sin(angle)

        World:spawnProjectileByDir(sourceObjId, projId, x, y, z, spreadDirX, diry, spreadDirZ, speed)
    end
end
--[[ REGISTER USE ID 15014 AK]]
CUSTOM_ACTION_REGISTER_USE(15014,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
--[[ REGISTER USE ID 4099 Bomb]]
CUSTOM_ACTION_REGISTER_USED(4099,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
--[[ REGISTER USE ID Rocket Launcer]]
CUSTOM_ACTION_REGISTER_USE(4101,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- Quick SMG ;
CUSTOM_ACTION_REGISTER_USE(15013,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- Quick Grenade
CUSTOM_ACTION_REGISTER_USED(4104,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- Bazooka;
CUSTOM_ACTION_REGISTER_USE(4105,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- Explosive Revolver
CUSTOM_ACTION_REGISTER_USE(4106,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- dynamite;
CUSTOM_ACTION_REGISTER_USED(4108,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- shotgun;
CUSTOM_ACTION_REGISTER_USE(4111,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- White Fang;
CUSTOM_ACTION_REGISTER_USE(4113,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- wall;
CUSTOM_ACTION_REGISTER_USED(4110,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
    -- create Wall;
    local r, x, y, z = Player:getPosition(playerid)
    local r, dirx, diry, dirz = Actor:getFaceDirection(playerid)
    WALL.CURVE(x, y, z, dirx, diry, dirz, 5, math.pi/2, 4, 2, {
        edge = 962,middleEdge=963,middle=964
    })
end)
-- shotgun;
CUSTOM_ACTION_REGISTER_USE(4114,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- energy rifle;
CUSTOM_ACTION_REGISTER_USE(4116,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- energy Canon;
CUSTOM_ACTION_REGISTER_USE(4117,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- SR Rifle 
CUSTOM_ACTION_REGISTER_USE(4118,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- Wall Lazard;
CUSTOM_ACTION_REGISTER_USED(4122,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
    -- create Wall;
    local r, x, y, z = Player:getPosition(playerid);
    local r, dirx, diry, dirz = Actor:getFaceDirection(playerid);
    -- get current block where player is standing;
    local r1 , blockid1 = Block:getBlockID(x,y-1,z);
    local r2 , blockid2 = Block:getBlockID(x+dirz,y-1,z-dirx);
    local r3 , blockid3 = Block:getBlockID(x-dirz,y-1,z+dirx);
    WALL.CURVE(x, y, z, dirx, diry, dirz, 5, math.pi/2, 4, 2, {
        edge = r3 == 0 and blockid3 or 670,middleEdge = r2 == 0 and blockid2 or 670,middle= r1 == 0 and blockid1 or 670
    })
end)
-- Grenade Launcher
CUSTOM_ACTION_REGISTER_USE(4123,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
--  m14
CUSTOM_ACTION_REGISTER_USE(15015,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
--  Hook Shoot
CUSTOM_ACTION_REGISTER_USE(12006,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
--  Rail Sniper
CUSTOM_ACTION_REGISTER_USE(4119,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
--  AUG Rifle;
CUSTOM_ACTION_REGISTER_USE(15019,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
--  Fire Rifle;
CUSTOM_ACTION_REGISTER_USE(15017,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- Fire Shotgun;
CUSTOM_ACTION_REGISTER_USE(4131,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end);
-- Fire Sniper;
CUSTOM_ACTION_REGISTER_USE(4132,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end);
--  Ice Rifle;
CUSTOM_ACTION_REGISTER_USE(15018,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- Ice Wall;
CUSTOM_ACTION_REGISTER_USED(4138,function(playerid,itemid)
    local r, x, y, z = Player:getPosition(playerid);
    local r, dirx, diry, dirz = Actor:getFaceDirection(playerid);
    WALL.STAIR(x + dirx * 3, y - 1, z + dirz * 3, dirx, diry, dirz, 6, 5, {edge=160002, middleEdge=160002, middle=160002}, 160002)
    WALL.STRAIGHT(x + dirx *8, y - 1, z + dirz * 8,dirx,diry,dirz,6,5,3,{edge=160002, middleEdge=160002, middle=160002})
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end);
-- Zap Rifle
CUSTOM_ACTION_REGISTER_USE(4137,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- Laser Blaster
CUSTOM_ACTION_REGISTER_USE(4136,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- Bazooka
CUSTOM_ACTION_REGISTER_USE(4127,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- Drone;
CUSTOM_ACTION_REGISTER_USED(4133,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end);
-- HK Explosive Rifle
CUSTOM_ACTION_REGISTER_USE(4141,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)
-- Castler;
CUSTOM_ACTION_REGISTER_USED(4144,function(playerid,itemid)
    local _, x, y, z = Player:getPosition(playerid)
    local _, dirx, diry, dirz = Actor:getFaceDirection(playerid)

    -- Place stairs first
    WALL.STAIR(x + dirx * 3, y - 1, z + dirz * 3, dirx, diry, dirz, 6, 4, {edge=683, middleEdge=428, middle=422}, 428)

    -- Then place the castle on top of the stairs
    local stairTopX = x + dirx * 9  -- (3 offset + 6 stairs)
    local stairTopY = y + 3         -- platformHeight
    local stairTopZ = z + dirz * 9

    WALL.CASTLE(
        stairTopX, stairTopY, stairTopZ,
        dirx, diry, dirz,
        5,           -- radius
        math.pi * 0.6, -- angleSpan
        4,           -- wall height
        2,           -- battlement height
        3,           -- inner wall height
        2,           -- gap interval for battlement
        {edge=683, middleEdge=428, middle=422}
    )
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end);
-- Multi Rocket
CUSTOM_ACTION_REGISTER_USE(4140,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)

-- Dragon AK
CUSTOM_ACTION_REGISTER_USE(4145,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)

-- Wall High;
CUSTOM_ACTION_REGISTER_USED(4146,function(playerid,itemid)
    local _, x, y, z = Player:getPosition(playerid)
    local _, dirx, diry, dirz = Actor:getFaceDirection(playerid)

    -- Place stairs first
    WALL.STAIR(x + dirx * 3, y - 1, z + dirz * 3, dirx, diry, dirz, 5, 4, {
        edge=40, middleEdge=450, middle=200381
    }, 200381)

    -- Then place the castle on top of the stairs
    local stairTopX = x + dirx * 6  -- (3 offset + 6 stairs)
    local stairTopY = y 
    local stairTopZ = z + dirz * 6

    WALL.CASTLE(
        stairTopX, stairTopY, stairTopZ,
        dirx, diry, dirz,
        5,           -- radius
        math.pi * 0.6, -- angleSpan
        6,           -- wall height
        2,           -- battlement height
        3,           -- inner wall height
        2,           -- gap interval for battlement
        {edge=40, middleEdge=450, middle=1107}
    )
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end);

-- Grappling Hook
CUSTOM_ACTION_REGISTER_USE(4147,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
    Actor:appendSpeed(playerid,0,0.5,0);
    local r , x,y,z =Player:getPosition(playerid);
    local _, dirx, diry, dirz = Actor:getFaceDirection(playerid);
    World:spawnProjectileByDir(playerid, 12006, x, y+1, z, dirx , diry +0.05, dirz , 1200);
    World:spawnProjectileByDir(playerid, 12006, x, y+1, z, dirx , diry -0.05, dirz , 1200);
end)
-- High Energy Gun
CUSTOM_ACTION_REGISTER_USE(4149,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)

-- Shield Boost 
CUSTOM_ACTION_REGISTER_USED(4148,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
    local _, x, y, z = Player:getPosition(playerid)
    local _, dirx, diry, dirz = Actor:getFaceDirection(playerid)

    -- Place stairs first
    WALL.STAIR(x + dirx * 3, y - 1, z + dirz * 3, dirx, diry, dirz, 5, 4, {
        edge=449, middleEdge=410, middle=449
    }, 449)

    -- Then place the castle on top of the stairs
    local stairTopX = x + dirx * 6  -- (3 offset + 6 stairs)
    local stairTopY = y 
    local stairTopZ = z + dirz * 6

    WALL.CASTLE(
        stairTopX, stairTopY, stairTopZ,
        dirx, diry, dirz,
        5,           -- radius
        math.pi * 0.6, -- angleSpan
        6,           -- wall height
        2,           -- battlement height
        3,           -- inner wall height
        2,           -- gap interval for battlement
        {edge=550, middleEdge=410, middle=449}
    )
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
end)

-- Super Operator 
CUSTOM_ACTION_REGISTER_USE(4150,function(playerid,itemid)
    BACKPACK.ConsumeIndex(playerid,CURRENT_EQUIP_INDEX[playerid],1);
    local r,x,y,z = Player:getPosition(playerid);
    local r,dirx,diry,dirz = Player:getFaceDirection(playerid);
    MISSILE_SHOT_FAN(playerid,4128,x+(dirx*2),y+1.5,z+(dirz*2),dirx,diry,dirz,600,2,5);
end)