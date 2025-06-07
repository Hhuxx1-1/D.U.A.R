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