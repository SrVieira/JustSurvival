ZombiePedSkins = {22,56,67,68} --ALTERNATE SKIN LISTS FOR ZOMBIES (SHORTER LIST IS TEXTURED ZOMBIES ONLY)

ZombieLoot = {
	{22,"hunter"},
	{56,"generic"},
	{67,"medical"},
	{68,"military"},
}

zombieLootType = {
	["runner"] = {
		{"Mina",0.12},
		{"Botiquin",0.28},
		{"Esteroides",0.12},
		{"Revolver",1.28},
		{"Frijoles",2.28},
		{"Puerco",2.28},
		{"Dew",1.28},
		{"Mochila Alice",0.28},
		{"Garrafa de Água",2.28},
		{"Mapa",4.28},
		{"PGM Hecate",1.28},
		{"7.62x54mm",2.28},
		{"Desert Eagle",1.28},
		{"11.43x23mm",4.28},
	},
	
	["civilian"] = {
		{"Lata de soda vacia",8.82},
		{"Lata vacia",8.82},
		{"Cerillos",8.82},
		{"Dew",11.76},
		{"Pepsi",8.82},
		{"Frijoles",4.90},
		{"Macarrão Enlatado",4.90},
		{"9x18mm",6.86},
		{"11.43x23mm",4.90},
		{"1866 Slug",4.90},
		{"12 Gauge",4.90},
		{"Curativo",5.88},
		{"Analgésicos",5.88},
	},

	["hunter"] = {
		{"Curativo",27.78},
		{"11.43x23mm",5.56},
		{"9x19mm",13.89},
		{".308 Winchester",13.89},
		{"Garrafa de Água vacia",5.56},
		{"9x18mm",27.78},
		{"Bolsa termica",5.56},
	},

	["generic"] = {
		{"Lata de soda vacia",0},
		{"Lata vacia",0},
		{"Cola)",0},
		{"Pepsi",0},
		{"Frijoles",1},
		{"Sardinas",1},
		{"Salchichas",1},
		{"Macarrão Enlatado",1},
		{"Garrafa de Água vacia",1},
		{"Garrafa de Água",1},
		{"Curativo",11},
		{"11.43x23mm",3},
		{"5.56x45mm",1},
		{".308 Winchester",4},
		{"9x19mm",4},
		{"12 Gauge",5},
		{"9x18mm",9},
		{"1866 Slug",2},
		{"Revolver",4},
		{"Bengala",7},
		{"Analgésicos",2},
		{"Bolsa termica",4},
		{"Mochila Asalto",6},
	},

	["medical"] = {
		{"Curativo",43.48},
		{"Analgésicos",21.74},
		{"Morfina",21.74},
		{"Bolsa termica",4.35},
		{"Botiquin",0.12},
	},

	["military"] = {
		{"MRE",0.99},
		{"Dew",0.99},
		{"Curativo",3.96},
		{"Analgésicos",3.96},
		{"Morfina",0.99},
		{"5.45x39mm",0.99},
		{"7.62x39mm",0.99},
		{"7.62x51mm",0.99},
		{"5.56x45mm",0.99},
		{"11.43x23mm",4.95},
		{"9x19mm",0.99},
		{"12 Gauge",3.96},
		{"1866 Slug",3.96},
		{"9x18mm",1.98},
		{"Revolver",1.98},
		{"Bengala",4},
		{"Valla de alambre",1},
		{"Granada",0.99},
		{"Bolsa termica",3.96},
	},
}

setElementData(root,"zombiestotal",0)
setElementData(root,"zombiesalive",0)
setElementData(root,"spawnedzombies",0)
createTeam("Zombies")

function createZombieTable(player)
	setElementData(player,"PlayerZombies",{"no","no","no","no","no","no","no","no","no"})
	setElementData(player,"spawnedzombies",0)
end

