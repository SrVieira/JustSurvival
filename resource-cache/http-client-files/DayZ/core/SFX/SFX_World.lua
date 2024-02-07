local ambience_volume = 0.015
local soundsTable = {}

function setAmbienceSound()
	local minute, seconds = getTime()
	local playing = getElementData(localPlayer, "Logeado")
	if playing then
		if not isElement(dayeffect) then
			dayeffect = playSound("sounds/world/day.mp3", true)
			setSoundVolume(dayeffect, ambience_volume)
		end
	end
end
setTimer(setAmbienceSound, 500, 0)

function setFireplaceSound(object, state)
	if state then
		if not isElement(soundsTable[object]) then
			local x, y, z = getElementPosition(object)
			soundsTable[object] = playSound3D("sounds/world/campfire.mp3", x, y, z, true)
			setSoundMaxDistance(soundsTable[object], 7)
			setSoundVolume(soundsTable[object], 0.7)
			attachElements(soundsTable[object], object)
		end
	else
		if isElement(soundsTable[object]) then
			stopSound(soundsTable[object])
			soundsTable[object] = nil			
		end
	end
end
addEvent("onClientFireplaceSound", true)
addEventHandler("onClientFireplaceSound", root, setFireplaceSound)

function roadFlareSound(flare)
	local x, y, z = getElementPosition(flare)
	soundsTable[flare] = playSound3D("sounds/world/roadflare.wav", x, y, z, true)
end
addEvent("onRoadFlareSound", true)
addEventHandler("onRoadFlareSound", root, roadFlareSound)

function breakBoneOnBearTramp()
	playSound("sounds/effects/brokenbone.mp3", false)
end
addEvent("onClientBearTrampCapture", true)
addEventHandler("onClientBearTrampCapture", root, breakBoneOnBearTramp)

function roadFlareSoundStop(flare)
	if isElement(soundsTable[flare]) then
		stopSound(soundsTable[flare])
		soundsTable[flare] = nil
	end
end
addEvent("onRoadFlareSoundStop", true)
addEventHandler("onRoadFlareSoundStop", root, roadFlareSoundStop)

function tentunpackSound()
	playSound("sounds/effects/tentunpack.ogg")
end
addEvent("onTentunpackSound", true)
addEventHandler("onTentunpackSound", root, tentunpackSound)

function tentpackSound()
	playSound("sounds/effects/action_tentpack.ogg")
end
addEvent("onTentpackSound", true)
addEventHandler("onTentpackSound", root, tentpackSound)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		setWorldSoundEnabled(5, false) -- Sonido de armas por defecto del gta.
		setTimer(function()
			for i, v in ipairs(getElementsByType("ped")) do
				setPedVoice(v, "PED_TYPE_DISABLED")
			end
			for i, v in ipairs(getElementsByType("player")) do
				setPedVoice(v, "PED_TYPE_DISABLED")
			end
		end, 2000, 0)
	end
)

