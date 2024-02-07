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

    SPAM.blockSpamTimer=setTimer(function() SPAM.blockSpamTimer=nil end, 500, 1)

    return block
end

local syncTimer={}
function setElementSyncData(player,name,value)
    if(not syncTimer[player])then
        setElementData(player,name,value)
    else
        setElementData(player,name,value,false)

        killTimer(syncTimer[player])
        syncTimer[player]=nil

        syncTimer[player]=setTimer(function()
            setElementData(player,name,value)
            syncTimer[player]=nil
        end, 1000, 1)
    end
end

local sw,sh=guiGetScreenSize()
local zoom=1920/sw
if(zoom > 1)then
	zoom=zoom/1.3
end

local edit=exports.px_editbox
local blur=exports.blur
local avatars=exports.px_avatars
local ranks = exports.px_admin:getRanks()

function getHex(admin, el)
    ranks = exports.px_admin:getRanks()
    
	if(ranks and ranks[admin])then
		return ranks[admin].hex
	elseif(getElementData(el, "user:gold"))then
		return "#d5ad4a"
	elseif(getElementData(el, "user:premium"))then
		return "#f1ee92"
	end
	return "#939393"
end

-- useful

function isMouseInPosition(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1], pos[2] = (pos[1] * sw), (pos[2] * sh)

	if pos[1] >= x and pos[1] <= (x + w) and pos[2] >= y and pos[2] <= (y + h) then
		return true
	end
	return nil
end

function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

--

local CHAT={}
CHAT.target=dxCreateRenderTarget(450/zoom, 400/zoom, true)
CHAT.messages={}

CHAT.minScroll=0
CHAT.maxScroll=0
CHAT.scroll=0

CHAT.assets={
    font={
        dxCreateFont(":px_assets/fonts/Font-SemiBold.ttf", 10/zoom, false, "antialiased"),
        dxCreateFont(":px_assets/fonts/Font-Bold.ttf", 12/zoom, false, "antialiased"),
		dxCreateFont(":px_assets/fonts/Font-ExtraBold.ttf", 12/zoom, false, "antialiased"),
    },

    tex={
        dxCreateTexture("assets/images/default.png", "argb", false, "clamp"),
		dxCreateTexture("assets/images/avatar_outline.png", "argb", false, "clamp"),
    }
}

CHAT.writing=false
CHAT.edit=false
CHAT.editPos={25/zoom, 450/zoom, 450/zoom, 30/zoom}
CHAT.writingActual=false
CHAT.type="normal"
CHAT.types={
    ["t"]={type="normal", desc="Chat normalny"}, -- normal
    ["y"]={type="Frakcja", desc="Chat frakcyjny"}, -- faction
    ["u"]={type="Służby", desc="Chat ogólno frakcyjny"}, -- factions
    ["o"]={type="Organizacja", desc="Chat organizacyjny"}, -- organization
    ["b"]={type="CB", desc="CB Radio"} -- cb radio
}

HUD={}
HUD.variables={
	logged=getElementData(localPlayer, "user:logged"),
	hud_disabled=false,
	showed_hud=false,
    chat_showed=false,
}

CHAT.scroll_update=false
CHAT.scroll_next=0
CHAT.scroll_tick=getTickCount()
CHAT.scroll_start=0

CHAT.isScrolling=false

