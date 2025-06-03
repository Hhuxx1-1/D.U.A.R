LEADERBOARD = {
    data = {} , name = "DUAR_RANK_1" , reqtime = 60, reqCooldown = 120 , currentSecond = 0
};

-- ================= UI =====================
local UI = "7478915094304987378";
local List = {
    {base=12,num=15,name=16,uid=17,valevel=18},
    {base=19,num=22,name=23,uid=24,valevel=25},
    {base=26,num=29,name=30,uid=31,valevel=32},
    {base=33,num=36,name=37,uid=38,valevel=39},
    {base=40,num=43,name=44,uid=45,valevel=46}
} --Slot List from 1,2,3 until then;
local YouSlot = {base=50,num=53,name=54,uid=55,valevel=56};
local PaginationBtn = {prev=48,next=49}
local MainDisplay,EmptyDisplay = 3,60;

local btnAction = {["7478915094304987378_57"] = function(playerid)
    Player:hideUIView(playerid,UI);
end};

local function setActionBtn(playerid,btn,func)
    if btnAction[playerid] == nil then 
        btnAction[playerid] = {};
    end 
    if type(func) == "function" then 
        btnAction[playerid][UI.."_"..btn] = func ;
    end 
end

--============ Leaderboard ===========
function LEADERBOARD:Add(i, v)
    -- make sure the index is number;
    if i ~= nil then
        self.data[tonumber(i)] = v
    end 
end

function LEADERBOARD:clear()
    -- clear data so it start fresh;
    self.data = {}
end 

function LEADERBOARD:resetRank()
    CloudSever:ClearOrderData(self.name);
end

function LEADERBOARD:loadServerData (n,t)
    local callback = function (ret, list)
        print(ret,"List : ",list)
        -- convert ret into boolean if it was number;
        if type(ret) == "number" then if ret == 0 then ret = true else ret = false end end;

        if ret and list then
            self:clear();
            for ix, v in ipairs(list) do
                self:Add(ix, v)
            end
        end
    end
    local ret = CloudSever:getOrderDataIndexArea(self.name, -1 * n, callback);
    if ret ~= ErrorCode.OK then
        self.reqtime = t + self.reqCooldown*10;
        print("Failed to Get "..self.name);
    else 
        self.reqtime = t + self.reqCooldown;
        print("Succeed to Get "..self.name);
    end
end


