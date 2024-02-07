--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local sw,sh=guiGetScreenSize()
local zoom=1920/sw

local bZoom1=0.82 -- fhd
local bZoom2=1.09 -- fhd
bZoom1=bZoom1*zoom
bZoom2=bZoom2*zoom

local blur=exports.blur

local MAP={}

MAP.type="circle"

MAP.zoom=10
MAP.minZoom=5
MAP.maxZoom=20

MAP.hoverTick=getTickCount()

MAP.blur=false

MAP.fonts = {
	dxCreateFont(":px_assets/fonts/Font-SemiBold.ttf", 13/zoom),
}

MAP.circleBlips={
    [1]=true,
    [3]=true,
    [4]=true,
    [5]=true,
    [6]=true,
    [8]=true,
    [10]=true,
    [11]=true,
    [12]=true,
    [13]=true,
    [14]=true,
    [15]=true,
    [16]=true,
    [20]=true,
    [23]=true,
    [25]=true,
    [26]=true,
    [28]=true,
    [29]=true,
    [30]=true,
	[31]=true,
	[32]=true,
	[33]=true,
	[34]=true,
	[35]=true,
	[38]=true,
    [39]=true,
	[40]=true,
    [41]=true,
	[43]=true,
	[44]=true,
	[47]=true,
}

-- locations

MAP.location = {
    pos = {0, 0, 0},

    alpha_1 = 255,
    alpha_2 = 255,

    location_1 = "",
    location_2 = "",

    location_1_a = false,
    location_2_a = false,

    animation_time = 500
}

local x,y,z = getElementPosition(localPlayer)
MAP.location.location_1 = getZoneName(x, y, z, true)
MAP.location.location_2 = getZoneName(x, y, z, false)
setTimer(function()
	animate(MAP.location.alpha_1, 0, "Linear", MAP.location.animation_time, function(a)
		MAP.location.alpha_1 = a
	end)

	animate(MAP.location.alpha_2, 0, "Linear", MAP.location.animation_time, function(a)
		MAP.location.alpha_2 = a
	end)
end, 2500, 1)

-- settings

MAP.hudMaskShader = dxCreateShader("assets/shaders/hud_mask.fx")
MAP.updateType=function(type)
	if(type == "circle")then
		MAP.pos={36/zoom, sh-275/zoom-36/zoom, 275/zoom, 275/zoom}
		MAP.radarSize=MAP.pos[3]+MAP.pos[4]
		MAP.radarPositionCenter={MAP.pos[1]+(MAP.pos[3]/2),MAP.pos[2]+(MAP.pos[4]/2)}

		dxSetShaderValue(MAP.hudMaskShader, "sPicTexture", getMapTexture())
		dxSetShaderValue(MAP.hudMaskShader, "sMaskTexture", assets.textures.maskTexture)
	
		if(not MAP.blur)then
			local m=-10/zoom
			MAP.blur=exports.circleBlur:createBlurCircle(MAP.pos[1]+m/2, MAP.pos[2]+m/2, MAP.pos[3]-m, MAP.pos[4]-m, tocolor(255, 255, 255))
		else
			exports.circleBlur:visibleCircleBlur(MAP.blur,false)
		end

		setElementData(localPlayer, "radar", "circle")
	elseif(type == "rectangle")then
		MAP.pos={36/zoom, sh-230/zoom-36/zoom, 370/zoom, 230/zoom}
		MAP.radarSize=MAP.pos[3]+MAP.pos[4]
		MAP.radarPositionCenter={MAP.pos[1]+(MAP.pos[3]/2),MAP.pos[2]+(MAP.pos[4]/2)}

		dxSetShaderValue(MAP.hudMaskShader, "sPicTexture", getMapTexture())
		dxSetShaderValue(MAP.hudMaskShader, "sMaskTexture", assets.textures.maskTexture2)

		setElementData(localPlayer, "radar", "rectangle")

		if(MAP.blur)then
			exports.circleBlur:destroyBlurCircle(MAP.blur)
			MAP.blur=false
		end
	end
end

--

MAP.speedo=0

