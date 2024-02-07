--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- global variables

sw,sh=guiGetScreenSize()
zoom=1920/sw

ui={}

-- exports

local ranks=exports.px_admin:getRanks()
local avatars=exports.px_avatars

function getHex(admin, el, premium, gold)
    ranks=exports.px_admin:getRanks()
    
	if(ranks and ranks[admin])then
		return ranks[admin].hex
	elseif(gold)then
		return "#d5ad4a"
	elseif(premium)then
		return "#f1ee92"
	end
	return "#939393"
end

-- variables

ui.getDistance=function(pPos)
    local myPos={getCameraMatrix(localPlayer)}
    local dist=getDistanceBetweenPoints3D(myPos[1],myPos[2],myPos[3],pPos[1],pPos[2],pPos[3])
    if(dist and ui.distance and tonumber(dist) and tonumber(ui.distance))then
        return dist < ui.distance
    end

    ui.distance=20
    ui.stopDistance=10
    return dist < ui.distance
end

ui.distance=false
ui.stopDistance=false

ui.zone=false

ui.zoneElements={
    ["player"]={},
    ["ped"]={},
    ["vehicle"]={}
}

ui.dates={
    ["vehicle"]={
        ["text"]=true,
    },
    ["ped"]={
        ["ped:desc"]=true
    },
    ["player"]={
        ["user:admin"]=true,
        ["user:avatar"]=true,
        ["user:id"]=true,
        ["user:organization"]=true,
        ["user:faction"]=true,

        -- buble chat
        ["user:last_chat_message"]=true,

        -- icons
        ["user:writing"]=true,
        ["user:premium"]=true,
        ["user:mute"]=true,
        ["user:voice_off"]=true,
        ["user:voice_say"]=true,
        ["user:voice_mute"]=true,
        ["user:gold"]=true,

        -- faction afk
        ["user:factionAFK"]=true,

        -- dm
        ["user:nameMask"]=true,
    }
}

ui.typing={
    el={
        [1]={value=0,tick=getTickCount()},
        [2]={value=0,tick=getTickCount()+200},
        [3]={value=0,tick=getTickCount()+400}
    },

    change=800,
    anim=0.7,
}

ui.bubbleChatTime=5000

ui.fonts={
    dxCreateFont(":px_assets/fonts/Font-Regular.ttf", 14, false, "antialiased"),
    dxCreateFont(":px_assets/fonts/Font-Regular.ttf", 12, false, "antialiased"),
    dxCreateFont(":px_assets/fonts/Font-Regular.ttf", 10, false, "antialiased"),
    dxCreateFont(":px_assets/fonts/Font-SemiBold.ttf", 14, false, "antialiased"),
    dxCreateFont(":px_assets/fonts/Font-Medium.ttf", 9, false, "antialiased"),
}

ui.icons={"user:premium","user:mute","user:voice_off","user:voice_say","user:voice_mute"}

ui.textures={
    ["shadow"]=dxCreateTexture("textures/shadow.png", "argb", false, "clamp"),

    ["typing"]=dxCreateTexture("textures/typing.png", "argb", false, "clamp"),
    ["typing_circle"]=dxCreateTexture("textures/circle.png", "argb", false, "clamp"),

    ["user:premium"]=dxCreateTexture("textures/premka.png", "argb", false, "clamp"),
    ["user:mute"]=dxCreateTexture("textures/sad.png", "argb", false, "clamp"),
    ["user:voice_off"]=dxCreateTexture("textures/voicemode.png", "argb", false, "clamp"),
    ["user:voice_say"]=dxCreateTexture("textures/talk.png", "argb", false, "clamp"),
    ["user:voice_mute"]=dxCreateTexture("textures/mute-talk.png", "argb", false, "clamp"),
}

ui.factionsColors={
    ["SAPD"]={0,0,255},
    ["SACC"]={255,255,0},
    ["SARA"]={232, 153, 7},
	["PSP"]={231, 50, 50},
}

-- functions

