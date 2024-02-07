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
        block=true
    end

    SPAM.blockSpamTimer=setTimer(function() SPAM.blockSpamTimer=nil end, 300, 1)

    return block
end

local sw,sh=guiGetScreenSize()
local zoom=1920/sw

local blur=exports.blur
local noti=exports.px_noti
local models=exports.px_models_encoder
local scroll=exports.px_scroll

UI={}

UI.models=models:getCustomModels()

UI.trigger=false

UI.items={
    -- kanistry
    ["Kanister 5L"]={type="kanister_paliwo_1",icon="canister"},

    -- naprawki
    ["Zestaw naprawczy"]={type="veh_fix_1",icon="toolkit_standard"},
    ["Zestaw naprawczy +"]={type="veh_fix_2",icon="toolkit_advanced"},
    ["Zestaw naprawczy opon"]={type="wheel_fix",icon="tire"},

    -- inne
    ["Paczka papierosów"]={type="papieros",icon="cigarette",use=20},
    ["Blant CBD"]={type="blant_cbd",icon="cannabis"},
    ["Browar"]={type="beer",icon="beer"},
    ["Wódka"]={type="vodka",icon="vodka"},

    -- apteczki
    ["Apteczka"]={type="aid",icon="aid"},

    -- weapons
    ["Kastet"]={icon="1",type="weapon"},
    ["Kij golfowy"]={icon="2",type="weapon"},
    ["Nóż"]={icon="4",type="weapon"},
    ["Kij do baseballa"]={icon="5",type="weapon"},
    ["Łopata"]={icon="6",type="weapon"},
    ["Katana"]={icon="8",type="weapon"},
    ["Deagle"]={icon="24",type="weapon",ammo=true},
    ["Strzelba"]={icon="25",type="weapon",ammo=true},
    ["Uzi"]={icon="28",type="weapon",ammo=true},
    ["MP5"]={icon="29",type="weapon",ammo=true},
    ["AK-47"]={icon="30",type="weapon",ammo=true},
    ["M4"]={icon="31",type="weapon",ammo=true},
    ["Spray"]={icon="41",type="weapon"},
    ["Kominiarka"]={icon="maska",type="maska"},
    ["Kamizelka 50%"]={icon="armor",type="kamizelka"},
    ["Kamizelka"]={icon="armor",type="kamizelka"},
    ["Plik pieniędzy"]={icon="plik",type="money"},
}

UI.itemsTextures={}

UI.itemsTextures["ammo"]=dxCreateTexture("assets/images/icons/ammo.png", "argb", false, "clamp")

for i,v in pairs(UI.items) do
    if(not UI.itemsTextures[i])then
        if(v.icon)then
            UI.itemsTextures[i]=dxCreateTexture("assets/images/icons/"..v.icon..".png", "argb", false, "clamp")
        else
            UI.itemsTextures[i]=dxCreateTexture("assets/images/icons/"..i..".png", "argb", false, "clamp")
        end
    end

    v.icon=UI.itemsTextures[i]
end

function getItemTexture(name)
    if(string.find(name,"Ammo"))then
        return UI.itemsTextures["ammo"]
    end
    return UI.itemsTextures[name]
end

-- main variables

