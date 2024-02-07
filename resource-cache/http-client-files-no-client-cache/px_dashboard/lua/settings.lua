--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local menu={
    {name="Ustawienia rozgrywki", draw=function(texs,a)
        local pos={
            [1]=380/zoom,
            [2]=(380+700)/zoom
        }

        local lists={
            [1]={
                ["wood_pc"]={name="Tryb dla słabych PC"},
                ["voice_chat"]={name="Czat głosowy"},
                ["vehicles_sounds"]={name="Dźwięki pojazdów"},
                ["fps_counter"]={name="Licznik FPS"},
                ["showed_hud"]={name="Ukryj HUD"},
                ["premium_notis"]={name="Ukryj ogłoszenia"},
                ["private_messages"]={name="Blokada prywatnych wiadomości"},
                ["friends_invites"]={name="Blokada zaproszeń do znajomych"},
                ["radar_type"]={name="Radar kołowy"},
                ["3dmusic"]={name="Wyłącz muzyke 3D"},
                ["normal_chat"]={name="Standardowy czat"},
            },

            [2]={
                ["off_premium_chats"]={name="Wyłącz czaty GOLD/PREMIUM"},
                ["nametag_distance"]={name="Większa widzialność nicków (-FPS)"},
                ["street_map"]={name="Mapa z dzielnicami"},
            },
        }

        for key,t in pairs(lists) do
            local k=0
            for i,v in pairs(t) do
                k=k+1

                local sY=(71/zoom)*(k-1)
                dxDrawText(v.name, pos[key]+45/zoom, 272/zoom+sY, pos[key]+243/zoom+143/zoom, 272/zoom+sY+49/zoom, tocolor(150, 150, 150, a), 1, assets.fonts[2], "left", "center")

                local state=getSettingState(i)
                local aa=state and 100 or 255
                aa=aa > a and a or aa
                
                dxDrawImage(pos[key]+100/zoom+243/zoom, 272/zoom+sY, 143/zoom, 49/zoom, texs[2], 0, 0, 0, tocolor(255, 255, 255, aa))
                dxDrawRectangle(pos[key]+100/zoom+243/zoom, 272/zoom+sY+49/zoom-1, 143/zoom, 1, not state and tocolor(137,51,51,aa) or tocolor(80, 80, 80, aa))
                dxDrawText("Nie", pos[key]+100/zoom+243/zoom, 272/zoom+sY, pos[key]+100/zoom+243/zoom+143/zoom, 272/zoom+sY+49/zoom, tocolor(200, 200, 200, aa), 1, assets.fonts[2], "center", "center")
                onClick(pos[key]+100/zoom+243/zoom, 272/zoom+sY, 143/zoom, 49/zoom, function()
                    setSettingState(i, nil)
                end)
                
                local aa=state and 255 or 100
                aa=aa > a and a or aa
                dxDrawImage(pos[key]+100/zoom+243/zoom+164/zoom, 272/zoom+sY, 143/zoom, 49/zoom, texs[2], 0, 0, 0, tocolor(255, 255, 255, aa))
                onClick(pos[key]+100/zoom+243/zoom+164/zoom, 272/zoom+sY, 143/zoom, 49/zoom, function()
                    setSettingState(i, true)
                end)
                dxDrawRectangle(pos[key]+100/zoom+243/zoom+164/zoom, 272/zoom+sY+49/zoom-1, 143/zoom, 1, state and tocolor(57,121,48,aa) or tocolor(80, 80, 80, aa))
                dxDrawText("Tak", pos[key]+100/zoom+243/zoom+164/zoom, 272/zoom+sY, pos[key]+100/zoom+243/zoom+164/zoom+143/zoom, 272/zoom+sY+49/zoom, tocolor(200, 200, 200, aa), 1, assets.fonts[2], "center", "center")
            end                
        end
    end},

    {name="Ustawienia graficzne", draw=function(texs,a)
        local list={
            ["bloom"]={name="Bloom"},
            ["detals_contrast"]={name="Ostrość detali"},
            ["detals"]={name="Szczególność detali"},
            ["blur"]={name="Rozmycie radialne"},
            ["sky"]={name="Realistyczne niebo"},
            ["distance"]={name="Wysoki dystans rysowania"},
            ["winter"]={name="Klimat zimowy"},
            ["snow"]={name="Spadajace platki śniegu"},

        }

        local k=0
        for i,v in pairs(list) do
            k=k+1

            local sY=(71/zoom)*(k-1)
            dxDrawText(v.name, 380/zoom+45/zoom, 272/zoom+sY, 380/zoom+243/zoom+143/zoom, 272/zoom+sY+49/zoom, tocolor(150, 150, 150, a), 1, assets.fonts[2], "left", "center")

            local state=getSettingState(i)
            local aa=state and 100 or 255
            aa=aa > a and a or aa

            dxDrawImage(480/zoom+243/zoom, 272/zoom+sY, 143/zoom, 49/zoom, texs[2], 0, 0, 0, tocolor(255, 255, 255, aa))
            dxDrawRectangle(480/zoom+243/zoom, 272/zoom+sY+49/zoom-1, 143/zoom, 1, not state and tocolor(137,51,51,aa) or tocolor(80, 80, 80, aa))
            dxDrawText("Nie", 480/zoom+243/zoom, 272/zoom+sY, 480/zoom+243/zoom+143/zoom, 272/zoom+sY+49/zoom, tocolor(200, 200, 200, aa), 1, assets.fonts[2], "center", "center")
            onClick(480/zoom+243/zoom, 272/zoom+sY, 143/zoom, 49/zoom, function()
                setSettingState(i, nil)
            end)
            
            local aa=state and 255 or 100
            aa=aa > a and a or aa
            dxDrawImage(480/zoom+243/zoom+164/zoom, 272/zoom+sY, 143/zoom, 49/zoom, texs[2], 0, 0, 0, tocolor(255, 255, 255, aa))
            onClick(480/zoom+243/zoom+164/zoom, 272/zoom+sY, 143/zoom, 49/zoom, function()
                setSettingState(i, true)
            end)
            dxDrawRectangle(480/zoom+243/zoom+164/zoom, 272/zoom+sY+49/zoom-1, 143/zoom, 1, state and tocolor(57,121,48,aa) or tocolor(80, 80, 80, aa))
            dxDrawText("Tak", 480/zoom+243/zoom+164/zoom, 272/zoom+sY, 480/zoom+243/zoom+164/zoom+143/zoom, 272/zoom+sY+49/zoom, tocolor(200, 200, 200, aa), 1, assets.fonts[2], "center", "center")
        end
    end},
}