function spawnZombies(x,y,z)
	x,y,z = getElementPosition(source)
	counter = 0
	if getElementData(source,"lastzombiespawnposition") then
		local xL,yL,zL = getElementData(source,"lastzombiespawnposition")[1] or false,getElementData(source,"lastzombiespawnposition")[2] or false,getElementData(source,"lastzombiespawnposition")[3] or false
		if xL then
			if getDistanceBetweenPoints3D (x,y,z,xL,yL,zL) < 50 then
				return
			end
		end
	end
	if getElementData(source,"spawnedzombies")+3 <= 3 then
		for i = 1, 2 do
			local x,y,z = getElementPosition(source)
			counter = counter+1
			local number1 = math.random(-20,20)
			local number2 = math.random(-20,20)
			randomZskin = math.random ( 1, table.getn ( ZombiePedSkins ) )	
			zombie = call (getResourceFromName("slothbot"),"spawnBot",x+number1,y+number2,z,math.random(0,360),ZombiePedSkins[randomZskin],0,0,getTeamFromName("Zombies"))
			setElementData(zombie,"zombie",true)
			setElementData(zombie,"blood", 1500)
			setElementData(zombie,"owner",source)
			call ( getResourceFromName ( "slothbot" ), "setBotGuard", zombie, x+number1,y+number2,z, false)
			setPedAnimation (zombie, "RYDER", "RYD_Die_PT1", -1, true, true, true)
			
			local checkZombieRunner = math.random(0, 50)
			if (checkZombieRunner >= 1 and checkZombieRunner <= 5) then
				setElementData(zombie,"blood",1500*1.5)
				setElementData(zombie,"zombieClass", "runner")
			end
		end
		setElementData(source,"lastzombiespawnposition",{x,y,z})
		setElementData(source,"spawnedzombies",getElementData(source,"spawnedzombies")+2)
	end
end
addEvent("createZomieForPlayer",true)
addEventHandler("createZomieForPlayer",root,spawnZombies)

function destroyZombieLoot(ped, col)
	if isElement(ped) and  isElement(col) then
		destroyElement(ped)
		destroyElement(col)
	end
end

local bodypartAnimation = {
	[9] = {"PED", "KO_shot_face"}, -- cabeza
	[3] = {"PED", "KO_shot_stom"}, -- pecho
	[8] = {"PED", "KD_right"}, -- pierna derecha
	[7] = {"PED", "KD_left"}, -- pierna izquierda
	[6] = {"PED", "KO_spin_R"}, -- brazo derecho
	[5] = {"PED", "KO_spin_L"}, -- brazo izquierdo
	[4] = {"PED", "KO_skid_back"}, -- culo
}

