--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

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

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

local noti = exports.px_noti
local blur=exports.blur
local btns=exports.px_buttons
local edits=exports.px_editbox

local UI={}

UI.btns={}
UI.edits={}

-- main variables

local assets={
    fonts={},
    fonts2={},
    fonts_paths={
        {":px_assets/fonts/Font-Regular.ttf", 15/zoom},
        {":px_assets/fonts/Font-Regular.ttf", 13/zoom},
        {":px_assets/fonts/Font-Regular.ttf", 13/zoom},
        {":px_assets/fonts/Font-Regular.ttf", 11/zoom},
        {":px_assets/fonts/Font-Regular.ttf", 11/zoom},
    },

    textures={},
    textures_paths={
        "assets/textures/window.png",
        "assets/textures/logo.png",
        "assets/textures/close.png",

        "assets/textures/bank_bg.png",

        "assets/textures/user_icon.png",
        "assets/textures/bank_icon.png",

        "assets/textures/cost.png",
    },
}

assets.create = function()
    for k,t in pairs(assets) do
        if(k=="fonts_paths")then
            for i,v in pairs(t) do
                assets.fonts[i] = dxCreateFont(v[1], v[2])
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

--

function dxDrawButton(x,y,w,h,alpha,postGUI)
	dxDrawRectangle(x,y,w,h,tocolor(31,32,31,alpha),postGUI)

	dxDrawRectangle(x,y,w,1,tocolor(54,56,53,alpha),postGUI)
	dxDrawRectangle(x,y,1,h,tocolor(54,56,53,alpha),postGUI)
	dxDrawRectangle(x,y+h,w,1,tocolor(54,56,53,alpha),postGUI)
	dxDrawRectangle(x+w-1,y,1,h,tocolor(54,56,53,alpha),postGUI)
end

function dxDrawEdit(text,desc,x,y,w,h,icon)
    local ww,hh=dxGetMaterialSize(icon)
    dxDrawButton(x,y,w,h,75)
    dxDrawImage(x+(h-hh/zoom)/2,y+(h-hh/zoom)/2,ww/zoom,hh/zoom,icon,0,0,0)
    dxDrawRectangle(x+(h-hh/zoom)+ww/zoom, y+(h-20/zoom)/2, 1, 20/zoom, tocolor(200, 200, 200))
    dxDrawText(text, x+(h-hh/zoom)+ww/zoom+(h-hh/zoom)/2, y, w, h+y, tocolor(200, 200, 200), 1, assets.fonts[2], "left", "center")
    dxDrawText(desc, x, y-20/zoom, w, h, tocolor(200, 200, 200), 1, assets.fonts[4], "left", "top")
end

