DROP = {data = {}}

function DROP:createDrop(x,y,z,load)
    local r , obj =  World:spawnCreature(x,y, z, 3400, 1)  -- Spawn object ID 3400
    -- spawn a picture
    Graphics:createGraphicsImageByActor(obj[1],Graphics:makeGraphicsImage(load.iconid, 0.3, 100, 1),{x=0,y=1,z=0},-10,0,75);
    Graphics:createGraphicsImageByActor(obj[1],Graphics:makeGraphicsImage([[8_1029380338_1741391128]], 0.86, 50, 2),{x=0,y=1,z=0},-50,0,0);
    Graphics:createGraphicsTxtByActor(obj[1], Graphics:makeGraphicsText("#cb1ffff+"..load.lvalue, 21, 0, 3),{x=0,y=1,z=0},-5,0,-20)
    Actor:playBodyEffectById(obj[1],1187,1,10)
    -- store with obj[1] as key;
    self.data[obj[1]] = {x=x, y=y, z=z, load=load, obj=obj[1]};

    -- delay 10 second and remove the drop;
    threadpool:delay(10,function()
        if self.data[obj[1]] then 
            if Actor:killSelf(obj[1]) == 0 then 
                self.data[obj[1]] = nil 
            end 
        end 
    end)
end

-- function when player touch the drop;
function DROP:dropTouch(playerid, dropId)
    local drop = self.data[dropId]
    if drop then 
        -- delete drop;
        if Actor:killSelf(drop.obj) == 0 then 
            -- give player the item;
            local load = drop.load;
            BACKPACK.AddItem(playerid,load.itemid,load.name,load.iconid,math.max(load.lvalue,1));
            -- delete drop from data;
            Player:playMusic(playerid,10963 ,70, 1, false);
            Actor:playBodyEffectById(playerid,1321,1);
            self.data[dropId] = nil;
        end 
    end 
end 

ScriptSupportEvent:registerEvent("Player.Collide",function(e)
    DROP:dropTouch(e.eventobjid,e.toobjid);
end)