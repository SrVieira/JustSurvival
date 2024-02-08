local animalTeam = createTeam("Animals")
local deadAnimalTimers = {}
local animalTable = {}

animalSpawnpointTable = {
	{-1350.775390625,-1070.8291015625,160.71176147461},
	{-1369.1123046875,-1094.70703125,163.45556640625},
	{-1431.8876953125,-1093.189453125,162.88122558594},
	{-1456.1787109375,-1064.6630859375,168.23822021484},
	{-1483.6357421875,-1024.376953125,170.4222869873},
	{-1468.3408203125,-988.3291015625,192.51156616211},
	{-1431.3173828125,-934.0478515625,201.39248657227},
	{-1577.904296875,-1020.0693359375,143.08142089844},
	{-1587.375,-1018.236328125,141.72036743164},
	{-1590.380859375,-1040.8505859375,134.61396789551},
	{-1581.958984375,-1072.4111328125,133.2043762207},
	{-1584.595703125,-1106.2001953125,138.63221740723},
	{-1550.591796875,-1137.1181640625,136.79585266113},
	{-1498.1083984375,-1180.9814453125,125.67600250244},
	{-1428.4541015625,-1225.892578125,106.43696594238},
	{-411.271484375,-1338.080078125,25.689184188843},
	{-373.59375,-1307.2568359375,26.628273010254},
	{-372.1689453125,-1259.75,31.759468078613},
	{-393.7333984375,-1195.427734375,60.393005371094},
	{-417.9150390625,-1180.4599609375,63.334930419922},
	{-433.0888671875,-1156.3349609375,61.920516967773},
	{-336.744140625,-1267.5693359375,23.735641479492},
	{-303.19140625,-1275.9599609375,10.24838924408},
	{-233.025390625,-1235.2373046875,6.5470447540283},
	{-193.0166015625,-1232.7568359375,10.130974769592},
	{-176.25,-1223.6298828125,8.0039596557617},
	{-166.5498046875,-1286.111328125,3.5691347122192},
	{-969.5048828125,-1738.703125,77.557479858398},
	{-966.748046875,-1776.2470703125,80.165809631348},
	{-976.7177734375,-1808.9462890625,90.694877624512},
	{-978.0849609375,-1827.4521484375,93.413543701172},
	{-986.23046875,-1855.9130859375,85.224227905273},
	{-1095.68359375,-1869.5302734375,86.347923278809},
	{-1168.853515625,-1864.869140625,79.263336181641},
	{-1221.1416015625,-1859.6591796875,76.356552124023},
	{-650.044921875,-2077.580078125,28.14298248291},
	{-632.34765625,-2062.50390625,32.527751922607},
	{-537.833984375,-1992.03515625,47.49878692627},
	{-498.4375,-1957.61328125,38.346961975098},
}

