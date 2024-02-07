--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- exports

blur=exports.blur
alogo=exports.px_alogos
avatars=exports.px_avatars
edits=exports.px_editbox
btns=exports.px_buttons
loading=exports.px_loading
scroll=exports.px_scroll

-- assets

assets={}
assets.list={
    texs={
        "textures/bg.png",
        "textures/avatar_outline.png",
        "textures/news.png",
        "textures/fixbug.png",
        "textures/update.png",
        "textures/checkbox.png",
        "textures/checkbox_selected.png",
        "textures/news_line.png",

        "textures/zones/bg.png",
        "textures/zones/map_shadow.png",
        "textures/zones/placeholder.png",
        "textures/zones/card-back.png",
        "textures/zones/card.png",
        "textures/zones/button_hover.png",
        "textures/zones/lv-icon.png",

        "textures/circle_avatar.png",
    },

    fonts={
        {"SemiBold", 18},
        {"Medium", 13},
        {"Regular", 12},
        {"Bold", 15},
        {"Bold", 25},
    },
}

assets.create=function()
    assets.textures={}
    for i,v in pairs(assets.list.texs) do
        assets.textures[i]=dxCreateTexture(v, "argb", false, "clamp")
    end

    assets.fonts={}
    for i,v in pairs(assets.list.fonts) do
        assets.fonts[i]=dxCreateFont(":px_assets/fonts/Font-"..v[1]..".ttf", v[2]/zoom)
    end
end

assets.destroy=function()
    for i,v in pairs(assets.textures) do
        if(v and isElement(v))then
            destroyElement(v)
        end
    end
    assets.textures={}

    for i,v in pairs(assets.fonts) do
        if(v and isElement(v))then
            destroyElement(v)
        end
    end
    assets.fonts={}
end

-- variables

ui={}

ui.rules=0
ui.selectedUpdate=1
ui.selectedUpdateTextAlpha=255
ui.save=0
ui.draw={}
ui.option="LOGOWANIE"
ui.border={}
ui.mainAlpha=255
ui.animate=false
ui.options={
    ["LOGOWANIE"]={x=315/zoom, y=490/zoom, a=255, a2=255},
    ["REGISTRO"]={x=492/zoom, y=390/zoom, a=150, a2=0},
    ["WYBÓR SPAWNU"]={a2=0},
}

ui.login_save=""
ui.password_save=""

ui.edits={}
ui.btns={}
ui.scroll=false

-- functions

