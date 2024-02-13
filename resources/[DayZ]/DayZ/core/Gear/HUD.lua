local screenW, screenH = guiGetScreenSize();
local resX, resY = 1024, 768;
local relX, relY = (screenW/resX), (screenH/resY);
local displayedHud = true;
local isMonitorVisible = true;
local isMapShown = false;
local mapkeybound = false;
local target = false;
local tickCountDamage = false;
local totalTickCount = false;
local bloodScreenRender = false;

local fonts = {
	[1] = dxCreateFont("fonts/BRNebula-Medium.ttf", 16),
	[2] = dxCreateFont("fonts/BRNebula-Bold.ttf", 16),
	[3] = dxCreateFont("fonts/BRNebula-Bold.ttf", 22),
	[4] = dxCreateFont("fonts/BRNebula-Medium.ttf", 13),
};

function posicao()
	local x, y, z = getElementPosition(localPlayer);
	outputChatBox(x);
	-- outputChatBox(x..", "..y..", "...z);
end
addCommandHandler("posicao", posicao)

function showDebugMonitor()
	if getElementData(localPlayer, "Logged") then
		isMonitorVisible = not isMonitorVisible;
	end
end
bindKey("F5", "down", showDebugMonitor);

function playerGetDamage(attacker, weapon)
	tickCountDamage = getTickCount();
	totalTickCount = getTickCount() + 3000;
	if not bloodScreenRender then
		addEventHandler("onClientRender", root, drawBloodScreen);
		bloodScreenRender = true;
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, playerGetDamage)

