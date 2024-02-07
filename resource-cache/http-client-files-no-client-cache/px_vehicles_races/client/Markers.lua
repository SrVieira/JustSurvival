
------------------------------------------------
-- Markery wyścigów, clientside
-- Autor: northez
-- Wykonano dla projektu Project X
------------------------------------------------

local CreatedMarkers = {}

sx,sy = guiGetScreenSize()

zoom = 1

local fh = 1920

if sx < fh then
  zoom = math.min(2,fh/sx)
end

s = function(n) return n/zoom end

Marker = {
	iconSize = 3.4,
	textAnimationSize = 0.1,
	textOffset = Vector3(0,0,1.2),

	boxSize = 500,
	imageSize = 360,
	Streamed = {},

	current = nil,
	key = "x",
}

Assets = {
	TexturesList = {
		"button",
		"flags",
		"icon",
		"floor",
		"linedots",
		"upline",
		"rights",
		"new-time",
		"st",
		"outline",
		"space",
		"podium",
		"your_time",
	},

	FontsList = {
		{"ExtraBold",11},
		{"ExtraBold",16},
		{"Medium",26},
		{"Bold",14},
		{false,60},
		{"ExtraBold",12},
	}
}

Marker.tick=getTickCount()

local raceRT={}

function Assets.create()
	Assets.Textures = {}
	for _,v in ipairs(Assets.TexturesList) do
		Assets.Textures[v] = dxCreateTexture("files/"..v..".png","argb",false,"clamp")
	end

	Assets.Fonts = {}
	for i,v in ipairs(Assets.FontsList) do
		local path=v[1] and ":px_assets/fonts/Font-"..v[1]..".ttf" or "files/font.ttf"
		Assets.Fonts[i] = dxCreateFont(path,v[2]/zoom)
	end
end
Assets.create()

function Assets.destroy()
	for _,v in ipairs(Assets.Textures) do
		if v and isElement(v) then
			destroyElement(v)
		end
	end
	Assets.Textures = {}

	for _,v in ipairs(Assets.Fonts) do
		if v and isElement(v) then
			destroyElement(v)
		end
	end
	Assets.Fonts = {}
end

local Properties = {
	color = {238,206,59},
	radius = 4.2,
	icon = "files/icons/house.png",
}

function Marker.drawMarker(marker)
	local data=getElementData(marker,"record") or {time=0,login="brak"}

	local record=convertTime(data.time)
	local recordPlayer=string.upper(data.login)

	raceRT[marker]=dxCreateRenderTarget(500/zoom,500/zoom,true)

	dxSetRenderTarget(raceRT[marker],true)
	
	dxDrawImage(Marker.boxSize/2-83,0,166,100,Assets.Textures.flags)
	dxDrawImage(Marker.boxSize/2-11,100,19,400,Assets.Textures.upline)
	dxDrawImage(Marker.boxSize/2-52,110,40,40,Assets.Textures.icon)

	dxDrawText("WYŚCIG",Marker.boxSize/2+11,100,0,0,white,1,Assets.Fonts[1])
	dxDrawText(getElementData(marker,"raceName"),Marker.boxSize/2+11,100+dxGetFontHeight(1,Assets.Fonts[1])*0.8,0,0,tocolor(87,222,134),1,Assets.Fonts[2])

	dxDrawText("REKORD",Marker.boxSize/2+11,100+dxGetFontHeight(1,Assets.Fonts[1])*2.2,0,0,white,1,Assets.Fonts[1])
	dxDrawText(record or "00:00:00",Marker.boxSize/2+11,100+dxGetFontHeight(1,Assets.Fonts[1])*3,0,0,tocolor(87,222,134),1,Assets.Fonts[1])

	dxDrawText("REKORDZISTA: #ffffff"..(recordPlayer or "BRAK"),-50,0,0,0,tocolor(87,222,134),1,Assets.Fonts[1],"center","top",false,false,false,true,false,270,225,0)

	dxSetRenderTarget()
end