function sfxWeapons()
	local weapon = false
	local wsound = false
	local x, y, z = getElementPosition(source)
	local x1, y1, z1 = getElementPosition(localPlayer)
	local distance = getDistanceBetweenPoints3D(x, y, z, x1, y1, z1)
	
	if getPedWeapon(source) == 34 then -- SNIPERS
		weapon = tostring(getElementData(source, "PRIMARY_Weapon"))
	elseif getPedWeapon(source) == 25 then -- SHOTGUNS
		weapon = tostring(getElementData(source, "PRIMARY_Weapon"))
	elseif getPedWeapon(source) == 33 then -- RIFLES
		weapon = tostring(getElementData(source, "PRIMARY_Weapon"))
	elseif getPedWeapon(source) == 31 then -- ASSAULTS RIFLE
		weapon = tostring(getElementData(source, "PRIMARY_Weapon"))	
	elseif getPedWeapon(source) == 30 then -- GRENADE LAUNCHER
		weapon = tostring(getElementData(source, "PRIMARY_Weapon"))			
	elseif getPedWeapon(source) == 23 then -- PISTOLS
		weapon = tostring(getElementData(source, "SECONDARY_Weapon"))
	elseif getPedWeapon(source) == 24 then -- REVOLVERS
		weapon = tostring(getElementData(source, "SECONDARY_Weapon"))
	elseif getPedWeapon(source) == 29 then -- SUB FUSIL
		weapon = tostring(getElementData(source, "SECONDARY_Weapon"))
	end
	
	if weapon and weapon == "Ballesta" then
		wsound = playSound3D("sounds/weapons/crossbow.wav", x, y, z)
		setSoundMaxDistance(wsound, 40)
	elseif weapon and weapon == "ACR" then
		wsound = playSound3D("sounds/weapons/acr.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "M16" then
		wsound = playSound3D("sounds/weapons/m16.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "G36C" then
		wsound = playSound3D("sounds/weapons/g36c.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "USP45 SD" then
		wsound = playSound3D("sounds/weapons/usp45sd.wav", x, y, z)
		setSoundMaxDistance(wsound, 40)
	elseif weapon and weapon == "USP45" then
		wsound = playSound3D("sounds/weapons/usp45.wav", x, y, z)
		setSoundMaxDistance(wsound, 80)
	elseif weapon and weapon == "Steyr AUG" then
		wsound = playSound3D("sounds/weapons/aug.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "AK-74" then
		wsound = playSound3D("sounds/weapons/ak74.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "AKS-74UN Kobra" then
		wsound = playSound3D("sounds/weapons/ak74.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "AK-74 PSO" then
		wsound = playSound3D("sounds/weapons/ak74.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "FN FAL" then
		wsound = playSound3D("sounds/weapons/fnfal.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "FN FNC" then
		wsound = playSound3D("sounds/weapons/fnfal.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "M9" then
		wsound = playSound3D("sounds/weapons/m9.wav", x, y, z)
		setSoundMaxDistance(wsound, 80)
	elseif weapon and weapon == "Beretta M92F" then
		wsound = playSound3D("sounds/weapons/berettam92.wav", x, y, z)
		setSoundMaxDistance(wsound, 80)
	elseif weapon and weapon == "IMI Galil" then
		wsound = playSound3D("sounds/weapons/galil.wav", x, y, z)
		setSoundMaxDistance(wsound, 40)
	elseif weapon and weapon == "Winchester 1866" then
		wsound = playSound3D("sounds/weapons/winchester.wav", x, y, z)
		setSoundMaxDistance(wsound, 160)
	elseif weapon and weapon == "Remington 870" then
		wsound = playSound3D("sounds/weapons/remington.wav", x, y, z)
		setSoundMaxDistance(wsound, 160)
	elseif weapon and weapon == "Benelli" then
		wsound = playSound3D("sounds/weapons/benelli.wav", x, y, z)
		setSoundMaxDistance(wsound, 160)
	elseif weapon and weapon == "G28" then
		wsound = playSound3D("sounds/weapons/g28.wav", x, y, z)
		setSoundMaxDistance(wsound, 200)
	elseif weapon and weapon == "Dragunov" then
		wsound = playSound3D("sounds/weapons/dragunov.wav", x, y, z)
		setSoundMaxDistance(wsound, 200)
	elseif weapon and weapon == "Barret 50" then
		wsound = playSound3D("sounds/weapons/barret.wav", x, y, z)
		setSoundMaxDistance(wsound, 200)
	elseif weapon and weapon == "Desert Eagle" then
		wsound = playSound3D("sounds/weapons/deagle.wav", x, y, z)
		setSoundMaxDistance(wsound, 100)
	elseif weapon and weapon == "Revolver" then
		wsound = playSound3D("sounds/weapons/revolver.wav", x, y, z)
		setSoundMaxDistance(wsound, 100)
	elseif weapon and weapon == "M1911" then
		wsound = playSound3D("sounds/weapons/m1911.wav", x, y, z)
		setSoundMaxDistance(wsound, 80)
	elseif weapon and weapon == "Bizon PP-19 SD" then
		wsound = playSound3D("sounds/weapons/bizon.wav", x, y, z)
		setSoundMaxDistance(wsound, 40)
	elseif weapon and weapon == "CZ 550" then
		wsound = playSound3D("sounds/weapons/cz550.wav", x, y, z)
		setSoundMaxDistance(wsound, 200)
	elseif weapon and weapon == "PDW" then
		wsound = playSound3D("sounds/weapons/pdw.wav", x, y, z)
		setSoundMaxDistance(wsound, 140)
	elseif weapon and weapon == "MP5A5" then
		wsound = playSound3D("sounds/weapons/mp5a5.wav", x, y, z)
		setSoundMaxDistance(wsound, 140)
	elseif weapon and weapon == "M107" then
		wsound = playSound3D("sounds/weapons/m107.wav", x, y, z)
		setSoundMaxDistance(wsound, 140)
	elseif weapon and weapon == "Mk14-EBR" then
		wsound = playSound3D("sounds/weapons/mk14ebr.wav", x, y, z)
		setSoundMaxDistance(wsound, 200)
	elseif weapon and weapon == "AS50" then
		wsound = playSound3D("sounds/weapons/as50.wav", x, y, z)
		setSoundMaxDistance(wsound, 200)
	elseif weapon and weapon == "Mk-48" then
		wsound = playSound3D("sounds/weapons/mk48.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "PKM" then
		wsound = playSound3D("sounds/weapons/pkm.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "M4A3 CCO" then
		wsound = playSound3D("sounds/weapons/m4a3.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "M79" then
		wsound = playSound3D("sounds/weapons/m79.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	elseif weapon and weapon == "PGM Hecate" then
		wsound = playSound3D("sounds/weapons/hecate.wav", x, y, z)
		setSoundMaxDistance(wsound, 200)
	elseif weapon and weapon == "AKS Gold" then
		wsound = playSound3D("sounds/weapons/ak74.wav", x, y, z)
		setSoundMaxDistance(wsound, 180)
	end
end
addEventHandler("onClientPlayerWeaponFire", root, sfxWeapons)

function setPlayerShootingLevel()
	if getPedControlState("fire") then
		local weapon = getPedWeapon(localPlayer)
		local noise = getWeaponNoise(weapon) or 0
		
		if not noise or noise ~= getElementData(localPlayer, "shooting") then
			setElementData(localPlayer,"shooting",noise)
		end
		
		if shootTimer then
			killTimer(shootTimer)
		end
		
		shootTimer = setTimer(function() 
			setElementData(localPlayer,"shooting",0)
			shootTimer = false
		end, 10000, 1)
	end
end
setTimer(setPlayerShootingLevel,100,0)
