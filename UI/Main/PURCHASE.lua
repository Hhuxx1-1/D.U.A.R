PURCHASE = {
    PERMANENT_ITEMS = {}, -- itemid => func
    TEMP_REQUESTS = {}    -- playerid => { itemid => func }
}
-- Register permanent itemid and function
function PURCHASE:Set_Item(itemid, func)
    if self.PERMANENT_ITEMS[itemid] then
        print("Warning: itemid "..itemid.." is already registered as a permanent item.")
        return
    end
    self.PERMANENT_ITEMS[itemid] = func
end

-- Per-player temporary purchase request
function PURCHASE:Request(playerid, itemid, message, callback)
    if self.PERMANENT_ITEMS[itemid] then
        print("Error: itemid "..itemid.." is registered as permanent item, use a different itemid.")
        return
    end
    self.TEMP_REQUESTS[playerid] = self.TEMP_REQUESTS[playerid] or {}
    self.TEMP_REQUESTS[playerid][itemid] = callback
    Player:openDevGoodsBuyDialog(playerid, itemid, message)
end

-- Handle item received
ScriptSupportEvent:registerEvent("Player.AddItem", function(e)
    local pid, item = e.eventobjid, e.itemid

    -- Handle permanent item
    if PURCHASE.PERMANENT_ITEMS[item] then
        local success, err = pcall(function()
            PURCHASE.PERMANENT_ITEMS[item](e, pid)
        end)
        if not success then print("[PURCHASE PERMANENT ERROR]", err) end
        Player:removeBackpackItem(pid, item, 1)
        return
    end

    -- Handle temporary request
    local requestTable = PURCHASE.TEMP_REQUESTS[pid]
    if requestTable and requestTable[item] then
        local success, err = pcall(function()
            requestTable[item](e, pid)
        end)
        if not success then print("[PURCHASE TEMP ERROR]", err) end
        Player:removeBackpackItem(pid, item, 1)
        requestTable[item] = nil
    end
end)