CHAT.rtUpdate=function()
    local plus=CHAT.scroll
	dxSetRenderTarget(CHAT.target, true)
		local sY=0
		local x=0
		local height=0
		local heightY=0
		local max=400/zoom
		local visibled=0
		for k=1,#CHAT.messages do
			if(CHAT.messages[k])then
                x=x+1

                local w=CHAT.messages[k].avatar and isElement(CHAT.messages[k].avatar) and 400 or 450
                local texts=wordWrap(CHAT.messages[k].text, w/zoom, 1, CHAT.assets.font[2], false)

                local sX=0
                if(CHAT.messages[k].avatar and isElement(CHAT.messages[k].avatar))then
                    sX=sX+20/zoom

                    local r,g,b=unpack(CHAT.messages[k].avatarColor)
					dxDrawImage(0, sY-plus, 30/zoom, 30/zoom, CHAT.assets.tex[2], 0, 0, 0, tocolor(100, 100, 100, 255), false)
                    dxDrawImage(4, 4+sY-plus, 22/zoom, 22/zoom, CHAT.messages[k].avatar, 0, 0, 0, tocolor(255, 255, 255, 255), false)

                    sX=sX+15/zoom
                end

                local endPos=0
                if(CHAT.messages[k].authorInfo)then
                    endPos=20/zoom

                    local width=dxGetTextWidth(string.gsub(CHAT.messages[k].authorInfo, "#%x%x%x%x%x%x", ""), 1, CHAT.assets.font[3])+5/zoom
                    dxDrawTextShadow(CHAT.messages[k].authorInfo, sX+4, sY-plus, width+sX, 20/zoom+sY-plus+4/zoom, tocolor(255, 255, 255), 1, CHAT.assets.font[3], "left", "center", false, false, false, true)
					dxDrawTextShadow(CHAT.messages[k].date, sX+width+4, sY-plus, width+sX, 20/zoom+sY-plus+4/zoom, tocolor(160, 160, 160), 1, CHAT.assets.font[1], "left", "center", false, false, false, true)
				end

                local xx=0
                local hex=texts[1] and utf8.sub(texts[1], 0, 1) == "#" and utf8.sub(texts[1], 0, 7) or ""
                for i,v in pairs(texts) do
                    xx=xx+1

                    local width=dxGetTextWidth(string.gsub(v, "#%x%x%x%x%x%x", ""), 1, CHAT.assets.font[2])+15
                    local pY=(20/zoom)*(xx-1)
                    dxDrawTextShadow(hex..v, sX+4/zoom, endPos+pY+sY-plus+4/zoom, width+sX+4/zoom, 20/zoom+endPos+pY+sY-plus+4/zoom, CHAT.messages[k].color or tocolor(160, 160, 160), 1, CHAT.assets.font[2], "left", "center", false, false, false, true)           
                end

                endPos=endPos+(30/zoom*(xx))
                height=height+endPos
                sY=sY+endPos
			end
		end
        CHAT.maxScroll=height-400/zoom
        if(not CHAT.isScrolling)then
            CHAT.scroll=CHAT.maxScroll
        end
	dxSetRenderTarget()
end

function render()
    if(getSettingState("normal_chat"))then
        if(HUD.variables.hud_disabled or HUD.variables.showed_hud or not HUD.variables.logged or HUD.variables.chat_showed)then 
            showChat(false)
        else
            showChat(true)

            if(isChatBoxInputActive() and not getElementData(localPlayer,"user:writing"))then
                setElementData(localPlayer,"user:writing",true)
            elseif(not isChatBoxInputActive() and getElementData(localPlayer,"user:writing"))then
                setElementData(localPlayer,"user:writing",false)
            end
        end

        return
    else
        showChat(false)

        if(HUD.variables.hud_disabled or HUD.variables.showed_hud or not HUD.variables.logged or HUD.variables.chat_showed)then return end
    end

	if(CHAT.scroll_update)then
		CHAT.scroll=interpolateBetween(CHAT.scroll_start, 0, 0, CHAT.scroll_next, 0, 0, (getTickCount()-CHAT.scroll_tick)/100, "Linear")

        CHAT.isScrolling=true
		CHAT.rtUpdate()

		if((getTickCount()-CHAT.scroll_tick) > 100)then
            CHAT.scroll=CHAT.scroll_next
			CHAT.scroll_update=false
			CHAT.scroll_next=0
		end
	end

	dxDrawImage(25/zoom, 25/zoom, 450/zoom, 400/zoom, CHAT.target)

	if(CHAT.scrollClick and isCursorShowing() and CHAT.writing)then
		local cX,cY=getCursorPosition()
		cX,cY=cX*sw,cY*sh
		cY=cY-25/zoom

		if(cY < 0)then
			cY=0
		end
		if(cY > 400/zoom)then
			cY=400/zoom
		end

        CHAT.isScrolling=true
        CHAT.scroll=CHAT.maxScroll*(cY/(400/zoom))

        CHAT.rtUpdate()
	end

	if(CHAT.maxScroll > 0 and isCursorShowing() and CHAT.writing)then
		local scroll=350/zoom*(CHAT.scroll/CHAT.maxScroll)
        dxDrawRectangle(485/zoom, 25/zoom, 4/zoom, 400/zoom, tocolor(96,95,94, 255))
        dxDrawRectangle(485/zoom, 25/zoom+scroll, 4/zoom, 50/zoom, tocolor(165,165,163, 255), false)
    end
