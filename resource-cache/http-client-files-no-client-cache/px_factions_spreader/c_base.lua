--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local doors={
    [5]=2,
    [6]=3,
    [7]=4,
    [8]=5
}

function removeVehicleDoor()
    local item=getElementData(localPlayer, "factionItems:have")
    if(item ~= "Rozpieracz")then return end

    local pos={getElementPosition(localPlayer)}
    local rot={getElementRotation(localPlayer)}
    local x,y = (pos[1] - math.sin(math.rad(rot[3])) * 1), (pos[2] + math.cos(math.rad(rot[3])) * 1)
    local _,_,_,_,veh,_,_,_,_,_,piece=processLineOfSight(pos[1], pos[2], pos[3], x, y, pos[3], true, true, true, true, true, _, _, _, localPlayer)
    if(piece and veh and isElement(veh))then
        local door=doors[piece]
        if(door)then
            triggerServerEvent("remove.door", resourceRoot, door, veh)
            playSound("sound.mp3")
        end
    end
end
bindKey("H","down",removeVehicleDoor)