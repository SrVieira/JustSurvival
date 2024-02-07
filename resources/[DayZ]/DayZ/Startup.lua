local textDisplayTable = {
	" ",
	--[[
	"Los maletines son un tipo de loot especial que son escasos.",
	"Usa el cuchillo para obtener la carne de animales muertos.",
	"Presiona 'F11' para abrir el mapa.",
	"Para abrir el inventario presiona 'J'.",
	"Los cascos y chalecos te ayudan a resistir los disparos.",
	"Cuidate de los animales salvajes.",
	"Nuestro servidor estará constantemente actualizandose teniendo en cuenta tus sugerencias.",
	]]
}

local bannedCommands = {
	["register"] = true,
	["login"] = true,
	["logout"] = true,
	["showchat"] = true,
	["nick"] = true,
}

function initDayZ()

	textDisplay2 = textCreateDisplay()
	textItem2 = textCreateTextItem("Cargando...", 0.5, 0.5, "medium", 255, 255, 255, 255, 3, "center", "center")
	textDisplayAddText(textDisplay2, textItem2)

	textDisplay3 = textCreateDisplay()

	setWeaponProperty(30, "poor", "maximum_clip_ammo", 100)
	setWeaponProperty(30, "pro", "maximum_clip_ammo", 100)
	setWeaponProperty(30, "std", "maximum_clip_ammo", 100)
	setWeaponProperty(30, "poor", "weapon_range", 200)
	setWeaponProperty(30, "pro", "weapon_range", 200)
	setWeaponProperty(30, "std", "weapon_range", 200)
	
	setWeaponProperty(31, "poor", "maximum_clip_ammo", 45)
	setWeaponProperty(31, "pro", "maximum_clip_ammo", 45)
	setWeaponProperty(31, "std", "maximum_clip_ammo", 45)
	setWeaponProperty(31, "poor", "weapon_range", 180)
	setWeaponProperty(31, "pro", "weapon_range", 180)
	setWeaponProperty(31, "std", "weapon_range", 180)
	
	setWeaponProperty(29, "poor", "maximum_clip_ammo", 25)
	setWeaponProperty(29, "pro", "maximum_clip_ammo", 25)
	setWeaponProperty(29, "std", "maximum_clip_ammo", 25)
	setWeaponProperty(29, "poor", "weapon_range", 120)
	setWeaponProperty(29, "pro", "weapon_range", 120)
	setWeaponProperty(29, "std", "weapon_range", 120)
	
	setWeaponProperty(24, "poor", "maximum_clip_ammo", 7)
	setWeaponProperty(24, "pro", "maximum_clip_ammo", 7)
	setWeaponProperty(24, "std", "maximum_clip_ammo", 7)
	setWeaponProperty(24, "poor", "weapon_range", 80)
	setWeaponProperty(24, "pro", "weapon_range", 80)
	setWeaponProperty(24, "std", "weapon_range", 80)
	
	setWeaponProperty(25, "poor", "weapon_range", 40)
	setWeaponProperty(25, "pro", "weapon_range", 40)
	setWeaponProperty(25, "std", "weapon_range", 40)
	
	setWeaponProperty(23, "poor", "maximum_clip_ammo", 12)
	setWeaponProperty(23, "pro", "maximum_clip_ammo", 12)
	setWeaponProperty(23, "std", "maximum_clip_ammo", 12)	
	
	for _, player in ipairs(getElementsByType("player")) do
		textDisplayAddObserver(textDisplay2, player)
		textDisplayAddObserver(textDisplay3, player)
	end

	for key, resource in ipairs(getResources()) do
		if string.find(getResourceName(resource), "MAP_") and getResourceState(resource) ~= "running" then
			startResource(resource)
		end
	end
	
	setGameType("DayZ v10")
	setMapName("Apocaliptic")
	
	local realtime = getRealTime()
	setTime(realtime.hour, realtime.minute)
	setMinuteDuration(60000)
