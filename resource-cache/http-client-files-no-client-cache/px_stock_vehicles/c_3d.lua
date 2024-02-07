--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local VEH = {}

-- assets

local assets={
    fonts={},
    fonts_paths={
        {":px_assets/fonts/Font-Medium.ttf", 17},
        {":px_assets/fonts/Font-Regular.ttf", 15},
        {":px_assets/fonts/Font-Regular.ttf", 13},
    },

    textures={},
    textures_paths={
        "textures/search/window.png",
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

VEH.shape = createColPolygon(2758.5244,1224.0465,2860.3921,1224.0924,2860.3872,1382.3395,2798.1992,1382.3472,2797.3958,1302.5215,2758.2861,1302.3951,2758.5247,1224.0465)

VEH.renderUI=function()
    if(isPedInVehicle(localPlayer))then return end
    
    local max_dist=5
    local x,y,z=getElementPosition(localPlayer)
    local elements=getElementsWithinRange(x,y,z,max_dist,"vehicle")
    for i,v in pairs(elements) do
        local puted=getElementData(v, "vehStock:puted")
        if(puted)then
            local pos={getStraightPosition(v, 2)}

            local distance=getDistanceBetweenPoints2D(x, y, pos[1], pos[2])
            distance=distance < 1 and 1 or distance

            if(distance <= max_dist)then
                local sx,sy = getScreenFromWorldPosition(pos[1], pos[2], pos[3]+1)
                if(sx and sy)then
                    local dis=getEasingValue(1-distance/max_dist, "Linear")
                    local alpha=dis*300
                    local size=dis*1.115
                    local font_size=dis*1.115
                    local w,h=500,370

                    local tune=''
                    local infos={
                        {"MK1", 'mk1'},
                        {"MK2", 'mk2'},
                        {"MultiLED", 'multiLED'},
                        {"Zawieszenie", 'suspension'},
                        {"Turbo", 'turbo'},
                        {"Hamulce", 'brakes'},
                        {"Nitro", 'nitro'},
                        {"ASR OFF", 'ASR'},
                        {"ALS", 'ALS'},
                        {"Wykrywacz radarów", 'radarDetector'},
                        {"CB-Radio", 'cbRadio'},
                        {"Kolor licznika", 'speedoColor'},
                        {"Maskowanie szyb", 'tint'},
                    }
                    for _,k in pairs(infos) do
                        local data=getElementData(v, 'vehicle:'..k[2])
                        if(data)then
                            if(data == true)then
                                tune=#tune > 0 and tune..', '..k[1] or k[1]
                            else
                                local text=data == true and 'tak' or data
                                if(k[1] == 'Maskowanie szyb')then
                                    text=text..'%'
                                end
                                tune=#tune > 0 and tune..', '..k[1]..' ('..text..')' or k[1]..' ('..text..')'
                            end
                        end
                    end
                    if(tune == '')then
                        tune='brak'
                    end

                    if(#tune > 50 and #tune < 100)then
                        h=h+20
                    elseif(#tune > 100 and #tune < 150)then
                        h=h+40
                    elseif(#tune > 150)then
                        h=h+60
                    end

                    local info={
                        {"Cena pojazdu:", puted.drawCost.."#5fa324$"},
                        {"Przebieg:", puted.distance.."#1f5378km"},
                        {"Paliwo:", puted.fuel.."#1f5378/#c8c8c8"..puted.tank.."#1f5378L"},
                        {"Pojemność silnika:", puted.engine.."#1f5378dm³ #c9c9c9"..puted.fuelType},
                        {"Spalanie:", puted.fuel_usage.."#1f5378l#c8c8c8/100#1f5378km"},
                        {"Napęd:", puted.naped},
                        {"Właściciel:", (getPlayerFromName(puted.owner) and "#00ff00" or "#ff0000")..puted.owner},
                        {"Dodatkowy tuning:", tune},
                    }

                    if(puted.offline)then
                        info[7][2]=info[7][2].." #c9c9c9(SPRZEDAŻ OFFLINE)"
                    end

                    local p={sx-(w/2)*size, sy-(h/2)*size, w*size, h*size}

                    alpha=alpha>255 and 255 or alpha

                    blur:dxDrawBlur(p[1],p[2],p[3],p[4], tocolor(255, 255, 255, alpha))
                    dxDrawImage(p[1],p[2],p[3],p[4], assets.textures[1], 0, 0, 0, tocolor(255, 255, 255, alpha))

                    dxDrawText(getVehicleName(v).." ("..puted.id..")", p[1],p[2]+(10*size),p[3]+p[1],p[4], tocolor(200,200,200,alpha), font_size, assets.fonts[1], "center", "top")
                    dxDrawRectangle(p[1]+(30*size),p[2]+(50*size),p[3]-(60*size),1,tocolor(85, 85, 85,alpha))

                    for i,v in pairs(info) do
                        local sY=(35*size)*(i-1)
                        dxDrawText(v[1], p[1]+(30*size), p[2]+(60*size)+sY, 0, 0, tocolor(200, 200, 200, alpha), font_size, assets.fonts[2])

                        if(i == #info)then
                            dxDrawText(v[2], p[1]+(30*size), p[2]+(60*size)+sY+(30*size), p[1]+p[3], 0, tocolor(150, 150, 150, alpha), font_size, assets.fonts[3], 'left', 'top', false, true)
                        else
                            dxDrawText(v[2], 0, p[2]+(60*size)+sY, p[1]+p[3]-(30*size), 0, tocolor(200, 200, 200, alpha), font_size, assets.fonts[2], "right", "top", false, false, false, true)
                        end
                    end
                end
            end
        end
    end
end

-- shape

addEvent("onShapeHit", true)
addEventHandler("onShapeHit", resourceRoot, function(elements)
    assets.create()
    addEventHandler("onClientRender", root, VEH.renderUI)
end)

addEventHandler("onClientColShapeLeave", VEH.shape, function(hit, dim)
    if(hit ~= localPlayer or not dim)then return end

    removeEventHandler("onClientRender", root, VEH.renderUI)
    assets.destroy()
end)

-- useful

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end

function getStraightPosition(element, plus)
    local x,y,z = getElementPosition(element)
    local _,_,rot = getElementRotation(element)
    local cx, cy = getPointFromDistanceRotation(x, y, (plus or 0), (-rot))
    return cx,cy,z
end