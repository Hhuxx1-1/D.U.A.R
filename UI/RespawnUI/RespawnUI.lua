local uiid = "7510065272332163314";

local killFeedUI = "7511519823136495858"
local lastUpdateKillFeed = 0
local isOnRes = {};
local function updateKillFeed()
    local r, n, players = World:getAllPlayers(-1)
    if n > 0 then
        -- Get only the last 5 messages from the killfeed
        local total = #BATTLE_DATA.KILLFEED
        local start = math.max(1, total - 4)
        local killfeed = {}
        for i = start, total do
            table.insert(killfeed, BATTLE_DATA.KILLFEED[i])
        end
        -- print("Killfeed : ",killfeed,BATTLE_DATA.KILLFEED);
        -- local killfeedMSG = table.concat(recentMessages, "\n") killfeed is no longer Just a message;
        -- it is now table {victimName = victimName , killerName = attackerName , weaponName = killer.weapon , weaponIcon = killer.weaponIcon};
        -- Timestamp this update
        lastUpdateKillFeed = os.time()
        local delay = 9

        -- Update the UI for all players
        for _, player in ipairs(players) do
            local kfUI = UIZ(killFeedUI, player)
            -- kfUI("text", 1):setText(killfeedMSG)-- we nolonger just displayed it on single text;
            -- itereate through available slot;
            for slot = 1 , 5 do 
                if killfeed[slot] then 
                    kfUI("base"..slot,32 + ((slot - 1) * 4)):show()
                    kfUI("picWeapon"..slot,32 + ((slot - 1) * 4) + 1):setTexture(tostring(killfeed[slot].weaponIcon));
                    kfUI("txtAttacker"..slot,32 + ((slot - 1) * 4) + 2):setText(killfeed[slot].killerName or "Unknown");
                    kfUI("txtVictim"..slot,32 + ((slot - 1) * 4) + 3):setText(killfeed[slot].victimName or "Unknown");
                else  
                    kfUI("base"..slot,32 + ((slot - 1 ) * 4 )):hide()
                end 
            end 
            kfUI()
        end

        -- Clear the UI after delay (only if no newer updates happened)
        threadpool:delay(delay, function()
            if os.time() - lastUpdateKillFeed >= delay then
                for _, player in ipairs(players) do
            -- itereate through available slot;
                    local kfUI = UIZ(killFeedUI, player)
                    for slot = 1 , 5 do 
                            kfUI("base"..slot,32 + ((slot - 1 ) * 4 )):hide()
                    end 
                    kfUI();
                end
            end
            BATTLE_DATA.KILLFEED = {} -- reset the kill Feed;
        end)
    end
end

