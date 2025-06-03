LEADERBOARD = {
    data = {} , name = "DUAR_RANK_1" , reqtime = 5, reqCooldown = 120
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
function LEADERBOARD:insert(i, v)
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
        -- convert ret into boolean if it was number;
        if type(ret) == "number" then if ret == 0 then ret = true else ret = false end end;

        if ret and list then
            self:clear();
            for ix, v in pairs(list) do
                self.insert(ix, v)
            end
        end
    end
    local ret = CloudSever:getOrderDataIndexArea(self.name, -1 * n, callback);
    if ret ~= ErrorCode.OK then
        self.reqtime = t + self.reqCooldown*10;
    else 
        self.reqtime = t + self.reqCooldown;
    end
end


function LEADERBOARD:displayForUI(playerid,page)
    local itemPerPage = 5;
    local startIndex = (page-1)*itemPerPage + 1; local endIndex = page * itemPerPage ;
    local c = 1;

    if #self.data <= 0 then 
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
                Customui:setText(playerid,UI,UI.."_"..List[c].valevel,"Level "..a.v);
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
                    if a.k == playerid_ then
                        a.n = i; --store the index into n; 
                        return true,a;
                    end 
                end 
            end 
            local result_fromcallback = {}
            -- if not exist then try Obtain by Key
            local callback = function (ret,k,v,ix)
                -- ret could return 2 type which is either number or boolean;
                -- convert into boolean if number;
                if type(ret) == "number" then if ret == ErrorCode.OK then ret = true else ret = false end end

                if ret then 
                    if ix then
                        local ranking = ix;
                        -- print('返回数据成功 键= '..k..' 值='..v..' 排名='..ix )
                        -- at this scenario the Ranking for player is Exist;
                        result_fromcallback = {k = k, v = v, n = ix};
                    else
                        -- print('返回数据成功 键= '..k..' 值='..v)
                        -- at this scenario the Ranking for Player is Not Exist;
                        result_fromcallback = {k = k, v = v};
                    end
                else
                    --Failed to obtain by Key;
                    result_fromcallback = {k = playerid_, v = "Not Recorded Yet"};
                end

                -- get the Player Nickname;
                local r,name =Player:getNickname(playerid_)
                if r == 0 and name then 
                    result_fromcallback.nick = name;
                end 
            end

            local ret = CloudSever:getOrderDataByKeyEx(LEADERBOARD.name,playerid_,callback)

            if ret == ErrorCode.OK then
                return true,result_fromcallback;
            else
                return false;
            end
        end 

        local tryLoad,LoadedData = loadForSelf(playerid)
        if tryLoad then
            -- load the Data into YouSlot
            Customui:setText(playerid,UI,UI.."_"..YouSlot.num,"You\n"..LoadedData.n or " ??? ");
            Customui:setText(playerid,UI,UI.."_"..YouSlot.name,LoadedData.nick or " Loading ");
            Customui:setText(playerid,UI,UI.."_"..YouSlot.uid,"UID:"..LoadedData.k);
            Customui:setText(playerid,UI,UI.."_"..YouSlot.valevel,""..LoadedData.v.."Kill" or " ???. ");
        else 
            Customui:setText(playerid,UI,UI.."_"..YouSlot.num,LoadedData.n);
            Customui:setText(playerid,UI,UI.."_"..YouSlot.name,"Loading...");
            Customui:setText(playerid,UI,UI.."_"..YouSlot.uid,"");
            Customui:setText(playerid,UI,UI.."_"..YouSlot.valevel,"-");
        end 
    end 
end

function LEADERBOARD:recordForAllPlayer()
    -- get All player ready in the Room;
    for _,player in ipairs(PLAYER_READY.PLAYERS) do 
        local v = BATTLE_DATA.players[player].kills
        -- insert into Leaderboard;
        local ret = CloudSever:setOrderDataBykey(self.name,player.id,v);
    end 
end

ScriptSupportEvent:registerEvent("Game.RunTime",function(e)
    if e.second then 
        if e.second == LEADERBOARD.reqtime - 2 then
            -- Chat:sendSystemMsg("Updating Leaderboard...");
            local r,err = pcall(LEADERBOARD.recordForAllPlayer,LEADERBOARD);
            -- LEADERBOARD:recordForAllPlayer()
            if not r then print(err) end;
        end 
        if e.second == LEADERBOARD.reqtime then
            -- Chat:sendSystemMsg("Leaderboard Updated...");
            local r,err = pcall(LEADERBOARD.loadServerData,LEADERBOARD,50,e.second)
            -- LEADERBOARD:loadServerData(50, e.second);
            if not r then print(err) end;
        end 
    end 
end)

-- UI Events
ScriptSupportEvent:registerEvent("UI.Show", function(e)
    local playerid = e.eventobjid
    local ui = e.CustomUI
    if ui == UI then
        pcall(function() LEADERBOARD:displayForUI(playerid,1) end)
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
                f_H:SendMessage(playerid,"Action Invalid");
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
                f_H:SendMessage(playerid,"Action Invalid");
            end 
        else
            f_H:SendMessage(playerid,"Action Invalid: unset");
        end 
    end 
end)