function LEADERBOARD:displayForUI(playerid,page)
    local itemPerPage = 5;
    local startIndex = (page-1)*itemPerPage + 1; local endIndex = page * itemPerPage ;
    local c = 1;

    if isEmptyTable(self.data) then 
        -- handle for empty data to display;
        Customui:showElement(playerid,UI,UI.."_"..EmptyDisplay);
        Customui:hideElement(playerid,UI,UI.."_"..MainDisplay);
    else

        Customui:showElement(playerid,UI,UI.."_"..MainDisplay);
        Customui:hideElement(playerid,UI,UI.."_"..EmptyDisplay);

        for i=startIndex , endIndex do 
            local a = self.data[i];
            if a then 
                -- the index is exist;
                local playerName, playeruid, value = a.nick or "???", a.k or ".??" , a.v or "??.";
                -- display it according into the list;
                -- Display the Base;
                Customui:showElement(playerid,UI,UI.."_"..List[c].base);
                -- Set the Text;
                Customui:setText(playerid,UI,UI.."_"..List[c].num,i);
                Customui:setText(playerid,UI,UI.."_"..List[c].name,playerName);
                Customui:setText(playerid,UI,UI.."_"..List[c].uid,"UID:"..playeruid);
                Customui:setText(playerid,UI,UI.."_"..List[c].valevel,a.v.." Kills");
            else 
                -- the index is not exist;
                -- clean the slot or hide it.
                Customui:hideElement(playerid,UI,UI.."_"..List[c].base);
            end 

            c=c+1;
        end 

        -- check if startIndex is > 1 which means it is not in page 1;
        if startIndex > 1 then
            -- enable prev Button and set the PRev button action to displayForUI playerid page-1;
            Customui:showElement(playerid,UI,UI.."_"..PaginationBtn.prev);
            setActionBtn(playerid,PaginationBtn.prev,function(playerid)
                self:displayForUI(playerid,page-1);
            end)
        else
            Customui:hideElement(playerid,UI,UI.."_"..PaginationBtn.prev);
            setActionBtn(playerid,PaginationBtn.prev,function(playerid)
                Player:notifyGameInfo2Self(playerid,"Page Limit Reached");
            end)
        end 
        -- check if endIndex+1 is not empty which means it has next page available;
        if endIndex+1 <= #self.data then
            Customui:showElement(playerid,UI,UI.."_"..PaginationBtn.next);
            setActionBtn(playerid,PaginationBtn.next,function(playerid)
                self:displayForUI(playerid,page+1);
            end)
        else
            Customui:hideElement(playerid,UI,UI.."_"..PaginationBtn.next);
            setActionBtn(playerid,PaginationBtn.next,function(playerid)
                Player:notifyGameInfo2Self(playerid,"Page Limit Reached");
            end)
        end 

        -- find playeruid same as playerid in self.data;
        local function loadForSelf(playerid_)
            -- Try Load from Top;
            for i,a in ipairs(self.data) do 
                if a then 
                    if tonumber(a.k) == playerid_ then
                        a.n = i; --store the index into n; 
                        return true,a;
                    end 
                end 
            end
            --  try load directly from current kill;
            local INFO = PLAYERDATA(TABLE_TYPE.string,"INFO",playerid_);
            local current_Kill = INFO:readIndex(4); --number
            if current_Kill then
                return true,{k = playerid_ , n = #self.data+1 , v = current_Kill};
            end 

            return false,nil;
        end 

        local tryLoad,LoadedData = loadForSelf(playerid)
        if tryLoad then
            -- load the Data into YouSlot
            Customui:setText(playerid,UI,UI.."_"..YouSlot.num,"You\n"..LoadedData.n or " ??? ");
            Customui:setText(playerid,UI,UI.."_"..YouSlot.name,LoadedData.nick or " Loading ");
            Customui:setText(playerid,UI,UI.."_"..YouSlot.uid,"UID:"..LoadedData.k);
            Customui:setText(playerid,UI,UI.."_"..YouSlot.valevel,LoadedData.v .. "Kill" or " ??? Kill ");
        else 
            Customui:setText(playerid,UI,UI.."_"..YouSlot.num,LoadedData.n);
            Customui:setText(playerid,UI,UI.."_"..YouSlot.name,"Loading...");
            Customui:setText(playerid,UI,UI.."_"..YouSlot.uid,"");
            Customui:setText(playerid,UI,UI.."_"..YouSlot.valevel,"-");
        end 
    end 

    -- === Show Room info ; 
    local roominfo = " Room Info :";
    if  World.getServerDateString then 
        local code,date = World:getServerDateString();
        if code == 0 then roominfo = roominfo .. "\n Date : "..date; end 
    end 
    if CloudSever.GetRoomID ~= nil then 
        local ret ,roomid = CloudSever:GetRoomID();
        if ret == 0 then roominfo = roominfo .."\n RoomID : "..roomid; end 
    end 
    if CloudSever.GetRoomCategory ~= nil then 
        local code ,msg = CloudSever:GetRoomCategory()
        if code == 0 then roominfo = roominfo .."\n Category : "..msg; end 
    end 
    if Player.getHostUin then 
        local code, host = Player:getHostUin()
        if code == 0 then roominfo = roominfo .."\n Host : "..host; end 
    end 
    if Player.getMainPlayerUin then 
        local code, mainPlayer = Player:getMainPlayerUin()
        if code == 0 then roominfo = roominfo .."\n MainPlayer : "..mainPlayer end 
    end 
    if  LEADERBOARD.currentSecond then 
        roominfo = roominfo .."\n Elapsed Second "..LEADERBOARD.currentSecond.."s";
        roominfo = roominfo .."\n Next Update in "..(LEADERBOARD.reqtime - LEADERBOARD.currentSecond) .."s";
    end 

    Customui:setText(playerid,UI,UI.."_63",roominfo);
end

function LEADERBOARD:recordForAllPlayer()
    -- get All player ready in the Room;
    for _,player in pairs(PLAYER_READY.PLAYERS) do 
        local INFO = PLAYERDATA(TABLE_TYPE.string,"INFO",player.id);
        local v = tonumber(INFO:readIndex(4));
        if v > 0 then 
        -- insert into Leaderboard;
            local ret = CloudSever:setOrderDataBykey(self.name,player.id,v);
            print(ret == 0 and "Player "..player.name.." Data Recorded Successfully" or "Error recording Player "..player.name.." Data");
        else 
            Chat:sendSystemMsg("Get Some Kills to get Into Leaderboard",player.id);
        end 
    end 
end

ScriptSupportEvent:registerEvent("Game.RunTime",function(e)
    if e.second then 
        if e.second == LEADERBOARD.reqtime - 2 then
            Chat:sendSystemMsg("#Y[System]#W Updating Leaderboard...");
            local r,err = pcall(LEADERBOARD.recordForAllPlayer,LEADERBOARD);
            -- LEADERBOARD:recordForAllPlayer()
            if not r then print(err) end;
        end 
        if e.second == LEADERBOARD.reqtime then
            Chat:sendSystemMsg("#Y[System]#W Leaderboard Updated");
            local r,err = pcall(LEADERBOARD.loadServerData,LEADERBOARD,50,e.second)
            -- LEADERBOARD:loadServerData(50, e.second);
            if not r then print(err) end;
        end 
        LEADERBOARD.currentSecond = e.second;
    end 
end)

-- UI Events
ScriptSupportEvent:registerEvent("UI.Show", function(e)
    local playerid = e.eventobjid
    local ui = e.CustomUI
    if ui == UI then
        local r, err = pcall(function() LEADERBOARD:displayForUI(playerid,1) end)
        if not r then print(err) end 
    end
end)

-- ScriptSupportEvent:registerEvent("UI.Hide", function(e)
--     local playerid = e.eventobjid
--     local ui = e.CustomUI
--     if ui == UI then
--         pcall(function() TIME_GIFT:CLOSE_UI(playerid) end)
--     end
-- end)


ScriptSupportEvent:registerEvent("UI.Button.Click",function(e)
    local playerid = e.eventobjid;
    local element =  e.uielement;

    if btnAction[playerid] then 
        -- btn Action for playerid is already defined 
        if btnAction[playerid][element] ~= nil then
            -- btn action is not nil 
            -- check if it is function 
            if type(btnAction[playerid][element]) == "function" then 
                -- It is executeable Function 
                local r , err = pcall(btnAction[playerid][element],playerid);
                if not r then 
                    print(err);
                end 
            else 
                -- not a function 
                Player:notifyGameInfo2Self(playerid,"Action Invalid");
            end 
        end
    else
        -- look for btnAction[element] instead
        if btnAction[element] ~= nil then
            -- btnAction[element] is not nil
            if type(btnAction[element]) == "function" then
                -- It is executeable Function
                local r , err = pcall(btnAction[element],playerid);
                if not r then
                    print(err);
                end 
            else 
                -- not a function 
                Player:notifyGameInfo2Self(playerid,"Action Invalid");
            end 
        else
            Player:notifyGameInfo2Self(playerid,"Action Invalid: unset");
        end 
    end 
end)