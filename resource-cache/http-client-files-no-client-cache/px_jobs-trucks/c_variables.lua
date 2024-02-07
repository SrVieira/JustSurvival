--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Project X (MTA)
]]

blur=exports.blur
scroll=exports.px_scroll

ui={}

ui.mapTexture=false

ui.blips={}
ui.zones={}

ui.orders={}
ui.maxRows=10
ui.selected=false
ui.info=false

ui.tick=0

ui.scroll=false

ui.elapsedTimeTick=getTickCount()
ui.elapsedTime=5

ui.vehicle=false
ui.upgrades={}

ui.types={
    ["petrol"]="Ropa",
    ["wood"]="Drewno",
    ["cars"]="Samochody",
    ["normal"]="Normalne"
}

ui.pos={}

function updatePos()
    ui.mapTexture=exports.px_map:getMapTexture()

    local w,h=dxGetMaterialSize(ui.mapTexture)
    ui.pos={
        [1]={sw/2-1423/2/zoom, sh/2-803/2/zoom, 1423/zoom, 803/zoom},
    
        [2]={sw/2-1423/2/zoom+80/zoom, sh/2-803/2/zoom+20/zoom, (w/3.5)/zoom, (h/3.5)/zoom},
        [3]={sw/2-1423/2/zoom, sh/2-803/2/zoom+625/zoom, 798/zoom, 30/zoom},
        [4]={sw/2-1423/2/zoom+20/zoom, sh/2-803/2/zoom+625/zoom, 798/zoom, sh/2-803/2/zoom+625/zoom+30/zoom},
        [5]={sw/2-1423/2/zoom+20/zoom, sh/2-803/2/zoom+625/zoom+45/zoom, 797/zoom, sh/2-803/2/zoom+625/zoom+30/zoom},
        [6]={sw/2-1423/2/zoom+20/zoom+260/zoom, sh/2-803/2/zoom+625/zoom+45/zoom, 798/zoom, sh/2-803/2/zoom+625/zoom+30/zoom},
        [7]={sw/2-1423/2/zoom+20/zoom+260/zoom+300/zoom, sh/2-803/2/zoom+625/zoom+45/zoom, 798/zoom, sh/2-803/2/zoom+625/zoom+30/zoom},
        [8]={sw/2-1423/2/zoom+20/zoom+260/zoom+300/zoom, sh/2-803/2/zoom+720/zoom, 30/zoom},
        [9]={sw/2-1423/2/zoom, sh/2-803/2/zoom+803/zoom-38/zoom, 797/zoom, 38/zoom},
    
        [10]={sw/2-1423/2/zoom+798/zoom, sh/2-803/2/zoom, 623/zoom, 72/zoom, 73/zoom, 30/zoom},
        [11]={sw/2-1423/2/zoom+798/zoom+200/zoom, sh/2-803/2/zoom, 30/zoom, 360/zoom},
        [12]={sw/2-1423/2/zoom+798/zoom+470/zoom, sh/2-803/2/zoom+(72-11)/2/zoom, 21/zoom, 11/zoom, 150/zoom},
    
        ["blip"]={22/zoom, 32/zoom}
    }
end

-- useful

table.size=function(t)
    local x=0; for i,v in pairs(t) do x=x+1; end; return x;
end

function checkAndDestroy(element)
    if(element and isElement(element))then
        destroyElement(element)
    end
end

-- mouse

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
	if(not isCursorShowing() or ui.animate)then return end

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

-- cuboids

c={}

c.places={}

c.render=function()
    local r=ui.info
    if(not r)then return end

    for _,element in pairs(ui.zones) do
        local pos=getColPolygonPoints(element)
        local z=getGroundPosition(r.point.pos[1], r.point.pos[2], r.point.pos[3])
        local color=tocolor(255,0,0)
        local el=getElementsWithinColShape(element)

        local elements=0
        for i,v in pairs(el) do
            if(getElementType(v) == "vehicle")then
                elements=elements+1
                if(elements > 1)then
                    color=tocolor(0,255,0)
                    ui.getPoint(_)
                    break
                end
            end
        end
        
        for i=1,#pos do
            if(pos[i+1])then
                local v=pos[i+1]
                local k=pos[i]
                dxDrawLine3D(k[1], k[2], z, v[1], v[2], z, color, 1)
            else
                local v=pos[1]
                local k=pos[i]
                dxDrawLine3D(k[1], k[2], z, v[1], v[2], z, color, 1)
            end
        end
    end
end

addEventHandler("onClientRender", root, function()
    local x,y,z=getElementPosition(localPlayer)
    for _,element in pairs(getElementsByType("colshape", resourceRoot)) do
        local pos=getColPolygonPoints(element)     
        for i=1,#pos do
            if(pos[i+1])then
                local v=pos[i+1]
                local k=pos[i]
                dxDrawLine3D(k[1], k[2], z, v[1], v[2], z, tocolor(255,0,0), 1)
            else
                local v=pos[1]
                local k=pos[i]
                dxDrawLine3D(k[1], k[2], z, v[1], v[2], z, tocolor(255,0,0) , 1)
            end
        end
    end
end)