local assets={
    fonts={},
    fonts2={},
    fonts_paths={
        {":px_assets/fonts/Font-Medium.ttf", 25},
        {":px_assets/fonts/Font-Regular.ttf", 12},
    },

    textures={},
    textures_paths={
        "assets/images/background.png",
        "assets/images/header_icon.png",

        "assets/images/waliza.png",
        "assets/images/row.png",
        "assets/images/row_hover.png",

        "assets/images/info_window.png",
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

-- ui

UI.table={}
for i=1,3 do
    local sY=(120/zoom)*(i-1)
    for i=1,5 do
        local sX=(136/zoom)*(i-1)
        UI.table[#UI.table+1]={sX=sX, sY=sY, alpha=255, hoverAlpha=0}
    end
end

UI.selectedItem=false
UI.scrollItem=false

UI.options={
    ["uzyj"]=function(id)
        if(not getPedOccupiedVehicle(localPlayer))then
            local items=getElementData(localPlayer, "user:eq")
            if(not items or (items and not items[id]))then return end

            UI.models=models:getCustomModels()
            triggerServerEvent("use.item", resourceRoot, id, UI.items[items[id].name], UI.models)
        end
    end,

    ["wyrzuc"]=function(id)
        if(not getPedOccupiedVehicle(localPlayer))then
            local items=getElementData(localPlayer, "user:eq")
            if(not items or (items and not items[id]))then return end

            if(items[id].name ~= "Kominiarka" and not utf8.find(items[id].name, "Kamizelka") and items[id].name ~= "Plik pieniędzy")then
                local pos={getElementPosition(localPlayer)}
                pos[3]=getGroundPosition(pos[1], pos[2], pos[3])
                pos[3]=pos[3]+0.2

                UI.models=models:getCustomModels()
                triggerServerEvent("drop.item", resourceRoot, items[id], id, pos, UI.models)
            else
                noti:noti("Nie możesz wyrzucić tego przedmiotu.", "error")
            end
        end
    end,
}

UI.updateItemPosition=function(id, value, name)
    if(UI.trigger or eq.trigger)then return end

    local items=getElementData(localPlayer, "user:eq")
    if(not items)then return end

    if(items[id])then
        if(getElementData(localPlayer, "user:haveWeapon") and items[id] and items[id].name and UI.items[items[id].name] and UI.items[items[id].name].type == "weapon")then
            exports.px_noti:noti("Najpierw odłóż broń.", "error")
            return
        end

        -- clipboard
        local cx,cy=getCursorPosition()
        if(eq.showed and eq.vehicle and isElement(eq.vehicle))then
            local px=sw-675/zoom
            local py=sh/2-150/zoom
            local clipboard=getElementData(eq.vehicle, "element:safe") or {}
            for x,v in pairs(eq.positions) do
                if(isMouseInPosition(px+v.sX+15/zoom, py+v.sY+64/zoom, 83/zoom, 75/zoom))then
                    if(clipboard[x])then
                        if(clipboard[x].name == items[id].name)then
                            clipboard[x].value=clipboard[x].value+items[id].value
                            items[id]=nil

                            triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items)
                            triggerServerEvent('set.Data', resourceRoot, eq.vehicle, "element:safe", clipboard)
                            UI.trigger=true
                        end
                    else
                        clipboard[x]=items[id]
                        items[id]=nil
    
                        triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items)
                        triggerServerEvent('set.Data', resourceRoot, eq.vehicle, "element:safe", clipboard)
                        UI.trigger=true
                    end
                end
            end
        end

        -- eq
        local row=math.floor(scroll:dxScrollGetPosition(UI.scroll)+1)
        local i=0
        for x=row,row+15 do
            i=i+1

            local v=UI.table[i]
            if(v)then
                if(isMouseInPosition(UI.pos[1]-340/zoom+v.sX, sh/2-180/zoom+v.sY, 133/zoom, 121/zoom) and x ~= id)then
                    local name=string.gsub(items[id].name, "Ammo ", "")
                    if(items[id] and string.find(items[id].name, "Ammo") and items[x] and items[x].name == name)then
                        local data=getElementData(localPlayer, "user:haveWeapon")
                        if(data)then
                            local weapon=getPedWeapon(localPlayer)
                            if(weapon == data.weaponID)then
                                items[x].ammo=(items[x].ammo or 0)+items[id].value
                                items[id]=nil

                                triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items)
                                UI.trigger=true
                            
                                triggerServerEvent("setPedWeaponAmmo", resourceRoot, weapon, items[x].ammo)
                            else
                                exports.px_noti:noti("Najpierw weź broń w rękę.", "error")
                            end
                        else
                            items[x].ammo=(items[x].ammo or 0)+items[id].value
                            items[id]=nil

                            triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items)
                            UI.trigger=true
                        end
                    else
                        if(value)then
                            if(items[x])then
                                if(items[x].name == items[id].name and UI.items[items[id].name].type ~= "weapon" and UI.items[items[id].name].type ~= "kamizelka" and UI.items[items[id].name].type ~= "maska")then
                                    items[x].value=items[x].value+1
        
                                    if(items[id].value == 1)then
                                        items[id]=nil
                                    else
                                        items[id].value=items[id].value-1
                                    end
                
                                    triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items)
                                    UI.trigger=true
                                end
                            else
                                items[x]={name=items[id].name,value=1,ammo=items[id].ammo}
        
                                if(items[id].value == 1)then
                                    items[id]=nil
                                else
                                    items[id].value=items[id].value-1
                                end
            
                                triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items)
                                UI.trigger=true
                            end
                        else
                            if(items[x])then
                                if(items[x].name == items[id].name and UI.items[items[id].name].type ~= "weapon" and UI.items[items[id].name].type ~= "kamizelka" and UI.items[items[id].name].type ~= "maska")then
                                    items[x].value=items[x].value+items[id].value
                                    items[id]=nil
        
                                    triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items)
                                    UI.trigger=true
                                end
                            else
                                if(x ~= id)then
                                    items[x]={name=items[id].name,value=items[id].value,ammo=items[id].ammo}
                                    items[id]=nil

                                    triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items)
                                    UI.trigger=true
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

