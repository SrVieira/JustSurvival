local blockedTasks = 
{
	"TASK_SIMPLE_IN_AIR", -- We're falling or in a jump.
	"TASK_SIMPLE_JUMP", -- We're beginning a jump
	"TASK_SIMPLE_LAND", -- We're landing from a jump
	"TASK_SIMPLE_GO_TO_POINT", -- In MTA, this is the player probably walking to a car to enter it
	"TASK_SIMPLE_NAMED_ANIM", -- We're performing a setPedAnimation
	"TASK_SIMPLE_CAR_OPEN_DOOR_FROM_OUTSIDE", -- Opening a car door
	"TASK_SIMPLE_CAR_GET_IN", -- Entering a car
	"TASK_SIMPLE_CLIMB", -- We're climbing or holding on to something
	"TASK_SIMPLE_SWIM",
	"TASK_SIMPLE_HIT_HEAD", -- When we try to jump but something hits us on the head
	"TASK_SIMPLE_FALL", -- We fell
	"TASK_SIMPLE_GET_UP" -- We're getting up from a fall
}

local isReloading = {}
isReloading[localPlayer] = false

addEvent("onReloadSound", true)
addEventHandler("onReloadSound", root,
	function()
		local playerWeapon = getPedWeapon(source)
		local x,y,z = getElementPosition(source)
		if playerWeapon == 24 and getElementData(source, "SECONDARY_Weapon") == "Desert Eagle" then
			playerWeapon = 23
		end
		
		if fileExists("sounds/weapons/reload/"..playerWeapon..".wav") then
			local sound = playSound3D("sounds/weapons/reload/"..playerWeapon..".wav",x,y,z)
			setSoundVolume(sound,0.25)
		end
		setTimer(resetReloadWeapon, 1500, 1, source)
	end
)

function resetReloadWeapon(source)
	isReloading[source] = false 
end

local function reloadWeapon()
	-- Usually, getting the simplest task is enough to suffice
	local task = getPedSimplestTask (localPlayer) 

	-- Iterate through our list of blocked tasks
	for idx, badTask in ipairs(blockedTasks) do
		-- If the player is performing any unwanted tasks, do not fire an event to reload
		if (task == badTask) then
			return
		end
	end

	triggerServerEvent("relWep", resourceRoot)
	isReloading[localPlayer] = true
end

function weaponFire(weapon)
	if weapon == 25 or weapon == 33 or weapon == 34 then
		setTimer(reloadWeaponAfterShoot, 600, 1, source, weapon)	
	end
end
addEventHandler("onClientPlayerWeaponFire", root, weaponFire)

function reloadWeaponAfterShoot(source, weapon)
	local x, y, z = getElementPosition(source)
	local sound = playSound3D("sounds/weapons/reload/"..weapon..".wav",x,y,z)
	setSoundVolume(sound,0.25)
end

-- The jump task is not instantly detectable and bindKey works quicker than getControlState
-- If you try to reload and jump at the same time, you will be able to instant reload.
-- We work around this by adding an unnoticable delay to foil this exploit.

local check
local timer
function checkReload(_, state)
	if state == "up" then
		check = true
		
		if isTimer(timer) then
			killTimer(timer)
		end
		
		timer = setTimer(function() check = nil end, 700, 1)
	end
end
bindKey("aim_weapon", "both", checkReload)
bindKey("fire", "both", checkReload)

addCommandHandler("Reload weapon", function()
	setTimer(function()
		if getPedControlState(localPlayer, "aim_weapon") then return end
		if getPedControlState(localPlayer, "fire") then return end
		if check == true then return end
		
		if getPedTotalAmmo (localPlayer) - getPedAmmoInClip (localPlayer) <= 0 then
			return
		end
		if getPedWeapon(localPlayer) == 25 or getPedWeapon(localPlayer) == 33 or getPedWeapon(localPlayer) == 34 then
			return
		end
		if 	getPedAmmoInClip (localPlayer) == getWeaponProperty(getPedWeapon( localPlayer ), "pro", "maximum_clip_ammo") then
			return
		end
		if 	getPedAmmoInClip (localPlayer) == getWeaponProperty(getPedWeapon( localPlayer ), "std", "maximum_clip_ammo") then
			return
		end
		if 	getPedAmmoInClip (localPlayer) == getWeaponProperty(getPedWeapon( localPlayer ), "poor", "maximum_clip_ammo") then
			return
		end
		if isReloading[localPlayer] == true then 
			return
		end
		reloadWeapon()
	end, 50, 1)
end)
bindKey("r", "down", "Reload weapon")