function getMapFromWorldPosition(x,y,vZoom)
	local _,_,rot=getElementRotation(localPlayer)
	local _,_,camrot = getElementRotation(getCamera())
	local px,py,pz=getElementPosition(localPlayer)
	local angle = findRotation(x, y, px, py)-camrot
	if(MAP.type == "rectangle")then
		newZoom=bZoom1*(MAP.maxZoom/vZoom)

		dist = getDistanceBetweenPoints2D(px, py, x, y)/newZoom
		x, y = getPointFromDistanceRotation(MAP.radarPositionCenter[1], MAP.radarPositionCenter[2], dist, angle)
		x, y = math.min(math.max(x, MAP.pos[1]), MAP.pos[1]+MAP.pos[3]), math.min(math.max(y, MAP.pos[2]), MAP.pos[2]+MAP.pos[4])				
	elseif(MAP.type == "circle")then
		newZoom=bZoom2*(MAP.maxZoom/vZoom)

		dist = math.min(getDistanceBetweenPoints2D(px, py, x, y)/newZoom, MAP.pos[3]/2)
		x, y = getPointFromDistanceRotation(MAP.radarPositionCenter[1], MAP.radarPositionCenter[2], dist, angle)
	end
	return x,y
end

MAP.onRender=function()
	if(not getElementData(localPlayer, "user:logged") or getElementData(localPlayer, "user:hud_disabled") or getElementData(localPlayer, "user:radar_disabled"))then 
		exports.circleBlur:visibleCircleBlur(MAP.blur,true)
		return 
	end

	if(isDim(localPlayer))then
		-- zoom update
		if((getKeyState("=") or getKeyState("num_add")) and not isChatBoxInputActive() and not isConsoleActive() and not isCursorShowing())then
			MAP.zoom = math.min(MAP.zoom+0.15, MAP.maxZoom)
		elseif((getKeyState("-") or getKeyState("num_sub")) and not isChatBoxInputActive() and not isConsoleActive() and not isCursorShowing())then
			MAP.zoom = math.max(MAP.zoom-0.15, MAP.minZoom)
		end
		--

		-- speed zoom
		local vZoom=MAP.zoom
		local v=getPedOccupiedVehicle(localPlayer)
		if(v)then
			MAP.speedo=getDistanceBetweenPoints3D(0,0,0,getElementVelocity(v))
			vZoom=MAP.zoom-(MAP.speedo*3)
			if(vZoom < 4)then
				vZoom=4
			end
		end
		--

		-- update radar
		local _,_,camrot = getElementRotation( getCamera() )
		local x,y = getElementPosition(localPlayer)
		x,y=x/6000,y/-6000

		dxSetShaderValue(MAP.hudMaskShader, "gUVPosition", x, y)
		dxSetShaderValue(MAP.hudMaskShader, "gUVRotAngle", math.rad(-camrot) )
		--

		if(MAP.type == "rectangle")then
			blur:dxDrawBlur(MAP.pos[1], MAP.pos[2], MAP.pos[3], MAP.pos[4], tocolor(255, 255, 255))
			dxDrawImage(MAP.pos[1], MAP.pos[2], MAP.pos[3], MAP.pos[4], assets.textures.radar, 0, 0, 0, tocolor(255, 255, 255, 255))

			local x1=MAP.pos[4]*100
			local x2=MAP.pos[3]*100
			local x=(x1/x2)
			local x,y=1/vZoom,1/(vZoom/x)
			dxSetShaderValue(MAP.hudMaskShader, "gUVScale", x, y)
		else
			exports.circleBlur:visibleCircleBlur(MAP.blur,false)

			local m=-10/zoom
			dxDrawImage(MAP.pos[1]+m/2, MAP.pos[2]+m/2, MAP.pos[3]-m, MAP.pos[4]-m, assets.textures.circleRadar, 0, 0, 0, tocolor(255, 255, 255, 255))
				
			dxSetShaderValue(MAP.hudMaskShader, "gUVScale", 1/vZoom, 1/vZoom)
		end

		-- draw map
		dxDrawImage(MAP.pos[1], MAP.pos[2], MAP.pos[3], MAP.pos[4], MAP.hudMaskShader, 0, 0, 0, tocolor(200, 200, 200, 222))
		--

		-- draw blips
		local newZoom=1*(MAP.maxZoom/vZoom)

		local gps=getGPSPositions()
		if(gps and #gps > 0)then
			for i,v in pairs(gps) do
				if(v.marker and getElementDimension(v.marker) == getElementDimension(localPlayer) and getElementInterior(v.marker) == getElementInterior(localPlayer))then
					local xx, yy = getElementPosition(localPlayer)
					local dist=getDistanceBetweenPoints2D(v.posX,v.posY, xx, yy)
					local max=40
					local distance=max*(MAP.maxZoom-MAP.zoom)
					if(dist <= distance)then
						local x,y=getMapFromWorldPosition(v.posX,v.posY,vZoom)

						local next=gps[i+1]
						if(next)then
							local x2,y2=getMapFromWorldPosition(next.posX,next.posY,vZoom)
							dxDrawLine(x, y, x2, y2, tocolor(255, 0, 0), 5)
						end
					end
				end
			end

			local v=gps[2]
			if(v)then
				local x,y=getMapFromWorldPosition(v.posX,v.posY,vZoom)
				if(x and y and v.marker and getElementDimension(v.marker) == getElementDimension(localPlayer) and getElementInterior(v.marker) == getElementInterior(localPlayer) and blip and isElement(blip))then
					local p1,p2=getElementPosition(localPlayer)
					local dist=getDistanceBetweenPoints2D(v.posX, v.posY, p1, p2)
					local max=40
					local distance=max*(MAP.maxZoom-MAP.zoom)
					if(dist <= distance)then
						local b1,b2=getElementPosition(blip)
						local bx,by=getMapFromWorldPosition(b1,b2,vZoom)

						dxDrawLine(x, y, bx, by, tocolor(255, 0, 0), 5, true)
					end
				end
			end
		end
		--

		local _,_,rot=getElementRotation(localPlayer)
		local _,_,camrot = getElementRotation(getCamera())
		local px,py,pz=getElementPosition(localPlayer)
		for k,v in pairs(getElementsByType("blip", true)) do
			if(localPlayer ~= getElementAttachedTo(v) and getElementDimension(v) == getElementDimension(localPlayer) and getElementInterior(v) == getElementInterior(localPlayer))then
				local x, y = getElementPosition(v)
				local dist=getDistanceBetweenPoints2D(px, py, x, y)
				if(dist <= (getBlipVisibleDistance(v) or 0))then
					-- pozycja blipu
					local angle = findRotation(x, y, px, py)-camrot
					if(MAP.type == "rectangle")then
						newZoom=bZoom1*(MAP.maxZoom/vZoom)

						dist = getDistanceBetweenPoints2D(px, py, x, y)/newZoom
						x, y = getPointFromDistanceRotation(MAP.radarPositionCenter[1], MAP.radarPositionCenter[2], dist, angle)
						x, y = math.min(math.max(x, MAP.pos[1]), MAP.pos[1]+MAP.pos[3]), math.min(math.max(y, MAP.pos[2]), MAP.pos[2]+MAP.pos[4])				
					elseif(MAP.type == "circle")then
						newZoom=bZoom2*(MAP.maxZoom/vZoom)

						dist = math.min(getDistanceBetweenPoints2D(px, py, x, y)/newZoom, MAP.pos[3]/2)
						x, y = getPointFromDistanceRotation(MAP.radarPositionCenter[1], MAP.radarPositionCenter[2], dist, angle)
					end
					--

					-- opcje blipu
					local blip_icon = getBlipIcon(v)
					local blip_size = getBlipIcon(v) == 0 and (20 / 2) * getBlipSize(v) or 35

					local a=255
					if(blip_icon == 27)then
						a=interpolateBetween(150, 0, 0, 255, 0, 0, (getTickCount()-MAP.hoverTick)/1000, "SineCurve")
					elseif(blip_icon == 18 or blip_icon == 42)then
						blip_size=20
					end

					local blip_color = getBlipIcon(v) == 0 and {getBlipColor(v)} or {255, 255, 255, a}
					local current_blip = findBlipTexture(blip_icon)

					local attached=getElementAttachedTo(v)
					if(attached and getElementType(attached) == "player" and isPlayerInFriends(attached))then
						blip_color={59, 186, 38,blip_color[4]}

						if(not getElementData(v, "friend:blip"))then
							setElementData(v, "friend:blip", getPlayerName(attached), false)
						end
					else
						if(getElementData(v, "friend:blip"))then
							setElementData(v, "friend:blip", false, false)
						end
					end
					--

					if(MAP.circleBlips[blip_icon])then
						dxDrawImage(x-blip_size/2/zoom, y-blip_size/2/zoom, blip_size/zoom, blip_size/zoom, assets.textures.circle, 0, 0, 0, tocolor(255,255,255, a), false)
					end

					dxDrawImage(x-blip_size/2/zoom, y-blip_size/2/zoom, blip_size/zoom, blip_size/zoom, current_blip, 0, 0, 0, tocolor(unpack(blip_color)), false)
				end
			end
		end

		-- draw arrow
		local _,_,rot=getElementRotation(localPlayer)
		rot=camrot-rot
		dxDrawImage(MAP.pos[1]+MAP.pos[3]/2-25/2/zoom, MAP.pos[2]+MAP.pos[4]/2-25/2/zoom, 25/zoom, 25/zoom, assets.textures.arrow, rot)

		-- map locations
		local text = ""
		local alpha = MAP.location.alpha_1 > 0 and MAP.location.alpha_1 or MAP.location.alpha_2
		if(MAP.type == "circle")then
			local text=string.upper(MAP.location.location_1)
			local width=dxGetTextWidth(text, 1, MAP.fonts[1])*1.1
			dxDrawRectangle(MAP.pos[1]+MAP.pos[3]+25/zoom, MAP.pos[2]+MAP.pos[4]-80/zoom, width, 30/zoom, tocolor(30,30,30, alpha > 180 and 180 or alpha))
			dxDrawText(text, MAP.pos[1]+MAP.pos[3]+25/zoom, MAP.pos[2]+MAP.pos[4]-80/zoom, width+MAP.pos[1]+MAP.pos[3]+25/zoom, 30/zoom+MAP.pos[2]+MAP.pos[4]-80/zoom, tocolor(190, 190, 190, alpha), 1, MAP.fonts[1], "center", "center", false)	
		
			local text=string.upper(MAP.location.location_2)
			local width=dxGetTextWidth(text, 1, MAP.fonts[1])*1.1
			dxDrawRectangle(MAP.pos[1]+MAP.pos[3], MAP.pos[2]+MAP.pos[4]-40/zoom, width, 30/zoom, tocolor(30,30,30, alpha > 180 and 180 or alpha))
			dxDrawText(text, MAP.pos[1]+MAP.pos[3], MAP.pos[2]+MAP.pos[4]-40/zoom, width+MAP.pos[1]+MAP.pos[3], 30/zoom+MAP.pos[2]+MAP.pos[4]-40/zoom, tocolor(190, 190, 190, alpha), 1, MAP.fonts[1], "center", "center", false)	
		else
			if(MAP.location.alpha_1 > 0)then
				if(#text > 0)then
					text = text..", "..MAP.location.location_1
				else
					text = MAP.location.location_1
				end
			end
		
			if(MAP.location.alpha_2 > 0)then
				if(#text > 0)then
					text = text..", "..MAP.location.location_2
				else
					text = MAP.location.location_2
				end
			end

			text=string.upper(text)

			local width=dxGetTextWidth(text, 1, MAP.fonts[1])*1.1	
			dxDrawRectangle(MAP.pos[1]+(MAP.pos[3]-width)/2, MAP.pos[2]+MAP.pos[4]-40/zoom, width, 30/zoom, tocolor(30,30,30, alpha > 180 and 180 or alpha))
			dxDrawText(text, MAP.pos[1]+(MAP.pos[3]-width)/2, MAP.pos[2]+MAP.pos[4]-40/zoom, width+MAP.pos[1]+(MAP.pos[3]-width)/2, 30/zoom+MAP.pos[2]+MAP.pos[4]-40/zoom, tocolor(190, 190, 190, alpha), 1, MAP.fonts[1], "center", "center", false)
		end

		local x,y,z = getElementPosition(localPlayer)
		if(MAP.location.location_1 ~= getZoneName(x, y, z, true) and not MAP.location.location_1_a)then
			MAP.location.location_1_a = true

			animate(MAP.location.alpha_1, 0, "Linear", MAP.location.animation_time, function(a)
				MAP.location.alpha_1 = a
			end, function()
				MAP.location.location_1 = getZoneName(x, y, z, true)

				animate(MAP.location.alpha_1, 255, "Linear", MAP.location.animation_time, function(a)
					MAP.location.location_1_a = false
					MAP.location.alpha_1 = a
				end, function()
					setTimer(function()
						animate(MAP.location.alpha_1, 0, "Linear", MAP.location.animation_time, function(a)
							MAP.location.location_1_a = false
							MAP.location.alpha_1 = a
						end)
					end, 2500, 1)
				end)
			end)
		end

		if(MAP.location.location_2 ~= getZoneName(x, y, z, false) and not MAP.location.location_2_a)then
			MAP.location.location_2_a = true

			animate(MAP.location.alpha_2, 0, "Linear", MAP.location.animation_time, function(a)
				MAP.location.alpha_2 = a
			end, function()
				MAP.location.location_2 = getZoneName(x, y, z, false)

				animate(MAP.location.alpha_2, 255, "Linear", MAP.location.animation_time, function(a)
					MAP.location.location_2_a = false
					MAP.location.alpha_2 = a
				end, function()
					setTimer(function()
						animate(MAP.location.alpha_2, 0, "Linear", MAP.location.animation_time, function(a)
							MAP.location.location_2_a = false
							MAP.location.alpha_2 = a
						end)
					end, 2500, 1)
				end)
			end)
		end
	else
		if(MAP.blur)then
			exports.circleBlur:visibleCircleBlur(MAP.blur,true)
		end
	end
end

MAP.loadRadar=function()
	MAP.updateType(MAP.type)

	addEventHandler("onClientHUDRender", root, MAP.onRender)
end
MAP.loadRadar()

-- core

function change_type(state)
	MAP.type=state and "circle" or "rectangle"
	MAP.updateType(MAP.type)

	removeEventHandler("onClientHUDRender", root, MAP.onRender)
	addEventHandler("onClientHUDRender", root, MAP.onRender)
end

addEventHandler("onClientElementDataChange", root, function(data,last,new)
	if data == "user:dash_settings" and source == localPlayer then
		local state=exports.px_dashboard:getSettingState("radar_type")
		change_type(state)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	local state=exports.px_dashboard:getSettingState("radar_type")
	change_type(state)
end)

-- assets

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function getPointFromDistanceRotation(x, y, dist, angle)

    local a = math.rad(90 - angle);
 
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
 
    return x+dx, y+dy;
 
end

-- friends

function isPlayerInFriends(player)
    local friends=getElementData(localPlayer, "friends:data") or {}
    local uid=getElementData(player, "user:uid")
    local inFriends=false
    for i,v in pairs(friends) do
        if(v.uid == uid)then
            inFriends=true
            break
        end
    end
    return inFriends
end

-- animate

local anims = {}
local rendering = false

local function renderAnimations()
    local now = getTickCount()
    for k,v in pairs(anims) do
        v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
        if(now >= v.start+v.duration)then
            table.remove(anims, k)
			if(type(v.onEnd) == "function")then
                v.onEnd()
            end
        end
    end

    if(#anims == 0)then
        rendering = false
        removeEventHandler("onClientRender", root, renderAnimations)
    end
end

function animate(f, t, easing, duration, onChange, onEnd)
	if(#anims == 0 and not rendering)then
		addEventHandler("onClientRender", root, renderAnimations)
		rendering = true
	end

    assert(type(f) == "number", "Bad argument @ 'animate' [expected number at argument 1, got "..type(f).."]")
    assert(type(t) == "number", "Bad argument @ 'animate' [expected number at argument 2, got "..type(t).."]")
    assert(type(easing) == "string", "Bad argument @ 'animate' [Invalid easing at argument 3]")
    assert(type(duration) == "number", "Bad argument @ 'animate' [expected number at argument 4, got "..type(duration).."]")
    assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
    table.insert(anims, {from = f, to = t, easing = easing, duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})

    return #anims
end

function destroyAnimation(id)
    if(anims[id])then
        anims[id] = nil
    end
end

-- on stop

addEventHandler("onClientResourceStop", resourceRoot, function()
    exports.circleBlur:destroyBlurCircle(MAP.blur)
end)

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and "ignore" argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end


function isMouseInPosition(x, y, w, h)
	if(not isCursorShowing())then return end

	local cx,cy=getCursorPosition()
	cx,cy=cx*sw,cy*sh

    if(isCursorShowing() and (cx >= x and cx <= (x + w)) and (cy >= y and cy <= (y + h)))then
        return true
    end
    return false
end

function getPosition(myX, myY, x, y, w, h)
    if(isCursorShowing() and (myX >= x and myX <= (x + w)) and (myY >= y and myY <= (y + h)))then
        return true
    end
    return false
end

local mouseState=false
local mouseTick=getTickCount()
local mouseClicks=0
local mouseClick=false
function onClick(x, y, w, h, fnc)
	if(not isCursorShowing())then return end

	if((getTickCount()-mouseTick) > 1000 and mouseClicks > 0)then
		mouseClicks=mouseClicks-1
	end

	if(not mouseState and getKeyState("mouse1"))then
		local cursor={getCursorPosition()}
        mouseState=cursor
    elseif(not getKeyState("mouse1") and (mouseClick or mouseState))then
        mouseClick=false
        mouseState=false
    end

    if(mouseState and mouseClicks < 10 and not mouseClick)then
		local cx,cy=unpack(mouseState)
        cx,cy=cx*sw,cy*sh

        if(getPosition(cx, cy, x, y, w, h))then
			fnc()

			mouseClicks=mouseClicks+1
            mouseTick=getTickCount()
            mouseClick=true
        end
	end
end

function isDim(player)
	if(getElementData(player,"user:admin"))then
		return true
	end

	if(getElementDimension(player) == 0 and getElementInterior(player) == 0)then
		return true
	end

	return false
end