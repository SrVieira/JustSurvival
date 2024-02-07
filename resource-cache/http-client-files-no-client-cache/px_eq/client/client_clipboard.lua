--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- global variables

local sw,sh=guiGetScreenSize()
local zoom=1920/sw

-- exports

local blur=exports.blur

-- assets

local assets={}
assets.list={
    texs={
        "assets/images/bagaznik.png",
        
        "assets/images/box.png",
        "assets/images/hover.png",

        "assets/images/ESC.png",
    },

    fonts={
        {"Medium", 25},
        {"Regular", 12},
        {"Regular", 10},
        {"Regular", 15},
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

eq={}

eq.vehicle=false
eq.selectedItem=false
eq.showed=false

eq.trigger=false

eq.positions={}
for i=1,2 do
    local sY=(80/zoom)*(i-1)
    for i=1,5 do
        local sX=(89/zoom)*(i-1)
        eq.positions[#eq.positions+1]={sX=sX,sY=sY}
    end
end

-- functions

eq.updateItemPosition=function(id)
    if(UI.trigger or eq.trigger)then return end

    if(UI.animate)then return end

    local items_normal=getElementData(localPlayer, "user:eq")
    if(not items_normal)then return end

    if(eq.showed and eq.vehicle and isElement(eq.vehicle))then
        local clipboard=getElementData(eq.vehicle, "element:safe") or {}
        if(clipboard[id])then
            local px=sw-675/zoom
            local py=sh/2-150/zoom
            for x,v in pairs(eq.positions) do
                if(isMouseInPosition(px+v.sX+15/zoom, py+v.sY+64/zoom, 83/zoom, 75/zoom) and x ~= id)then
                    if(clipboard[x])then
                        if(clipboard[x].name == clipboard[id].name)then
                            clipboard[x].value=clipboard[x].value+clipboard[id].value
                            clipboard[id]=nil

                            triggerServerEvent('set.Data', resourceRoot, eq.vehicle, "element:safe", clipboard)
                            eq.trigger=true
                        end
                    else
                        if(x ~= id)then
                            clipboard[x]=clipboard[id]
                            clipboard[id]=nil

                            triggerServerEvent('set.Data', resourceRoot, eq.vehicle, "element:safe", clipboard)
                            eq.trigger=true
                        end
                    end
                end
            end

            for x,v in pairs(UI.table) do
                if(isMouseInPosition(UI.pos[1]-340/zoom+v.sX, sh/2-180/zoom+v.sY, 133/zoom, 121/zoom))then
                    if(value)then
                        if(items_normal[x])then
                            items_normal[x].value=items_normal[x].value+1
        
                            if(clipboard[id].value == 1)then
                                clipboard[id]=nil
                            else
                                clipboard[id].value=clipboard[id].value-1
                            end
        
                            triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items_normal)
                            triggerServerEvent('set.Data', resourceRoot, eq.vehicle, "element:safe", clipboard)
                            eq.trigger=true
                        else
                            items_normal[x]=clipboard[id]
        
                            if(clipboard[id].value == 1)then
                                clipboard[id]=nil
                            else
                                clipboard[id].value=clipboard[id].value-1
                            end
        
                            triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items_normal)
                            triggerServerEvent('set.Data', resourceRoot, eq.vehicle, "element:safe", clipboard)
                            eq.trigger=true
                        end
                    else
                        if(items_normal[x])then
                            if(items_normal[x].name == clipboard[id].name)then
                                items_normal[x].value=items_normal[x].value+clipboard[id].value
                                clipboard[id]=nil
        
                                triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items_normal)
                                triggerServerEvent('set.Data', resourceRoot, eq.vehicle, "element:safe", clipboard)
                                eq.trigger=true
                            end
                        else
                            if(x ~= id)then
                                items_normal[x]=clipboard[id]
                                clipboard[id]=nil

                                triggerServerEvent('set.Data', resourceRoot, localPlayer, "user:eq", items_normal)
                                triggerServerEvent('set.Data', resourceRoot, eq.vehicle, "element:safe", clipboard)
                                eq.trigger=true
                            end
                        end
                    end
                end
            end
        end
    end
end