function drawBloodScreen()
	if tickCountDamage and totalTickCount then
		if getElementData(localPlayer, "dead") then
			if bloodScreenRender then
				removeEventHandler("onClientRender", root, drawBloodScreen);
				bloodScreenRender = false;
			end
		end
		local count = getTickCount();
		local elapsed = count - tickCountDamage;
		local duration = totalTickCount - tickCountDamage;
		local progress = elapsed / duration;
		local alpha = interpolateBetween(255, 0, 0, 0, 0, 0, progress, "Linear");
		dxDrawImage(0, 0, screenW, screenH, "images/misc/bloodscreen.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false);
		if (alpha <= 0) then
			if bloodScreenRender then
				removeEventHandler("onClientRender", root, drawBloodScreen);
				bloodScreenRender = false;
			end
		end
	end
end

function displayDayZHud()
	toggleControl("radar", false);
	if getElementData(localPlayer, "Logged") and not getElementData(localPlayer, "dead") then
		drawPlayerStatus();
		drawWeaponInfo();
		drawPlayerTag();
		-- if getElementData(localPlayer, "Bússola") and getElementData(localPlayer, "Bússola") > 0 then
			drawTheCompass();
		-- end	
		if getElementData(localPlayer, "GPS") and getElementData(localPlayer, "GPS") > 0 then
			drawTheGPS();
		else
			if isPlayerHudComponentVisible('radar') then
				showPlayerHudComponent('radar', false);
			end
		end
		if getElementData(localPlayer, "Mapa") and getElementData(localPlayer, "Mapa") > 0 then
			if not mapkeybound then
				bindKey("F11"," down", toggleMap);
				mapkeybound = true;
			end		
		else
			if mapkeybound then
				unbindKey("F11", "down", toggleMap);
				mapkeybound = false;
				if isMapShown then
					closeMap();
				end
			end		
		end
		if isMonitorVisible and not isMapShown then
			drawMonitorStatus();
		end
		if getElementData(localPlayer, "Relógio") and getElementData(localPlayer, "Relógio") > 0 then
			local h, m = getTheTime();
			dxDrawText(h..":"..m, screenW * 0.99 + 1, screenH * 0.05 + 1, screenW * 0.99 + 1, screenH * 0.05 + 1, tocolor(0, 0, 0, 240), 1.00, fonts[2], "right", "center");
			dxDrawText(h..":"..m, screenW * 0.99 + 1, screenH * 0.05, screenW * 0.99 + 1, screenH * 0.05, tocolor(255, 255, 255, 255), 1.00, fonts[2], "right", "center");
		end
		--# Iconos del vehiculo
		local vehicle = getPedOccupiedVehicle(localPlayer);
		if isElement(vehicle) and getVehicleController(vehicle) == localPlayer and isElement(getElementData(vehicle, "parent")) and getVehicleType(vehicle) ~= "BMX" then
			drawVehicleHud();
		end
	end
end
addEventHandler("onClientRender", root, displayDayZHud);

function drawPlayerStatus()
	local blood = math.floor(getElementData(localPlayer, "blood") or 0.0)
	local hungry = math.floor(getElementData(localPlayer, "food") or 0.0)
	local thirsty = math.floor(getElementData(localPlayer, "thirst") or 0.0)
	local temp = math.floor(getElementData(localPlayer, "temperature") or 0.0)
	local infected = getElementData(localPlayer, "infection") or 0
	local brokenbone = getElementData(localPlayer, "brokenbone") or 0
	local pain = getElementData(localPlayer, "pain") or 0
	local bleeding = getElementData(localPlayer, "bleeding") or 0
	local volume = getElementData(localPlayer, "volume") or 0
	local vision = getElementData(localPlayer, "visibility") or 0
	local armor = getElementData(localPlayer, "kevlar")
	local helmet = getElementData(localPlayer, "helmet")
	
	--# COMIDA
	local icon = "0.png"
	local color = tocolor(50, 134, 50, 240)
	--local color = getColorStatus(hungry)

	if hungry < 5 then
		color = tocolor(200, 0, 0, 240)
		icon = "0.png"
	elseif hungry < 10 then
		color = tocolor(200, 0, 0, 240)
		icon = "10.png"
	elseif hungry < 20 then
		color = tocolor(134, 134, 50, 240)
		icon = "20.png"
	elseif hungry < 50 then
		color = tocolor(50, 134, 50, 240)
		icon = "50.png"
	elseif hungry < 80 then
		color = tocolor(50, 134, 50, 240)
		icon = "80.png"
	elseif hungry >= 80 then
		color = tocolor(80, 128, 52, 255)
		icon = "100.png"		
	end
	
	--color = tocolor(50, 134, 50, 255)
	
	dxDrawImage(screenW*0.95, screenH*0.875, screenH*0.055, screenH*0.055, "images/status/food1.png", 0, 0, 0, tocolor(80, 128, 52, 255), false)
	dxDrawImage(screenW*0.95, screenH*0.875, screenH*0.055, screenH*0.055, "images/status/food/food_"..icon, 0, 0, 0, color, false)

	--# SANGRE
	if (blood < 2000) then
		enableBlackWhite(true)
	else
		enableBlackWhite(false)
	end
	
	local icon = "0.png"
	local color = tocolor(50, 134, 50, 240)

	if blood < 500 then
		color = tocolor(200, 0, 0, 240)
		icon = "0.png"
	elseif blood < 1000 then
		color = tocolor(200, 0, 0, 240)
		icon = "500.png"
	elseif blood < 2000 then
		color = tocolor(200, 0, 0, 240)
		icon = "1000.png"
	elseif blood < 4000 then
		color = tocolor(134, 134, 50, 240)
		icon = "2000.png"
	elseif blood < 6000 then
		color = tocolor(134, 134, 50, 240)
		icon = "4000.png"
	elseif blood < 8000 then
		color = tocolor(50, 134, 50, 240)
		icon = "6000.png"
	elseif blood < 10000 then
		color = tocolor(50, 134, 50, 240)
		icon = "8000.png"
	elseif blood < 12000 then
		color = tocolor(50, 134, 50, 240)
		icon = "10000.png"		
	elseif blood >= 12000 then
		color = tocolor(80, 128, 52, 240)
		icon = "12000.png"		
	end
	
	--color = tocolor(50, 134, 50, 255)

	dxDrawImage(screenW*0.95, screenH*0.82, screenH*0.055, screenH*0.055, "images/status/blood1.png", 0, 0, 0, tocolor(80, 128, 52, 255), false)
	dxDrawImage(screenW*0.95, screenH*0.82, screenH*0.055, screenH*0.055, "images/status/blood/blood_"..icon, 0, 0, 0, color, false)

	--~# AGUA / SED
	local icon = "0.png"
	local color = tocolor(50, 134, 50, 240)

	if thirsty < 10 then
		color = tocolor(200, 0, 0, 240)
		icon = "0.png"
	elseif thirsty < 20 then
		color = tocolor(200, 0, 0, 240)
		icon = "10.png"
	elseif thirsty < 40 then
		color = tocolor(134, 134, 50, 240)
		icon = "20.png"
	elseif thirsty < 60 then
		color = tocolor(134, 134, 50, 240)
		icon = "40.png"
	elseif thirsty < 80 then
		color = tocolor(50, 134, 50, 240)
		icon = "60.png"
	elseif thirsty < 100 then
		color = tocolor(50, 134, 50, 240)
		icon = "80.png"
	elseif thirsty >= 100 then
		color = tocolor(80, 128, 52, 240)
		icon = "100.png"		
	end
	
	--color = tocolor(50, 134, 50, 240)
	
	dxDrawImage(screenW*0.95, screenH*0.765, screenH*0.055, screenH*0.055, "images/status/water1.png", 0, 0, 0, tocolor(80, 128, 52, 255), false)
	dxDrawImage(screenW*0.95, screenH*0.765, screenH*0.055, screenH*0.055, "images/status/water/water_"..icon, 0, 0, 0, color, false)
	
	--~# TEMPERATURA
	local temperature = math.round(getElementData(localPlayer, "temperature"),2)
	local color = tocolor(50, 134, 50, 240)
	local t_number = 3
	if temperature < 33 then
		color = tocolor(200, 0, 0, 240)
		t_number = 0
	elseif temperature < 35 then
		color = tocolor(134, 134, 50, 240)
		t_number = 1
	elseif temperature < 39 then
		color = tocolor(50, 134, 50, 240)
		t_number = 2
	elseif temperature < 41 then	
		color = tocolor(50, 134, 50, 240)
		t_number = 3
	elseif temperature >= 41 then
		color = tocolor(50, 134, 50, 240)
		t_number = 4
	end
	
	color = tocolor(50, 134, 50, 240)
	
	dxDrawImage(screenW*0.95, screenH*0.71, screenH*0.055, screenH*0.055, "images/status/temp1.png", 0, 0, 0, tocolor(50, 100, 134, 240), false)
	dxDrawImage(screenW*0.95, screenH*0.71, screenH*0.055, screenH*0.055, "images/status/temp/"..t_number..".png", 0, 0, 0, color, false)
	
	-- # CASCO / CHALECO
	if helmet then
		dxDrawImage((screenW*0.95)-screenH*0.055, screenH*0.765, screenH*0.055, screenH*0.055, "images/status/helmet.png", 0, 0, 0, tocolor(50, 100, 134, 240), false)
	end
	if armor then
		dxDrawImage((screenW*0.95)-screenH*0.055, screenH*0.82, screenH*0.055, screenH*0.055, "images/status/armor.png", 0, 0, 0, tocolor(50, 100, 134, 240), false)
	end	

	--# ICONOS DE SANIDAD.
	if brokenbone > 0 then
		dxDrawImage(screenW*0.95, screenH*0.6, screenH*0.055, screenH*0.055, "images/status/brokenbone.png", 0, 0, 0, tocolor(150, 100, 50, 240), false)
	end	
	
	if bleeding > 0 then
		dxDrawImage(screenW*0.95, screenH*0.82, screenH*0.055, screenH*0.055, "images/status/bleeding.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
	
	if infected > 0 then
		dxDrawImage(screenW*0.95, screenH*0.545, screenH*0.055, screenH*0.055, "images/status/infection.png", 0, 0, 0, tocolor(150, 100, 50, 240), false)
	end	

	--# HUMANIDAD.
	local humanity = getElementData(localPlayer, "humanity") or 0
	local color = tocolor(150, 100, 50, 240)
	local h_number = 0
	
	if humanity >= 5000 and humanity >= 3501 then
		h_number = 5
	elseif humanity <= 3500 and humanity >= 2501 then
		h_number = 4
	elseif humanity <= 2500 and humanity >= 1 then
		h_number = 3
	elseif humanity <= 0 and humanity >= -1001 then
		h_number = 2
	elseif humanity <= -1000 and humanity >= -2501 then
		h_number = 1
	elseif humanity >= -2500 or humanity < -2500 then
		h_number = 0
	end

	dxDrawImage(screenW*0.95, screenH*0.655, screenH*0.055, screenH*0.055, "images/status/humanity/"..h_number..".png", 0, 0, 0, color, false)

	--# RUIDO
	local color = tocolor(50, 134, 50, 240)
	local icon = "0.png"
	local alph = 255
	if volume == 0 then
		alph = 50
		icon = "0.png"
	elseif volume < 20 then
		alph = 50
		icon = "1.png"
	elseif volume < 40 then
		alph = 100
		icon = "2.png"
	elseif volume < 60 then
		alph = 150
		icon = "3.png"
	elseif volume < 80 then
		alph = 200
		icon = "4.png"
	elseif volume <= 100 then
		alph = 255
		icon = "5.png"		
	end
		
	color = tocolor(50, 100, 134, alph)
	
	dxDrawImage(screenW*0.95, screenH*0.49, screenH*0.055, screenH*0.055, "images/status/volume.png", 0, 0, 0, color, false)
	dxDrawImage((screenW*0.95)-screenH*0.055, screenH*0.49, screenH*0.055, screenH*0.055, "images/status/volume/volume_"..icon, 0, 0, 0, color, false)

	--# VISIBILIDAD
	local color = tocolor(50, 100, 134, 240)
	local icon = "0.png"
	local alph = 255
	if vision == 0 then
		alph = 50
		icon = "0.png"
	elseif vision < 20 then
		alph = 50
		icon = "1.png"
	elseif vision < 40 then
		alph = 100
		icon = "2.png"
	elseif vision < 60 then
		alph = 150
		icon = "3.png"
	elseif vision < 80 then
		alph = 200
		icon = "4.png"
	elseif vision <= 100 then
		alph = 255
		icon = "5.png"
	end
	
	color = tocolor(50, 100, 134, alph)

	dxDrawImage(screenW*0.95, screenH*0.435, screenH*0.055, screenH*0.055, "images/status/eye.png", 0, 0, 0, color, false)
	dxDrawImage((screenW*0.95)-screenH*0.055, screenH*0.435, screenH*0.055, screenH*0.055, "images/status/volume/volume_"..icon, 0, 0, 0, color, false)

	drawServerInfo()
end

local FPSLimit = 255
local FPSMax = 1
local FPSCalc = 0
local FPSTime = getTickCount() + 1000
local serverInfo = "Ping: %.2d | FPS: %.2d"
local formatText = ""
local formatLootRefresh = ""
local refreshTimer

function drawServerInfo()
	if ( getTickCount() < FPSTime ) then
		FPSCalc = FPSCalc + 1
	else
		if ( FPSCalc > FPSMax ) then 
			FPSLimit = 255 / FPSCalc 
			FPSMax = FPSCalc 
		end

		formatText = string.format(serverInfo, getPlayerPing(localPlayer), FPSCalc)
		
		FPSCalc = 0
		FPSTime = getTickCount() + 1000
	end

	dxDrawText(formatText, 17, 1, screenW-17, 16, tocolor(0, 0, 0, 255), 1, "default", "left", "center", true)
	dxDrawText(formatText, 16, 0, screenW-16, 15, tocolor(255, 255, 255, 255), 1, "default", "left", "center", true)
end

function drawWeaponInfo()
	local ammo = getPedTotalAmmo(localPlayer) - getPedAmmoInClip(localPlayer);
	local clip = getPedAmmoInClip(localPlayer);
	local weaponID = getPedWeapon(localPlayer);

	if weaponID == 22 then
		weapName = getElementData(localPlayer, "SECONDARY_Weapon");
	elseif weaponID == 23 then
	   weapName = getElementData(localPlayer, "SECONDARY_Weapon");
	elseif weaponID == 24 then
		weapName = getElementData(localPlayer, "SECONDARY_Weapon");
	elseif weaponID == 25 then
		weapName = getElementData(localPlayer, "PRIMARY_Weapon");
	elseif weaponID == 26 then
	   weapName = getElementData(localPlayer, "PRIMARY_Weapon");
	elseif weaponID == 27 then
		weapName = getElementData(localPlayer, "PRIMARY_Weapon")
	elseif weaponID == 28 then
		weapName = getElementData(localPlayer, "SECONDARY_Weapon");
	elseif weaponID == 29 then
		weapName = getElementData(localPlayer, "SECONDARY_Weapon");
	elseif weaponID == 30 then
	   weapName = getElementData(localPlayer, "PRIMARY_Weapon");
	elseif weaponID == 31 then
		weapName = getElementData(localPlayer, "PRIMARY_Weapon");
	elseif weaponID == 33 then
		weapName = getElementData(localPlayer, "PRIMARY_Weapon");
	elseif weaponID == 34 then
		weapName = getElementData(localPlayer, "PRIMARY_Weapon");
	elseif weaponID == 16 then
		weapName = getElementData(localPlayer, "SPECIAL_Weapon");
		clip = clip+ammo;
		ammo = false;
	elseif weaponID == 43 then
		weapName = getElementData(localPlayer, "SPECIAL_Weapon");
		clip = false;
		ammo = false;
	elseif weaponID == 46 then
		weapName = getElementData(localPlayer, "SPECIAL_Weapon");
		clip = false;
		ammo = false;
	elseif weaponID == 4 then
		weapName = getElementData(localPlayer, "SECONDARY_Weapon");
		clip = false;
		ammo = false;
	elseif weaponID == 5 then
		weapName = getElementData(localPlayer, "SECONDARY_Weapon");
		clip = false;
		ammo = false;
	elseif weaponID == 6 then
		weapName = getElementData(localPlayer, "SECONDARY_Weapon");
		clip = false;
		ammo = false;
	elseif weaponID == 8 then
		weapName = getElementData(localPlayer, "SECONDARY_Weapon");
		clip = false;
		ammo = false;
	else
		weapName = false;
		clip = false;
		ammo = false;
	end

	if weapName then
		dxDrawText(weapName, screenW * 0.99 + 1, 1+screenH*0.1, screenW * 0.99 + 1, 1+screenH*0.1, tocolor(0, 0, 0, 240), 1.00, fonts[1], "right", "center", false, false, false, false, false);
		dxDrawText(weapName, screenW * 0.99 + 1, screenH*0.1, screenW * 0.99 + 1, screenH*0.1, tocolor(255, 255, 255), 1.00, fonts[1], "right", "center", false, false, false, false, false);
	end

	if clip and weapName then
		if ammo >= 100 then
			dxDrawText(clip, 1+screenW*0.965, 1+screenH*0.14, 1+screenW*0.965, 1+screenH*0.14, tocolor(0, 0, 0, 240), 1.00, fonts[3], "right", "center", false, false, false, false, false);
			dxDrawText(clip, screenW*0.965, screenH*0.14, screenW*0.965, screenH*0.14, tocolor(255, 255, 255), 1.00, fonts[3], "right", "center", false, false, false, false, false);
		elseif ammo >= 10 and ammo < 100 then
			dxDrawText(clip, 1+screenW*0.97, 1+screenH*0.14, 1+screenW*0.97, 1+screenH*0.14, tocolor(0, 0, 0, 240), 1.00, fonts[3], "right", "center", false, false, false, false, false);
			dxDrawText(clip, screenW*0.97, screenH*0.14, screenW*0.97, screenH*0.14, tocolor(255, 255, 255), 1.00, fonts[3], "right", "center", false, false, false, false, false);
		else
			dxDrawText(clip, 1+screenW*0.95, 1+screenH*0.14, 1+screenW*0.95, 1+screenH*0.14, tocolor(0, 0, 0, 240), 1.00, fonts[3], "right", "center", false, false, false, false, false);
			dxDrawText(clip, screenW*0.95, screenH*0.14, screenW*0.95, screenH*0.14, tocolor(255, 255, 255), 1.00, fonts[3], "right", "center", false, false, false, false, false);
		end
	end

	if ammo and weapName then
		dxDrawText(ammo, 1+screenW * 0.99, 1+screenH*0.14, 1+screenW * 0.99, 1+screenH*0.14, tocolor(0, 0, 0, 240), 1.00, fonts[4], "right", "center", false, false, false, false, false);
		dxDrawText(ammo, screenW * 0.99, screenH*0.14, screenW * 0.99, screenH*0.14, tocolor(255, 255, 255), 1.00, fonts[4], "right", "center", false, false, false, false, false);
	end
end

function drawPlayerTag()
	local x, y, z = getElementPosition(localPlayer)
	for i, v in ipairs(getElementsByType("player")) do
		if isElement(v) then
			if isPlayerNametagShowing(v) then
				setPlayerNametagShowing(v, false)
			end
			local block, anim = getPedAnimation(v)
			if v ~= localPlayer and getElementData(v, "Logged") and (tostring(anim) ~= "FLOOR_hit_f" or not anim) then
				local dx, dy, dz = getElementPosition(v)
				local dis = getDistanceBetweenPoints3D(x, y, z, dx, dy, dz)
				if (dis <= 8) then
					local sx, sy = getScreenFromWorldPosition(dx, dy, dz + 0.95,  0.06)
					local name =  string.gsub(getPlayerName(v), "#%x%x%x%x%x%x", "" )
					if (getElementData(v, "bandit") and getElementData(v, "bandit") > 0) then
						name = name.." \n(Bandido)"
					else
						if (getElementData(v, "hero") and getElementData(v, "hero") > 0) then
							name = name.." \n(Heroe)"
						end
					end
					if sx then
						dxDrawText(name, sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "top")
						dxDrawText(name, sx, sy, sx, sy, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top")
					end
				end
			end
		end
	end
	if isElement(target) then
		local dx, dy, dz = getElementPosition(target)
		local dis = getDistanceBetweenPoints3D(x, y, z, dx, dy, dz)
		if dis > 8 then
			local sx, sy = getScreenFromWorldPosition(dx, dy, dz + 0.95,  0.06)
			local name =  string.gsub(getPlayerName(target), "#%x%x%x%x%x%x", "")
			
			if (getElementData(target, "bandit") and getElementData(target, "bandit") > 0) then
				name = name.." \n(Bandido)"
			else
				if (getElementData(target, "hero") and getElementData(target, "hero") > 0) then
					name = name.." \n(Heroe)"
				end
			end
			if sx then
				dxDrawText (name, sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "top")
				dxDrawText (name, sx, sy, sx, sy, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top")
			end
		end
	end
	for i,veh in ipairs(getElementsByType("vehicle")) do
		if isElement(veh) then
			local px,py,pz = getElementPosition(veh)
			local vehID = getElementModel(veh)
			local vehicle = getPedOccupiedVehicle(localPlayer)
			if veh ~= vehicle then
				local pdistance = getDistanceBetweenPoints3D ( x,y,z,px,py,pz )
				if pdistance <= 4 then
					local sx,sy = getScreenFromWorldPosition ( px, py, pz+0.95, 0.06 )
					if sx and sy then
						local w = dxGetTextWidth(getVehicleName(veh),1.00,"default-bold")
						local vehName = getVehicleNewName(getElementModel(veh)) or getVehicleName(veh)
						dxDrawText ( vehName, sx-(w/2)+1, sy-1, sx-(w/2)+1, sy-1, tocolor ( 0, 0, 0, 200 ), 1.00, "default-bold" )	
						dxDrawText ( vehName, sx-(w/2)+1, sy, sx-(w/2)+1, sy, tocolor ( 0, 0, 0, 200 ), 1.00, "default-bold" )	
						dxDrawText ( vehName, sx-(w/2)+1, sy+1, sx-(w/2)+1, sy+1, tocolor ( 0, 0, 0, 200 ), 1.00, "default-bold" )	
						dxDrawText ( vehName, sx-(w/2)-1, sy-1, sx-(w/2)-1, sy-1, tocolor ( 0, 0, 0, 200 ), 1.00, "default-bold" )	
						dxDrawText ( vehName, sx-(w/2)-1, sy, sx-(w/2)-1, sy, tocolor ( 0, 0, 0, 200 ), 1.00, "default-bold" )	
						dxDrawText ( vehName, sx-(w/2)-1, sy+1, sx-(w/2)-1, sy+1, tocolor ( 0, 0, 0, 200 ), 1.00, "default-bold" )	
						dxDrawText ( vehName, sx-(w/2), sy, sx-(w/2), sy, tocolor (255, 70, 0, 255), 1.00, "default-bold" )	
					end
				end
			end
		end
	end
end

function drawMonitorStatus()
	local murders = getElementData(localPlayer, "murders") or 0
	local headshots = getElementData(localPlayer, "headshots") or 0
	local zombieskilled = getElementData(localPlayer, "zombieskilled") or 0
	local banditskilled = getElementData(localPlayer, "banditskilled") or 0
	local blood = getElementData(localPlayer, "blood") or 0
	local humanity = getElementData(localPlayer, "humanity") or 0
	local temperature = math.round(getElementData(localPlayer, "temperature"), 2) or 0
	local size = (1/resY)*screenH

	--dxDrawRectangle(relX*808, relY*180, relX*236, relY*124, tocolor(0, 0, 0, 191), false)
	dxDrawImage(relX*796, relY*176, relX*222, relY*120, "images/status/monitor.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawText("Asesinatos:", relX*814, relY*186, relX*1020, relY*200, tocolor(255, 255, 255, 200), size, "default", "left", "center", true, false, false, false, false)
	dxDrawText("Headshots:", relX*814, relY*200, relX*1020, relY*214, tocolor(255, 255, 255, 200), size, "default", "left", "center", true, false, false, false, false)
	dxDrawText("Zombies matados:", relX*814, relY*214, relX*1020,relY* 228, tocolor(255, 255, 255, 200), size, "default", "left", "center", true, false, false, false, false)
	dxDrawText("Bandidos matados:", relX*814, relY*228, relX*1020, relY*242, tocolor(255, 255, 255, 200), size, "default", "left", "center", true, false, false, false, false)
	dxDrawText("Sangre:", relX*814, relY*242, relX*1020, relY*256, tocolor(255, 255, 255, 200), size, "default", "left", "center", true, false, false, false, false)
	dxDrawText("Humanidad:", relX*814, relY*256, relX*1020, relY*270, tocolor(255, 255, 255, 200), size, "default", "left", "center", true, false, false, false, false)
	--dxDrawText("Tipo de sangre:", relX*814, relY*270, relX*1020, relY*284, tocolor(255, 255, 255, 200), size, "default", "left", "center", true, false, false, false, false)
	dxDrawText("Temperatura:", relX*814, relY*270, relX*1020, relY*284, tocolor(255, 255, 255, 200), size, "default", "left", "center", true, false, false, false, false)
	
	-- Resultados.
	dxDrawText(murders, relX*814, relY*186, relX*1002, relY*200, tocolor(255, 255, 255, 200), size, "default", "right", "center", true, false, false, false, false)
	dxDrawText(headshots, relX*814, relY*200, relX*1002, relY*214, tocolor(255, 255, 255, 200), size, "default", "right", "center", true, false, false, false, false)
	dxDrawText(zombieskilled, relX*814, relY*214, relX*1002,relY* 228, tocolor(255, 255, 255, 200), size, "default", "right", "center", true, false, false, false, false)
	dxDrawText(banditskilled, relX*814, relY*228, relX*1002, relY*242, tocolor(255, 255, 255, 200), size, "default", "right", "center", true, false, false, false, false)
	dxDrawText(math.floor(blood), relX*814, relY*242, relX*1002, relY*256, tocolor(255, 255, 255, 200), size, "default", "right", "center", true, false, false, false, false)
	dxDrawText(humanity, relX*814, relY*256, relX*1002, relY*270, tocolor(255, 255, 255, 200), size, "default", "right", "center", true, false, false, false, false)
	--dxDrawText(bloodType, relX*814, relY*270, relX*1002, relY*284, tocolor(255, 255, 255, 200), size, "default", "right", "center", true, false, false, false, false)
	dxDrawText(temperature.."ºC", relX*814, relY*270, relX*1002, relY*284, tocolor(255, 255, 255, 200), size, "default", "right", "center", true, false, false, false, false)
end

function checkTarget(elem)
	if isElement(elem) and getElementType(elem) == "player" then
		target = elem
	else
		target = nil
	end
end
addEventHandler("onClientPlayerTarget",root, checkTarget)

function drawVehicleHud()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	local model = getElementModel(vehicle)
	local col = getElementData(vehicle, "parent")
	local vehicleType = getVehicleType(vehicle)	
	local max_batery = getVehicleMaxBatery(model)
	local max_rotary = getVehicleMaxRotary(model)
	local max_tank = getVehicleMaxFuelTank(model)
	local max_tires = getVehicleMaxTires(model)
	local max_engine = getVehicleMaxEngine(model)
	local max_fuel = getVehicleMaxFuel(model)

	if max_fuel then
		local fuel = getElementData(col, "vehicleFuel") or 0
		if (getElementData(col, "vehicleFuel") or 0) > max_fuel then fuel = max_fuel end
		if (getElementData(col, "vehicleFuel") or 0) < 0 then fuel = 0 end
		
		local h = 140 * (fuel / max_fuel)
		dxDrawRectangle(screenW * 0.01953125, screenH * 0.2630208333333333, 10, 144, tocolor(0, 0, 0, 255), false)
		dxDrawRectangle((screenW * 0.01953125) + 2, (screenH * 0.2630208333333333) + 142, 6, -h, tocolor(76, 185, 76, 255), false)
	end
	if max_engine then
		local engine = getElementData(col, "vehicleEngine") or 0
		if (getElementData(col, "vehicleEngine") or 0) > max_engine then engine = max_engine end
		if (getElementData(col, "vehicleEngine") or 0) < 0 then engine = 0 end
		
		local green = 185 * (engine / max_engine)
		local red = 185 - green
		local blue = 76 * (engine / max_engine)
		dxDrawImage(screenW * 0.0390625, screenH * 0.27734375, 46, 22, "images/status/vehicle/eng.png", 0, 0, 0, tocolor(red, green, blue, 255), false)
	end
	if max_batery then
		local batery = getElementData(col, "vehicleBatery") or 0
		if (getElementData(col, "vehicleBatery") or 0) > max_batery then batery = max_batery end
		if (getElementData(col, "vehicleBatery") or 0) < 0 then batery = 0 end

		local green = 185 * (batery / max_batery)
		local red = 185 - green
		local blue = 76 * (batery / max_batery)
		dxDrawImage(screenW * 0.0390625, screenH * 0.31640625, 46, 22, "images/status/vehicle/btry.png", 0, 0, 0, tocolor(red, green, blue, 255), false)
	end	
	if max_tank then
		local tank = getElementData(col, "vehicleFuelTank") or 0
		if (getElementData(col, "vehicleFuelTank") or 0) > max_tank then tank = max_tank end
		if (getElementData(col, "vehicleFuelTank") or 0) < 0 then tank = 0 end
		
		local green = 185 * (tank / max_tank)
		local red = 185 - green
		local blue = 76 * (tank / max_tank)
		dxDrawImage(screenW * 0.0390625, screenH * 0.35546875, 46, 22, "images/status/vehicle/fltnk.png", 0, 0, 0, tocolor(red, green, blue, 255), false)
	end
	if vehicleType == "Automobile" or vehicleType == "Bike" then
		if max_tires then
			local tires = getElementData(col, "vehicleTires") or 0
			if (getElementData(col, "vehicleTires") or 0) > max_tires then tires = max_tires end
			if (getElementData(col, "vehicleTires") or 0) < 0 then tires = 0 end

			local green = 185 * (tires / max_tires)
			local red = 185 - green
			local blue = 76 * (tires / max_tires)			
			dxDrawImage(screenW * 0.0390625, screenH * 0.39453125, 46, 22, "images/status/vehicle/trs.png", 0, 0, 0, tocolor(red, green, blue, 255), false)
		end
	elseif vehicleType == "Helicopter" then
		if max_rotary then
			local rotary = getElementData(col, "vehicleTires") or 0
			if (getElementData(col, "vehicleTires") or 0) > max_rotary then rotary = max_rotary end
			if (getElementData(col, "vehicleTires") or 0) < 0 then rotary = 0 end

			local green = 185 * (rotary / max_rotary)
			local red = 185 - green
			local blue = 76 * (rotary / max_rotary)		
			local rotary = getElementData(col, "vehicleRotary") or 0
			dxDrawImage(screenW * 0.0390625, screenH * 0.39453125, 46, 22, "images/status/vehicle/rtry.png", 0, 0, 0, tocolor(red, green, blue, 255), false)
		end
	end
end

local defaultBlip = {
	--x, y, icon
	--# Hospitales
	{1182.14709, -1324.17480, "hospital.png"},
	{2029.55652, -1417.07568, "hospital.png"},
	{-315.83524, 1053.21545, "hospital.png"},
	{-1514.9406, 2523.88257, "hospital.png"},
	{-2201.74292, -2291.82544, "hospital.png"},
	{-2659.86792, 612.68445, "hospital.png"},
	{1873.67188, 2235.08643, "hospital.png"},
	{1607.49158, 1828.01672, "hospital.png"},
	{1245.71289, 335.25357, "hospital.png"},
	--# Estacion de gasolinas
	{-1611.121582, -2708.705566, "patrol.png"},
	{-2244.901855, -2562.626709, "patrol.png"},
	{-90.653503, -1167.064941, "patrol.png"},
	{1005.438843, -937.768311, "patrol.png"},
	{654.485535, -564.414551, "patrol.png"},
	{2481.719482, -2212.343506, "patrol.png"},
	{1940.253662, -1770.361206, "patrol.png"},
	{-1671.872070, 420.963501, "patrol.png"},
	{-2409.977051, 972.192078, "patrol.png"},
	{-1476.901489, 1861.822388, "patrol.png"},
	{-1328.787354, 2680.793457, "patrol.png"},
	{-736.509338, 2747.841309, "patrol.png"},
	{384.527588, 2601.450195, "patrol.png"},
	{608.124573, 1698.808472, "patrol.png"},
	{1594.016846, 2199.565186, "patrol.png"},
	{2201.370605, 2474.884766, "patrol.png"},
	{2150.263672, 2747.303467, "patrol.png"},
	{2116.795166, 920.466125, "patrol.png"},
	{2638.850586, 1108.108521, "patrol.png"},
	{-1144.502686, -147.477814, "patrol.png"},
}

local mapCursorInfo = "Pulsa 'click derecho' para mostrar el cursor"
local relX, relY = screenW/1024, screenH/768
local gpsRT = dxCreateRenderTarget(169 * relY, 151 * relY)
local gpsMapSize = 3072
local mapSize = 3072
local playerBlipFade = true
local playerBlipAlpha = 0
local mapOptionsGUI = guiCreateWindow(screenW * 0.7841796875, screenH * 0.0130208333333333, 211, 234, "Mapa", false)
local helicrash = guiCreateCheckBox(9, 26, 192, 15, "Helicopteros destruidos", true, false, mapOptionsGUI)
local vehiclecrash = guiCreateCheckBox(9, 51, 192, 15, "Vehiculos destruidos", true, false, mapOptionsGUI)
local hospitals = guiCreateCheckBox(9, 76, 192, 15, "Hospitales", true, false, mapOptionsGUI)
local gangmembers = guiCreateCheckBox(9, 101, 192, 15, "Compañeros", true, false, mapOptionsGUI)
local patrol = guiCreateCheckBox(9, 126, 192, 15, "Estacion de gasolina", true, false, mapOptionsGUI)

guiWindowSetSizable(mapOptionsGUI, false)
guiSetVisible(mapOptionsGUI, false)

function loadOtherLoots()
	for _, loot in ipairs(getElementsByType("colshape")) do
		local x, y = getElementPosition(loot)
		if getElementData(loot, "vehiclecrash") then
			table.merge(defaultBlip, {{x, y, "vehiclecrash.png"}})
		end
		if getElementData(loot, "helicrashside") then
			table.merge(defaultBlip, {{x, y, "helicrash.png"}})
		end
	end
end
setTimer(loadOtherLoots, 8000, 1)

function drawTheCompass()
	if not isMapShown then
		local rx,ry,rz = getRotationOfCamera()
		if getElementData(localPlayer, "GPS") and getElementData(localPlayer, "GPS") > 0 then
			dxDrawImage(31 * relY, 494 * relY, 78 * relY, 76 * relY, "images/misc/compassrow.png", rz, 0, 0, tocolor(255, 255, 255, 255), false)
			dxDrawImage(0, 488 * relY, 161 * relY, 92 * relY, "images/misc/compassborder.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)	
		else
			dxDrawImage(31 * relY, 684 * relY, 78 * relY, 76 * relY, "images/misc/compassrow.png", rz, 0, 0, tocolor(255, 255, 255, 255), false)
			dxDrawImage(0, 676 * relY, 161 * relY, 92 * relY, "images/misc/compassborder.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)	
		end
	end
end 

function drawTheGPS()
	if not isMapShown then
		local blipSizeInit = 20
		local blipSizeInit2 = 10

		local mW, mH = dxGetMaterialSize(gpsRT)
		local x1, y1, z = getElementPosition(localPlayer)
		local x2, y2 = mW/2 -(x1/(6000/(gpsMapSize))), mH/2 +(y1/(6000/(gpsMapSize)))
		local camX,camY,camZ = getElementRotation(getCamera())
		local rx, ry, rz = getElementRotation(localPlayer)
		
		if (getElementInterior(localPlayer) == 0) then	
			dxSetRenderTarget(gpsRT, true)
			dxDrawRectangle(0, 0, mW, mH, tocolor(67, 87, 86, 255)) --render background
			dxDrawImage(x2 - gpsMapSize/2, mH/5 + (y2 - gpsMapSize/2), gpsMapSize, gpsMapSize, "images/radar/map.jpg", camZ, (x1/(6000/(gpsMapSize))), -(y1/(6000/gpsMapSize)), tocolor(255, 255, 255, 255))
			dxSetRenderTarget()
			dxDrawImage(16 * relY, 597 * relY, 169 * relY, 151 * relY, gpsRT, 0, 0, 0, tocolor(255, 255, 255, 255))			
			
			local lB = 16 * relY
			local rB = lB + 169 * relY
			local tB = 597 * relY
			local bB = tB + 151 * relY
			
			local cX, cY = (rB+lB)/2, (tB+bB)/2 + (35)*relY
			local toLeft, toTop, toRight, toBottom = cX-lB, cY-tB, rB-cX, bB-cY

			for k, v in ipairs(getElementsByType("blip")) do
				if isElement(v) then
					local bx, by = getElementPosition(v)
					local actualDist = getDistanceBetweenPoints2D(x1, y1, bx, by)
					local maxDist = getBlipVisibleDistance(v)
					if actualDist <= maxDist and getElementDimension(v)==getElementDimension(localPlayer) and getElementInterior(v)==getElementInterior(localPlayer) then
						local dist = actualDist/(6000/((gpsMapSize+gpsMapSize)/2))
						local rot = findRotation(bx, by, x1, y1)-camZ
						local bpx, bpy = getPointFromDistanceRotation(cX, cY, math.min(dist, math.sqrt(toTop^2 + toRight^2)), rot)
						local bpx = math.max(lB, math.min(rB, bpx))
						local bpy = math.max(tB, math.min(bB, bpy))
						local bid = getElementData(v, "customIcon")
						local _, _, _, bcA = getBlipColor(v)
						local bcR, bcG, bcB = 255, 255, 255
						local blipSize = (blipSizeInit2*getBlipSize(v))
						local offsetBlipSize = (screenH * (blipSize/screenH)) / 2
						local xx, yy = bpx - offsetBlipSize, bpy - offsetBlipSize					
						local locatedPlayer = getElementAttachedTo(v)
						
						if getBlipIcon(v) == 0 then
							bcR, bcG, bcB = getBlipColor(v)
						end

						if xx > lB and xx + offsetBlipSize * 2 < rB and yy > tB and yy + offsetBlipSize * 2 < bB then
							if isElement(locatedPlayer) and getElementType(locatedPlayer) == "player" and locatedPlayer ~= localPlayer then
								local _, _, rz2 = getElementRotation(locatedPlayer)
								dxDrawImage(xx, yy, screenH * (blipSize/screenH), screenH * (blipSize/screenH), "images/radar/player.png", 90 - rz2, 0, 0, tocolor(0, 0, 255, 255))
							else
								dxDrawImage(xx, yy, screenH * (blipSize/screenH), screenH * (blipSize/screenH), bid or "images/radar/1.png", 0, 0, 0, tocolor(bcR, bcG, bcB, 255))
							end
						end
					end
				end
			end
			
			if localPlayer:getData('Mapa') and getElementData(getLocalPlayer(), "Mapa") >= 1 then
				toggleControl("radar", false)
			else
				toggleControl("radar", false)
			end
			
			if playerBlipFade then
				playerBlipAlpha = playerBlipAlpha - 20
				if (playerBlipAlpha <= 0) then
					playerBlipAlpha = 0
					playerBlipFade = false
				end
			else
				playerBlipAlpha = playerBlipAlpha + 20
				if (playerBlipAlpha >= 255) then
					playerBlipAlpha = 255
					playerBlipFade = true
				end			
			end
			dxDrawImage(0, 579 * relY, 222 * relY, 189 * relY, "images/radar/gps.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)	
			dxDrawImage(lB + ((169 * relY) / 2) - (blipSizeInit*relY) / 2, tB + (151 * relY) - (blipSizeInit*relY) / 2 - (40 * relY), screenH * (blipSizeInit/screenH), screenH * (blipSizeInit/screenH), "images/radar/player.png", camZ-rz, 0, 0, tocolor(255, 0, 0, playerBlipAlpha), false)
		end
	end
end

function toggleMap()
	if isInventoryVisible() or getElementData(localPlayer, "dead") or isControlMenuActive() then 
		return
	end
	if not isMapShown then
		openMap()
	else
		closeMap()
	end
end

function openMap()
	isMapShown = true
	showChat(false)
	guiSetVisible(mapOptionsGUI, true)
	addEventHandler("onClientRender",root,drawTheMap)
	bindKey("mouse2", "down", showCursorOnRightClick)
end

function closeMap()
	if isCursorShowing() then 
		showCursor(false) 
	end
	isMapShown = false
	showChat(true)
	guiSetVisible(mapOptionsGUI, false)
	removeEventHandler("onClientRender",root,drawTheMap)
	unbindKey("mouse2", "down", showCursorOnRightClick)
end

function closeMapOnWasted()
	if isMapShown then
		closeMap()
	end
end
addEventHandler("onClientPlayerWasted", localPlayer, closeMapOnWasted)

function drawTheMap()
	--local relX, relY = 1280/1024, 1024/768
	local x, y, z = getElementPosition(localPlayer)
	local rx, ry, rz = getElementRotation(localPlayer)
	local lB = 10 * relX
	local rB = lB + (782 * relX)
	local tB = 10 * relY
	local bB = tB + (748 * relY)
	local blipSizeRel = 20
	local playerBlipSizeRel = 23

	if isMapShown or getElementInterior(localPlayer) == 0 then
		dxDrawImage(10 * relX, 10 * relY, 782 * relX, 748 * relY, "images/radar/map.jpg", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	
		-- load dayz blips.
		for k, v in ipairs(defaultBlip) do
			if (v[3] == "patrol.png" and guiCheckBoxGetSelected(patrol)) or (v[3] == "hospital.png" and guiCheckBoxGetSelected(hospitals)) 
				or (v[3] == "vehiclecrash.png" and guiCheckBoxGetSelected(vehiclecrash)) or (v[3] == "helicrash.png" and guiCheckBoxGetSelected(helicrash))
			then
				if getElementDimension(localPlayer) == 0 then
					local bx, by = v[1], v[2]
					local bpx, bpy = math.floor((bx + 3000) * (782 * relX) / 6000), math.floor((3000 - by) * (748 * relY) / 6000)
					local bpx = math.max(lB, math.min(rB, bpx))
					local bpy = math.max(tB, math.min(bB, bpy))
					local alpha = 255
					local bid = v[3]
					dxDrawImage(bpx, bpy, (relY * blipSizeRel), (relY * blipSizeRel), "images/radar/"..bid, 0, 0, 0, tocolor(255, 255, 255, 255), false)
				end
			end
		end		
		-- draw other blips
		for k, v in ipairs(getElementsByType("blip")) do
			local bx, by = getElementPosition(v)
			if getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v)==getElementInterior(localPlayer) then
				local bS = getBlipSize(v)
				local bpx, bpy = math.floor((bx + 3000) * (782 * relX) / 6000), math.floor((3000 - by) * (748 * relY) / 6000)
				local bpx = math.max(lB, math.min(rB, bpx))
				local bpy = math.max(tB, math.min(bB, bpy))
				local bid = getElementData(v, "customIcon") 
				local _, _, _, bcA = getBlipColor(v)
				local bcR, bcG, bcB = 255, 255, 255
				local locatedPlayer = getElementAttachedTo(v)
				if getBlipIcon(v) == 0 then
					bcR, bcG, bcB = getBlipColor(v)
				end
				if isElement(locatedPlayer) and getElementType(locatedPlayer) == "player" and locatedPlayer ~= localPlayer then
					if guiCheckBoxGetSelected(gangmembers) then
						local _, _, rz2 = getElementRotation(locatedPlayer)
						local name = getPlayerName(locatedPlayer):gsub("#%x%x%x%x%x%x", "")
						local wName = dxGetTextWidth(name, 1, "default-bold")
						dxDrawRectangle(bpx + (relY * playerBlipSizeRel) + 2, bpy, wName, 15, tocolor(0, 0, 0, 200), false)
						dxDrawText(name, bpx + (relY * playerBlipSizeRel) + 2, bpy, 0, 0, tocolor(0, 0, 255, 255), 1, "default-bold")
						dxDrawImage(bpx, bpy, (relY * blipSizeRel), (relY * blipSizeRel), bid or "images/radar/player.png", 90-rz2, 0, 0, tocolor(0, 0, 255, 255), false)
					end
				else
					dxDrawImage(bpx, bpy, (relY * blipSizeRel), (relY * blipSizeRel), bid or "images/radar/1.png", 0, 0, 0, tocolor(bcR, bcG, bcB, 255), false)
				end
			end
		end	
	end
	-- show cursor text
	dxDrawText(mapCursorInfo, 10 * relX, 15 * relY, (10 * relX) + 782 * relX, (15 * relY) + 20, tocolor(0, 0, 0, 200), 1, "default-bold", "center", "top")
	
	-- cuadricula
	local Ox, Oy = 0, 0
	for i = 0, 25 do
		dxDrawLine((10 * relX) + Ox, 10 * relY, (10 * relX) + Ox, (10 * relY) + 748 * relY, tocolor(0, 0, 0, 75), 1)
		Ox = Ox + (782 * relX)/25
	end
	for i = 0, 25 do
		dxDrawLine(10 * relX, (10 * relY) + Oy, (10 * relX) + 782 * relX, (10 * relY) + Oy, tocolor(0, 0, 0, 75), 1)
		Oy = Oy + (748 * relY)/25
	end
	
	-- draw local player
	local bpx, bpy = math.floor((x + 3000) * (782 * relX) / 6000), math.floor((3000 - y) * (748 * relY) / 6000)
	
	if playerBlipFade then
		playerBlipAlpha = playerBlipAlpha - 20
		if (playerBlipAlpha <= 0) then
			playerBlipAlpha = 0
			playerBlipFade = false
		end
	else
		playerBlipAlpha = playerBlipAlpha + 20
		if (playerBlipAlpha >= 255) then
			playerBlipAlpha = 255
			playerBlipFade = true
		end			
	end

	dxDrawLine((10 * relX), bpy + (relY * playerBlipSizeRel)/2, (10 * relX) + 782 * relX, bpy + (relY * playerBlipSizeRel)/2, tocolor(255, 0, 0, playerBlipAlpha), 1)
	dxDrawLine(bpx + (relY * playerBlipSizeRel)/2, (10 * relY), bpx + (relY * playerBlipSizeRel)/2, (10 * relY) + 748 * relY, tocolor(255, 0, 0, playerBlipAlpha), 1)
	dxDrawImage(bpx, bpy, (relY * playerBlipSizeRel), (relY * playerBlipSizeRel), "images/radar/player.png", 360-rz, 0, 0, tocolor(255, 0, 0, playerBlipAlpha), false)
end

function showCursorOnRightClick()
	if not isCursorShowing() then
		showCursor(true)
	else
		showCursor(false)
	end
end

function isMapOpened()
	return isMapShown
end