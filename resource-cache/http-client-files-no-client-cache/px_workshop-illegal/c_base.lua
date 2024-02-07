--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

ui={}

ui['nav']={
    {tex_id=5, text='Nazwa części', x=72/zoom, key='name'},
    {tex_id=6, text='Koszt/montażu/demontażu', x=211/zoom, key='cost'},
    {tex_id=7, text='Status', x=426/zoom, key='status'},
}

ui['items']={
    {name='ASR OFF', cost=5000, data='vehicle:ASR'},
    {name='Anti Lag System', cost=45000, data='vehicle:ALS'},
    {name='Wykrywacz radarów', cost=15000, data='vehicle:radarDetector'},
    {name='CB-Radio', cost=2000, data='vehicle:cbRadio'},

    {name='Kolor licznika', cost=20000, data='vehicle:speedoColor', preview=true},

    {name='Przyciemnione szyby 50%', cost=20000, data='vehicle:tint', value=50, cancel='vehicle:tint', preview=true},
    {name='Przyciemnione szyby 75%', cost=35000, data='vehicle:tint', value=75, cancel='vehicle:tint', preview=true},
    {name='Przyciemnione szyby 90%', cost=50000, data='vehicle:tint', value=90, cancel='vehicle:tint', preview=true},
    {name='Przyciemnione szyby 100%', cost=80000, data='vehicle:tint', value=100, cancel='vehicle:tint', preview=true},
}

ui['speedos_id']={
    [2]=true,
    [5]=true,
    [1]=true,
}

ui['speedoColors']={
    ['Magenta']={100,58,173},
    ['Club']={212,5,225},
    ['Watercolar']={89,191,142},
    ['Rust']={217,180,52},
    ['Diablo']={255,73,25},
    ['Fluo']={166,242,37},
    ['Matrix']={103,100,225},
    ['Sea']={85,225,241},
    ['Hit']={225,17,17},
    ['Weathered']={180,85,96},
    ['Plaster']={213,97,66},
}

ui['colorSelected']=false
ui['selected']=false

ui['buttons']={}
ui['scroll']=false

ui['preview']=false

ui['showed']=false

ui['haveTune']=false

ui['isVehicleHaveIllegalTuning']=function(vehicle, name)
    local have=false
    for i,v in pairs(ui['items']) do
        if(v['name'] == name)then
            if(v['data'])then
                have=ui['haveTune'][v['data']]
                if(v['value'] and have ~= v['value'])then
                    have=false
                end
                break
            end
        end
    end
    return have
end