UI.onRender=function()
    local items=getElementData(localPlayer, "user:eq")
    if(not items)then return end

    if(getElementData(localPlayer, "user:tank"))then return end

    toggleControl('forwards', false)
    toggleControl('backwards', false)
    toggleControl('left', false)
    toggleControl('right', false)

    -- tlo
    blur:dxDrawBlur(0, 0, sw, sh, tocolor(255, 255, 255, UI.alpha))
    dxDrawImage(0, 0, sw, sh, assets.textures[1], 0, 0, 0, tocolor(255, 255, 255, UI.alpha))

    if(UI.openType == "clipboard")then
        UI.pos={math.floor(1083/2/zoom+5/zoom),sh/2}

        drawClipboard()

        -- header
        dxDrawText("SCHOWEK", 0, 85/zoom, sw, sh, tocolor(200, 200, 200, UI.alpha), 1, assets.fonts[1], "center", "top")
        dxDrawImage(sw/2-dxGetTextWidth("SCHOWEK", 1, assets.fonts[1])/2-30/zoom, 97/zoom, 18/zoom, 22/zoom, assets.textures[2], 0, 0, 0, tocolor(255, 255, 255, UI.alpha))
        dxDrawRectangle(sw/2-409/2/zoom, 134/zoom, 409/zoom, 1, tocolor(85, 85, 85, UI.alpha))
        dxDrawText("#c2c2c2Aby dodać przedmiot, przeciągnij go z Twojego ekwipunku  do #2193b0schowka.#c2c2c2", 0, 150/zoom, sw, sh, tocolor(200, 200, 200, UI.alpha), 1, assets.fonts[2], "center", "top", false, false, false, true)
    else
        UI.pos={sw/2,sh/2}

        -- header
        dxDrawText("EKWIPUNEK", 0, 85/zoom, sw, sh, tocolor(200, 200, 200, UI.alpha), 1, assets.fonts[1], "center", "top")
        dxDrawImage(sw/2-dxGetTextWidth("EKWIPUNEK", 1, assets.fonts[1])/2-30/zoom, 97/zoom, 18/zoom, 22/zoom, assets.textures[2], 0, 0, 0, tocolor(255, 255, 255, UI.alpha))
        dxDrawRectangle(sw/2-409/2/zoom, 134/zoom, 409/zoom, 1, tocolor(85, 85, 85, UI.alpha))
        dxDrawText("#c2c2c2W #2193b0ekwipunku#c2c2c2 możesz znaleźć wszystkie posiadane\nprzez Ciebie przedmioty.", 0, 150/zoom, sw, sh, tocolor(200, 200, 200, UI.alpha), 1, assets.fonts[2], "center", "top", false, false, false, true)
    end

    local px=UI.pos[1]

    -- srodek
    dxDrawImage(px-1083/2/zoom, sh/2-752/2/zoom+35/zoom, 1083/zoom, 752/zoom, assets.textures[3], 0, 0, 0, tocolor(255, 255, 255, UI.alpha))

    local row=math.floor(scroll:dxScrollGetPosition(UI.scroll)+1)
    local i=0
    for x=row,row+15 do
        i=i+1

        local v=UI.table[i]
        if(v)then
            if(isMouseInPosition(px-340/zoom+v.sX, sh/2-180/zoom+v.sY, 133/zoom, 121/zoom) and not v.animate and v.hoverAlpha < 100)then
                v.animate=true
                animate(0, 100, "Linear", 250, function(a)
                    v.hoverAlpha=a
                    v.alpha=100-a
                end, function()
                    v.animate=false
                end)
                animate(0, 255, "Linear", 250, function(a)
                    v.infoAlpha=a
                end)
            elseif(v.hoverAlpha and not isMouseInPosition(px-340/zoom+v.sX, sh/2-180/zoom+v.sY, 133/zoom, 121/zoom) and not v.animate and v.hoverAlpha > 0)then
                v.animate=true
                animate(100, 0, "Linear", 250, function(a)
                    v.hoverAlpha=a
                    v.alpha=100-a
                end, function()
                    v.animate=false
                end)
                animate(255, 0, "Linear", 250, function(a)
                    v.infoAlpha=a
                end)
            end
    
            local a=UI.alpha > 100 and 100 or UI.alpha
            dxDrawImage(px-340/zoom+v.sX, sh/2-180/zoom+v.sY, 133/zoom, 121/zoom, assets.textures[4], 0, 0, 0, tocolor(255, 255, 255, v.alpha > a and a or v.alpha))
            dxDrawImage(px-340/zoom+v.sX-(141-133)/2/zoom, sh/2-180/zoom+v.sY-(131-121)/2/zoom, 144/zoom, 131/zoom, assets.textures[5], 0, 0, 0, tocolor(255, 255, 255, v.hoverAlpha > a and a or v.hoverAlpha))
     
            local item=items[x]
            if(item)then
                -- informacje
                if(isCursorShowing() and v.infoAlpha and v.infoAlpha > 0 and not UI.scrollItem and not UI.selectedItem)then
                    local cx,cy=getCursorPosition()
                    cx,cy=cx*sw,cy*sh
                    cx=cx+10/zoom
                    cy=cy+10/zoom

                    dxDrawImage(cx, cy, 350/zoom, 174/zoom, assets.textures[6], 0, 0, 0, tocolor(255, 255, 255, v.infoAlpha), true)
                    dxDrawText("Informacje o przedmiocie", cx+15/zoom, cy+10/zoom, 311/zoom, 174/zoom, tocolor(200, 200, 200, v.infoAlpha), 1, assets.fonts[2], "left", "top", false, false, true)
                    dxDrawRectangle(cx+(350-330)/2/zoom, cy+35/zoom, 330/zoom, 1, tocolor(85, 85, 85, v.infoAlpha))
                    
                    local tex=getItemTexture(item.name)
                    if(tex)then
                        dxDrawImage(cx+15/zoom, cy+45/zoom, 70/zoom, 70/zoom, tex, 0, 0, 0, tocolor(255, 255, 255, v.infoAlpha), true)
                    end

                    local itemInfo=UI.items[item.name] or {type="ammo"}
                    if(itemInfo and itemInfo.type == "weapon")then
                        dxDrawText("#808080Nazwa: #c2c2c2"..item.name.."\n#808080Ilość: #c2c2c2"..(item.value or 1).."\n#808080Amunicja: #c2c2c2"..(item.ammo or 0), cx+105/zoom, cy+40/zoom, cx+80/zoom, cy+40/zoom+80/zoom, tocolor(200, 200, 200, v.infoAlpha), 1, assets.fonts[2], "left", "center", false, false, true, true)
                    elseif(itemInfo and itemInfo.type == "ammo")then
                        dxDrawText("#808080Nazwa: #c2c2c2"..item.name.."\n#808080Ilość: #c2c2c2"..(item.value or 1), cx+105/zoom, cy+40/zoom, cx+80/zoom, cy+40/zoom+80/zoom, tocolor(200, 200, 200, v.infoAlpha), 1, assets.fonts[2], "left", "center", false, false, true, true)
                    else
                        local value=item.value or 1
                        local used=(itemInfo.use and (itemInfo.use*value) or (1*value))
                        dxDrawText("#808080Nazwa: #c2c2c2"..item.name.."\n#808080Ilość: #c2c2c2"..(item.value or 1).."\n#808080Użyć: #c2c2c2"..used, cx+105/zoom, cy+40/zoom, cx+80/zoom, cy+40/zoom+80/zoom, tocolor(200, 200, 200, v.infoAlpha), 1, assets.fonts[2], "left", "center", false, false, true, true)
                    end

                    dxDrawText("#c2c2c2Naciśnij 2x #2193b0PPM#c2c2c2, aby użyć.\n#c2c2c2Przenieś za #2193b0ekwipunek#c2c2c2, aby wyrzucić.", cx+15/zoom, cy+10/zoom, 311/zoom, cy+165/zoom, tocolor(200, 200, 200, v.infoAlpha), 1, assets.fonts[2], "left", "bottom", false, false, true, true)
                end
                --

                local tex=getItemTexture(item.name)
                if(tex)then
                    dxDrawImage(px-340/zoom+v.sX+(133-80)/2/zoom, sh/2-180/zoom+v.sY+(121-80)/2/zoom, 80/zoom, 80/zoom, tex, 0, 0, 0, tocolor(255, 255, 255, UI.alpha))
                end

                if(item.value and item.value > 1)then
                    dxDrawText(item.value, px-340/zoom+v.sX, sh/2-180/zoom+v.sY+8/zoom, px-340/zoom+v.sX+133/zoom-10/zoom, sh/2-180/zoom+v.sY+121/zoom, tocolor(200, 200, 200, UI.alpha), 1, assets.fonts[2], "right", "top")
                end

                if(isMouseInPosition(px-340/zoom+v.sX, sh/2-180/zoom+v.sY, 133/zoom, 121/zoom) and getKeyState("mouse1") and not UI.scrollItem and not UI.selectedItem and not eq.selectedItem)then
                    UI.selectedItem=x
                end

                if(isMouseInPosition(px-340/zoom+v.sX, sh/2-180/zoom+v.sY, 133/zoom, 121/zoom) and getKeyState("mouse3") and not UI.selectedItem and not UI.scrollItem and not eq.selectedItem)then
                    UI.scrollItem=x
                end
            end
        end
    end

    if(UI.scrollItem)then
        local cx,cy=getCursorPosition()
        cx,cy=cx*sw,cy*sh
        if(getKeyState("mouse3") and items[UI.scrollItem])then
            local tex=getItemTexture(items[UI.scrollItem].name)
            if(tex)then
                dxDrawImage(cx-80/2/zoom, cy-80/2/zoom, 80/zoom, 80/zoom, tex, 0, 0, 0, tocolor(255, 255, 255, UI.alpha))
            end
        else
            UI.updateItemPosition(UI.scrollItem, true)
            UI.scrollItem=false
        end
    end

    if(UI.selectedItem)then
        local cx,cy=getCursorPosition()
        cx,cy=cx*sw,cy*sh
        if(getKeyState("mouse1") and items[UI.selectedItem])then
            local tex=getItemTexture(items[UI.selectedItem].name)
            if(tex)then
                dxDrawImage(cx-80/2/zoom, cy-80/2/zoom, 80/zoom, 80/zoom, tex, 0, 0, 0, tocolor(255, 255, 255, UI.alpha))
            end
        else
            if(isMouseInPosition(px-1083/2/zoom, sh/2-752/2/zoom+35/zoom, 1083/zoom, 752/zoom))then
                UI.updateItemPosition(UI.selectedItem)
                UI.selectedItem=false
            else
                if(not UI.openType)then
                    if(SPAM.getSpam())then return end

                    UI.options["wyrzuc"](UI.selectedItem)
                    UI.selectedItem=false
                else
                    UI.updateItemPosition(UI.selectedItem)
                    UI.selectedItem=false
                end
            end
        end
    end