end

function click(btn,state)
	if(btn ~= "left")then return end

	if(isMouseInPosition(485/zoom, 25/zoom, 4/zoom, 400/zoom) and state and CHAT.maxScroll > 0)then
		CHAT.scrollClick=true
        CHAT.isScrolling=true
	else
		CHAT.scrollClick=false
        CHAT.isScrolling=false
    end

    if(isMouseInPosition(CHAT.editPos[1], CHAT.editPos[2], CHAT.editPos[3], CHAT.editPos[4]) and state == "down" and CHAT.writing)then
        CHAT.writingActual=not CHAT.writingActual
    elseif(not isMouseInPosition(CHAT.editPos[1], CHAT.editPos[2], CHAT.editPos[3], CHAT.editPos[4]) and state == "down" and CHAT.writing)then
        CHAT.writingActual=false
    end
end

function key(key,press)
    if(getSettingState("normal_chat"))then return end
    if(HUD.variables.hud_disabled or HUD.variables.showed_hud or not HUD.variables.logged)then return end

    if(press and not CHAT.writingActual and not isCursorShowing() and not CHAT.writing)then
        if(CHAT.types[key] and not getElementData(localPlayer, "user:gui_showed"))then
            CHAT.writing=true
            CHAT.writingActual=true
            CHAT.type=CHAT.types[key].type

            CHAT.edit=edit:dxCreateEdit(CHAT.types[key].desc..":", CHAT.editPos[1], CHAT.editPos[2], CHAT.editPos[3], CHAT.editPos[4], false, 11/zoom, 255, false, 90, false, false, false, true)

            showCursor(true,false)

            setElementSyncData(localPlayer, "user:writing", true)

            setElementSyncData(localPlayer, "user:gui_showed", resourceRoot, false)
        end
    elseif(key == "enter" and press and CHAT.writing)then
        local text=edit:dxGetEditText(CHAT.edit)
        if(#text > 0)then
            if(SPAM.getSpam())then return end

            CHAT.writingActual=false
            CHAT.writing=false

            if(CHAT.edit)then
				edit:dxDestroyEdit(CHAT.edit)
				CHAT.edit=false
            end

            triggerServerEvent("chat:sendMessage", resourceRoot, text, CHAT.type)

            showCursor(false)

            setElementSyncData(localPlayer, "user:writing", false)

            setElementSyncData(localPlayer, "user:gui_showed", false, false)
        else
            CHAT.writingActual=false
            CHAT.writing=false

            if(CHAT.edit)then
				edit:dxDestroyEdit(CHAT.edit)
				CHAT.edit=false
            end

            showCursor(false)

            setElementSyncData(localPlayer, "user:writing", false)

            setElementSyncData(localPlayer, "user:gui_showed", false, false)
        end
    elseif(key == "escape" and press and CHAT.writing)then
        cancelEvent()

        CHAT.writing=false

        if(CHAT.edit)then
            edit:dxDestroyEdit(CHAT.edit)
            CHAT.edit=false
        end

        CHAT.writingActual=false

        showCursor(false)

        setElementSyncData(localPlayer, "user:writing", false)

        setElementSyncData(localPlayer, "user:gui_showed", false, false)
    end

	if(not isMouseInPosition(25/zoom, 25/zoom, 490/zoom, 400/zoom) or not CHAT.writing)then return end

	if(key == "mouse_wheel_up")then
		local last=CHAT.scroll
		local new=CHAT.scroll-50
		if(new < 0)then
			new=0
		end

		CHAT.scroll_update=true
		CHAT.scroll_start=last
		CHAT.scroll_next=new
		CHAT.scroll_tick=getTickCount()
	elseif(key == "mouse_wheel_down" and CHAT.maxScroll > 0)then
		local last=CHAT.scroll
		local new=CHAT.scroll+50
		if(new > CHAT.maxScroll)then
            new=CHAT.maxScroll
        end

		CHAT.scroll_update=true
		CHAT.scroll_start=last
		CHAT.scroll_next=new
		CHAT.scroll_tick=getTickCount()
    end
end

CHAT.loadAvatar=function(element)
	return avatars:getPlayerAvatar(element)
end

CHAT.addMessage=function(text, author, color, avatarLoad)
    if(#CHAT.messages > 10)then
        table.remove(CHAT.messages, 1)
    end

    local authorInfo=false
    local r,g,b=31,31,42
    local avatar=false
    local date=""
    if(isElement(author))then
        avatar=CHAT.loadAvatar(author)

        ranks = exports.px_admin:getRanks()
        local admin=getElementData(author, "user:admin")
        local hex=getHex(admin,author) or "#777777"
        authorInfo="#a39f9f["..getElementData(author, "user:id").."] "..hex..getPlayerMaskName(author)

        r,g,b=hex2rgb(hex)

        date="#a39f9f"..string.format("%02d", getRealTime().hour)..":"..string.format("%02d", getRealTime().minute)
    elseif(author)then
        authorInfo=author
    end

    if(avatarLoad and isElement(avatarLoad))then
        avatar=CHAT.loadAvatar(avatarLoad)

        ranks=exports.px_admin:getRanks()
        local admin=getElementData(avatarLoad, "user:admin")
        local hex=getHex(admin,avatarLoad) or "#777777"

        r,g,b=hex2rgb(hex)
    end

    CHAT.messages[#CHAT.messages+1]={text=text, author=author, authorInfo=authorInfo, color=color, avatar=avatar, avatarColor={r,g,b}, date=date}

    CHAT.rtUpdate()
    setTimer(function() CHAT.rtUpdate() end, 50, 1)
end
addEvent("chat:addMessage", true)
addEventHandler("chat:addMessage", root, CHAT.addMessage)
function addMessage(...) CHAT.addMessage(...) end

-- triggers

function handleCommand(input)
    local splittedInput = split(input, " ")
    local slashCmd = table.remove(splittedInput, 1)
    local cmd = utf8.sub(slashCmd, 2, utf8.len(slashCmd))

    local args = ""
    for _, arg in ipairs(splittedInput) do
        args = string.format("%s %s", args, arg)
    end
    args = utf8.sub(args, 2, utf8.len(args))

    return executeCommandHandler(cmd, args)
end

addEvent("chat:sendMessage", true)
addEventHandler("chat:sendMessage", resourceRoot, function(input)
    handleCommand(input)
end)

-- on stop

addEventHandler("onClientResourceStop", resourceRoot, function()
    local gui = getElementData(localPlayer, "user:gui_showed")
    if(gui and gui == source)then
        setElementSyncData(localPlayer, "user:gui_showed", false, false)
    end
end)

addEventHandler("onClientRestore", root, function(didClearRenderTargets)
    CHAT.rtUpdate()
end)

-- hud

addEventHandler("onClientElementDataChange", root, function(data, last, new)
    if(source == localPlayer)then
        data=string.sub(data, 6, #data)
        for i,v in pairs(HUD.variables) do
            if(i == data)then
                HUD.variables[data]=new
            end
        end
    end
end)

addEventHandler("onClientPlayerSpawn", localPlayer, function()
    for i,v in pairs(HUD.variables) do
        HUD.variables[i]=getElementData(localPlayer, "user:"..i)
    end
end)

-- useful

function getSettingState(name, element)
    local data=getElementData(element or localPlayer, "user:dash_settings") or {}
    return data[name] or false
end

-- on start

addEventHandler("onClientRender", root, render)
addEventHandler("onClientClick", root, click)
addEventHandler("onClientKey", root, key)

-- useful

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

function dxDrawTextShadow( text, x, y, w, h, color, fontSize, fontType, alignX, alignY, ... )
    dxDrawText( text:gsub("#%x%x%x%x%x%x", ""), x+1, y+1, w+1, h+1, tocolor(0, 0, 0, 255), fontSize, fontType, alignX, alignY, ... )
    dxDrawText( text, x, y, w, h, color, fontSize, fontType, alignX, alignY, ... )
end

-- names

function getPlayerMaskName(player)
	return getElementData(player, "user:nameMask") or getPlayerName(player)
end