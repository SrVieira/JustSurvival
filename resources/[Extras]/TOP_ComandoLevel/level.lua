function reset_lvl(source,_,...)
	if ( hasObjectPermissionTo ( source, "general.adminpanel" ) ) then
		local cadena = table.concat({...},',')
		local nombre,nivel = cadena:sub(1,cadena:find(',')-1),cadena:sub(cadena:find(',')+1,cadena:len())
		local jugador = getPlayerFromPartialName(tostring(nombre))
		setElementData(jugador, 'lvl', tonumber(nivel))
	end
end
addCommandHandler("reset", reset_lvl)

function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end