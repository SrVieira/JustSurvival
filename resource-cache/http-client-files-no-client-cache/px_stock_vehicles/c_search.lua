--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- variables

local assets={
    fonts={},
    fonts2={},
    fonts_paths={
        {":px_assets/fonts/Font-Regular.ttf", 12},
        {":px_assets/fonts/Font-Medium.ttf", 14},
        {":px_assets/fonts/Font-Medium.ttf", 10},
        {":px_assets/fonts/Font-Medium.ttf", 13},
    },

    textures={},
    textures_paths={
        "textures/search/window.png",
        "textures/search/logo.png",
        "textures/search/header.png",
        "textures/search/row.png",
        "textures/search/row2.png",
        "textures/search/online.png",
        "textures/search/color.png",
    },
}

--

local search={}

search.vehs={}
search.opened=false
search.edits={}
search.buttons={}
search.row=0
search.alpha=0
search.scroll=false
search.blip=false
search.timer=false
search.selected=false

search.onSearch=function()
    local vehs=search.vehs
    local tbl={}
    local text1=editbox:dxGetEditText(search.edits[1]) or ""
    local text2=editbox:dxGetEditText(search.edits[2]) or ""
    if(#text1 > 0)then -- marka
        for i,v in pairs(vehs) do
            if(string.find(getVehicleName(v.veh):lower(), text1:lower(), 1, true))then
				tbl[#tbl+1]=v
			end
        end
    elseif(#text2 > 0)then -- max cena
        for i,v in pairs(vehs) do
            local cost=getElementData(v.veh, "vehStock:puted") and getElementData(v.veh, "vehStock:puted").cost or 0
            if(tonumber(cost) <= tonumber(text2))then
				tbl[#tbl+1]=v
			end
        end
    elseif(#text1 < 1 and #text2 < 1)then
        tbl=vehs
    end
    return tbl
end

search.onRender=function()
    if(search.selected)then
        local v=search.selected
        local export=exports.px_custom_vehicles

        blur:dxDrawBlur(sw/2-891/2/zoom, sh/2-750/2/zoom, 891/zoom, 750/zoom, tocolor(255, 255, 255, search.alpha))
        dxDrawImage(sw/2-891/2/zoom, sh/2-750/2/zoom, 891/zoom, 750/zoom, assets.textures[1], 0, 0, 0, tocolor(255, 255, 255, search.alpha), false)

        dxDrawImage(sw/2-891/2/zoom+30/zoom, sh/2-750/2/zoom+(80-57)/2/zoom, 146/zoom, 57/zoom, assets.textures[2], 0, 0, 0, tocolor(255, 255, 255, search.alpha), false)

        -- lewo
        dxDrawText("Główne informacje", sw/2-800/2/zoom+17/zoom, sh/2-736/2/zoom+151/zoom, 0, 0, tocolor(200, 200, 200,search.alpha), 1, assets.fonts[2], "left", "top")
        dxDrawRectangle(sw/2-800/2/zoom+17/zoom, sh/2-736/2/zoom+178/zoom, 311/zoom, 1, tocolor(86,86,86,search.alpha))

        local engine=getElementData(v.veh, "vehicle:engine") or export:getVehicleEngineFromModel(getElementModel(v.veh))
        local infos={
            {"Marka", getVehicleName(v.veh)},
            {"Przebieg", string.format("%0.1f", getElementData(v.veh, "vehicle:distance")).."km"},
            {"ID", getElementData(v.veh, "vehicle:id")},
            {"Bak", math.floor(getElementData(v.veh, "vehicle:fuel")).."l/"..math.floor(getElementData(v.veh, "vehicle:fuelTank")).."l"},
            {"Silnik", string.format("%.1f", engine).." dm³"},
            {"Rodzaj paliwa", getElementData(v.veh, "vehicle:fuelType")},
            {"Napęd", string.upper(getVehicleHandling(v.veh).driveType)},
        }

        for i,v in pairs(infos) do
            local sY=(43/zoom)*(i-1)
            dxDrawImage(sw/2-800/2/zoom+17/zoom, sh/2-736/2/zoom+178/zoom+11/zoom+sY, 311/zoom, 41/zoom, assets.textures[5], 0, 0, 0, tocolor(255,255,255,search.alpha))
            dxDrawText(v[1], sw/2-800/2/zoom+17/zoom+12/zoom, sh/2-736/2/zoom+178/zoom+11/zoom+sY-2, 311/zoom+sw/2-800/2/zoom+17/zoom, 41/zoom+sh/2-736/2/zoom+178/zoom+11/zoom+sY, tocolor(200, 200, 200,search.alpha), 1, assets.fonts[2], "left", "center")
            dxDrawText(v[2], sw/2-800/2/zoom+17/zoom+12/zoom, sh/2-736/2/zoom+178/zoom+11/zoom+sY-2, 311/zoom+sw/2-800/2/zoom+17/zoom-12/zoom, 41/zoom+sh/2-736/2/zoom+178/zoom+11/zoom+sY, tocolor(200, 200, 200,search.alpha), 1, assets.fonts[2], "right", "center")
        end

        -- prawo
        dxDrawText("Informacje mechaniczne", sw/2-800/2/zoom+800/zoom-311/zoom-17/zoom, sh/2-736/2/zoom+151/zoom, 0, 0, tocolor(200, 200, 200,search.alpha), 1, assets.fonts[2], "left", "top")
        dxDrawRectangle(sw/2-800/2/zoom+800/zoom-311/zoom-17/zoom, sh/2-736/2/zoom+178/zoom, 311/zoom, 1, tocolor(86,86,86,search.alpha))
        
        -- tuning
        local upgrades=""
        for i,v in ipairs(getVehicleUpgrades(v.veh)) do
            local slot=NAMES.tuningSlots[getVehicleUpgradeSlotName(v)] or getVehicleUpgradeSlotName(v)
            local upgrade=NAMES.tuningNames[v] or v
            if(upgrade == "Lampa" or slot == "Nitro" or slot == "Hydraulika" or slot == "Stereo")then
                text=slot
            else
                text=slot.." ("..upgrade..")"
            end

            if(#upgrades > 0)then
                upgrades=upgrades..", "..text
            else
                upgrades=text
            end
        end
        upgrades=#upgrades > 0 and upgrades or "brak"
        --

        local infos={
            {"MK1", getElementData(v.veh, "vehicle:mk1") and "tak" or "nie"},
            {"MK2", getElementData(v.veh, "vehicle:mk2") and "tak" or "nie"},
            {"MultiLED", getElementData(v.veh, "vehicle:multiLED") and "tak" or "nie"},
            {"Zawieszenie", getElementData(v.veh, "vehicle:suspension") or "brak"},
            {"Turbosprężarka", getElementData(v.veh, "vehicle:turbo") or "brak"},
            {"Hamulce", getElementData(v.veh, "vehicle:brakes") or "brak"},
            {"Nitro", getElementData(v.veh, "vehicle:nitro") or "brak"},
        }

        for i,v in pairs(infos) do
            local sY=(43/zoom)*(i-1)
            dxDrawImage(sw/2-800/2/zoom+800/zoom-311/zoom-17/zoom, sh/2-736/2/zoom+178/zoom+sY+11/zoom, 311/zoom, 41/zoom, assets.textures[5], 0, 0, 0, tocolor(255,255,255,search.alpha))
            dxDrawText(v[1], sw/2-800/2/zoom+800/zoom-311/zoom-17/zoom+12/zoom, sh/2-736/2/zoom+178/zoom+sY+11/zoom-2, 311/zoom+sw/2-800/2/zoom+800/zoom-311/zoom-17/zoom, 41/zoom+sh/2-736/2/zoom+178/zoom+sY+11/zoom, tocolor(200, 200, 200,search.alpha), 1, assets.fonts[2], "left", "center")
            dxDrawText(v[2], sw/2-800/2/zoom+800/zoom-311/zoom-17/zoom+12/zoom, sh/2-736/2/zoom+178/zoom+sY+11/zoom-2, 311/zoom+sw/2-800/2/zoom+800/zoom-311/zoom-17/zoom-12/zoom, 41/zoom+sh/2-736/2/zoom+178/zoom+sY+11/zoom, tocolor(200, 200, 200,search.alpha), 1, assets.fonts[2], "right", "center")
        end

        -- dol
        dxDrawText("Pozostałe informacje", sw/2-800/2/zoom+17/zoom, sh/2-736/2/zoom+507/zoom, 0, 0, tocolor(200, 200, 200,search.alpha), 1, assets.fonts[2], "left", "top")
        dxDrawRectangle(sw/2-800/2/zoom+17/zoom, sh/2-736/2/zoom+532/zoom, 311/zoom, 1, tocolor(86,86,86,search.alpha))

        local color={getVehicleColor(v.veh,true)}
        local light={getVehicleHeadLightColor(v.veh)}
        local infos={
            {"Tuning wizualny", #upgrades > 0 and upgrades or "brak"},
            {"Kolor karoserii", "karo", color},
            {"Kolor świateł", "light", light},
        }
        local last=0
        for i,v in pairs(infos) do
            local sY=last+(25/zoom)*(i-1)
            if(v[2] == "karo")then
                dxDrawText(v[1]..":", sw/2-800/2/zoom+17/zoom, sh/2-736/2/zoom+540/zoom+sY, 0, 0, tocolor(165,165,165,search.alpha), 1, assets.fonts[2], "left", "top", false, false, false, true)
                dxDrawImage(sw/2-800/2/zoom+17/zoom+dxGetTextWidth(v[1]..":", 1, assets.fonts[2])+14/2/zoom, sh/2-736/2/zoom+540/zoom+sY+5/zoom, 14/zoom, 14/zoom, assets.textures[7], 0, 0, 0, tocolor(v[3][1],v[3][2],v[3][3],search.alpha))
                dxDrawImage(sw/2-800/2/zoom+17/zoom+dxGetTextWidth(v[1]..":", 1, assets.fonts[2])+14/2/zoom+20/zoom, sh/2-736/2/zoom+540/zoom+sY+5/zoom, 14/zoom, 14/zoom, assets.textures[7], 0, 0, 0, tocolor(v[3][4],v[3][5],v[3][6],search.alpha))
            elseif(v[2] == "light")then
                dxDrawText(v[1]..":", sw/2-800/2/zoom+17/zoom, sh/2-736/2/zoom+540/zoom+sY, 0, 0, tocolor(165,165,165,search.alpha), 1, assets.fonts[2], "left", "top", false, false, false, true)
                dxDrawImage(sw/2-800/2/zoom+17/zoom+dxGetTextWidth(v[1]..":", 1, assets.fonts[2])+14/2/zoom, sh/2-736/2/zoom+540/zoom+sY+5/zoom, 14/zoom, 14/zoom, assets.textures[7], 0, 0, 0, tocolor(v[3][1],v[3][2],v[3][3],search.alpha))
            else
                dxDrawText(v[1]..": "..v[2], sw/2-800/2/zoom+17/zoom, sh/2-736/2/zoom+540/zoom+sY, sw/2-800/2/zoom+650/zoom, 0, tocolor(165,165,165,search.alpha), 1, assets.fonts[2], "left", "top", false, true)
                if(dxGetTextWidth(v[1]..": "..v[2], 1, assets.fonts[2]) > 650/zoom)then
                    last=20/zoom
                end
            end
        end

        dxDrawRectangle(sw/2-891/2/zoom, sh/2-750/2/zoom+750/zoom-37/zoom, 891/zoom, 1, tocolor(81, 81, 81, search.alpha))
        dxDrawText("Wyjdź aby zamknąć panel", sw/2-891/2/zoom, sh/2-750/2/zoom+750/zoom-37/zoom, 891/zoom+sw/2-891/2/zoom, sh/2-750/2/zoom+750/zoom, tocolor(150, 150, 150, search.alpha), 1, assets.fonts[3], "center", "center")

        onClick(sw/2+10/zoom, sh/2-750/2/zoom+750/zoom-38/zoom-38/zoom-30/zoom, 147/zoom, 38/zoom, function()
            if(search.blip)then
                destroyElement(search.blip)
                search.blip=false

                if(search.timer)then
                    killTimer(search.timer)
                    search.timer=false
                end
            end

            local x,y,z=getElementPosition(v.veh)
            search.blip=createBlip(x,y,z,27)
            search.tick=getTickCount()

            noti:noti("Pojazd został namierzony na mapie.", "success")

            setTimer(function()
                if(search.blip)then
                    destroyElement(search.blip)
                    search.blip=false
                    search.timer=false
                end
            end, 30*1000, 1)
        end)

        onClick(sw/2-147/zoom-10/zoom, sh/2-750/2/zoom+750/zoom-38/zoom-38/zoom-30/zoom, 147/zoom, 38/zoom, function()
            animate(search.alpha, 0, "Linear", 300, function(a)
                search.alpha=a

                for i,v in pairs(search.buttons) do
                    buttons:buttonSetAlpha(v, a)
                end

                for i,v in pairs(search.edits) do
                    editbox:dxSetEditAlpha(v, a)
                end

                if(search.scroll)then
                    scroll:dxScrollSetAlpha(search.scroll, a)
                end
            end, function()
                search.selected=false

                for i,v in pairs(search.buttons)  do
                    buttons:destroyButton(v)
                end

                search.edits[1] = editbox:dxCreateEdit("Wyszukaj poprzez markę samochodu", sw/2-350/2/zoom-20/zoom, sh/2-750/2/zoom+(90-30)/2/zoom, 300/zoom, 30/zoom, false, 11/zoom, 0, false, false, ":px_stock_vehicles/textures/edit.png")
                search.edits[2] = editbox:dxCreateEdit("Wprowadź max. cene", sw/2-891/2/zoom+891/zoom-250/zoom, sh/2-750/2/zoom+(90-30)/2/zoom, 220/zoom, 30/zoom, false, 11/zoom, 0, true, false, ":px_stock_vehicles/textures/edit.png")
                search.scroll=scroll:dxCreateScroll(sw/2-891/2/zoom+891/zoom-4/zoom, sh/2-750/2/zoom+90/zoom+32/zoom, 4, 4, 0, 10, search.vehs, 630/zoom-37/zoom, 0, 3)        

                setTimer(function()
                    animate(search.alpha, 255, "Linear", 300, function(a)
                        search.alpha=a

                        for i,v in pairs(search.edits) do
                            editbox:dxSetEditAlpha(v, a)
                        end

                        if(search.scroll)then
                            scroll:dxScrollSetAlpha(search.scroll, a)
                        end
                    end)
                end, 100, 1)
            end)
        end)
    else
        blur:dxDrawBlur(sw/2-891/2/zoom, sh/2-750/2/zoom, 891/zoom, 750/zoom, tocolor(255, 255, 255, search.alpha))
        dxDrawImage(sw/2-891/2/zoom, sh/2-750/2/zoom, 891/zoom, 750/zoom, assets.textures[1], 0, 0, 0, tocolor(255, 255, 255, search.alpha), false)

        dxDrawImage(sw/2-891/2/zoom+30/zoom, sh/2-750/2/zoom+(90-57)/2/zoom, 146/zoom, 57/zoom, assets.textures[2], 0, 0, 0, tocolor(255, 255, 255, search.alpha), false)

        dxDrawImage(sw/2-891/2/zoom, sh/2-750/2/zoom+90/zoom, 891/zoom, 27/zoom, assets.textures[3], 0, 0, 0, tocolor(255, 255, 255, search.alpha), false)
        dxDrawText("ID", sw/2-891/2/zoom+30/zoom, sh/2-750/2/zoom+90/zoom, 891/zoom+sw/2-891/2/zoom, 27/zoom+sh/2-750/2/zoom+90/zoom, tocolor(200, 200, 200, search.alpha), 1, assets.fonts[1], "left", "center")
        dxDrawText("Pojazd", sw/2-891/2/zoom+105/zoom, sh/2-750/2/zoom+90/zoom, 891/zoom+sw/2-891/2/zoom, 27/zoom+sh/2-750/2/zoom+90/zoom, tocolor(200, 200, 200, search.alpha), 1, assets.fonts[1], "left", "center")
        dxDrawText("Sprzedający", sw/2-891/2/zoom+404/zoom, sh/2-750/2/zoom+90/zoom, 891/zoom+sw/2-891/2/zoom, 27/zoom+sh/2-750/2/zoom+90/zoom, tocolor(200, 200, 200, search.alpha), 1, assets.fonts[1], "left", "center")
        dxDrawText("Przebieg", sw/2-891/2/zoom+580/zoom, sh/2-750/2/zoom+90/zoom, 891/zoom+sw/2-891/2/zoom, 27/zoom+sh/2-750/2/zoom+90/zoom, tocolor(200, 200, 200, search.alpha), 1, assets.fonts[1], "left", "center")
        dxDrawText("Cena", sw/2-891/2/zoom+763/zoom, sh/2-750/2/zoom+90/zoom, 891/zoom+sw/2-891/2/zoom, 27/zoom+sh/2-750/2/zoom+90/zoom, tocolor(200, 200, 200, search.alpha), 1, assets.fonts[1], "left", "center")

        search.row=math.floor(scroll:dxScrollGetPosition(search.scroll))
        
        dxDrawRectangle(sw/2-891/2/zoom, sh/2-750/2/zoom+750/zoom-37/zoom, 891/zoom, 1, tocolor(81, 81, 81, search.alpha))
        dxDrawText("Wyjdź aby zamknąć panel", sw/2-891/2/zoom, sh/2-750/2/zoom+750/zoom-37/zoom, 891/zoom+sw/2-891/2/zoom, sh/2-750/2/zoom+750/zoom, tocolor(150, 150, 150, search.alpha), 1, assets.fonts[3], "center", "center")

        local tbl=search.onSearch()
        local x=0
        for i=search.row,search.row+9 do
            x=x+1

            local v=tbl[i+1]
            if(v)then
                local sY=(59/zoom)*(x-1)

                -- alpha
                if(isMouseInPosition(sw/2-886/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY, 886/zoom, 57/zoom) and not v.animate)then
                    v.animate=true

                    animate(v.alpha, 255, "Linear", 200, function(a)
                        if(v.animate)then
                            v.alpha = a
                        end
                    end)
                elseif(not isMouseInPosition(sw/2-886/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY, 886/zoom, 57/zoom) and v.animate)then
                    v.animate = false

                    animate(v.alpha, 0, "Linear", 200, function(a)
                      if(not v.animate)then
                        v.alpha = a
                      end
                    end)
                end
                --

                dxDrawImage(sw/2-886/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY, 886/zoom, 57/zoom, assets.textures[4], 0, 0, 0, tocolor(255, 255, 255, search.alpha), false)
                dxDrawRectangle(sw/2-886/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY+57/zoom-1, 886/zoom, 1, tocolor(81, 81, 81, search.alpha), false)
                dxDrawRectangle(sw/2-886/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY+57/zoom-1, 886/zoom, 1, tocolor(55, 139, 100, v.alpha > search.alpha and search.alpha or v.alpha), false)

                local id = getElementData(v.veh, "vehicle:id") or 0
                local owner = getElementData(v.veh, "vehicle:ownerName") or "?"
                local distance=getElementData(v.veh, "vehicle:distance") or 0
                local cost=getElementData(v.veh, "vehStock:puted") and getElementData(v.veh, "vehStock:puted").cost or 0
                dxDrawText(id, sw/2-891/2/zoom+30/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY, 891/zoom+sw/2-891/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY+57/zoom, tocolor(200, 200, 200, search.alpha), 1, assets.fonts[4], "left", "center")
                dxDrawText(getVehicleName(v.veh), sw/2-891/2/zoom+105/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY, 891/zoom+sw/2-891/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY+57/zoom, tocolor(200, 200, 200, search.alpha), 1, assets.fonts[4], "left", "center")
                
                local av=avatars:getPlayerAvatar(owner)
                if(av)then
                    if(getPlayerFromName(owner))then
                        dxDrawImage(sw/2-891/2/zoom+404/zoom-(23-21)/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY+(57-23)/2/zoom, 23/zoom, 23/zoom, assets.textures[6], 0, 0, 0, tocolor(255, 255, 255, search.alpha))
                    end
                    dxDrawImage(sw/2-891/2/zoom+404/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY+(57-21)/2/zoom, 21/zoom, 21/zoom, av, 0, 0, 0, tocolor(255, 255, 255, search.alpha))
                end
                dxDrawText(owner, sw/2-891/2/zoom+404/zoom+30/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY, 891/zoom+sw/2-891/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY+57/zoom, tocolor(200, 200, 200, search.alpha), 1, assets.fonts[4], "left", "center")
                
                dxDrawText(string.format("%0.1f", distance).."km", sw/2-891/2/zoom+580/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY, 891/zoom+sw/2-891/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY+57/zoom, tocolor(200, 200, 200, search.alpha), 1, assets.fonts[4], "left", "center")
                dxDrawText("$ "..convertNumber(cost), sw/2-891/2/zoom+763/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY, 891/zoom+sw/2-891/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY+57/zoom, tocolor(200, 200, 200, search.alpha), 1, assets.fonts[4], "left", "center")        

                onClick(sw/2-886/2/zoom, sh/2-750/2/zoom+90/zoom+27/zoom+1+sY, 886/zoom, 57/zoom, function()
                    if(search.animate or search.selected == v)then return end

                    search.animate=true
                    animate(search.alpha, 0, "Linear", 300, function(a)
                        search.alpha=a

                        for i,v in pairs(search.edits) do
                            editbox:dxSetEditAlpha(v, a)
                        end

                        if(search.scroll)then
                            scroll:dxScrollSetAlpha(search.scroll, a)
                        end
                    end, function()
                        search.animate=false

                        search.selected=v

                        for i,v in pairs(search.edits) do
                            editbox:dxDestroyEdit(v)
                        end

                        scroll:dxDestroyScroll(search.scroll)

                        search.buttons[1]=buttons:createButton(sw/2-147/zoom-10/zoom, sh/2-750/2/zoom+750/zoom-38/zoom-38/zoom-30/zoom, 147/zoom, 38/zoom, "COFNIJ", 0, 10, false, false, ":px_stock_vehicles/textures/search/back.png", {140,145,62})
                        search.buttons[2]=buttons:createButton(sw/2+10/zoom, sh/2-750/2/zoom+750/zoom-38/zoom-38/zoom-30/zoom, 147/zoom, 38/zoom, "NAMIERZ", 0, 9, false, false, ":px_stock_vehicles/textures/search/button.png")

                        setTimer(function()
                            animate(search.alpha, 255, "Linear", 300, function(a)
                                search.alpha=a

                                for i,v in pairs(search.buttons) do
                                    buttons:buttonSetAlpha(v, a)
                                end
                            end)
                        end, 100, 1)
                    end)
                end)
            end
        end
    end
end

-- trigger

addEvent("open.search", true)
addEventHandler("open.search", resourceRoot, function(vv)
    if(not search.opened and vv)then
        if(getElementData(localPlayer, "user:gui_showed"))then return end

        search.opened=true
        search.selected=false
        search.vehs=vv

        assets.create()

        showCursor(true, false)

        addEventHandler("onClientRender", root, search.onRender)

        search.edits[1] = editbox:dxCreateEdit("Wyszukaj poprzez markę samochodu", sw/2-350/2/zoom-20/zoom, sh/2-750/2/zoom+(90-30)/2/zoom, 300/zoom, 30/zoom, false, 11/zoom, 0, false, false, ":px_stock_vehicles/textures/edit.png")
        search.edits[2] = editbox:dxCreateEdit("Wprowadź max. cene", sw/2-891/2/zoom+891/zoom-250/zoom, sh/2-750/2/zoom+(90-30)/2/zoom, 220/zoom, 30/zoom, false, 11/zoom, 0, true, false, ":px_stock_vehicles/textures/edit.png")
        search.scroll=scroll:dxCreateScroll(sw/2-891/2/zoom+891/zoom-4/zoom, sh/2-750/2/zoom+90/zoom+32/zoom, 4, 4, 0, 10, search.vehs, 630/zoom-37/zoom, 0, 3)

        animate(search.alpha, 255, "Linear", 300, function(a)
            if(search.opened)then
                search.alpha=a

                for i,v in pairs(search.edits) do
                    editbox:dxSetEditAlpha(v, a)
                end

                for i,v in pairs(search.buttons) do
                    buttons:buttonSetAlpha(v, a)
                end

                if(search.scroll)then
                    scroll:dxScrollSetAlpha(search.scroll, a)
                end
            end
        end)

        setElementData(localPlayer, "user:gui_showed", resourceRoot, false)
    else
        setElementData(localPlayer, "user:gui_showed", false, false)

        search.opened=false

        animate(search.alpha, 0, "Linear", 300, function(a)
            if(not search.opened)then
                search.alpha=a

                for i,v in pairs(search.edits) do
                    editbox:dxSetEditAlpha(v, a)
                end

                for i,v in pairs(search.buttons) do
                    buttons:buttonSetAlpha(v, a)
                end

                if(search.scroll)then
                    scroll:dxScrollSetAlpha(search.scroll, a)
                end
            end
        end, function()
            search.vehs={}

            showCursor(false)

            removeEventHandler("onClientRender", root, search.onRender)

            assets.destroy()

            for i,v in pairs(search.edits) do
                editbox:dxDestroyEdit(v)
            end

            for i,v in pairs(search.buttons)  do
                buttons:destroyButton(v)
            end

            scroll:dxDestroyScroll(search.scroll)
        end)
    end
end)

-- main variables

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

-- on stop

addEventHandler("onClientResourceStop", resourceRoot, function()
    local gui = getElementData(localPlayer, "user:gui_showed")
    if(gui and gui == source)then
        setElementData(localPlayer, "user:gui_showed", false, false)
    end
end)