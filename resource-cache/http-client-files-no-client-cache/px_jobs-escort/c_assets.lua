--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

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

-- useful

function checkAndDestroy(element)
    if(element and isElement(element))then
        destroyElement(element)
        element=nil
    end
end

function table.size(tbl)
    local k=0
    for i,v in pairs(tbl) do
        k=k+1
    end
    return k
end

function dxDrawShadowText(text,x,y,w,h,color,size,font,alignX,alignY)
    dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x+1,y+1,w+1,h+1,tocolor(0,0,0),size,font,alignX,alignY,false,false,false,true)
    dxDrawText(text,x,y,w,h,color,size,font,alignX,alignY,false,false,false,true)
end

function getElementAttachedObjects(element)
    local tbl=getAttachedElements(element)
    for i,v in pairs(tbl) do
        if(getElementType(v) ~= "object")then
            tbl[i]=nil
        end
    end
    return tbl
end