end

UI.clickDouble=function(button)
    if(button == "right")then
        local items=getElementData(localPlayer, "user:eq")
        if(not items)then return end

        local px=UI.pos[1]
        local row=math.floor(scroll:dxScrollGetPosition(UI.scroll)+1)
        local i=0
        for x=row,row+15 do
            i=i+1

            local v=UI.table[i]
            if(v)then
                local item=items[x]
                if(item and isMouseInPosition(px-340/zoom+v.sX+(133-80)/2/zoom, sh/2-180/zoom+v.sY+(121-80)/2/zoom, 80/zoom, 80/zoom))then
                    if(not SPAM.getSpam())then
                        UI.options["uzyj"](x)
                        break
                    end
                end
            end
        end
    end
end

local tbl={}
for i=1,50 do
    table.insert(tbl,{})
end

function openInventory(type)
    local gui=getElementData(localPlayer, "user:gui_showed")
    if(gui and getResourceName(gui) ~= "px_interaction")then return end

    local items=getElementData(localPlayer, "user:eq")
    if(not items)then return end

    if(getElementData(localPlayer, "user:tank"))then return end

    blur=exports.blur
    noti=exports.px_noti

    UI.showed=true

    assets.create()

    addEventHandler("onClientRender", root, UI.onRender)
    addEventHandler("onClientDoubleClick", root, UI.clickDouble)

    showCursor(true)

    if(not type)then
        UI.scroll = scroll:dxCreateScroll(sw/2+350/zoom, sh/2-350/2/zoom, 4/zoom, 4/zoom, 0, 15, tbl, 350/zoom, 0, 5, false, false, false, false, false, true)
    end

    UI.animate=true
    UI.alpha=0
    animate(UI.alpha, 255, "Linear", 500, function(a)
        UI.alpha=a
        scroll:dxScrollSetAlpha(UI.scroll,a)
    end, function()
        UI.animate=false
    end)   

    UI.openType=type

    setElementData(localPlayer, "user:gui_showed", resourceRoot, false)
