-- Battle Data System
BATTLE_DATA = {
    players = {}  -- Stores all battle data per player
}
BATTLE_DATA.KILLFEED = {} --stores current killfeed;

-- Check if object is a player
local function isPlayer(objid)
    return Actor:isPlayer(objid) == 0  -- 0 means player in your system
end

-- Initialize or clear player data
local function initPlayerData(playerid)
    if not BATTLE_DATA.players[playerid] then
        BATTLE_DATA.players[playerid] = {
            damageTaken = {},    -- All damage received
            damageDealt = {},    -- All damage dealt
            kills = 0,
            assists = 0
        }
    end
end

-- Record damage between players only
local function recordDamage(e)
    -- Only track player vs player damage
    if not isPlayer(e.eventobjid) or not isPlayer(e.toobjid) then
        return
    end
    
    initPlayerData(e.eventobjid)  -- Attacker
    initPlayerData(e.toobjid)     -- Victim
    
    -- Get weapon name from equipment system
    local r,currentEquip =  BACKPACK.getActualId(e.eventobjid)
    local weaponName = r == true and currentEquip.name or "Unknown Weapon";
    local weaponIcon = r == true and currentEquip.iconid or [[8_1029380338_1711289202]];
    
    -- Store damage dealt (attacker perspective)
    table.insert(BATTLE_DATA.players[e.eventobjid].damageDealt, {
        victim = e.toobjid,
        damage = e.hurtlv or e.CurEventParam.Hurtlv or 0,
        weapon = weaponName,
        weaponIcon = weaponIcon,
        timestamp = os.time()
    })
    
    -- Store damage taken (victim perspective)
    table.insert(BATTLE_DATA.players[e.toobjid].damageTaken, {
        attacker = e.eventobjid,
        damage = e.hurtlv or e.CurEventParam.Hurtlv or 0,
        weapon = weaponName,
        weaponIcon = weaponIcon,
        timestamp = os.time()
    })
end

-- Get killer info
local function getKiller(playerid)
    if not BATTLE_DATA.players[playerid] then return nil end;
    local damages = BATTLE_DATA.players[playerid].damageTaken
    if #damages > 0 then
        return damages[#damages]  -- Most recent damage
    end
    return nil
end

-- Generate death recap message
local function getDeathRecap(playerid)
    local killer = getKiller(playerid)
    if not killer then return "Died to unknown causes" end
    local attackerName = PLAYER_READY.PLAYERS[killer.attacker] ~= nil and PLAYER_READY.PLAYERS[killer.attacker].name or killer.attacker;
    local msg = string.format("Killed by [%s] (%s) | %d DMG",
          attackerName, killer.weapon, killer.damage)
    
    -- Check for assists (other damagers)
    local assistMap = {}
    for _, dmg in ipairs(BATTLE_DATA.players[playerid].damageTaken) do
        if dmg.attacker ~= killer.attacker then
            assistMap[dmg.attacker] = (assistMap[dmg.attacker] or 0) + dmg.damage
        end
    end
    
    -- Add assists to message
    for attackerId, damage in pairs(assistMap) do
        local weapon = BATTLE_DATA.players[attackerId].damageDealt[1].weapon  -- Get first weapon used
        msg = msg .. string.format("\n + Assisted by [Player%d] (%s) | %d DMG", 
              attackerId, weapon, damage)
    end

    -- add into killFeed
    local r, victimName = Player:getNickname(playerid);victimName = victimName:gsub("@", "")
    table.insert(BATTLE_DATA.KILLFEED,{victimName = victimName , killerName = attackerName , weaponName = killer.weapon , weaponIcon = killer.weaponIcon});

    return msg
end



-- Clear combat data
local function clearCombatData(playerid)
    BATTLE_DATA.players[playerid] = {
        damageTaken = {},
        damageDealt = {},
        kills = 0,
        assists = 0
    }
end

-- Event handler
ScriptSupportEvent:registerEvent("Player.DamageActor", function(e)
    recordDamage(e)
end)

-- Utility functions
function BATTLE_DATA:GetKills(playerid)
    return self.players[playerid] and self.players[playerid].kills or 0
end

function BATTLE_DATA:GetLastWeaponUsed(playerid)
    if self.players[playerid] and #self.players[playerid].damageDealt > 0 then
        return self.players[playerid].damageDealt[#self.players[playerid].damageDealt].weapon
    end
    return "None"
end

function BATTLE_DATA:DeathMessage(playerid)
    return getDeathRecap(playerid) or "???"
end

function BATTLE_DATA:GetKiller(playerid)
    return getKiller(playerid);
end

function BATTLE_DATA:Clear(playerid)
    return clearCombatData(playerid);
end