UI.draw=function()
    blur:dxDrawBlur(sw/2-710/2/zoom, sh/2-437/2/zoom, 710/zoom, 437/zoom, tocolor(255, 255, 255, 255))
    dxDrawImage(sw/2-710/2/zoom, sh/2-437/2/zoom, 710/zoom, 437/zoom, assets.textures[1])

    dxDrawImage(sw/2-646/2/zoom, sh/2-437/2/zoom+(79-55)/2/zoom+5/zoom, 152/zoom, 55/zoom, assets.textures[2])

    dxDrawImage(sw/2-710/2/zoom+710/zoom-10/zoom-(79-10)/2/zoom, sh/2-437/2/zoom+(79-10)/2/zoom, 10/zoom, 10/zoom, assets.textures[3])

    dxDrawRectangle(sw/2-646/2/zoom, sh/2-437/2/zoom+79/zoom, 646/zoom, 1, tocolor(85,85,85))

    -- left
    dxDrawText("Wniosek o otwarcie konta", sw/2-646/2/zoom, sh/2-437/2/zoom+79/zoom+20/zoom, 0, 0, tocolor(200, 200, 200), 1, assets.fonts[1], "left", "top")

    dxDrawEdit(getPlayerName(localPlayer), "Nazwa użytkownika", sw/2-646/2/zoom, sh/2-437/2/zoom+165/zoom, 365/zoom, 35/zoom, assets.textures[5])
    dxDrawEdit("Bank Las Venturas", "Oddział banku", sw/2-646/2/zoom, sh/2-437/2/zoom+165/zoom+70/zoom, 365/zoom, 35/zoom, assets.textures[6])

    -- prawo
    dxDrawText("Wymagania", sw/2-710/2/zoom+425/zoom, sh/2-437/2/zoom+79/zoom+20/zoom, 0, 0, tocolor(200, 200, 200), 1, assets.fonts[1], "left", "top")
    dxDrawText("- Przegrane 10 godzin\n- Posiadanie 5 poziomu", sw/2-710/2/zoom+425/zoom, sh/2-437/2/zoom+79/zoom+20/zoom+35/zoom, 0, 0, tocolor(186, 186, 186), 1, assets.fonts[2], "left", "top")

    dxDrawText("Korzyści", sw/2-710/2/zoom+425/zoom, sh/2-437/2/zoom+200/zoom, 0, 0, tocolor(200, 200, 200), 1, assets.fonts[1], "left", "top")
    dxDrawText("- Posiadanie karty debetowej\n- Darmowy dostęp do bankomatów\n- Wysyłanie przelewów", sw/2-710/2/zoom+425/zoom,  sh/2-437/2/zoom+200/zoom+35/zoom, 0, 0, tocolor(186, 186, 186), 1, assets.fonts[2], "left", "top")

    -- dol
    dxDrawImage(sw/2-710/2/zoom+40/zoom, sh/2-437/2/zoom+378/zoom, 15/zoom, 19/zoom, assets.textures[7])
    dxDrawText("Koszt: 1,500$", sw/2-710/2/zoom+70/zoom, sh/2-437/2/zoom+378/zoom, 15/zoom, 19/zoom+sh/2-437/2/zoom+378/zoom, tocolor(200, 200, 200), 1, assets.fonts[3], "left", "center")

    onClick(sw/2-710/2/zoom+710/zoom-10/zoom-(79-10)/2/zoom, sh/2-437/2/zoom+(79-10)/2/zoom, 10/zoom, 10/zoom, function()
        removeEventHandler("onClientRender", root, UI.draw)
        showCursor(false)
        UI.opened=false
        assets.destroy()

        for i,v in pairs(UI.btns) do
            btns:destroyButton(v)
        end

        for i,v in pairs(UI.edits) do
            edits:dxDestroyEdit(v)
        end
    end)

    onClick(sw/2-710/2/zoom+710/zoom-140/zoom-26/zoom, sh/2-437/2/zoom+437/zoom-37/zoom-26/zoom, 140/zoom, 37/zoom, function()
        local pin_1=edits:dxGetEditText(UI.edits[1]) or ""
        local pin_2=edits:dxGetEditText(UI.edits[2]) or ""
        if(pin_1 == pin_2 and #pin_1 == 4 and #pin_2 == 4 and tonumber(pin_1) and tonumber(pin_2))then
            if(getPlayerMoney(localPlayer) >= 1500)then
                local data=getElementData(localPlayer, "user:online_time")
                if(math.floor(data/60) >= 10)then
                    local level=getElementData(localPlayer, "user:level")
                    if(level >= 5)then
                        if(SPAM.getSpam())then return end

                        triggerServerEvent("open.account", resourceRoot, pin_1)

                        removeEventHandler("onClientRender", root, UI.draw)
                        showCursor(false)
                        UI.opened=false
                        assets.destroy()
                
                        for i,v in pairs(UI.btns) do
                            btns:destroyButton(v)
                        end

                        for i,v in pairs(UI.edits) do
                            edits:dxDestroyEdit(v)
                        end
                    else
                        noti:noti("Aby założyć konto musisz posiadasz minimalnie 5 poziom.", "error")
                    end
                else
                    noti:noti("Musisz mieć przegrane 10 godzin aby założyć konto.", "error")
                end
            else
                noti:noti("Założenie konta kosztuje 1,500$.", "error")
            end
        else
            noti:noti("Wprowadziłeś zły PIN.", "error")
        end
    end)
end

UI.opened=false

UI.open=function(self)
    if(UI.opened or self)then
        removeEventHandler("onClientRender", root, UI.draw)
        showCursor(false)
        UI.opened=false
        assets.destroy()

        for i,v in pairs(UI.btns) do
            btns:destroyButton(v)
        end

        for i,v in pairs(UI.edits) do
            edits:dxDestroyEdit(v)
        end
    else
        noti = exports.px_noti
        blur=exports.blur
        btns=exports.px_buttons
        edits=exports.px_editbox

        addEventHandler("onClientRender", root, UI.draw)
        showCursor(true)
        UI.opened=true
        assets.create()
        blur:dxDrawBlur(sw/2-710/2/zoom, sh/2-437/2/zoom, 710/zoom, 437/zoom, tocolor(255, 255, 255, 255))

        UI.btns[1]=btns:createButton(sw/2-710/2/zoom+710/zoom-140/zoom-26/zoom, sh/2-437/2/zoom+437/zoom-37/zoom-26/zoom, 140/zoom, 37/zoom, "WYŚLIJ WNIOSEK", 255, 7, false, false, ":px_bank_acc_create/assets/textures/button_icon.png")
    
        UI.edits[1]=edits:dxCreateEdit("PIN", sw/2-646/2/zoom, sh/2-437/2/zoom+300/zoom, 152/zoom, 35/zoom, false, 11/zoom, 255, true, false, ":px_bank_acc_create/assets/textures/pin_icon.png")
        UI.edits[2]=edits:dxCreateEdit("Powtórz PIN", sw/2-710/2/zoom+235/zoom, sh/2-437/2/zoom+300/zoom, 152/zoom, 35/zoom, false, 11/zoom, 255, true, false, ":px_bank_acc_create/assets/textures/pin_icon.png")
    end
end

-- triggers

addEvent("open.interface", true)
addEventHandler("open.interface", resourceRoot, function(self)
    UI.open(self)
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

addEventHandler("onClientResourceStop", resourceRoot, function()
    local gui = getElementData(localPlayer, "user:gui_showed")
    if(gui and gui == source)then
        setElementData(localPlayer, "user:gui_showed", false, false)
    end
end)

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
