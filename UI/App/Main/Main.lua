ActionProcedure = { data = {}, scripted = {} }
local secondCounter = 5

ScriptSupportEvent:registerEvent("Game.RunTime", function(e)
    if not e.second then return end

    local key = e.second

    -- 1. Check scripted events
    if ActionProcedure.scripted[key] then
        local actions = type(ActionProcedure.scripted[key]) == "table" 
            and ActionProcedure.scripted[key] 
            or { ActionProcedure.scripted[key] }

        local action = actions[math.random(1, #actions)]
        local r, err = pcall(action)
        if not r then print("Scripted Error: "..key.." - "..err) end
        return
    end

    -- 2. Handle random events
    secondCounter = secondCounter - 1
    if secondCounter <= 0 and #ActionProcedure.data > 0 then
        local action = ActionProcedure.data[math.random(1, #ActionProcedure.data)]
        local r, err = pcall(action)
        if not r then print("Random Error: "..err) end
        secondCounter = math.random(11, 22)
    end
end)

-- Register events (scripted at x=100s or random if x=0)
function ActionProcedure:NEW(x, f)
    if x == 0 then
        table.insert(self.data, f)
    else
        self.scripted[x] = self.scripted[x] or {}
        table.insert(self.scripted[x], f)
    end
end