function drawClipboard()
    if(not isElement(eq.vehicle))then
        eq.destroy()
        return closeInventory()
    end

    local myPos={getElementPosition(localPlayer)}
    local vehPos={getElementPosition(eq.vehicle)}
    local dist=getDistanceBetweenPoints3D(myPos[1], myPos[2], myPos[3], vehPos[1], vehPos[2], vehPos[3])
    if(dist > 5)then
        eq.destroy()
        return closeInventory()
    end

    toggleControl('forwards', false)
    toggleControl('backwards', false)
    toggleControl('left', false)
    toggleControl('right', false)

    local items=getElementData(localPlayer, "user:eq") or {}
    local clipboard=getElementData(eq.vehicle, "element:safe") or {}

    dxDrawImage(35/zoom, sh-25/zoom-35/zoom, 46/zoom, 25/zoom, assets.textures[4], 0, 0, 0, tocolor(255, 255, 255, UI.alpha))
    dxDrawText("Wyjdź z panelu", 35/zoom+46/zoom+10/zoom, sh-25/zoom-35/zoom, 46/zoom, 25/zoom+sh-25/zoom-35/zoom, tocolor(255, 255, 255, UI.alpha), 1, assets.fonts[1], "left", "center")

    local px=UI.pos[1]
    dxDrawText("Twój ekwipunek", px-1083/2/zoom, sh/2-752/2/zoom+35/zoom+35/zoom, 1083/zoom+px-1083/2/zoom, 752/zoom, tocolor(222, 222, 222, UI.alpha), 1, assets.fonts[3], "center", "top")

    dxDrawImage(sw-770/zoom-90/zoom, sh/2-636/2/zoom, 839/zoom, 636/zoom, assets.textures[1], 0, 0, 0, tocolor(255, 255, 255, UI.alpha))
    dxDrawText(getVehicleName(eq.vehicle).." - schowek", sw-770/zoom-90/zoom, sh/2-636/2/zoom+20/zoom, 839/zoom+sw-770/zoom-90/zoom, 636/zoom, tocolor(222, 222, 222, UI.alpha), 1, assets.fonts[3], "center", "top")

    local x=0
    for i,v in pairs(eq.positions) do
        local px=sw-675/zoom
        local py=sh/2-150/zoom

        x=x+1

        if(not v.alpha)then
            v.alpha=255
        end
        if(not v.hoverAlpha)then
            v.hoverAlpha=0
        end

        if(isMouseInPosition(px+v.sX+15/zoom, py+v.sY+64/zoom, 83/zoom, 75/zoom) and not v.animate and v.hoverAlpha < 100)then
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
        elseif(v.hoverAlpha and not isMouseInPosition(px+v.sX+15/zoom, py+v.sY+64/zoom, 83/zoom, 75/zoom) and not v.animate and v.hoverAlpha > 0)then
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
        dxDrawImage(px+v.sX+15/zoom, py+v.sY+64/zoom, 83/zoom, 75/zoom, assets.textures[2], 0, 0, 0, tocolor(255, 255, 255, v.alpha > a and a or v.alpha))
        dxDrawImage(px+v.sX+15/zoom, py+v.sY+64/zoom, 83/zoom, 75/zoom, assets.textures[3], 0, 0, 0, tocolor(255, 255, 255, v.hoverAlpha > a and a or v.hoverAlpha))

        local item=clipboard[x]
        if(item)then
            local tex=UI.itemsTextures[item.name]
            local tex=getItemTexture(item.name)
            if(tex)then
                dxDrawImage(px+v.sX+15/zoom+(83-50)/2/zoom, py+v.sY+64/zoom+(75-50)/2/zoom, 50/zoom, 50/zoom, tex, 0, 0, 0, tocolor(255, 255, 255, UI.alpha))
            end

            if(isMouseInPosition(px+v.sX+15/zoom+(83-50)/2/zoom, py+v.sY+64/zoom+(75-50)/2/zoom, 50/zoom, 50/zoom) and getKeyState("mouse1") and not UI.scrollItem and not UI.selectedItem2 and not UI.selectedItem and not eq.selectedItem)then
                eq.selectedItem=x
            end

            if(item.value and item.value > 1)then
                dxDrawText(item.value, px+v.sX+15/zoom, py+v.sY+64/zoom+2/zoom, px+v.sX+15/zoom+83/zoom-5/zoom, 75/zoom, tocolor(200, 200, 200, UI.alpha), 1, assets.fonts[2], "right", "top")
            end
        end
    end

    if(eq.selectedItem and not UI.animate)then
        local cx,cy=getCursorPosition()
        cx,cy=cx*sw,cy*sh
        if(getKeyState("mouse1") and clipboard[eq.selectedItem])then
            local tex=UI.itemsTextures[clipboard[eq.selectedItem].name]
            if(tex)then
                dxDrawImage(cx-50/2/zoom, cy-50/2/zoom, 50/zoom, 50/zoom, tex, 0, 0, 0, tocolor(255, 255, 255, UI.alpha), true)
            end
        else
            eq.updateItemPosition(eq.selectedItem)
            eq.selectedItem=false
        end
    end
end

eq.key=function(button,press)
    if(press)then
        if(button == "escape" or button == "i")then
            cancelEvent()
            eq.destroy()
        end 
    end
end

eq.create=function(vehicle)
    if(eq.showed or UI.showed)then return end

    blur=exports.blur

    eq.showed=true

    assets.create()

    eq.vehicle=vehicle

    openInventory("clipboard")

    addEventHandler("onClientKey", root, eq.key)
end

eq.destroy=function()
    if(not eq.showed)then return end

    removeEventHandler("onClientKey", root, eq.key)

    closeInventory()
    setTimer(function()
        assets.destroy()
        eq.showed=false
    end, 550, 1)

    toggleControl('forwards', true)
    toggleControl('backwards', true)
    toggleControl('left', true)
    toggleControl('right', true)
end

function toggleSafe(veh)
    eq.create(veh)
end

addEvent("eq.create", true)
addEventHandler("eq.create", resourceRoot, function(vehicle)
    eq.create(vehicle)
end)

addEvent("stop.trade", true)
addEventHandler("stop.trade", resourceRoot, function()
    closeInventory()
end)

addEvent('set.Data.Off', true)
addEventHandler('set.Data.Off', resourceRoot, function()
    eq.trigger=false
end)