pickupItemTable = {}
pickupGroundTimer = {}
lootTable = {}
oldLootTable = {}
objectsLoot = {}

isRefreshing = false
removePickupItemTimer = 60000*5

Async:setPriority("low")
Async:setDebug(true)

function objectItemPositioning(object, item)
	for _, v in ipairs(itemLootTable) do
		if v[1] == item then
			local offx, offy, offz = getElementPosition(object)
			local rx, ry, rz = 0, 0, 0
			
			if getIDFromWeaponName(item) then
				rx, ry, rz = 275.61706542969, 110.79721069336, 110.88891601563
				
				if item == "Palanca" then
					rx, ry, rz = 90, 90, 0	
				elseif item == "Cuchillo" then
					rx, ry, rz = 90, 90, 0	
				elseif item == "Ballesta" then
					rx, ry, rz = 0, 13.036010742188, 358.92938232422
				end
			else
				if item == "Casco de aviador" or item == "Casco de moto" or item == "Casco de guerra" then
					offz = offz - 0.6
					ry = ry - 10
				elseif item == "Chaleco de policia" then
					offz = offz - 0.4
				elseif item == "Chaleco de guerra" then
					offz = offz - 0.4
					offx = offx + 1
				elseif item == "Chaleco civil" then
					offz = offz + 0.2
					ry = -90
				end
			end		

			setElementPosition(object, offx, offy, offz)
			setElementRotation(object, rx, ry, rz)
			setObjectScale(object, v[3])
			break
		end
	end
end

--[[
		if itemPlus and itemPlus > 0 then
			if value[1] == "12 Gauge" then
				itemPlus = 12 * math.random(1,3)
			elseif value[1] == "5.45x39mm" then
				itemPlus = 39 * math.random(1,3)
			elseif value[1] == "5.56x45mm" then
				itemPlus = 45 * math.random(1,3)
			elseif value[1] == "7.62x51mm" then
				itemPlus = 100 * math.random(1,3)
			elseif value[1] == "7.62x54mm" then
				itemPlus = 54 * math.random(1,3)
			elseif value[1] == "11.43x23mm" then
				itemPlus = 23 * math.random(1,3)
			elseif value[1] == "1866 Slug" then
				itemPlus = 10 * math.random(1,3)
			elseif value[1] == "9x18mm" then
				itemPlus = 18 * math.random(1,3)
			elseif value[1] == "9x19mm" then
				itemPlus = 19 * math.random(1,3)
			elseif value[1] == ".308 Winchester" then
				itemPlus = 14 * math.random(1,3)
			end
			
			setElementData(col, value[1], itemPlus)
]]