_T,_S,_CURRENT_TIME = 0,0,"--:--";

ScriptSupportEvent:registerEvent("Game.RunTime",function(e)
    _T = e.ticks;
    if e.second then 
       _S  = e.second 
       _CURRENT_TIME = string.format("%02d", math.floor(_S / 60) ) .. ":" .. string.format("%02d",  math.floor(_S % 60))
    end
end);