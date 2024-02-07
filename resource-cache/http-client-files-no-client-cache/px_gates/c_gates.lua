--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

local blur=exports.blur

-- assets

local assets={
    fonts={},
    fonts_paths={
        {":px_assets/fonts/Font-Medium.ttf", 15},
    },

    textures={},
    textures_paths={
        "textures/bg.png",
        "textures/outline.png",
        "textures/gate.png",
    },
}

assets.create = function()
    for k,t in pairs(assets) do
        if(k=="fonts_paths")then
            for i,v in pairs(t) do
                assets.fonts[i] = dxCreateFont(v[1], v[2]/zoom)
            end
        elseif(k=="textures_paths")then
            for i,v in pairs(t) do
                assets.textures[i] = dxCreateTexture(v, "argb", false, "clamp")
            end
        end
    end
end

assets.destroy = function()
    for k,t in pairs(assets) do
        if(k == "textures" or k == "fonts")then
            for i,v in pairs(t) do
                if(v and isElement(v))then
                    destroyElement(v)
                end
            end
            assets.fonts={}
            assets.textures={}
        end
    end
end

-- variables

local ui={}

ui.info={}
ui.showed=false
ui.rt=false
ui.gatePos=0
ui.animate=false
ui.obj=false

-- functions

ui.onRender=function()
    toggleControl("fire",false)

    blur:dxDrawBlur(50/zoom, sh/2-266/2/zoom, 275/zoom, 266/zoom)
    dxDrawImage(50/zoom, sh/2-266/2/zoom, 275/zoom, 266/zoom, assets.textures[1])

    dxDrawRectangle(50/zoom, sh/2-266/2/zoom+45/zoom, 275/zoom, 1, tocolor(75,75,75))

    dxDrawText("System bram", 50/zoom, sh/2-266/2/zoom, 275/zoom+50/zoom, sh/2-266/2/zoom+45/zoom, tocolor(200,200,200), 1, assets.fonts[1], "center", "center")

    dxDrawImage(50/zoom+(275-143)/2/zoom, sh/2-266/2/zoom+80/zoom, 143/zoom, 143/zoom, assets.textures[2])
    dxDrawImage(50/zoom+(275-143)/2/zoom, sh/2-266/2/zoom+80/zoom, 143/zoom, 143/zoom, ui.rt)

    onClick(50/zoom+(275-143)/2/zoom, sh/2-266/2/zoom+80/zoom, 143/zoom, 143/zoom, function()
        ui.startAnim(getElementData(ui.obj,"page"))
    end)
end

ui.updateRT=function()
    if(not ui.rt)then return end

    dxSetRenderTarget(ui.rt,true)
        dxDrawImage(ui.gatePos+(143-121)/2/zoom, (143-126)/2/zoom, 121/zoom, 126/zoom, assets.textures[3])
    dxSetRenderTarget()
end

SPAM={}
SPAM.getSpam=function()
    local block=false

    if(SPAM.blockSpamTimer)then
        killTimer(SPAM.blockSpamTimer)
        exports.px_noti:noti("Zaczekaj jedną sekunde.", "error")
        block=true
    end

    SPAM.blockSpamTimer=setTimer(function() SPAM.blockSpamTimer=nil end, 1000, 1)

    return block
end

ui.startAnim=function(type)
    if(ui.animate or not ui.rt)then return end
    
    if(SPAM.getSpam())then return end

    if(type == "right")then
        triggerLatentServerEvent("open.gate", resourceRoot, ui.info, "right")

        ui.animate=true
        animate(ui.gatePos, 0, "Linear", 5000, function(a)
            ui.gatePos=a
            ui.updateRT()
        end, function()
            ui.animate=false
        end)
    elseif(type == "left")then
        triggerLatentServerEvent("open.gate", resourceRoot, ui.info, "left")

        ui.animate=true
        animate(ui.gatePos, (-143/zoom), "Linear", 5000, function(a)
            ui.gatePos=a
            ui.updateRT()
        end, function()
            ui.animate=false
        end)
    end
end

ui.create=function()
    if(getElementData(ui.obj,"page") == "right" and ui.gatePos == 0)then
        ui.gatePos=(-143/zoom)
    elseif(getElementData(ui.obj,"page") == "left" and math.abs(ui.gatePos) > 0)then
        ui.gatePos=0
    end

    blur=exports.blur
    
    assets.create()

    addEventHandler("onClientRender", root, ui.onRender)

    showCursor(true, false)

    ui.rt=dxCreateRenderTarget(143/zoom,143/zoom,true)
    ui.updateRT()
end

ui.destroy=function()
    assets.destroy()

    removeEventHandler("onClientRender", root, ui.onRender)

    showCursor(false)

    if(ui.rt and isElement(ui.rt))then
        destroyElement(ui.rt)
        ui.rt=false
    end

    ui.obj=false
    ui.info=false
end

addEvent("open.gui", true)
addEventHandler("open.gui", resourceRoot, function(info,obj)
    if(info and obj)then
        ui.info=info
        ui.obj=obj
    end

    ui.showed=not ui.showed
    if(ui.showed)then ui.create() else ui.destroy() end
end)

-- useful function created by Asper

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