ui.onRender=function()
    if(ui.banStatus)then
        CAM.render()
        blur:dxDrawBlur(0,0,sw,sh)
        dxDrawImage(0,0,sw,sh,assets.textures[9],0,0,0,tocolor(255,255,255,ui.mainAlpha>100 and 100 or ui.mainAlpha))
        dxDrawImage(0,0,sw,sh,assets.textures[1],0,0,0,tocolor(255,255,255,ui.mainAlpha))
        dxDrawText("ZOSTAŁEŚ ZBANOWANY", 0, 0, sw, sh, tocolor(200,200,200,200), 1, assets.fonts[1], "center", "center")
        
        local ban_text = "-----------------\nOsoba banująca: "..ui.banStatus['admin'].."\nPowód: "..ui.banStatus['reason'].."\nCzas trwania kary: "..ui.banStatus['date'].."\n\nJeżeli uważasz, że kara została nadana niesłusznie bądź jej czas trwania\nwykracza poza normy, możesz napisać odwołanie.\n-----------------";
        dxDrawText(ban_text, 0, 200/zoom, sw, sh, tocolor(200,200,200,200), 1, assets.fonts[2], "center", "center")

        local exitButton = {sw/2 - 187/2/zoom, sh - 150/zoom, 187/zoom, 38/zoom}
        dxDrawText("Od kary możesz się odwołać na naszym forum:\npixelmta.pl", exitButton[1], exitButton[2] - 100/zoom, exitButton[1]+exitButton[3], exitButton[2]+exitButton[4], tocolor(200,200,200,200), 1, assets.fonts[1], "center", "top")

        if(not ui.btns[1])then
            ui.btns[1]=btns:createButton(exitButton[1], exitButton[2], exitButton[3], exitButton[4], "OPUŚĆ SERWER", 255, 10, false, false, false, {132,39,39})
        end

        onClick(exitButton[1], exitButton[2], exitButton[3], exitButton[4], function()
            if(SPAM.getSpam())then return end
            triggerServerEvent("px_auth->leaveServer", resourceRoot, ui.banStatus)
        end)
        return
    end

    local visible=loading:isLoadingVisible()
    if(visible)then 
        if(sound and isElement(sound))then
            music(false)
        end
        return 
    else
        if(not sound and not isElement(sound))then
            music(true)
        end
    end

    CAM.render()

    if(ui.option ~= "WYBÓR SPAWNU")then
        blur:dxDrawBlur(0,0,sw,sh)
        dxDrawImage(0,0,sw,sh,assets.textures[9],0,0,0,tocolor(255,255,255,ui.mainAlpha>100 and 100 or ui.mainAlpha))
        dxDrawImage(0,0,sw,sh,assets.textures[1],0,0,0,tocolor(255,255,255,ui.mainAlpha))
        alogo:dxDrawLogo(205/zoom,130/zoom,276/zoom,90/zoom,ui.mainAlpha)
    end

    if(ui.draw[ui.option])then
        local a2=ui.options[ui.option].a2 > ui.mainAlpha and ui.mainAlpha or ui.options[ui.option].a2
        local a=ui.option ~= "WYBÓR SPAWNU" and a2 or ui.options[ui.option].a2
        ui.draw[ui.option](a)
    end

    if(ui.option ~= "WYBÓR SPAWNU")then
        for i,v in pairs(ui.options) do
            if(i ~= "WYBÓR SPAWNU")then
                local w=dxGetTextWidth(i,1,assets.fonts[1])
                if(not ui.border[1] or not ui.border[2])then
                    ui.border={
                        (v.x-w)+(w-104/zoom)/2,
                        v.y
                    }
                end

                local y=ui.border[2]
                dxDrawText(i, v.x-w, y, w+v.x-w, 30/zoom+y, tocolor(200,200,200,v.a > ui.mainAlpha and ui.mainAlpha or v.a), 1, assets.fonts[1], "center", "center")

                onClick(v.x-w, y, w, 30/zoom, function()
                    ui.animate=true
                    animate(ui.border[1], ((v.x-w)+(w-104/zoom)/2), "InOutQuad", 400, function(a)
                        ui.border[1]=a
                    end, function()
                        ui.animate=false
                    end)

                    animate(ui.border[2], v.y, "InOutQuad", 400, function(a)
                        ui.border[2]=a
                    end)

                    animate(ui.options[ui.option].a, 150, "Linear", 200, function(a)
                        ui.options[ui.option].a=a
                    end, function()
                        for i,v in pairs(ui.edits) do
                            edits:dxDestroyEdit(v)
                        end
                        ui.edits={}

                        for i,v in pairs(ui.btns) do
                            btns:destroyButton(v)
                        end
                        ui.btns={}

                        ui.option=i
                        animate(ui.options[ui.option].a, 255, "Linear", 200, function(a)
                            ui.options[ui.option].a=a
                        end)
                    end)

                    animate(ui.options[ui.option].a2, 0, "Linear", 200, function(a)
                        ui.options[ui.option].a2=a
                    end, function()
                        animate(ui.options[ui.option].a2, 255, "Linear", 200, function(a)
                            ui.options[ui.option].a2=a
                        end)
                    end)
                end)
            end
        end

        dxDrawRectangle(ui.border[1],ui.border[2]+35/zoom,104/zoom,1,tocolor(33,92,108,ui.mainAlpha))
    end
end