ScriptSupportEvent:registerEvent("UI.Show",function(e)
    local playerid = e.eventobjid;
    -- close statuses UI and backpack UI;
    local statusesUI = "7504000963193805042"
    local backpackUI = "7504602816960993522"
    if Player:hideUIView(playerid,statusesUI) == 0 
    and Player:hideUIView(playerid,backpackUI) == 0 
    then 
        isOnRes[playerid] = true;
        BACKPACK.Clear(playerid);
        --    set plaer Location;
        local r, _x, _y, _z = Player:getPosition(playerid);
        if Player:setPosition(playerid, _x, 120, _z) == 0 
        then
            Player:setAttr(playerid,2,1); 
            Player:setActionAttrState(playerid,1, false);
            Player:setActionAttrState(playerid,64, false);
            -- mount Camera original _x,_y,_z position;
            Player:SetCameraMountPos(playerid, {x=_x,y=_y+3,z=_z});

            local _e = UIZ(uiid,playerid);
            _e("respawnButton",2):setAction(function()
                Player:ResetCameraAttr(playerid)
                Player:hideUIView(playerid,uiid);
                threadpool:wait(1);
                GIVE_PLAYER_LOADOUT(playerid)
            end)
            _e("changeButton",5):setAction(function()
                Player:ResetCameraAttr(playerid)
                Player:hideUIView(playerid,uiid);
                PLAYER_READY:UNREGISTER(playerid);
                threadpool:wait(1);
                Player:openUIView(playerid,"7508907770055956722");
                Actor:addBuff(playerid,50000003,1, 1);
            end)


             -- Player died
            local deathMsg = BATTLE_DATA:DeathMessage(playerid)
            -- print(deathMsg)
            _e("deathText",11):setText(deathMsg);
            
            -- Award kill to killer
            local killer = BATTLE_DATA:GetKiller(playerid)
            if killer then
                BATTLE_DATA.players[killer.attacker].kills = 
                    BATTLE_DATA.players[killer.attacker].kills + 1;
                local INFO = PLAYERDATA(TABLE_TYPE.string,"INFO",killer.attacker);
                local current_Kill = INFO:readIndex(4);
                INFO:updateIndex(4,current_Kill+1);
                INFO:destroy();
                -- update the killfeed text;
                updateKillFeed();
                if playerid ~= killer.attacker then 
                -- make sure it is other player killed;
                -- add coin for killer;
                    local coins = CURRENCY("Coins",killer.attacker);
                    coins:gain(1000,"Kill Player"..playerid);
                    local diamond = CURRENCY("Diamonds",killer.attacker);
                    diamond:gain(5,"Kill Player"..playerid);
                end 
            end

            -- Calculate yaw (horizontal) and pitch (vertical) angle difference
            local function getAngleDiff(playerid, target)
                local _, px, py, pz = Actor:getPosition(playerid)
                local _, dx, dy, dz = Player:getAimPos(playerid)
                local tx, ty, tz = target.x, target.y, target.z

                -- Vector from player to aim direction
                local dirX, dirZ = dx - px, dz - pz
                local aimMag = math.sqrt(dirX^2 + dirZ^2)
                dirX, dirZ = dirX / aimMag, dirZ / aimMag

                -- Vector from player to target
                local toTargetX, toTargetZ = tx - px, tz - pz
                local targetMag = math.sqrt(toTargetX^2 + toTargetZ^2)
                toTargetX, toTargetZ = toTargetX / targetMag, toTargetZ / targetMag

                -- Yaw
                local dot = toTargetX * dirX + toTargetZ * dirZ
                local det = toTargetX * dirZ - toTargetZ * dirX
                local yaw = math.atan2(det, dot) * (180 / math.pi)

                -- Pitch: vertical angle between player and target
                local dy = ty - py
                local dz = math.sqrt((tx - px)^2 + (tz - pz)^2)
                local pitch = math.atan2(dy, dz) * (180 / math.pi)

                return yaw, pitch
            end

            -- Repeated camera update
            local function cameraFollow(playerid, target, ticks)
                if ticks > 20 or not isOnRes[playerid] then return end

                local r, tx, ty, tz = Player:getPosition(target)
                local yaw, pitch = getAngleDiff(playerid, {x = tx, y = ty, z = tz})

                Player:SetCameraRotTransformBy(playerid, {x = yaw, y = pitch}, 1, 0.4)

                -- Schedule next update
                threadpool:delay(0.5, function()
                    cameraFollow(playerid, target, ticks + 1)
                end)
            end

            -- Start following camera
            cameraFollow(playerid, killer.attacker, 1)

            -- print("BATTLE_DATA : ",BATTLE_DATA);
            
            -- Clear victim's data for respawn
            BATTLE_DATA:Clear(playerid)

        end 
    end 
end)
ScriptSupportEvent:registerEvent("UI.Hide",function(e)
    local playerid = e.eventobjid;
    isOnRes[playerid] = false;
end)

ScriptSupportEvent:registerEvent("UI.Button.Click",function(e)
    local playerid = e.eventobjid;
    local CustomUI = e.CustomUI;
    local elementBtn = e.uielement;
    -- check from PROMPT 
    if CustomUI == uiid then 
        -- print("This UI Clicked")
        if UIZ_BUTTON then 
            -- print("UIZ_BUTTON : " , playerid,elementBtn)
            -- PROMPT is exist 
            UIZ_BUTTON(playerid,elementBtn)
        end     
    end 
end)