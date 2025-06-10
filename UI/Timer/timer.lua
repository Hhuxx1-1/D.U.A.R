-- version: 2022-04-20
-- mini: 1029380338
local uiid = "7513849795649935602"

ScriptSupportEvent:registerEvent("UPDATE", function(e)
    local playerid = e.eventobjid
    local _e = UIZ(uiid,playerid);
    Player:openUIView(playerid,uiid);
    -- convert second to timer format mm:ss; 
    -- set text to timer
    _e("TextTimer",3):setText(_CURRENT_TIME or "--:--");

    _e() -- clear 
end);