--[[
	##
	##
	##	``DayZ Login Panel´´
	##
	##	Author: Enargy
	##	File: server.lua
	##	Type: server
	##
	##
]]

addEvent("onLoginPlayer", true)
addEventHandler("onLoginPlayer", root,
	function(user, pass)
		local isExists = getAccount(user, pass)
		if not isExists then
			triggerClientEvent(source, "onClientLoginNotifyFromServer", source, "El nombre de cuenta y/o contraseña son incorrectos", "error")
			return
		end	

		logIn(source, isExists, pass)
		triggerClientEvent(source, "onLoginGUIClose", source, user, pass)
	end
)

addEvent("onRegisterPlayer", true)
addEventHandler("onRegisterPlayer", root,
	function(user, pass)
		if getAccount(user) then
			triggerClientEvent(source, "onClientLoginNotifyFromServer", source, "Esta cuenta ya se encuentra creada", "error")
			return
		end
		
		local check = addAccount(user, pass)
		if check ~= false then
			triggerClientEvent(source, "onRegisterGUIClose", source, user)
		else
			triggerClientEvent(source, "onClientLoginNotifyFromServer", source, "Hubo un error al crear esta cuenta", "error")
		end
	end
)