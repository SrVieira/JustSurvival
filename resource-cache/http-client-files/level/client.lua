-- Level System
local sW, sH = guiGetScreenSize();

-- Interface Main
local windowRank = guiCreateWindow((sW - 500) / 2, (sH - 400) / 2, 500, 400, "Sistema de Rank", false);
guiWindowSetSizable(windowRank, false);
guiSetVisible(windowRank, false);

-- Interface Elements
local windowRankGridList = guiCreateGridList(10, 28, 360, 360, false, windowRank);
local windowRankColumn = guiGridListAddColumn(windowRankGridList, "Jogador", 0.90);
local windowRankEdit = guiCreateEdit(383, 150, 100, 30, "", false, windowRank);
local windowRankEdit2 = guiCreateEdit(383, 250, 100, 30, "", false, windowRank);
local windowRankButton = guiCreateButton(383, 358, 100, 30, "Cambiar", false, windowRank);
local windowRankLabelLevel = guiCreateLabel(383, 120, 100, 20, "Level: None", false, windowRank);
guiLabelSetHorizontalAlign(windowRankLabelLevel, "center");
local windowRankLabelExp = guiCreateLabel(383, 220, 100, 20, "Experience: None", false, windowRank);
guiLabelSetHorizontalAlign(windowRankLabelExp, "center");

-- Ranks Table
local ranksTable = {
  {"1","Training","1000"},
  {"2","Recruit","2000"},
  {"3","Private","3000"},
  {"4","Private First Class","4000"},
  {"5","Corporal","5000"},
  {"6","Sergeant","5800"},
  {"7","Staff Sergeant |","8100"},
  {"8","Staff Sergeant ||","11000"},
  {"9","Staff Sergeant |||","14600"},
  {"10","Sergeant First Class |","18800"},
  {"11","Sergeant First Class ||","23800"},
  {"12","Sergeant First Class |||","29600"},
  {"13","Master Sergeant |","36300"},
  {"14","Master Sergeant ||","44100"},
  {"15","Master Sergeant |||","53000"},
  {"16","Master Sergeant ||||","63000"},
  {"17","Command Sergeant Major |","74500"},
  {"18","Command Sergeant Major |||","87400"},
  {"19","Command Sergeant Major ||||","102000"},
  {"20","Command Sergeant Major ||||","118400"},
  {"21","Command Sergeant Major |||||","136700"},
  {"22","Second Lieutenant |","157200"},
  {"23","Second Lieutenant ||","180000"},
  {"24","Second Lieutenant |||","205200"},
  {"25","Second Lieutenant ||||","233300"},
  {"26","Second Lieutenant |||||","264400"},
  {"27","First Lieutenant |","298700"},
  {"28","First Lieutenant ||","336500"},
  {"29","First Lieutenant |||","378000"},
  {"30","First Lieutenant ||||","423700"},
  {"31","First Lieutenant |||||","473700"},
  {"32","Captain |","528400"},
  {"33","Captain |||","588100"},
  {"34","Captain ||||","653400"},
  {"35","Captain ||||","724400"},
  {"36","Captain |||||","801600"},
  {"37","Major |","885500"},
  {"38","Major |||","976400"},
  {"39","Major ||||","1074800"},
  {"40","Major ||||","1181100"},
  {"41","Major |||||","1296000"},
  {"42","Lieutenant Colonel |","1419700"},
  {"43","Lieutenant Colonel ||","1552900"},
  {"44","Lieutenant Colonel |||","1696200"},
  {"45","Lieutenant Colonel ||||","1849900"},
  {"46","Lieutenant Colonel |||||","2014800"},
  {"47","Colonel |","2191200"},
  {"48","Colonel ||","2380000"},
  {"49","Colonel |||","2581500"},
  {"50","Colonel |||| ","2796400"},
  {"51","Colonel |||||","3025300"},
  {"52","Brigadier General |","3268800"},
  {"53","Brigadier General ||","3527500"},
  {"54","Brigadier General |||","3801900"},
  {"55","Brigadier General ||||","4092800"},
  {"56","Brigadier General |||||","4400600"},
  {"57","Major General |","4726000"},
  {"58","Major General ||","5069500"},
  {"59","Major General |||","5431800"},
  {"60","Major General ||||'","6000000"},
  {"61","Major General |||||'","6568200"},
  {"62","Lieutenant General |","7136400"},
  {"63","Lieutenant General ||'","7704600"},
  {"64","Lieutenant General |||","8272800"},
  {"65","Lieutenant General ||||","8841000"},
  {"66","Lieutenant General |||||","9409200"},
  {"67","General |","9977400"},
  {"68","General ||","10545600"},
  {"69","General |||","11113800"},
  {"70","General of the Army","11692000"}
};