addEvent( "onZombieGetsKilled", true )
function lostblood (attacker,weapon,headshot,bodyparty)
	local ped = source
	if not isPedDead(ped) and isElement(ped) then
		local hour, minute = getTheTime()
		local x, y, z = getElementPosition(ped)
		local _, _, r = getElementRotation(ped)
		local zombloot = createPed(getElementModel(ped), x, y, z+0.5)
		local zombcol = createColSphere(x, y, z, 1.2)
		local class = getElementData(ped, "zombieClass")
		setElementRotation(zombloot, 0, 0, r)
		setElementData(zombloot, "BotTeam", getTeamFromName("Zombies"))
		setElementData(zombloot, "parent", zombcol)
		setElementData(zombcol, "parent", zombloot)
		setElementData(zombcol, "deadperson", true)
		setElementData(zombcol, "lootname", "Zombie")
		setElementData(zombcol, "MAX_Slots", 20)
		attachElements(zombcol, zombloot, 0, 0, 0)
		setElementData(zombcol, "info", "Al parecer esta muerto. (Hora: "..hour..":"..minute..", Arma: "..(weapon or "Desconocido")..")")
		setTimer(destroyZombieLoot, 60*1000*5, 1, zombloot, zombcol)

		if bodyparty then
			local block, anim = bodypartAnimation[bodyparty][1], bodypartAnimation[bodyparty][2]
			setTimer(setPedAnimation, 200, 1, zombloot, block, anim, -1, false, true, false)
			setTimer(setElementData, 500, 1, zombloot, "anim", {block, anim})
		else
			setTimer(setPedAnimation, 200, 1, zombloot, "PED", "KO_skid_front", -1, false, true, false)
			setTimer(setElementData, 500, 1, zombloot, "anim", {"PED", "KO_skid_front"})
		end
		
		setTimer(setElementHealth, 500, 1, zombloot, 0)
				
		local lootTable = ""
		local multiplier = 1
		for _, v in ipairs(ZombieLoot) do
			if class and class == "runner" then
				multiplier = 2
				lootTable = "runner"
			else
				if getElementModel(ped) == v[1] then
					lootTable = v[2]
				end
			end
		end

		local value = math.random(0, 200) / 2
		for _, v in ipairs(zombieLootType[lootTable] or {}) do
			if value <= 60 then
				local chance = percentChance(v[2], math.random(1, 3))
				if chance > 0 then
					local itemPlus = 1
					if v[1] == "12 Gauge" then
						itemPlus = 12
					elseif v[1] == "5.45x39mm" then
						itemPlus = 39
					elseif v[1] == "5.56x45mm" then
						itemPlus = 45
					elseif v[1] == "7.62x51mm" then
						itemPlus = 100
					elseif v[1] == "7.62x54mm" then
						itemPlus = 54
					elseif v[1] == "11.43x23mm" then
						itemPlus = 23
					elseif v[1] == "1866 Slug" then
						itemPlus = 10
					elseif v[1] == "9x18mm" then
						itemPlus = 18
					elseif v[1] == "9x19mm" then
						itemPlus = 19
					elseif v[1] == ".308 Winchester" then
						itemPlus = 14
					end
					setElementData(zombcol, v[1], itemPlus * multiplier)
				end
			end
		end
		
		if isElement(attacker) and (getElementType ( attacker ) == "player") and attacker ~= ped then
			setElementData ( attacker, "zombieskilled", ( getElementData ( attacker, "zombieskilled" ) or 0 ) + 1 )
			
			if headshot then
				setPedHeadless(zombloot, true)
				setElementData ( attacker, "headshots", ( getElementData ( attacker, "headshots" ) or 0 ) + 1 )
			end
		end

		local zombieCreator = getElementData(source,"owner")
		if zombieCreator then
			setElementData(zombieCreator,"spawnedzombies",getElementData(zombieCreator,"spawnedzombies")-1)
		end

		destroyElement(ped)
	end
end
addEventHandler( "onZombieGetsKilled", getRootElement(), lostblood )

function controlZombieSpawning()
	for i,ped in ipairs(getElementsByType("ped")) do
		if getElementData(ped,"zombie") then 
			goReturn = false
			local zombieCreator = getElementData(ped,"owner")
			if not isElement(zombieCreator) then 
				setElementData ( ped, "status", "dead" )	
				setElementData ( ped, "target", nil )
				setElementData ( ped, "leader", nil )
				destroyElement(ped)
				goReturn = true
			end
			if not goReturn then
				local x,y,z = getElementPosition(getElementData(ped,"owner"))
				local Zx,Zy,Zz = getElementPosition(ped)
					if getElementData(zombieCreator,"spawnedzombies")-1 >= 0 then
						setElementData(zombieCreator,"spawnedzombies",getElementData(zombieCreator,"spawnedzombies")-1)
					end	
					setElementData ( ped, "status", "dead" )	
					setElementData ( ped, "target", nil )
					setElementData ( ped, "leader", nil )
					destroyElement(ped)
				end
			end
		end				
	end		
setTimer(controlZombieSpawning,20000,0)

function botAttack(ped)
	if isElement(ped) then
		setPedAnimation(ped,false)
	end
	call ( getResourceFromName ( "slothbot" ), "setBotFollow", ped, source)
end
addEvent("botAttack",true)
addEventHandler("botAttack",root,botAttack)

function botStopFollow (ped)
	local x,y,z = getElementPosition(ped)
	call ( getResourceFromName ( "slothbot" ), "setBotGuard", ped, x, y, z, false)
end
addEvent("botStopFollow",true)
addEventHandler("botStopFollow",root,botStopFollow)