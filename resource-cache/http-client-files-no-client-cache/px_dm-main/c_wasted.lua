--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

function damage(_, wep, bodypart, ile)
	local player = source
	if getElementData(player, "DM_Guard") then
		setElementHealth(player, getElementHealth(player)+ile)
	end
end

addEventHandler("onClientPedDamage", getRootElement(), damage)
addEventHandler("onClientPlayerDamage", getRootElement(), damage)