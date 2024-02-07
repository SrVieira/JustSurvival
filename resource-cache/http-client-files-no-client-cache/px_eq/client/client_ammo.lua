--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
    local data=getElementData(localPlayer, "user:haveWeapon")
    if(not data)then return end

    local eq=getElementData(localPlayer, "user:eq")
    if(not eq)then return end

    local item=eq[data.itemID]
    if(item)then
        item.ammo=ammo
        setElementData(localPlayer, "user:eq", eq)
    end
end)

setElementData(localPlayer,"user:haveWeapon",false)

if(getElementData(localPlayer, "user:admin") and getElementData(localPlayer, "user:admin") > 2)then
    setElementData(localPlayer, "Area.InZone", true)
end