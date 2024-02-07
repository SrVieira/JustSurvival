function math.percentChance(percent,repeatTime)
	local hits = 0
	for i = 1, repeatTime do
	local number = math.random(0,200)/2
		if number <= (percent or 0.28) then
			hits = hits+1
		end
	end
	return hits
end

function percentChance(percent,repeatTime)
	local hits = 0
	for i = 1, repeatTime do
	local number = math.random(0,200)/2
		if number <= (percent or 0.28) then
			hits = hits+1
		end
	end
	return hits
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then 
		return math[method](number * factor) / factor
    else 
		return tonumber(("%."..decimals.."f"):format(number or 0)) 
	end
end

function getRotationOfCamera()
    local px, py, pz, lx, ly, lz = getCameraMatrix()
    local rotz = 6.2831853071796 - math.atan2 ( ( lx - px ), ( ly - py ) ) % 6.2831853071796
    local rotx = math.atan2 ( lz - pz, getDistanceBetweenPoints2D ( lx, ly, px, py ) )
    --Convert to degrees
    rotx = math.deg(rotx)
    rotz = -math.deg(rotz)	
    return rotx, 180, rotz
end

function table.merge(table1,...)
	for _,table2 in ipairs({...}) do
		for key,value in pairs(table2) do
			if (type(key) == "number") then
				table.insert(table1,value)
			else
				table1[key] = value
			end
		end
	end
	return table1
end

function convertTime ( ms ) 
    local min = math.floor ( ms / 60000 )
    local sec = math.floor ( ( ms / 1000 ) % 60 ) 
    return min, sec 
end 

function getTopPointRelativeOfElement(element,distance)
    local x, y, z = getElementPosition ( element )
    local rx, ry, rz = getElementRotation ( element )	
	y = y - (distance * math.sin(math.rad(rx)) )
	x = x + (distance * math.sin(math.rad(ry)) )  
	z = z + (distance * math.cos(math.rad(rx+ry)) )	
	return x,y,z
end

function table_size(t)
	local n = 0
	for _ in pairs(t) do
		n = n + 1
	end
	return n
end

function getPointFromDistanceRotation(x, y, dist, angle)
	local a = math.rad(90 - angle)
	local dx = math.cos(a) * dist
	local dy = math.sin(a) * dist
	return x+dx, y+dy
end

function findRotation(x1,y1,x2,y2) 
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
end

function isObjectAroundPlayer ( thePlayer, distance, height )
	local x, y, z = getElementPosition( thePlayer )
	for i = math.random(0,360), 360, 1 do
		local nx, ny = getPointFromDistanceRotation( x, y, distance, i )
		local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight ( x, y, z + height, nx, ny, z + height)
		if material == 0 then
			return material,hitX, hitY, hitZ
		end
	end
	return false
end

function isObjectAroundPlayer2 ( thePlayer, distance, height )
	material_value = 0
	local x, y, z = getElementPosition( thePlayer )
	for i = math.random(0,360), 360, 1 do
		local nx, ny = getPointFromDistanceRotation( x, y, distance, i )
		local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight ( x, y, z + height, nx, ny, z + height,true,false,false,false,false,false,false,false )
		if material == 0 then
			material_value = material_value+1
		end
		if material_value > 40 then
			return material,hitX, hitY, hitZ
		end
	end
	return false
end

function isMouseOnPosition(x, y, w, h)
	if not isCursorShowing() then return end
	if not x or not y or not w or not h then return end
	local cx, cy = getCursorPosition()
	local screenX, screenY = guiGetScreenSize()
	local px, py = cx*screenX, cy*screenY
	if (px >= x and px <= x + w and py >= y and py <= y + h) then
		return true
	end
	return false
end

function getAbsoluteCursorPosition()
	if not isCursorShowing() then return end
	local screenX, screenY = guiGetScreenSize()
	local cx, cy = getCursorPosition()
	return cx*screenX, cy*screenY
end

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        local x = (maxvalue*percent)/100
        return x
    end
    return false
end

function table.merge(table1,...)
	for _,table2 in ipairs({...}) do
		for key,value in pairs(table2) do
			if (type(key) == "number") then
				table.insert(table1,value)
			else
				table1[key] = value
			end
		end
	end
	return table1
end