end

function closeInventory(alpha)
    if(alpha)then
        showCursor(false)
    
        removeEventHandler("onClientRender", root, UI.onRender)
        removeEventHandler("onClientDoubleClick", root, UI.clickDouble)

        UI.alpha=0
        UI.showed=false
        UI.animate=false
        
        assets.destroy()

        setElementData(localPlayer, "user:gui_showed", false, false)

        toggleControl('forwards', true)
        toggleControl('backwards', true)
        toggleControl('left', true)
        toggleControl('right', true)
        return
    end

    UI.showed=false

    showCursor(false)

    setElementData(localPlayer, "user:gui_showed", false, false)

    UI.animate=true
    UI.alpha=255
    animate(UI.alpha, 0, "Linear", 500, function(a)
        UI.alpha=a
        scroll:dxScrollSetAlpha(UI.scroll,a)
    end, function()
        UI.animate=false
        assets.destroy()
        removeEventHandler("onClientRender", root, UI.onRender)
        removeEventHandler("onClientDoubleClick", root, UI.clickDouble)
        scroll:dxDestroyScroll(UI.scroll)

        toggleControl('forwards', true)
        toggleControl('backwards', true)
        toggleControl('left', true)
        toggleControl('right', true)
    end)  
end
addEvent("closeInventory", true)
addEventHandler("closeInventory", resourceRoot, closeInventory)