function createAnimalOnStart()
	for index, value in ipairs(animalSpawnpointTable) do
		local rand = math.random(1, #gameplayVariables["config_animals"])
		local atype = gameplayVariables["config_animals"][rand][1]
		local skin = gameplayVariables["config_animals"][rand][2]
		local maxblood = gameplayVariables["config_animals"][rand][3]
		local rawmeat = gameplayVariables["config_animals"][rand][4]
		local offensive = gameplayVariables["config_animals"][rand][5]
		local damage = gameplayVariables["config_animals"][rand][6]
		
		local animal
		if offensive then 
			animal = call(getResourceFromName("dzslothbot"), "spawnBot", value[1], value[2], value[3], math.random(0,360), skin, 0, 0, getTeamFromName("Animals"), 0, "hunting")
			call(getResourceFromName("dzslothbot"), "setBotAttackEnabled", animal, true)
		else
			animal = createPed(skin, value[1], value[2], value[3], math.random(0,360))
		end

		setPedAnimation(animal, "PED", "WALK_civi", -1, true, true, true)
		
		setElementData(animal, "animal", true)
		setElementData(animal, "damage", damage)
		setElementData(animal, "blood", maxblood)
		setElementData(animal, "animalData", toJSON({animalType = atype, offensive = offensive}))
		
		table.insert(animalTable, animal)
	end
end
addEventHandler("onResourceStart", resourceRoot, createAnimalOnStart)

function removeAnimal()
	for index, animal in ipairs(animalTable) do
		if isElement(animal) then
			destroyElement(animal)
		end
	end
end
addEventHandler("onResourceStop", resourceRoot, removeAnimal)

function setAnimalAttacking(ped)
	if isElement(ped) then
		if isPedDead(ped) then return end
		setPedAnimation(ped)
		call ( getResourceFromName ( "dzslothbot" ), "setBotFollow", ped, source)
	end
end
addEvent("setAnimalAttacking",true)
addEventHandler("setAnimalAttacking",root,setAnimalAttacking)

function stopAnimalAttacking (ped)
	if not isElement(ped) then return end
	if isPedDead(ped) then return end
	local x,y,z = getElementPosition(ped)
	call ( getResourceFromName ( "dzslothbot" ), "setBotGuard", ped, x, y, z, false)
end
addEvent("stopAnimalAttacking",true)
addEventHandler("stopAnimalAttacking",root,stopAnimalAttacking)

function removeRawmetFromAnimal(ped, col)
	if isElement(ped) and isElement(col) then
		if deadAnimalTimers[ped] and isTimer(deadAnimalTimers[ped]) then
			killTimer(deadAnimalTimers[ped])
			deadAnimalTimers[ped] = nil
		end
		
		for k, d in ipairs(gameplayVariables["config_animals"]) do
			if (getElementModel(ped) == d[2]) then
				setElementData(source, "Carne Crua", (getElementData(source, "Carne Crua") or 0) + d[4])
				triggerClientEvent(source, "displayClientInfo", source, "Has tomado "..d[4].." de carne.", {0, 255, 0})
				break
			end
		end
		
		setPedAnimation(source, "BOMBER", "BOM_Plant_2Idle", -1, false)
		setTimer(setPedAnimation, 1000, 1, source)
		destroyElement(ped)
		destroyElement(col)
	end
end
addEvent("onPlayerRawmeatTaken", true)
addEventHandler("onPlayerRawmeatTaken", root, removeRawmetFromAnimal)

addEvent( "onAnimalDie", true )
function onAnimalGotDie (attacker, weapon)
	if not isPedDead(source) and isElement(source) then
		local hour, minute = getTheTime()
		local id = getElementModel(source)
		local x, y, z = getElementPosition(source)
		local _, _, r = getElementRotation(source)
		local ped = createPed(id, x, y, z+0.5)
		local col = createColSphere(x, y, z, 1.2)
		setElementRotation(ped, 0, 0, r)
		setElementData(ped, "BotTeam", getTeamFromName("Animals"))
		setElementData(ped, "parent", col)
		setElementData(col, "parent", ped)
		setElementData(col, "deadanimal", true)
		attachElements(col, ped, 0, 0, 0)
		
		if isElement(attacker) then
			if weapon then
				setElementData(col, "info", "Tiempo estimado de muerte: (Hora: "..hour..":"..minute..", Arma: "..(weapon or "Desconocida")..")")
			else
				setElementData(col, "info", "Tiempo estimado de muerte: (Hora: "..hour..":"..minute..")")
			end
		else
			setElementData(col, "info", "Como ha muerto este animal?")
		end

		setTimer(setPedAnimation, 200, 1, ped, "BEACH", "ParkSit_W_loop", -1, false, true, false)
		setTimer(setElementData, 500, 1, ped, "anim", {"BEACH", "ParkSit_W_loop"})
		setTimer(setElementHealth, 500, 1, ped, 0)
		
		for i, sourceAnimal in ipairs(animalTable) do
			if sourceAnimal == source then
				destroyElement(source)
				table.remove(animalTable, i)
			end
		end

		deadAnimalTimers[ped] = setTimer(destroyAnimal, 60000*5, 1, ped, col)
	end
end
addEventHandler( "onAnimalDie", root, onAnimalGotDie)

function destroyAnimal(ped, col)
	if isElement(ped) and isElement(col) then
		destroyElement(ped)
		destroyElement(col)
		deadAnimalTimers[ped] = nil
	end
end