function reloadWeapon()
	if reloadPedWeapon(client) then
		triggerClientEvent("onReloadSound", client)
	end
end
addEvent("relWep", true)
addEventHandler("relWep", resourceRoot, reloadWeapon)