ui.onRender=function()
    if(not getElementData(localPlayer, "user:logged") or not ui.zone or (ui.zone and not isElement(ui.zone)))then return end

    -- typing
    for i,v in pairs(ui.typing.el) do
        v.value=interpolateBetween(-ui.typing.anim, 0, 0, ui.typing.anim, 0, 0, (getTickCount()-v.tick)/ui.typing.change, "SineCurve")
    end
    --

    if(getElementData(localPlayer, "user:inv"))then
        local x,y,z=getCameraMatrix(localPlayer)
        detachElements(ui.zone)
        setElementPosition(ui.zone,x,y,z)
    else
        attachElements(ui.zone,localPlayer)
    end

    local admin=getElementData(localPlayer, "user:admin")

    -- draw vehs
    local cam={getCameraMatrix()}
    local myPos={getCameraMatrix(localPlayer)}

    for v,data in pairs(ui.zoneElements["vehicle"]) do
        if(isElement(v))then
            local text=data.text
            local pos={getElementPosition(v)}
            local sx,sy=getScreenFromWorldPosition(pos[1], pos[2], pos[3])
            if(sx and ui.getDistance(pos))then
                local distance=getDistanceBetweenPoints3D(myPos[1], myPos[2], myPos[3], pos[1], pos[2], pos[3])
                local x=getEasingValue(1-distance/ui.distance, "InOutQuad")
                local a=x*222

                dxDrawText(stripColors(data.text), sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, a), x, ui.fonts[1], "center", "center", false, false, false, true)
                dxDrawText(data.text, sx, sy, sx, sy, tocolor(200, 200, 200, a), x, ui.fonts[1], "center", "center", false, false, false, true)
            end
        else
            ui.zoneElements["vehicle"][v]=nil
        end
    end

    -- draw peds
    for v,data in pairs(ui.zoneElements["ped"]) do
        if(isElement(v))then
            local text=data["ped:desc"]
            local pos={getPedBonePosition(v, 5)}
            local sx,sy=getScreenFromWorldPosition(pos[1], pos[2], pos[3]+0.4)
            if(sx and ui.getDistance(pos))then
                local distance=getDistanceBetweenPoints3D(myPos[1], myPos[2], myPos[3], pos[1], pos[2], pos[3])
                local x=getEasingValue(1-distance/ui.distance, "InOutQuad")
                local a=x*222

                dxDrawText(stripColors(text.desc), sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, a), x, ui.fonts[3], "center", "top", false, false, false, true)
                dxDrawText(text.desc, sx, sy, sx, sy, tocolor(150, 150, 150, a), x, ui.fonts[3], "center", "top", false, false, false, true)
    
                dxDrawText(text.name, sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, a), x, ui.fonts[2], "center", "bottom", false, false, false, true)
                dxDrawText(text.name, sx, sy, sx, sy, tocolor(222, 222, 222, a), x, ui.fonts[2], "center", "bottom", false, false, false, true)
            end
        else
            ui.zoneElements["ped"][v]=nil
        end
    end

    -- draw players
    for v,data in pairs(ui.zoneElements["player"]) do
        if(isElement(v) and getElementType(v) == "player")then
            local pos={getPedBonePosition(v, 4)}
            local sx,sy=getScreenFromWorldPosition(pos[1], pos[2], pos[3]+0.55)
            if(sx and sy and ui.getDistance(pos))then
                local distance=getDistanceBetweenPoints3D(myPos[1], myPos[2], myPos[3], pos[1], pos[2], pos[3])
                local nick=getPlayerName(v)
                local mask=data["user:nameMask"]
                nick=mask and mask or nick

                local x=distance > ui.stopDistance and getEasingValue(0.7-(distance-ui.stopDistance)/(ui.distance-ui.stopDistance), "Linear") or 1-(0.3*(distance/ui.stopDistance))
                x=math.min(x,1)
                x=math.max(x,0)

                sx=sx-(x*42)/2

                local a=distance > ui.stopDistance and x*222 or 222

                local alpha_player=getElementAlpha(v)

                local hex=getHex(data["user:admin"], v, data["user:premium"], data["user:gold"])
                local rank=(data["user:admin"] and ranks and ranks[data["user:admin"]]) and ranks[data["user:admin"]].name or ""

                if(alpha_player > 0)then
                    alpha=a > alpha_player and alpha_player or a

                    local pos={x*100,x*42,x*10}

                    -- icons
                    local render={}
                    for i,v in pairs(ui.icons) do
                        if(data[v])then
                            render[#render+1]=v
                        end
                    end

                    local index=0
                    local nametag_width=(dxGetTextWidth(nick, x, ui.fonts[1]))+(dxGetTextWidth("["..data["user:id"].."]", x, ui.fonts[4]))+pos[2]+pos[3]

                    local icons_width=(x*30)*(#render)
                    for _,name in pairs(render) do
                        index=index+1

                        local pX=(x*30)*(index-1)
                        local s=x*25
                        dxDrawImage(sx-pos[2]-pos[3]+pX+(nametag_width-icons_width)/2, sy-(s*2), s, s, ui.textures[name], tocolor(255, 255, 255, a))
                    end

                    -- typing
                    if(data["user:writing"])then
                        local typing={x*(74/2), x*(48/2)}
                        local color=data["user:gold"] and tocolor(213, 173, 74, a) or data["user:premium"] and tocolor(241, 238, 146, a) or tocolor(255, 255, 255, a)
                        dxDrawImage(sx-pos[2]-pos[3]+nametag_width+(x*10), sy-(x*30), typing[1], typing[2], ui.textures["typing"], 0, 0, 0, color)
    
                        for i=1,3 do
                            local s=x*7
                            local sX=(x*8)*(i-1)
    
                            local color=data["user:gold"] and tocolor(133, 108, 46, a) or data["user:premium"] and tocolor(130, 129, 79, a) or tocolor(130, 130, 130, a)
                            dxDrawImage(sx-pos[2]-pos[3]+nametag_width+(x*19)+sX, sy-(x*22)+(x*ui.typing.el[i].value), s, s, ui.textures["typing_circle"], 0, 0, 0, color)
                        end
                    end

                    -- avatar
                    dxDrawImage(sx-pos[2]-(pos[1]-pos[2])/2-pos[3], sy-pos[2]/2-(pos[1]-pos[2])/2, pos[1], pos[1], ui.textures.shadow, 0, 0, 0, tocolor(255, 255, 255, a > 150 and 150 or a))

                    if(data["user:avatar"] and isElement(data["user:avatar"]))then
                        dxDrawImage(sx-pos[2]-pos[3], sy-pos[2]/2, pos[2], pos[2], data["user:avatar"], 0, 0, 0, tocolor(255, 255, 255, a))
                    else
                        data["user:avatar"]=exports.px_avatars:getPlayerAvatar(nick)
                    end

                    -- ranks
                    dxDrawText(rank, sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, a), x, ui.fonts[3], "left", "top", false, false, false, true)
                    dxDrawText(hex..rank, sx, sy, sx, sy, tocolor(222, 222, 222, a), x, ui.fonts[3], "left", "top", false, false, false, true)

                    -- nick
                    dxDrawText(nick, sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, a), x, ui.fonts[1], "left", #rank > 0 and "bottom" or "center", false, false, false, true)
                    dxDrawText(nick, sx, sy, sx, sy, tocolor(222, 222, 222, a), x, ui.fonts[1], "left", #rank > 0 and "bottom" or "center", false, false, false, true)

                    -- id
                    local w=dxGetTextWidth(nick, x, ui.fonts[1])+(x*5)
                    dxDrawText("["..data["user:id"].."]", sx+w+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, a), x, ui.fonts[4], "left", #rank > 0 and "bottom" or "center", false, false, false, true)
                    dxDrawText(hex.."["..data["user:id"].."]", sx+w, sy, sx, sy, tocolor(222, 222, 222, a), x, ui.fonts[4], "left", #rank > 0 and "bottom" or "center", false, false, false, true)

                    -- admin mask
                    if((admin and admin >= 3) and data["user:nameMask"])then
                        dxDrawText(getPlayerName(v), sx+1, sy+(x*15)+1, sx+1, sy+1, tocolor(0, 0, 0, a), x, ui.fonts[3], "left", "top", false, false, false, true)
                        dxDrawText(getPlayerName(v), sx, sy+(x*15), sx, sy, tocolor(200, 200, 200, a), x, ui.fonts[3], "left", "top", false, false, false, true)
                        sy=sy+(x*15)
                    end

                    -- org
                    if(data["user:organization"] and (getKeyState("lalt") or getKeyState("ralt")))then
                        dxDrawText(data["user:organization"], sx+1, sy+(x*15)+1, sx+1, sy+1, tocolor(0, 0, 0, a), x, ui.fonts[3], "left", "top", false, false, false, true)
                        dxDrawText(data["user:organization"], sx, sy+(x*15), sx, sy, tocolor(100, 100, 100, a), x, ui.fonts[3], "left", "top", false, false, false, true)
                        sy=sy+(x*15)
                    end

                    -- faction
                    if(data["user:faction"])then
                        local afk=data["user:factionAFK"]
                        local t=ui.factionsColors[data["user:faction"]]
                        local r,g,b=200,200,200
                        if(t)then
                            r,g,b=unpack(t)
                        end
                        
                        local text=data["user:faction"]
                        if(afk)then
                            text=text.." (S2)"
                        end
                        dxDrawText(text, sx+1, sy+(x*15)+1, sx+1, sy+1, tocolor(0, 0, 0, a), x, ui.fonts[3], "left", "top", false, false, false, true)
                        dxDrawText(text, sx, sy+(x*15), sx, sy, tocolor(r,g,b, a), x, ui.fonts[3], "left", "top", false, false, false, true)
                    end

                    -- bubble chat
                    local chat=data["last_messages"]
                    local index=0
                    if(chat)then
                        for _,k in pairs(chat) do
                            if((getTickCount()-k.tick) > ui.bubbleChatTime)then
                                chat[_]=nil
                            else
                                index=index+1

                                local w=dxGetTextWidth(k.text, x, ui.fonts[3])+(x*20)
                                local p={
                                    sx-pos[3]-pos[2]+(nametag_width-w)/2,
                                    sy+(x*25),
                                    w,
                                    20
                                }

                                local pY=(p[4]+(x*2))*(index-1)

                                dxDrawRoundedRectangle(p[1], p[2]+pY, p[3], p[4], 10, tocolor(30, 30, 30, a > 150 and 150 or a))
                                dxDrawText(k.text, p[1]+1, p[2]+pY+1, p[3]+p[1]+1, p[4]+p[2]+pY+1, tocolor(0, 0, 0, a), x, ui.fonts[3], "center", "center", false, false, false, true)
                                dxDrawText(k.text, p[1], p[2]+pY, p[3]+p[1], p[4]+p[2]+pY, tocolor(222, 222, 222, a), x, ui.fonts[3], "center", "center", false, false, false, true)
                            end
                        end
                    end
                elseif(admin)then
                    dxDrawText(getPlayerName(v).." - #000000("..rank..") ["..data["user:id"].."] (INV)", sx+1, sy+1, sx+1, sy+1, tocolor(0, 0, 0, a), x, ui.fonts[1], "center", "center", false, false, false, true)
                    dxDrawText(getPlayerName(v).." - "..hex.."("..rank..") ["..data["user:id"].."] #939393(INV)", sx, sy, sx, sy, tocolor(222, 222, 222, a), x, ui.fonts[1], "center", "center", false, false, false, true)
                end
            end
        end
    end

    -- cam head
    local x, y, z=getWorldFromScreenPosition(sw/2, sh/2, 10)
    setPedLookAt(getLocalPlayer(), x, y, z, 3000)

    -- afk key state
    if(afk.getKeyStates)then
        afk.getKeyStates()
    end
end

ui.insertTable=function(element)
    admin=exports.px_admin
    ranks=admin:getRanks()
    avatars=exports.px_avatars

    local el_type=getElementType(element)
    if(el_type == "vehicle" and getElementData(element, "text"))then
        ui.zoneElements[el_type][element]={["text"]=getElementData(element, "text")}
    elseif(el_type == "ped" and getElementData(element, "ped:desc"))then
        ui.zoneElements[el_type][element]={["ped:desc"]=getElementData(element, "ped:desc")}
    elseif(el_type == "player" and getElementData(element, "user:uid") and element ~= localPlayer)then
        ui.zoneElements[el_type][element]={
            ["user:admin"]=getElementData(element, "user:admin"),
            ["user:organization"]=getElementData(element, "user:organization"),
            ["user:faction"]=getElementData(element, "user:faction"),
            ["user:avatar"]=avatars:getPlayerAvatar(element),
            ["user:premium"]=getElementData(element, "user:premium"),
            ["user:gold"]=getElementData(element, "user:gold"),
            ["user:id"]=getElementData(element, "user:id"),
            ["user:writing"]=getElementData(element, "user:writing"),
            ["user:mute"]=getElementData(element, "user:mute"),
            ["user:voice_off"]=not exports.px_dashboard:getSettingState("voice_chat", element),
            ["user:voice_say"]=getElementData(element, "voice:say"),
            ["user:voice_mute"]=getElementData(element, "user:voice_mute"),
            ["last_messages"]={},
            ["user:factionAFK"]=getElementData(element, "user:factionAFK"),
            ["user:nameMask"]=getElementData(element, "user:nameMask"),
        }
    end
end

-- events

addEventHandler("onClientElementStreamIn", root, function()
    if(ui.zone and isElement(ui.zone) and getElementDimension(source) == getElementDimension(localPlayer) and isElementWithinColShape(source, ui.zone))then
        ui.insertTable(source)
    end
end)

addEventHandler("onClientColShapeHit", resourceRoot, function(element, dim)
    if(source ~= ui.zone)then return end

    if(dim)then
        ui.insertTable(element)
    end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(element, dim)
    if(source ~= ui.zone)then return end

    if(dim)then
        local el_type=getElementType(element)
        if(ui.zoneElements[el_type] and ui.zoneElements[el_type][element])then
            ui.zoneElements[el_type][element]=nil
        end
    end
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    local el_type=getElementType(source)
    if(not ui.dates[el_type] or (ui.dates[el_type] and not ui.dates[el_type][data]) or not ui.zoneElements[el_type] or (ui.zoneElements[el_type] and not ui.zoneElements[el_type][source]))then return end

    avatars=exports.px_avatars

    if(new)then
        if(data == "user:avatar")then
            ui.zoneElements[el_type][source][data]=avatars:getPlayerAvatar(source)
        elseif(data == "user:last_chat_message")then
            local v=ui.zoneElements[el_type][source]["last_messages"]
            if(not v)then
                ui.zoneElements[el_type][source]["last_messages"]={}
                v=ui.zoneElements[el_type][source]["last_messages"]
            end

            if(#v == 2)then
                table.remove(v, 1)
            end

            v[#v+1]={tick=getTickCount(), text=new}

            setElementData(source, "user:last_chat_message", false)
        else
            ui.zoneElements[el_type][source][data]=new
        end
    else
        if(ui.zoneElements[el_type][source][data])then
            ui.zoneElements[el_type][source][data]=nil
        end
    end
end)

-- useful

function RGBToHex(red, green, blue, alpha)

	-- Make sure RGB values passed to this function are correct
	if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
		return nil
	end

	-- Alpha check
	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end

end

function stripColors(text)
    local cnt=1
    while (cnt>0) do
      text,cnt=string.gsub(text,"#%x%x%x%x%x%x","")
    end
    return text
end

function math.lerp(a, b, k)
	local result = a * (1-k) + b * k
	if result >= b then
		result = b
	elseif result <= a then
		result = a
	end
	return result
end

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

-- on start
local players = getElementsByType("player")
for key, player in ipairs(players) do
    setPlayerNametagShowing(player, false)
end

-- state

local b = false
function setDashboardState(state,start)
    if(ui.zone)then
        destroyElement(ui.zone)
        ui.zone=false
    end

	if state and not b then
		ui.distance=50
        ui.stopDistance=25

		b = true
	elseif not state and b then
        ui.distance=20
        ui.stopDistance=10

        b = false
	end

    ui.zone=createColSphere(0,0,0,ui.distance or 20)
    attachElements(ui.zone,localPlayer)

    if(start)then
        for i,v in pairs(ui.zoneElements) do
            local elements=getElementsWithinColShape(ui.zone, i)
            if(elements and #elements > 0)then
                for i,v in pairs(elements) do
                    ui.insertTable(v)
                end
            end
        end

        addEventHandler("onClientRender", root, ui.onRender)
    end
end

addEventHandler("onClientElementDataChange", root, function(data)
	if data == "user:dash_settings" and source == localPlayer then
		local state=exports.px_dashboard:getSettingState("nametag_distance")
        setDashboardState(state)
	end
end)

addEventHandler("onClientPlayerSpawn", localPlayer, function()
    local state=exports.px_dashboard:getSettingState("nametag_distance")
    setDashboardState(state,true)
end)

if(getElementData(localPlayer, 'user:logged'))then
    local state=exports.px_dashboard:getSettingState("nametag_distance")
    setDashboardState(state,true)
end