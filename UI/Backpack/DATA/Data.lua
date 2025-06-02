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