ui.create=function()
    assets.create()

    addEventHandler("onClientRender", root, ui.onRender)
    setPlayerHudComponentVisible("all", false)
    showCursor(true)
    fadeCamera(true)
    music(true, ui.banStatus)
    setElementFrozen(localPlayer, true)
    setElementData(localPlayer, "user:hud_disabled", true, false)

    if(ui.banStatus)then return end

    triggerServerEvent("ui.getSave", resourceRoot)

    ui.rt=dxCreateRenderTarget(475/zoom,1080/zoom,true)
    ui.map=exports.px_map:getMapTextureWithBlips()

    addEventHandler("onClientRestore", root, restore)
end

function restore()
    ui.rt=dxCreateRenderTarget(475/zoom,1080/zoom,true)
    ui.map=exports.px_map:getMapTextureWithBlips()
end

ui.destroy=function(login, pos)
    ui.animate=true
    animate(ui.mainAlpha, 0, "Linear", 500, function(a)
        ui.mainAlpha=a

        scroll:dxScrollSetAlpha(ui.scroll, a)
    end, function()
        removeEventHandler("onClientRender", root, ui.onRender)

        showCursor(false)
    
        setElementData(localPlayer, "user:hud_disabled", false, false)
    
        setElementFrozen(localPlayer, false)
    
        music(false)
    
        setCameraTarget(localPlayer)
    
        for i,v in pairs(ui.edits) do
            edits:dxDestroyEdit(v)
        end
        ui.edits={}
    
        for i,v in pairs(ui.btns) do
            btns:destroyButton(v)
        end
        ui.btns={}
    
        destroyElement(ui.rt)
        ui.rt=nil
    
        setPlayerHudComponentVisible("all", false)
        setPlayerHudComponentVisible("crosshair", true)
    
        assets.destroy()
        
        ui.animate=false

        destroyElement(ui.map)
        ui.map=false

        scroll:dxDestroyScroll(ui.scroll)
    end)

    triggerServerEvent("ui.spawnPlayer", resourceRoot, login, pos)
    removeEventHandler("onClientRestore", root, restore)
end

-- triggers

addEvent("ui.setDates", true)
addEventHandler("ui.setDates", resourceRoot, function()
  local data=loadDateFromXML() or {"", ""}
  ui.login_save, ui.password_save=unpack(data)
  if(#ui.login_save > 0)then
      ui.save=1
      ui.checkboxAlpha=255

      edits:dxSetEditText(ui.edits[1], ui.login_save)
      edits:dxSetEditText(ui.edits[2], ui.password_save)
  end
end)

addEvent("ui.showPanel", true)
addEventHandler("ui.showPanel", resourceRoot, function(login, spawns)
    if(ui.animate)then return end

    ui.animate=true
    animate(ui.mainAlpha, 0, "Linear", 500, function(a)
        ui.mainAlpha=a
    end, function()
        for i,v in pairs(ui.edits) do
            edits:dxDestroyEdit(v)
        end
        ui.edits={}
    
        for i,v in pairs(ui.btns) do
            btns:destroyButton(v)
        end
        ui.btns={}
    
        ui.option="WYBÓR SPAWNU"
        ui.login=login
    
        ui.spawns={}
        for i,v in pairs(spawns) do
            ui.spawns[#ui.spawns+1]=v
        end
        for i,v in pairs(ui.spawnsAll) do
            ui.spawns[#ui.spawns+1]=v
        end
        ui.pos=ui.spawns[1].pos
        ui.newPos=ui.spawns[1].pos

        ui.scroll=scroll:dxCreateScroll(1900/zoom, 86/zoom, 4, 200/zoom, 0, 8, ui.spawns, 920/zoom, 0)

        animate(ui.options[ui.option].a2, 255, "Linear", 500, function(a)
            ui.options[ui.option].a2=a
            scroll:dxScrollSetAlpha(ui.scroll, a)
        end, function()
            ui.animate=false
        end)
    end)
end)

-- create login

addEvent("px_auth->responseBan", true)
addEventHandler("px_auth->responseBan", resourceRoot, function(status)
    ui.banStatus = status;
    ui.create()
end)

if(not getElementData(localPlayer, "user:uid"))then
    triggerServerEvent("px_auth->checkBan", resourceRoot)
    --ui.create()
end
