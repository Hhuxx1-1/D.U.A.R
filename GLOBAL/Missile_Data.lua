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

-- Bom;
local error = MISSILE:REGISTER(4098)
:SET_CREATE(function(e)
    Actor:playSoundEffectById(e.toobjid,10664 , 100, 1, false)
    Actor:playBodyEffectById(e.toobjid,1333, 1)
    threadpool:delay(3,function()
        local r,posX,posY,posZ = Actor:getPosition(e.toobjid);
        print(e);
        MISSILE.f.ExplodeByRadius(posX,posY,posZ, 5, 1500, 45, 1009, 10538, e.helperobjid);
        Actor:killSelf(e.toobjid);
    end)
end)
:SET_HIT(function()
    
end)
;
-- Box;
local error = MISSILE:REGISTER(12298)
:SET_CREATE(function(e)
    Actor:playBodyEffectById(e.toobjid,1226, 0.7);
    -- use threadpool to delay its deletetion randomly;
    threadpool:delay(math.random(2, 4),function()
        Actor:killSelf(e.toobjid);
    end)
end)
:SET_HIT(function(e)
    threadpool:wait(1);
    local r, stringModel = Actor:getActorFacade(e.eventobjid);
    -- string model should start with either Block or block; 
    if r == 0 and stringModel then 
        if string.sub(stringModel,1, 5) ~= "Block" or string.sub(stringModel,1, 5) ~= "block" then
            Actor:killSelf(e.eventobjid);
        end 
    end 
end)
;
-- Normal Bullet;
local error = MISSILE:REGISTER(15003)
:SET_HIT(function(e)
    -- print("Hit Event : ",e);
    if math.random() < 0.6 then 
        MISSILE.f.ExplodeByRadius(e.x,e.y,e.z, 1, 1, 0, 0, 0, e.helperobjid);
    end 
    Actor:killSelf(e.eventobjid);
end)
:SET_CREATE(function(e)
    -- print("Create Event : ",e);
    -- create line 
    local r,x,y,z = Actor:getFaceDirection(e.eventobjid)
	local size , color = 0.25 , 0xff0000;
	local id = 1;
	local info=Graphics:makeGraphicsLineToPos(e.x+x,e.y+y-1.5,e.z+z, size, color, id)
	local offset , dir =  0 , {x=0,y=0,z=0}--Offset direction
	Graphics:createGraphicsLineByActorToPos(e.toobjid, info, dir, offset)
end)
;
-- Explosive Bullet;
local error = MISSILE:REGISTER(4109)
:SET_HIT(function(e)
    -- print("Hit Event : ",e);
    MISSILE.f.ExplodeByRadius(e.x,e.y,e.z, 2.5, 200, 20, 1009, 10660, e.helperobjid);
    Actor:killSelf(e.eventobjid);
end)
:SET_CREATE(function(e)
    -- print("Create Event : ",e);
    -- create line 
    local r,x,y,z = Actor:getFaceDirection(e.eventobjid)
	local size , color = 0.25 , 0xff0000;
	local id = 1;
	local info=Graphics:makeGraphicsLineToPos(e.x+x,e.y+y-1.5,e.z+z, size, color, id)
	local offset , dir =  0 , {x=0,y=0,z=0}--Offset direction
	Graphics:createGraphicsLineByActorToPos(e.toobjid, info, dir, offset)
end)
;

-- Missile Rpg;
local error = MISSILE:REGISTER(4102)
:SET_HIT(function(e)
    -- print(e);
    MISSILE.f.ExplodeByRadius(e.x,e.y,e.z,  math.random(4,6), 500, 45, 1009, 10660, e.helperobjid);
    Actor:killSelf(e.eventobjid);
end)
:SET_CREATE(function(e)
    Actor:playSoundEffectById(e.toobjid, 10637, 100, 1, false)
    Actor:playBodyEffectById(e.toobjid,1194, 1)
end)
;

-- Quick Grenade;
local error = MISSILE:REGISTER(4103)
:SET_HIT(function(e)
    -- print(e);
    threadpool:delay(1,function()
        local r,posX,posY,posZ = Actor:getPosition(e.eventobjid);
        MISSILE.f.ExplodeByRadius(posX,posY,posZ,  math.random(4,6), 500, 45, 1009, 10660, e.helperobjid);
        Actor:killSelf(e.eventobjid);
    end)
end)
:SET_CREATE(function(e)

end)
;

-- Dynamite;
local error = MISSILE:REGISTER(4107)
:SET_HIT(function(e)
    -- print(e);
    threadpool:delay(1,function()
        local r,posX,posY,posZ = Actor:getPosition(e.eventobjid);
        MISSILE.f.ExplodeByRadius(posX,posY,posZ,  math.random(4,6), 500, 45, 1009, 10660, e.helperobjid);
        Actor:killSelf(e.eventobjid);
    end)
end)
:SET_CREATE(function(e)

end)
;