local selected=1

ui.rendering["Ustawienia"], desc=function(a, mainA)
    local uid=getElementData(localPlayer, "user:uid")
    if(not uid)then return end

    a=a > mainA and mainA or a

    local texs=assets.textures["Ustawienia"]
    if(not texs or (texs and #texs < 1))then return false end

    -- header
    dxDrawText("Ustawienia", 426/zoom, 63/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[5], "left", "top")
    dxDrawText("Zarządzaj rozgrywką, ustawieniami graficznymi oraz zabezpiecz swoje konto.", 426/zoom, 93/zoom, 0, 0, tocolor(150, 150, 150, a), 1, assets.fonts[1], "left", "top")
        
    dxDrawRectangle(381/zoom+1, 140/zoom, 1494/zoom, 1, tocolor(80,80,80,a > 50 and 50 or a))
    dxDrawImage(381/zoom+1, 140/zoom+1, 1279/zoom, 70/zoom, texs[1], 0, 0, 0, tocolor(255, 255, 255, a))

    local sX=0
    for i,v in pairs(menu) do
        local w=dxGetTextWidth(v.name, 1, assets.fonts[2])

        dxDrawText(v.name, 380/zoom+45/zoom+sX, 140/zoom+1+22/zoom, 380/zoom+45/zoom+sX+w, 20/zoom, tocolor(200, 200, 200, a), 1, assets.fonts[2], "center", "top")

        if(selected == i)then
            dxDrawRectangle(380/zoom+45/zoom+sX, 140/zoom+1+22/zoom+25/zoom, w, 1, tocolor(40,102,119,a))
        end

        onClick(380/zoom+45/zoom+sX, 140/zoom+1+22/zoom, w, 20/zoom, function()
            selected=i
        end)

        sX=sX+w+57/zoom
    end

    menu[selected].draw(texs,a)
end

-- useful

function getSettingState(name, element)
    local data=getElementData(element or localPlayer, "user:dash_settings") or {}
    return data[name] or false
end

function setSettingState(name, type)
    local data=getElementData(localPlayer, "user:dash_settings") or {}
    if((not type and data[name]) or type)then
        data[name]=type
        setElementData(localPlayer, "user:dash_settings", data)
    end
end

-- dystans rysowania

addEventHandler("onClientElementDataChange", root, function(data,last,new)
	if data == "user:dash_settings" then
		local state=getSettingState("distance")
        distance(state)

        local state=getSettingState("wood_pc")
        lowDistance(state)
	end
end)

local on = false
function distance(state)
	if state and not on then
        setFarClipDistance(10000)

		on = true
    elseif not state and on then
        resetFarClipDistance()

		on = false
	end
end

local on2 = false
function lowDistance(state)
	if state and not on2 then
        setFarClipDistance(200)

		on2 = true
    elseif not state and on2 then
        if(on)then
            setFarClipDistance(10000)
        else
            resetFarClipDistance()
        end

		on2 = false
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	local state=getSettingState("distance")
	distance(state)

	local state=getSettingState("wood_pc")
	lowDistance(state)
end)