ui['render']=function()
    local veh=getPedOccupiedVehicle(localPlayer)
    if(not veh)then ui['destroy']() return end

    -- bg
    blur:dxDrawBlur(0, sh/2-560/2/zoom, 551/zoom, 560/zoom)
    dxDrawImage(0, sh/2-560/2/zoom, 551/zoom, 560/zoom, assets.textures[1])

    -- header
    dxDrawImage(551/2/zoom-dxGetTextWidth(' WORKSHOP', 1, assets.fonts[2])/2-dxGetTextWidth('ILLEGAL', 1, assets.fonts[1])/2-20/zoom-20/zoom, sh/2-560/2/zoom+(55-20)/2/zoom, 20/zoom, 20/zoom, assets.textures[2])
    dxDrawText('ILLEGAL', -dxGetTextWidth(' WORKSHOP', 1, assets.fonts[2])/2, sh/2-560/2/zoom, 551/zoom-dxGetTextWidth(' WORKSHOP', 1, assets.fonts[2])/2, sh/2-560/2/zoom+55/zoom, tocolor(200, 200, 200), 1, assets.fonts[1], 'center', 'center')
    dxDrawText('WORKSHOP', dxGetTextWidth('ILLEGAL', 1, assets.fonts[1])/2, sh/2-560/2/zoom, 551/zoom+dxGetTextWidth('ILLEGAL', 1, assets.fonts[1])/2, sh/2-560/2/zoom+55/zoom, tocolor(200, 200, 200), 1, assets.fonts[2], 'center', 'center')

    dxDrawImage(551/zoom-10/zoom-(55-10)/2/zoom, sh/2-560/2/zoom+(55-10)/2/zoom, 10/zoom, 10/zoom, assets.textures[3])

    dxDrawRectangle((551-501)/2/zoom, sh/2-560/2/zoom+55/zoom, 501/zoom, 1, tocolor(80,80,80))

    -- nav
    dxDrawImage((551-547)/2/zoom, sh/2-560/2/zoom+55/zoom, 547/zoom, 22/zoom, assets.textures[4])
    for i,v in pairs(ui['nav']) do
        local w,h=dxGetMaterialSize(assets.textures[v['tex_id']])
        dxDrawImage(v['x'], sh/2-560/2/zoom+55/zoom+(22-h)/2/zoom, w, h, assets.textures[v['tex_id']])
        dxDrawText(v['text'], v['x']+w+8/zoom, sh/2-560/2/zoom+55/zoom, 0, sh/2-560/2/zoom+55/zoom+22/zoom, tocolor(200, 200, 200), 1, assets.fonts[3], 'left', 'center')
    end

    -- list
    local x=0
    local row=math.floor(scroll:dxScrollGetPosition(ui['scroll'])+1)
    for i=row,row+4 do
        local v=ui['items'][i]
        if(v)then
            x=x+1

            local sY=(58/zoom)*(x-1)

            -- bg
            dxDrawImage((551-547)/2/zoom, sh/2-560/2/zoom+80/zoom+sY, 547/zoom, 57/zoom, assets.textures[8])
            dxDrawRectangle((551-547)/2/zoom, sh/2-560/2/zoom+80/zoom+sY+57/zoom-1, 547/zoom, 1, tocolor(80,80,80))

            -- check
            dxDrawImage(21/zoom, sh/2-560/2/zoom+80/zoom+sY+(57-19)/2/zoom, 19/zoom, 19/zoom, ui['selected'] == i and assets.textures[10] or assets.textures[9])
            onClick(21/zoom, sh/2-560/2/zoom+80/zoom+sY+(57-19)/2/zoom, 19/zoom, 19/zoom, function()
                ui['selected']=ui['selected'] ~= i and i

                if(ui['preview'])then
                    setElementData(veh, ui['preview'][1], ui['preview'][2], false)
                    ui['preview']=false
                end
            end)

            -- names
            for _,k in pairs(ui['nav']) do
                local w,h=dxGetMaterialSize(assets.textures[k['tex_id']])
                local key=k['key'] == 'status' and false or k['key']
                local text=key and v[key] or 'Niezamontowany'
                if(key == 'cost')then
                    if(ui['isVehicleHaveIllegalTuning'](veh, v['name']))then
                        text='#2affca$#c2c2c2 '..convertNumber(text/2)
                    else
                        text='#2affca$#c2c2c2 '..convertNumber(text)
                    end
                elseif(key == 'status')then
                    if(ui['isVehicleHaveIllegalTuning'](veh, v['name']))then
                        text='Zamontowany'
                    else
                        text='Niezamontowany'
                    end
                end

                local start=k['x']
                local stop=k['x']+w+8/zoom+dxGetTextWidth(k['text'], 1, assets.fonts[3])
                dxDrawText(text, start, sh/2-560/2/zoom+80/zoom+sY, stop, sh/2-560/2/zoom+80/zoom+sY+57/zoom, tocolor(200, 200, 200), 1, assets.fonts[4], key == 'name' and 'left' or 'center', 'center', false, false, false, true)
            end
        end
    end

    -- update button
    if(ui['selected'])then
        local item=ui['items'][ui['selected']]
        if(item and item['data'])then
            if(ui['isVehicleHaveIllegalTuning'](veh, item['name']))then
                buttons:buttonSetText(ui['buttons'][1], 'DEMONTUJ')
            else
                buttons:buttonSetText(ui['buttons'][1], 'MONTUJ')
            end
        end
    else
        buttons:buttonSetText(ui['buttons'][1], 'MONTUJ')
    end

    -- lights
    dxDrawImage(551/zoom-36/zoom, sh/2-560/2/zoom+375/zoom, 36/zoom, 123/zoom, assets.textures[11])

    dxDrawText('Dostępne', 35/zoom, sh/2-560/2/zoom+410/zoom, 0, 0, tocolor(200, 200, 200), 1, assets.fonts[3], 'left', 'top')
    dxDrawText('Nazwa', 35/zoom, sh/2-560/2/zoom+455/zoom, 0, 0, tocolor(200, 200, 200), 1, assets.fonts[3], 'left', 'top')

    local x=0
    for i,v in pairs(ui['speedoColors']) do
        x=x+1

        local sX=(31/zoom)*(x-1)
        dxDrawImage(145/zoom+sX, sh/2-560/2/zoom+410/zoom, 19/zoom, 19/zoom, assets.textures[12], 0, 0, 0, tocolor(unpack(v)))

        if(i == ui['colorSelected'])then
            dxDrawImage(145/zoom+sX-1, sh/2-560/2/zoom+410/zoom-1, 21/zoom, 21/zoom, assets.textures[13])
        end

        onClick(145/zoom+sX, sh/2-560/2/zoom+410/zoom, 19/zoom, 19/zoom, function()
            ui['colorSelected']=ui['colorSelected'] ~= i and i
        end)
    end

    local color=ui['colorSelected'] or 'Wybierz kolor'
    dxDrawText(color, 145/zoom, sh/2-560/2/zoom+455/zoom, 0, 0, tocolor(200, 200, 200), 1, assets.fonts[3], 'left', 'top')

    -- footer
    dxDrawImage((551-547)/2/zoom, sh/2-560/2/zoom+560/zoom-57/zoom, 547/zoom, 57/zoom, assets.textures[14])

    -- podglad
    onClick(179/zoom, sh/2-560/2/zoom+560/zoom-57/zoom+(57-39)/2/zoom, 39/zoom, 39/zoom, function()
        if(not ui['preview'])then
            if(ui['selected'])then
                local item=ui['items'][ui['selected']]
                if(item and item['data'])then
                    if(item['preview'])then
                        local value=item['value'] or true
                        if(item['name'] == 'Kolor licznika')then
                            value=ui['colorSelected']
                        end
                                                
                        if(value)then
                            ui['preview']={
                                item['data'],
                                getElementData(veh, item['data'], false) or false
                            }
                            setElementData(veh, item['data'], value, false)
                        end
                    else
                        exports.px_noti:noti('Wybrany tuning nie posiada podglądu.', 'error')
                    end
                end
            end
        else
            setElementData(veh, ui['preview'][1], ui['preview'][2], false)
            ui['preview']=false
        end
    end)

    -- montaz
    onClick(226/zoom, sh/2-560/2/zoom+560/zoom-57/zoom+(57-39)/2/zoom, 148/zoom, 39/zoom, function()
        if(ui['selected'])then
            if(ui['preview'])then
                exports['px_noti']:noti('Najpierw zakończ podgląd.', 'error')
                return
            end
            
            local item=ui['items'][ui['selected']]
            if(item and item['data'])then
                if(ui['isVehicleHaveIllegalTuning'](veh, item['name']))then
                    ui['preview']=false
                    ui['destroy']()
                    triggerServerEvent('remove.illegal', resourceRoot, veh, item['name'], item['cost'], item['data'])
                else
                    local value=item['value'] or true
                    if(item['name'] == 'Kolor licznika')then
                        value=ui['colorSelected']

                        local speedo=getElementData(veh, 'vehicle:speedoType') or exports['px_speedo']:getVehicleSpeedoType(veh)
                        if(not ui['speedos_id'][speedo])then
                            exports['px_noti']:noti('Nie możesz zamontować koloru do tego licznika!', 'error')
                            return
                        end
                    end

                    if(value)then
                        if(getPlayerMoney(localPlayer) >= item['cost'])then
                            if(not item['cancel'] or (item['cancel'] and not getElementData(veh, item['cancel'])))then
                                ui['preview']=false
                                ui['destroy']()
                                triggerServerEvent('add.illegal', resourceRoot, veh, item['name'], item['cost'], item['data'], value)
                            else
                                exports.px_noti:noti('Nie możesz zamontować podwójnie tego samego tuningu! Najpierw wymontuj ten który posiadasz.', 'error')
                            end
                        else
                            exports.px_noti:noti('Brak wystarczających funduszy.', 'error')
                        end
                    else
                        exports.px_noti:noti('Nie wybrałeś koloru', 'error')
                    end
                end
            end
        end
    end)

    -- close
    onClick(551/zoom-10/zoom-(55-10)/2/zoom, sh/2-560/2/zoom+(55-10)/2/zoom, 10/zoom, 10/zoom, function()
        ui['destroy']()
    end)