-- Energy Pulse ;
local error = MISSILE:REGISTER(4120)
:SET_HIT(function(e)
    -- print(e);
    if math.random() < 0.3 then 
    local r,posX,posY,posZ = Actor:getPosition(e.eventobjid);
        threadpool:delay(0.2,function()
            MISSILE.f.ExplodeByRadius(posX,posY,posZ,  math.random(20,30)/10, math.random(20,30)*1.5, 0, 1009, 10660, e.helperobjid);
        end)
    end
    threadpool:delay(0.4,function()
        Actor:killSelf(e.eventobjid);
    end)
end)
:SET_CREATE(function(e)
    local r,x,y,z = Actor:getFaceDirection(e.helperobjid);
	local size , color = 0.4 , 0x1111ff;
	local id = 1;
	local info=Graphics:makeGraphicsLineToPos(e.x+x,e.y+y-1,e.z+z, size, color, id)
	local offset , dir =  0 , {x=0,y=100,z=0}--Offset direction
	Graphics:createGraphicsLineByActorToPos(e.toobjid, info, dir, offset)   
    threadpool:delay(3,function()
        Actor:killSelf(e.toobjid);
    end)
end)
;

-- Canon Energy ;
local error = MISSILE:REGISTER(4121)
:SET_HIT(function(e)
    local r,posX,posY,posZ = Actor:getPosition(e.eventobjid);
    threadpool:delay(0.1,function()
        MISSILE.f.ExplodeByRadius(posX,posY,posZ, 4.5, 450, 45, 1009, 10660, e.helperobjid);
    end)
end)
:SET_CREATE(function(e)
    Actor:playSoundEffectById(e.toobjid, 10471, 100, 1, false)
    Actor:playBodyEffectById(e.toobjid,1040, 1)
    threadpool:delay(3,function()
        local r,posX,posY,posZ = Actor:getPosition(e.toobjid);
        threadpool:delay(0.1,function()
            MISSILE.f.ExplodeByRadius(posX,posY,posZ, 5, 650, 45, 1009, 10660, e.helperobjid);
        end)
        Actor:killSelf(e.toobjid);
    end)
end)
;

-- Shotgun Bullet ;
local error = MISSILE:REGISTER(4112)
:SET_HIT(function(e)
    local r,posX,posY,posZ = Actor:getPosition(e.eventobjid);
    MISSILE.f.ExplodeByRadius(posX,posY,posZ, 4.5, 600, 45, 1009, 10660, e.helperobjid);
end)
:SET_CREATE(function(e)
    threadpool:delay(0.4,function()
        local r,posX,posY,posZ = Actor:getPosition(e.toobjid);
        threadpool:delay(0.1,function()
            MISSILE.f.ExplodeByRadius(posX,posY,posZ, 5, 500, 45, 1009, 10660, e.helperobjid);
        end)
        Actor:killSelf(e.toobjid);
    end)
end)
;

-- Grenade Launcher projectile;
local error = MISSILE:REGISTER(4124)
:SET_HIT(function(e)
    -- print(e);
    local r,posX,posY,posZ = Actor:getPosition(e.eventobjid);
    MISSILE.f.ExplodeByRadius(posX,posY,posZ,  math.random(4,6), 200, 45, 1009, 10660, e.helperobjid);
    Actor:killSelf(e.eventobjid);
end)
:SET_CREATE(function(e)
    Actor:playSoundEffectById(e.toobjid, 10637, 100, 1, false)
    Actor:playBodyEffectById(e.toobjid,1194, 1)
end)
;

-- Rail Gun projectile ;
local error = MISSILE:REGISTER(4128)
:SET_HIT(function(e)
    -- print(e);
    local r,posX,posY,posZ = Actor:getPosition(e.eventobjid);
    local r,pX,pY,pZ = Actor:getPosition(e.helperobjid);
    -- calculate the distance;
    local distance = math.sqrt((pX-posX)^2+(pY-posY)^2+(pZ-posZ)^2);
    threadpool:delay(0.3,function()
        -- now the sniper mostly affected by distance;
        MISSILE.f.ExplodeByRadius(posX,posY,posZ,  math.min(distance * 0.1,5), math.min(distance * 10,450), math.min(distance * 0.5,90), 1009, 10660, e.helperobjid);        
    end)

    threadpool:delay(0.6,function()
        Actor:killSelf(e.eventobjid);
    end)
end)
:SET_CREATE(function(e)
    local r,x,y,z = Actor:getFaceDirection(e.helperobjid);
	local size , color = 1.6 , 0xaa00ff;
	local id = 1;
	local info=Graphics:makeGraphicsLineToPos(e.x+x,e.y+y-1,e.z+z, size, color, id)
	local offset , dir =  0 , {x=0,y=100,z=0}--Offset direction
	Graphics:createGraphicsLineByActorToPos(e.toobjid, info, dir, offset)   
    threadpool:delay(3,function()
        Actor:killSelf(e.toobjid);
    end)
end)
;

