--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

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

function animate(f, t, easing, duration, onChange, onEnd, cel)
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

function wordWrap(text, maxwidth, scale, font, colorcoded)
    local lines = {}
    local words = split(text, " ") -- this unfortunately will collapse 2+ spaces in a row into a single space
    local line = 1 -- begin with 1st line
    local word = 1 -- begin on 1st word
    local endlinecolor
    while (words[word]) do -- while there are still words to read
        repeat
            if colorcoded and (not lines[line]) and endlinecolor and (not string.find(words[word], "^#%x%x%x%x%x%x")) then -- if on a new line, and endline color is set and the upcoming word isn't beginning with a colorcode
                lines[line] = endlinecolor -- define this line as beginning with the color code
            end
            lines[line] = lines[line] or "" -- define the line if it doesnt exist

            if colorcoded then
                local rw = string.reverse(words[word]) -- reverse the string
                local x, y = string.find(rw, "%x%x%x%x%x%x#") -- and search for the first (last) occurance of a color code
                if x and y then
                    endlinecolor = string.reverse(string.sub(rw, x, y)) -- stores it for the beginning of the next line
                end
            end

            lines[line] = lines[line]..words[word] -- append a new word to the this line
            lines[line] = lines[line] .. " " -- append space to the line

            word = word + 1 -- moves onto the next word (in preparation for checking whether to start a new line (that is, if next word won't fit)
        until ((not words[word]) or dxGetTextWidth(lines[line].." "..words[word], scale, font, colorcoded) > maxwidth) -- jumps back to 'repeat' as soon as the code is out of words, or with a new word, it would overflow the maxwidth

        lines[line] = string.sub(lines[line], 1, -2) -- removes the final space from this line
        if colorcoded then
            lines[line] = string.gsub(lines[line], "#%x%x%x%x%x%x$", "") -- removes trailing colorcodes
        end
        line = line + 1 -- moves onto the next line
    end -- jumps back to 'while' the a next word exists
    return lines
end

---

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

local font_1 = dxCreateFont(":px_assets/fonts/Font-Bold.ttf", 12/zoom)
local font_2 = dxCreateFont(":px_assets/fonts/Font-Regular.ttf", 10/zoom)

local bg=dxCreateTexture("assets/images/bg.png", "argb", false, "clamp")

local notis={
    info={tex=dxCreateTexture("assets/images/info_icon.png", "argb", false, "clamp"), name="Informacja", color={52,142,159}},
    error={tex=dxCreateTexture("assets/images/warn_icon.png", "argb", false, "clamp"), name="Uwaga", color={225, 76, 75}},
    success={tex=dxCreateTexture("assets/images/success_icon.png", "argb", false, "clamp"), name="Gratulacje", color={12,162,113}},
}

local tabela = {}

local blur=exports.blur

function gui()
    local last=0
	for i,v in pairs(tabela) do
        if(tonumber(v.czas) and (getTickCount()-v.tick) < (v.czas+500) or v.czas)then
            local y=getElementData(localPlayer, "radar") == "circle" and sh-350/zoom or sh-290/zoom
    		local posY = (getElementData(localPlayer, "user:hud_disabled") or not getElementData(localPlayer, "user:logged") or getElementDimension(localPlayer) ~= 0 or getElementInterior(localPlayer) ~= 0 or getElementData(localPlayer, "user:radar_disabled")) and sh-20/zoom or y
    		local postGUI=true
            local positionY=posY-last-v.height

            if(getElementData(localPlayer, "user:logged"))then
                blur:dxDrawBlur(v.posX/zoom, positionY, 404/zoom, v.height, tocolor(255,255,255, v.alpha), true)
                dxDrawImage(v.posX/zoom, positionY, 404/zoom, v.height, bg, 0, 0, 0, tocolor(255, 255, 255, v.alpha), true)
            else
                dxDrawImage(v.posX/zoom, positionY, 404/zoom, v.height, bg, 0, 0, 0, tocolor(255, 255, 255, v.alpha), true)
            end

            local text=notis[v.type].name
            dxDrawText(text, v.posX/zoom+20/zoom+1, positionY+12/zoom+1, 404/zoom+v.posX/zoom-75/zoom+1, v.height+positionY+1, tocolor(0,0,0, v.alpha), 1, font_1, "left", "top", false, true, postGUI)
            dxDrawText(text, v.posX/zoom+20/zoom, positionY+12/zoom, 404/zoom+v.posX/zoom-75/zoom, v.height+positionY, tocolor(192,188,183, v.alpha), 1, font_1, "left", "top", false, true, postGUI)
            local w=dxGetTextWidth(text, 1, font_1)
            dxDrawImage(v.posX/zoom+20/zoom+w+6/zoom, positionY+12/zoom+4/zoom, 12/zoom, 12/zoom, notis[v.type].tex, 0, 0, 0, tocolor(255,255,255,v.alpha), true)

            dxDrawText(v.text, v.posX/zoom+20/zoom+1, positionY+35/zoom+1, 404/zoom+v.posX/zoom-75/zoom+1, v.height+positionY+1, tocolor(0,0,0, v.alpha), 1, font_2, "left", "top", false, true, postGUI)
            dxDrawText(v.text, v.posX/zoom+20/zoom, positionY+35/zoom, 404/zoom+v.posX/zoom-75/zoom, v.height+positionY, tocolor(192,188,183, v.alpha), 1, font_2, "left", "top", false, true, postGUI)

            if(tonumber(v.czas))then
                local time=v.czas
                local actual=(getTickCount()-v.tick)
                local t=actual > time and time or actual
                local x=(t/time)
                dxDrawRectangle(v.posX/zoom, positionY+v.height-1, 404/zoom, 1, tocolor(85,85,85), true)
                dxDrawRectangle(v.posX/zoom, positionY+v.height-1, (404/zoom)*x, 1, tocolor(unpack(notis[v.type].color)), true)
            else
                local r,g,b=unpack(notis[v.type].color)
                local a=interpolateBetween(255, 0, 0, 100, 0, 0, (getTickCount()-v.tick)/500, "SineCurve")
                dxDrawRectangle(v.posX/zoom, positionY+v.height-1, 404/zoom, 1, tocolor(r,g,b,a), true)
            end

    		if(v.dump > 1)then
    			dxDrawText("[x"..v.dump.."]", v.posX/zoom+75/zoom, positionY, 395/zoom+v.posX/zoom, positionY+v.height-5/zoom, tocolor(192,188,183, v.alpha), 1, font_2, "right", "bottom", false, true, postGUI)
    		end

            last=last+v.height+10/zoom
        end

        if(tonumber(v.czas))then
            if((getTickCount()-v.tick) > v.czas and not v.animate)then
                v.animate = true

                animate(36, -404, "InOutQuad", 500, function(a)
                    v.posX = a
                end)

                animate(v.alpha, 0, "InOutQuad", 500, function(a)
                    v.alpha = a
                end, function()
                    tabela[i]=nil

                    if(#tabela == 0)then
                        removeEventHandler("onClientRender", root, gui)
                        tabela={}
                    end
                end)
            end
        end

		if(not v.animates)then
			v.animates = true

			animate(0, 255, "InOutQuad", 500, function(a)
				v.alpha = a
			end)

			animate(-404, 36, "InOutQuad", 500, function(a)
				v.posX = a
			end)
		end
    end
end

function isDumping(text, type)
	local rtrn = false
	for i,v in pairs(tabela) do
		if(v.text == text and v.type == type)then
			v.dump = v.dump+1
			v.tick = getTickCount()
			rtrn = true
			break
		end
	end
	return rtrn
end

function noti(text, type, from, timeoff)
    blur=exports.blur
	dashboard=exports.px_dashboard
    
    type=type or "info"
    from=from or ""

	if(isDumping(text,type))then return end

    local lastRow=#tabela+1

	if(#tabela >= 5)then
        tabela[1]=nil
	end

    local wrap=wordWrap(text, (402-20-75)/zoom, 1, font_2, false)
    local height=dxGetFontHeight(1, font_2)
    local h=(height*#wrap)+50/zoom

	local time=timeoff or #text*150
    
    tabela[lastRow]={text=text, alpha=0, tick=getTickCount(), czas=time, posX=-404, dump=1, type=type, from=from, height=h}
	outputConsole(text)

	playSound("assets/sounds/info.mp3")

	if(#tabela == 1)then
		addEventHandler("onClientRender", root, gui)
	end

    return lastRow
end
addEvent("notka", true)
addEventHandler("notka", resourceRoot, function(data, type, timeoff, from)
    noti(data, type, from, timeoff)
end)

function notiSetText(id,text)
    local v=tabela[id]
    if(v)then
        local wrap=wordWrap(text, (402-20-75)/zoom, 1, font_2, false)
        local height=dxGetFontHeight(1, font_2)
        local h=(height*#wrap)+50/zoom
        v.text=text
        v.height=h
    end
end

function notiDestroy(id)
    if(tabela[id])then
        tabela[id].czas=100
        setTimer(function()
            tabela[id]=nil

            if(#tabela == 0)then
                removeEventHandler("onClientRender", root, gui)
            end
        end, 100, 1)
    end
end

function isNotificationExists()
	return #tabela > 0 and true or false
end