Marker.rotation=0
function Marker.renderMarkers(marker)
	if(getElementDimension(marker) ~= getElementDimension(localPlayer))then return end

	if not Properties then 
		return
	end

	local t = getTickCount()

	local color = {255,255,255,210}

	if isElementWithinMarker(localPlayer,marker) or localPlayer.vehicle and localPlayer.vehicle:isWithinMarker(marker) and localPlayer.vehicle then
		if Marker.current ~= marker then
			Marker.current = marker
		end

		Marker.drawEntry(marker)
	end

	local mx,my,mz = getElementPosition(marker)
	mz=getGroundPosition(mx,my,mz)+0.2
	
	if Properties.icon then
		local markerIconSize = Marker.iconSize
		local animationSize = 0.1
		if Properties.radius then
			markerIconSize = Properties.radius
			animationSize = markerIconSize / Marker.iconSize * 0.1
		end
		local iconSize = markerIconSize - math.sin(t * 0.002) * animationSize		

		local direction = math.rad(Marker.rotation)
		local ox = math.cos(direction) * iconSize / 2
		local oy =  math.sin(direction) * iconSize / 2

		local alpha=255

		dxDrawMaterialLine3D(
			mx + ox,
			my + oy,
			mz,
			mx - ox,
			my - oy,
			mz,
			Assets.Textures.floor, 
			iconSize,
			tocolor(255,255,255,alpha),
			mx,
			my,
			mz + 1
		)
	end

	local px,py,pz = getElementPosition(localPlayer)
	local distance = getDistanceBetweenPoints3D(mx,my,mz,px,py,pz)
	if distance < 75 and Marker.current ~= marker and raceRT[marker] then
		local scale = 255

		local textSize = Properties.size or 7
		local textAnimationOffset = math.sin(t * 0.002) * 0.1

		dxDrawMaterialLine3D(
			mx, 
			my,
			mz + textSize / 2 + 1.2 + textAnimationOffset,
			mx,
			my,
			mz - textSize / 2 + 1.2 + textAnimationOffset,
			raceRT[marker],
			textSize,
			tocolor(255,255,255,scale),
			mx,
			my+2
		)
	end
end

function addMarkerToDraw(marker)
	if isElementStreamedIn(marker) then
		Marker.Streamed[marker] = true
		Marker.drawMarker(marker)
	end
end

addEventHandler("onClientRender",root,function()
	Marker.rotation=interpolateBetween(0, 0, 0, 180, 0, 0, (getTickCount()-Marker.tick)/5000, "SineCurve")
	for m in pairs(Marker.Streamed) do
		Marker.renderMarkers(m)
	end
end)

addEventHandler("onClientElementStreamIn",resourceRoot,function()
	if getElementData(source,"raceid") then
		addMarkerToDraw(source)
	end
end)

addEventHandler("onClientElementStreamOut",root,function()
	if Marker.Streamed[source] then
		Marker.Streamed[source] = nil

		if(raceRT[source])then
			destroyElement(raceRT[source])
			raceRT[source]=nil
		end
	end
end)

addEventHandler("onClientElementDestroy",root,function()
	if Marker.Streamed[source] then
		Marker.Streamed[source] = nil

		if(raceRT[source])then
			destroyElement(raceRT[source])
			raceRT[source]=nil
		end
	end
end)

addEventHandler("onClientKey",root,function(key,state)
	if key == Marker.key and state then
		if isMTAWindowActive() then return false end
		if not isElement(Marker.current) then return end
		if getElementInterior(localPlayer) ~= getElementInterior(Marker.current) then return end
		if getElementDimension(localPlayer) ~= getElementDimension(Marker.current) then return end
		if localPlayer:isWithinMarker(Marker.current) or (localPlayer.vehicle and localPlayer.vehicle:isWithinMarker(Marker.current)) then
			if(key == "x")then
				local _,_,z1=getElementPosition(Marker.current)
				local _,_,z2=getElementPosition(localPlayer)
				if(z2 > (z1+1))then return cancelEvent() end

				local vehs=getElementData(Marker.current, "raceVehicles")
				if(vehs)then
					if(vehs[getElementModel(getPedOccupiedVehicle(localPlayer))])then
						Marker.startRace(getElementData(Marker.current, "raceid"))
					else
						exports.px_noti:noti("Twoje auto nie może uczestniczyć w tym wyścigu!", "error")
					end
				else
					Marker.startRace(getElementData(Marker.current, "raceid"))
				end
			end

			cancelEvent()
		end	
	end
end)

addEventHandler("onClientMarkerLeave",resourceRoot,function(player)
	if player ~= localPlayer then return end

	if source == Marker.current then 
		Marker.current = nil 
	end
end)

-- create by psychol.

function Marker.create()
	for i,marker in pairs(getElementsByType("marker", resourceRoot)) do
		local id=List[getElementData(marker,"raceid")]
		if(id)then
			addMarkerToDraw(marker)
		end
	end
end
setTimer(function()
	Marker.create()
end, 500, 1)

-- useful

function findRotation( x1, y1, x2, y2 ) 
	local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) ) + 90
	return t < 0 and t + 360 or t
end

function getPointFromDistanceRotation(x, y, angler)
    local a = math.rad(270 - angler)
    local dx = math.cos(a)
    local dy = math.sin(a)
    return x+dx, y+dy
end