-- Intermadieate Sniper projectile ;
local error = MISSILE:REGISTER(4135)
:SET_HIT(function(e)
    -- print(e);
    local r,posX,posY,posZ = Actor:getPosition(e.eventobjid);
    local r,pX,pY,pZ = Actor:getPosition(e.helperobjid);
    -- calculate the distance;
    local distance = math.sqrt((pX-posX)^2+(pY-posY)^2+(pZ-posZ)^2);
    threadpool:delay(0.3,function()
        -- now the sniper mostly affected by distance;
        MISSILE.f.ExplodeByRadius(posX,posY,posZ,  math.min(distance * 0.1,3.5), math.min(distance * 7,250), math.min(distance * 0.2,45), 1009, 10660, e.helperobjid);        
    end)

    threadpool:delay(0.6,function()
        Actor:killSelf(e.eventobjid);
    end)
end)
:SET_CREATE(function(e)
    local r,x,y,z = Actor:getFaceDirection(e.helperobjid);
	local size , color = 1.6 , 0xaa00ff;
	local id = 1;
	local info=Graphics:makeGraphicsLineToPos(e.x+x,e.y+y-1,e.z+z, size, color, id)
	local offset , dir =  0 , {x=0,y=100,z=0}--Offset direction
	Graphics:createGraphicsLineByActorToPos(e.toobjid, info, dir, offset)   
    threadpool:delay(3,function()
        Actor:killSelf(e.toobjid);
    end)
end)
;

-- Zap Gun projectile ;
local error = MISSILE:REGISTER(4139)
:SET_HIT(function(e)
    -- print(e);
    local r,posX,posY,posZ = Actor:getPosition(e.eventobjid);
    local r,pX,pY,pZ = Actor:getPosition(e.helperobjid);
    -- calculate the distance;
    local distance = math.sqrt((pX-posX)^2+(pY-posY)^2+(pZ-posZ)^2);
    threadpool:delay(0.3,function()
        -- now the sniper mostly affected by distance;
        MISSILE.f.ExplodeByRadius(posX,posY,posZ,  2.4, 250, 25, 1009, 10660, e.helperobjid);        
    end)

    threadpool:delay(0.6,function()
        Actor:killSelf(e.eventobjid);
    end)
end)
:SET_CREATE(function(e)
    local r,x,y,z = Actor:getFaceDirection(e.helperobjid);
	local size , color = 0.6 , 0xaaaaff;
	local id = 1;
	local info=Graphics:makeGraphicsLineToPos(e.x+x,e.y+y-1,e.z+z, size, color, id)
	local offset , dir =  0 , {x=0,y=100,z=0}--Offset direction
	Graphics:createGraphicsLineByActorToPos(e.toobjid, info, dir, offset)   
    threadpool:delay(3,function()
        Actor:killSelf(e.toobjid);
    end)
end)
;

-- HK RIFLE Gun projectile ;
local error = MISSILE:REGISTER(4142)
:SET_HIT(function(e)
    -- print(e);
    local r,posX,posY,posZ = Actor:getPosition(e.eventobjid);
    local r,pX,pY,pZ = Actor:getPosition(e.helperobjid);
    -- calculate the distance;
    MISSILE.f.ExplodeByRadius(posX,posY,posZ,  2.4, 250, 25, 1009, 10660, e.helperobjid);        

    threadpool:delay(0.6,function()
        Actor:killSelf(e.eventobjid);
    end)
end)
:SET_CREATE(function(e)
    local r,x,y,z = Actor:getFaceDirection(e.helperobjid);
	local size , color = 0.6 , 0xdd1100;
	local id = 1;
	local info=Graphics:makeGraphicsLineToPos(e.x+x,e.y+y-1,e.z+z, size, color, id)
	local offset , dir =  0 , {x=0,y=100,z=0}--Offset direction
	Graphics:createGraphicsLineByActorToPos(e.toobjid, info, dir, offset)   
    threadpool:delay(3,function()
        Actor:killSelf(e.toobjid);
    end)
end)
;


-- Missile Rpg;
local error = MISSILE:REGISTER(4143)
:SET_HIT(function(e)
    -- print(e);
    MISSILE.f.ExplodeByRadius(e.x,e.y,e.z,  math.random(4,6), 500, 45, 1009, 10660, e.helperobjid);
    Actor:killSelf(e.eventobjid);
end)
:SET_CREATE(function(e)
    Actor:playSoundEffectById(e.toobjid, 10637, 100, 1, false)
    Actor:playBodyEffectById(e.toobjid,1194, 1);
    local r,dirx,diry,dirz = Actor:getFaceDirection(e.helperobjid);
    threadpool:delay(0.4,function()
        local r,x,y,z = Actor:getPosition(e.toobjid)
        if r == 0 then 
            MISSILE_SHOT_FAN(e.helperobjid, 4102, x, y + 1, z, dirx, diry, dirz, 280, 3,15)
            Actor:killSelf(e.toobjid);
        end 
    end)
end)
;