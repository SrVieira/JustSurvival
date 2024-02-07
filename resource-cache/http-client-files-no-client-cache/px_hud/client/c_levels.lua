--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local lvlUp=50
local lvlUpBlock=false

function getLevelNeedExp(level) 
	level=level or 1

	return (level*lvlUp)+lvlUp
end

function getPlayerNextLevel(exp)
    if(not exp)then 
        outputConsole("[System poziomów] Wystąpił błąd, zgłoś to do CEO na forum. (1)") 
        return false 
    end

    local level=getElementData(localPlayer, "user:level")
    if(level)then
        local needExp=getLevelNeedExp(level)
        if(needExp)then
            if(exp >= needExp and not lvlUpBlock)then
                setElementData(localPlayer, "user:level", level+1)
                setElementData(localPlayer, "user:exp", exp-needExp)

                lvlUpBlock=setTimer(function()
                    lvlUpBlock=nil
                end, 500, 1)
            end
            return true
        end
    end

    outputConsole("[System poziomów] Wystąpił błąd, zgłoś to do CEO na forum. (2)")

    return false
end

addEventHandler("onClientElementDataChange", localPlayer, function(data,old,new)
    if(data == "user:exp" and new and new > 0)then
        getPlayerNextLevel(new)
    end
end)