function getPlayerRankName()
  for i=1, 70 do
    if getElementData(localPlayer, "level") == tonumber(ranksTable[i][1]) then
      return ranksTable[i][2];
    end
  end
end

function getPlayerRankExperience()
  for i=1,70 do
    if getElementData(localPlayer, "level") == tonumber(ranksTable[i][1]) then
	    return tonumber(ranksTable[i][3]);
	  end
  end
end

function mainRanks()
  if getElementData(localPlayer, "Logeado") == true then
    if (getElementData(localPlayer, "experience") or 0) > (getPlayerRankExperience() or 0) then
      if (getElementData(localPlayer, "level") or 0 ) < 70 then
        setElementData(localPlayer, "level", getElementData(localPlayer, "level") + 1)
      end
    end
    dxDrawImage ( sW*0.1193, sH*0.6510, sW*0.0453, sH*0.0859, "images/level/rank"..( getElementData(localPlayer, "level") or 1 )..".jpg" )	
  end
end 
addEventHandler("onClientRender", root, mainRanks);

--     local l

--     if ( getElementData(localPlayer, "level") or 0 ) < 70 then
--       l = "XP Necesario: "..getPlayerRankExperience()
-- 	else
--       l = "Nivel máximo"
--     end	

--     local a = getPlayerRankName().." ("..( getElementData(localPlayer, "level") or 0 )..")"
--     local b = " Actual: ".. (getElementData(localPlayer, "experience") or 0)
--     local width = dxGetTextWidth( a, 1.02, "default-bold" ) + 5
--     if ( dxGetTextWidth( a, 1.02, "default-bold" ) + 5 ) < 118 then
--     	width = 119
--     end


--     	dxDrawRectangle(sW*0.0043, sH*0.6536, sW*0.1112, sH*0.0833, tocolor(0, 0, 0, 149), false)


--         dxDrawText(""..a.."\n".."XP:"..b.."\n"..l, sW*0.0043, sH*0.6510, sW*0.1156, sH*0.7369, tocolor(255, 255, 255, 255), 0.90, "default-bold", "center", "center", false, false, false, false, false)
       	





--   end
-- end
-- addEventHandler ( "onClientRender", root, mainRanks )







-- function toggleWindowRanks()
--   if getElementData(localPlayer, "adminRanks") == true then 
--     if guiGetVisible(windowRank) == false then
--       guiSetVisible(windowRank, true)
-- 	  showCursor(true)
-- 	  for k, v in ipairs (getElementsByType("player")) do
-- 	    if getElementData (v, "Logeado") == true then
--           local row = guiGridListAddRow ( windowRankGridList )
--           guiGridListSetItemText ( windowRankGridList, row, windowRankColumn, getPlayerName ( v ), false, false )
-- 	    end
-- 	  end
--     else
--       guiSetVisible(windowRank, false)
-- 	  showCursor(false)
-- 	  guiGridListClear(windowRankGridList)
--     end
--   end
-- end
-- bindKey("8", "down", toggleWindowRanks)

-- function windowRankClick()
-- local playerName = guiGridListGetItemText ( windowRankGridList, guiGridListGetSelectedItem ( windowRankGridList ), 1 )
--   if source == windowRankGridList then
--     if guiGridListGetSelectedCount(windowRankGridList) == 1 then
--       guiSetText(windowRankLabelLevel, "Level: "..getElementData(getPlayerFromName(playerName), "level"))
-- 	  guiSetText(windowRankLabelExp, "Experience: "..getElementData(getPlayerFromName(playerName), "experience"))
--     else
--       guiSetText(windowRankLabelLevel, "Level: None")
-- 	  guiSetText(windowRankLabelExp, "Experience: None")
--     end
--   end 
--   if source == windowRankButton then
--     if guiGridListGetSelectedCount(windowRankGridList) == 1 then
--     local playerName = guiGridListGetItemText ( windowRankGridList, guiGridListGetSelectedItem ( windowRankGridList ), 1 )
--       if guiGetText(windowRankEdit) ~= "" then
-- 	    setElementData(getPlayerFromName(playerName), "level", tonumber(guiGetText(windowRankEdit)))
--         guiSetText(windowRankLabelLevel, "Level: "..getElementData(getPlayerFromName(playerName), "level"))
--       end
--       if guiGetText(windowRankEdit2) ~= "" then
-- 	    setElementData(getPlayerFromName(playerName), "experience", tonumber(guiGetText(windowRankEdit2)))
--         guiSetText(windowRankLabelExp, "Experience: "..getElementData(getPlayerFromName(playerName), "experience"))
--       end	
--     else
-- 	  outputChatBox("#FF0000[LEVEL SYSTEM]: #FFFFFFSelecciona un jugador!", thePlayer, 171, 205, 239, true)
--     end
--   end
-- end
-- addEventHandler ("onClientGUIClick", windowRank, windowRankClick)