end

ui['create']=function(have)
    local gui=getElementData(localPlayer, "user:gui_showed")
    if(gui)then return end
    
    if(not isPedInVehicle(localPlayer) or ui['showed'])then return end

    ui['haveTune']=have

    assets.create()
    addEventHandler('onClientRender', root, ui['render'])

    setElementData(localPlayer, 'user:chat_showed', true, false)
    setElementData(localPlayer, 'user:radar_disabled', true, false)

    ui['selected']=false

    showCursor(true)

    ui['buttons'][1]=buttons:createButton(226/zoom, sh/2-560/2/zoom+560/zoom-57/zoom+(57-39)/2/zoom, 148/zoom, 39/zoom, "ZAMONTUJ", 255, 10/zoom, false, false, ":px_workshop-illegal/textures/button.png")
    ui['buttons'][2]=buttons:createButton(179/zoom, sh/2-560/2/zoom+560/zoom-57/zoom+(57-39)/2/zoom, 39/zoom, 39/zoom, "", 255, 10/zoom, false, false, ":px_workshop-illegal/textures/eye.png", {46,78,160})

    ui['scroll']=scroll:dxCreateScroll(551/zoom-4/zoom, sh/2-560/2/zoom+80/zoom, 4/zoom, 4/zoom, 0, 5, ui['items'], 290/zoom, 255)

    ui['showed']=true

    toggleControl('enter_exit', false)

    setElementData(localPlayer, "user:gui_showed", resourceRoot, false)