bindKey("i", "down", function()
    if(UI.animate or eq.showed)then return end
    if(not getElementData(localPlayer, "user:uid"))then return end

    if(UI.showed)then
        closeInventory()
    else
        openInventory() 
    end
end)

-- binds

UI.getItem=function()
    if(getElementData(localPlayer, "user:gui_showed") or isCursorShowing())then return end
    if(SPAM.getSpam())then return end

    local pos={getElementPosition(localPlayer)}
    pos[3]=getGroundPosition(pos[1], pos[2], pos[3])
    pos[3]=pos[3]+0.2
    triggerServerEvent("get.key", resourceRoot, "mouse1", pos)
end

UI.kickItem=function()
    if(getElementData(localPlayer, "user:gui_showed") or isCursorShowing())then return end
    if(SPAM.getSpam())then return end

    local pos={getElementPosition(localPlayer)}
    pos[3]=getGroundPosition(pos[1], pos[2], pos[3])
    pos[3]=pos[3]+0.2
    triggerServerEvent("get.key", resourceRoot, "mouse2", pos)
end

addEvent("start:have", true)
addEventHandler("start:have", resourceRoot, function(type)
    if(not type)then
        bindKey("mouse1","down",UI.getItem)
    end

    bindKey("mouse2","down",UI.kickItem)
end)

addEvent("stop:have", true)
addEventHandler("stop:have", resourceRoot, function()
    unbindKey("mouse1","down",UI.getItem)
    unbindKey("mouse2","down",UI.kickItem)
end)

-- useful

local anims = {}
local rendering = false

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
function onClick(x, y, w, h, fnc, double)
    if(UI.animate)then return end
    if(#anims > 0)then return end

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
            mouseClicks=mouseClicks+1
            mouseTick=getTickCount()
            mouseClick=true
                
			fnc()
        end
	end
end

addEventHandler("onClientResourceStop", resourceRoot, function()
    local gui = getElementData(localPlayer, "user:gui_showed")
    if(gui and gui == source)then
        setElementData(localPlayer, "user:gui_showed", false, false)
    end

    setElementData(localPlayer, "user:have_item", false)
end)

-- animate

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

addEvent('set.Data.Off', true)
addEventHandler('set.Data.Off', resourceRoot, function()
    UI.trigger=false
end)