end
addEventHandler("onResourceStart", resourceRoot, initDayZ)

function disableCommands(cmd)
	if bannedCommands[cmd] then
		cancelEvent()
	end
end
addEventHandler("onPlayerCommand", root, disableCommands)

function updateDisplayText()
	if textItem3 then
		textDestroyTextItem(textItem3)
	end
	local text = textDisplayTable[math.random(#textDisplayTable)]
	textItem3 = textCreateTextItem(text, 0.5, 0.6, "medium", 255, 255, 255, 255, 1.2, "center", "center")
	textDisplayAddText(textDisplay3, textItem3)
end
setTimer(updateDisplayText, 4000, 1)
setTimer(updateDisplayText, 30000, 0)

function movePlayerIntoLobbyOnJoin()
	textDisplayAddObserver(textDisplay2, source)
	textDisplayAddObserver(textDisplay3, source)
		
	setElementDimension(source, 100)
	showChat(source, false)
end
addEventHandler("onPlayerJoin", root, movePlayerIntoLobbyOnJoin)

addEvent("onTextAuthRemove", true)
addEventHandler("onTextAuthRemove", root,
	function()
		textDisplayRemoveObserver(textDisplay2, source)
		textDisplayRemoveObserver(textDisplay3, source)
	end
)

function setWeaponSkills(_, currentSlot)
	if currentSlot == 30 then
		setWeaponProperty(30, "poor", "maximum_clip_ammo", 100)
		setWeaponProperty(30, "pro", "maximum_clip_ammo", 100)
		setWeaponProperty(30, "std", "maximum_clip_ammo", 100)
		setWeaponProperty(30, "poor", "weapon_range", 200)
		setWeaponProperty(30, "pro", "weapon_range", 200)
		setWeaponProperty(30, "std", "weapon_range", 200)
	elseif currentSlot == 31 then
		setWeaponProperty(31, "poor", "maximum_clip_ammo", 45)
		setWeaponProperty(31, "pro", "maximum_clip_ammo", 45)
		setWeaponProperty(31, "std", "maximum_clip_ammo", 45)
		setWeaponProperty(31, "poor", "weapon_range", 180)
		setWeaponProperty(31, "pro", "weapon_range", 180)
		setWeaponProperty(31, "std", "weapon_range", 180)
	elseif currentSlot == 24 then
		setWeaponProperty(24, "poor", "maximum_clip_ammo", 7)
		setWeaponProperty(24, "pro", "maximum_clip_ammo", 7)
		setWeaponProperty(24, "std", "maximum_clip_ammo", 7)
		setWeaponProperty(24, "poor", "weapon_range", 80)
		setWeaponProperty(24, "pro", "weapon_range", 80)
		setWeaponProperty(24, "std", "weapon_range", 80)
	elseif currentSlot == 25 then
		setWeaponProperty(25, "poor", "weapon_range", 40)
		setWeaponProperty(25, "pro", "weapon_range", 40)
		setWeaponProperty(25, "std", "weapon_range", 40)
	elseif currentSlot == 23 then
		setWeaponProperty(23, "poor", "maximum_clip_ammo", 12)
		setWeaponProperty(23, "pro", "maximum_clip_ammo", 12)
		setWeaponProperty(23, "std", "maximum_clip_ammo", 12)
	elseif currentSlot == 29 then
		setWeaponProperty(29, "poor", "maximum_clip_ammo", 25)
		setWeaponProperty(29, "pro", "maximum_clip_ammo", 25)
		setWeaponProperty(29, "std", "maximum_clip_ammo", 25)
		setWeaponProperty(29, "poor", "weapon_range", 120)
		setWeaponProperty(29, "pro", "weapon_range", 120)
		setWeaponProperty(29, "std", "weapon_range", 120)
	end	
end
addEventHandler("onPlayerWeaponSwitch", root, setWeaponSkills)