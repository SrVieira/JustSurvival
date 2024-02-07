function TeamIcon()
	local x,y,z = getElementPosition (getLocalPlayer())
	local gangname = getElementData(getLocalPlayer(),"gang")
	if gangname == "N/A" then return end	

	if getElementData( getLocalPlayer(  ), "Iniciado" ) then
		for i, player in ipairs(getElementsByType("player")) do
			local px, py, pz = getPedBonePosition( player, 8 )
			local sx, sy = getScreenFromWorldPosition(px, py, pz + 1.25, 0)
			local pdistance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
			if pdistance <= 500 then

				if x and y and px and py and sx and sy then

					--if isLineOfSightClear( px, py, pz, x, y, z, true, false, false, false ) then
						if getElementData(player,"gang") ~= "N/A" then
							if gangname == getElementData(player,"gang") then

								if  player ~= getLocalPlayer() then
									dxDrawImage(sx-pdistance/3*0.33 , sy, 25,25, ":DayZ/Imagenes/Teamicon.png" )
								end	

							end
						end

					--end

				end

			end
		end
	end
end
addEventHandler("onClientRender", root, TeamIcon)