end

ui['destroy']=function()
    if(not ui['showed'])then return end

    local veh=getPedOccupiedVehicle(localPlayer)
    if(ui['preview'] and veh)then
        setElementData(veh, ui['preview'][1], ui['preview'][2], false)
    end

    removeEventHandler('onClientRender', root, ui['render'])

    setElementData(localPlayer, 'user:chat_showed', false, false)
    setElementData(localPlayer, 'user:radar_disabled', false, false)

    showCursor(false)

    for i,v in pairs(ui['buttons']) do
        buttons:destroyButton(ui['buttons'][i])
    end
    ui['buttons']={}

    scroll:dxDestroyScroll(ui['scroll'])
    ui['scroll']=false

    assets.destroy()

    ui['showed']=false

    if(veh)then
        setElementFrozen(veh, false)
    end

    toggleControl('enter_exit', true)

    setElementData(localPlayer, "user:gui_showed", false, false)
end

-- events

addEvent('open.ui', true)
addEventHandler('open.ui', resourceRoot, function(...)
    ui['create'](...)
end)

addEvent('destroy.ui', true)
addEventHandler('destroy.ui', resourceRoot, function()
    ui['destroy']()
end)

-- on stop

addEventHandler('onClientResourceStop', resourceRoot, ui['destroy'])

-- exports

function getVehicleSpeedoColorName(name)
    return ui['speedoColors'][name]
end

-- on stop

addEventHandler("onClientResourceStop", resourceRoot, function()
    local gui = getElementData(localPlayer, "user:gui_showed")
    if(gui and gui == source)then
        setElementData(localPlayer, "user:gui_showed", false, false)
    end
end)