--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

Marker.timeInfo={time=0,top={}}

Marker.startRace=function(id)
    local veh=getPedOccupiedVehicle(localPlayer)
    if(veh and getVehicleController(veh) == localPlayer)then
        if(id)then
			local VEHID=getElementData(veh, "vehicle:id")
			if(not VEHID)then return end
			
			if(Cutscene.Recording)then return end

            Race.start(id)
        end
    else
        exports.px_noti:noti("Aby rozpocząć wyścig, musisz znajdować się w pojeździe.", "error")
    end
end

function Marker.dxDrawPlace(text,x,y,w,h,c,id)
	local p=Marker.timeInfo.top[id] or {login="Brak",time=0}
	if(p)then
		dxDrawRectangle(x,y,w,h,tocolor(0,0,0,100))
		dxDrawText(text,x+1,y+1,w+x+1,h+y+1,tocolor(0,0,0),1,Assets.Fonts[4],"center","center")
		dxDrawText(text,x,y,w+x,h+y,c,1,Assets.Fonts[4],"center","center")

		local av=exports.px_avatars:getPlayerAvatar(p.login)
		if(av)then
			dxDrawImage(x+(124-48)/2/zoom,y+65/zoom,48/zoom,48/zoom,av)
			dxDrawImage(x+(124-48)/2/zoom,y+65/zoom,48/zoom,48/zoom,Assets.Textures.outline)
		end

		dxDrawText(p.login,x+1,y+56/zoom+60/zoom+1,w+x+1,h+y+1,tocolor(0,0,0),1,Assets.Fonts[4],"center","top")
		dxDrawText(p.login,x,y+56/zoom+60/zoom,w+x,h+y,tocolor(200,200,200),1,Assets.Fonts[4],"center","top")

		local time=convertTime(p.time)
		dxDrawText(time,x+1,y+56/zoom+87/zoom+1,w+x+1,h+y+1,tocolor(0,0,0),1,Assets.Fonts[4],"center","top")
		dxDrawText(time,x,y+56/zoom+87/zoom,w+x,h+y,c,1,Assets.Fonts[4],"center","top")
	end
end

function Marker.drawEntry(marker)
	if(Cutscene.Recording)then return end

	local w,h = s(590),s(30)
	local x,y = sx/2-w/2,sy*0.75

	dxDrawImage(x-75/zoom,y-(75-30)/2/zoom,75/zoom,75/zoom,Assets.Textures.icon)

	Marker.dxDrawPlace("ZŁOTO", x+24/zoom,y-25/zoom,124/zoom,38/zoom,tocolor(255,184,31),1)
	Marker.dxDrawPlace("SREBRO", x+24/zoom+196/zoom,y-25/zoom,124/zoom,38/zoom,tocolor(170,170,170),2)
	Marker.dxDrawPlace("BRĄZ", x+24/zoom+392/zoom,y-25/zoom,124/zoom,38/zoom,tocolor(88,57,25),3)

	dxDrawImage(x,y,w,h,Assets.Textures.linedots)

	local times=convertTime(Marker.timeInfo.time)
	if(times)then
		dxDrawText("Twój najlepszy czas:\n"..times,x+1,sy-100/zoom+1,sx-678/zoom+1,h+y+1,tocolor(0,0,0),1,Assets.Fonts[4],"right","top")
		dxDrawText("Twój najlepszy czas:\n#ffb81f"..times,x,sy-100/zoom,sx-678/zoom,h+y,tocolor(200,200,200),1,Assets.Fonts[4],"right","top",false,false,false,true)
	end

	dxDrawImage(sx-678/zoom-49/zoom, sy-328/zoom-49/zoom, 49/zoom, 49/zoom, Assets.Textures.button)
	dxDrawText("Aby podjąć próbę naciśnij", 0+1, sy-328/zoom-49/zoom+1, sx-678/zoom-49/zoom-10/zoom+1, sy-328/zoom+1,tocolor(0,0,0),1,Assets.Fonts[4],"right","center")
	dxDrawText("Aby podjąć próbę naciśnij", 0, sy-328/zoom-49/zoom, sx-678/zoom-49/zoom-10/zoom, sy-328/zoom,tocolor(200,200,200),1,Assets.Fonts[4],"right","center")
end

addEvent("Marker.getInfo", true)
addEventHandler("Marker.getInfo", resourceRoot, function(r,top)
	Marker.timeInfo={
		time=r,
		top=top
	}

	table.sort(Marker.timeInfo.top, function(a,b) return a.time < b.time end)
end)

local floor=math.floor
local format=string.format
function convertTime(milliseconds)
    if(milliseconds and tonumber(milliseconds) and milliseconds > 0)then
        seconds = floor(milliseconds / 1000);
        minutes = floor(seconds / 60);
        milliseconds = milliseconds % 1000;
        seconds = seconds % 60;
        minutes = minutes % 60;

        milliseconds=string.sub(milliseconds,0,2)
        return minutes..":"..format("%02d",seconds)..":"..format("%02d",milliseconds)
    end
    return "0:00:00"
end