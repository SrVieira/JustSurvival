--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- variables

local Line={}

Line.tex=dxCreateTexture("firehose.png", "argb", false, "clamp")
Line.color=tocolor(0,0,0)

Line.elements={}

Line.veh=false

-- renders

Line.myRender=function()
    local data=getElementData(localPlayer, "3dlines")
    if(not data)then
        Line.destroy(localPlayer)
    else
        if(#data >= 30 or getPedOccupiedVehicle(localPlayer))then
            Line.destroy(localPlayer)
        else
            local v=data[#data]
            local bonePos={getPedBonePosition(localPlayer, 25)}
            local myPos={getElementPosition(localPlayer)}
            local dist=getDistanceBetweenPoints2D(v[1], v[2], bonePos[1], bonePos[2])
            if( ((dist > 2 and v[6]) or (dist > 2.5 and not v[6])) and not data.block )then
                local ground=getGroundPosition(myPos[1], myPos[2], myPos[3])
                local cs1=createColTube(myPos[1], myPos[2], ground, 0.5, 5)
                table.insert(data, {myPos[1], myPos[2], ground+0.1, cs1, false, true})
                setElementData(localPlayer, "3dlines", data)
            end
        end
    end

    if(Line.veh and isElement(Line.veh))then
        setVehicleEngineState(Line.veh,false)
        for i=0,3 do
            setVehicleLightState(Line.veh, i, 1)
        end
    end
end

Line.onRender = function()
    -- draw
    for k,data in pairs(Line.elements) do
        if(k and isElement(k) and data)then
            local tbl=smooth3D(data, 8)
            local lx, ly, lz=0,0,0
            local xx=0
            if(#tbl > 2)then
                for i,v in pairs(tbl) do
                    xx=xx+1
    
                    if(tbl[xx+1])then
                        local endPos = tbl[xx+1]
                        dxDrawMaterialLine3D(v.x, v.y, v.z, endPos.x, endPos.y, endPos.z, Line.tex, 0.15, tocolor(255, 255, 255, 255))
                    else
                        lx, ly, lz = v.x, v.y, v.z, x,y,z
                    end
                end
            elseif(#tbl == 2)then
                local endPos = data[2]
                dxDrawMaterialLine3D(data[1][1], data[1][2], data[1][3], endPos[1], endPos[2], endPos[3], Line.tex, 0.15, tocolor(255, 255, 255, 255))

                lx, ly, lz = endPos[1], endPos[2], endPos[3]
            elseif(#tbl == 1)then
                lx, ly, lz = data[1][1], data[1][2], data[1][3]
            end

            local x,y,z = getPedBonePosition(k, 25)
            if(data.block)then
                x,y,z=unpack(data.block)
            end

            local lastX, lastY, lastZ = x, y, z
            for i = 1, 20 do
                local x, y = interpolateBetween(x, y, 0, lx, ly, 0, i/20, "Linear")
                local z = z + interpolateBetween(0, 0, 0, lz-z, 0, 0, i/20, "InOutQuad")
                dxDrawMaterialLine3D(lastX, lastY, lastZ, x, y, z, Line.tex, 0.15, tocolor(255, 255, 255, 255))
                lastX, lastY, lastZ = x, y, z
            end
        end
    end
end
addEventHandler("onClientRender", root, Line.onRender)

-- functions

Line.setLastPosition=function(pos)
    local data=getElementData(localPlayer, "3dlines")
    data.block=pos
    setElementData(localPlayer,"3dlines",data)
end
addEvent("setLastPosition", true)
addEventHandler("setLastPosition", resourceRoot, Line.setLastPosition)

Line.create=function(player, pos, ped, veh)
    local data=getElementData(localPlayer, "3dlines") or {}
    table.insert(data,{pos[1],pos[2],pos[3],false,false,true})
    setElementData(player, "3dlines", data)

    addEventHandler("onClientColShapeHit", resourceRoot, Line.onHit)
    addEventHandler("onClientColShapeLeave", resourceRoot, Line.onLeave)
    addEventHandler("onClientRender", root, Line.myRender)

    Line.veh=veh
end
addEvent("Line.create", true)
addEventHandler("Line.create", resourceRoot, Line.create)

Line.destroy=function(player)
    removeEventHandler("onClientColShapeHit", resourceRoot, Line.onHit)
    removeEventHandler("onClientColShapeLeave", resourceRoot, Line.onLeave)
    removeEventHandler("onClientRender", root, Line.myRender)

    setElementData(player, "3dlines", false)

    Line.veh=false
end
addEvent("Line.destroy", true)
addEventHandler("Line.destroy", resourceRoot, Line.destroy)

Line.onHit = function(hit)
    if(hit ~= localPlayer)then return end

    local data=getElementData(localPlayer, "3dlines")
    if(not data)then
        Line.destroy(localPlayer)
    else
        local quit1 = data[#data][5]
        for i,v in pairs(data) do
            if(source == v[4] and quit1)then
                for i = i,#data do
                    if(data[i][4] and isElement(data[i][4]))then
                        destroyElement(data[i][4])
                    end
            
                    data[i] = nil
                    data[#data][6] = false

                    setElementData(localPlayer, "3dlines", data)
                end
                break
            end
        end
    end
end

Line.onLeave = function(hit)
    if(hit ~= localPlayer)then return end
    
    local data=getElementData(localPlayer, "3dlines")
    if(not data)then
        Line.destroy(localPlayer)
    else
        for i,v in pairs(data)do
            if(v[4] and source == v[4])then
                v[5] = true

                setElementData(localPlayer, "3dlines", data)
                break
            end
        end
    end
end

-- synchro

addEventHandler("onClientElementDataChange", root, function(data,old,new)
    if(data == "3dlines" and isElementStreamedIn(source))then
        Line.elements[source]=getElementData(source, "3dlines")
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
    if(getElementType(source) == "player" and getElementData(source, "3dlines"))then
        Line.elements[source]=getElementData(source, "3dlines")
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if(Line.elements[source])then
        Line.elements[source]=nil
    end
end)

addEventHandler("onClientPlayerQuit", root, function()
    if(Line.elements[source])then
        Line.elements[source]=nil
    end
end)

-- useful

function smooth3D( points, steps, count )
    if #points < 3 then
        return points
    end
    local steps = steps or 5
    local spline = {}
    local count = (#points - 1) - (count or 0)
    local p0, p1, p2, p3, x, y, z
    for i = 1, count do
        if i == 1 then
            p0, p1, p2, p3 = points[i], points[i], points[i + 1], points[i + 2]
        elseif i == count then
            p0, p1, p2, p3 = points[#points - 2], points[#points - 1], points[#points], points[#points]
        else
            p0, p1, p2, p3 = points[i - 1], points[i], points[i + 1], points[i + 2]
        end
        if(p0 and p1 and p2 and p3)then
            for t = 0, 1, 1 / steps do
                x = 0.5 * ( ( 2 * p1[1] ) + ( p2[1] - p0[1] ) * t + ( 2 * p0[1] - 5 * p1[1] + 4 * p2[1] - p3[1] ) * t * t + ( 3 * p1[1] - p0[1] - 3 * p2[1] + p3[1] ) * t * t * t )
                y = 0.5 * ( ( 2 * p1[2] ) + ( p2[2] - p0[2] ) * t + ( 2 * p0[2] - 5 * p1[2] + 4 * p2[2] - p3[2] ) * t * t + ( 3 * p1[2] - p0[2] - 3 * p2[2] + p3[2] ) * t * t * t )
                z = 0.5 * ( ( 2 * p1[3] ) + ( p2[3] - p0[3] ) * t + ( 2 * p0[3] - 5 * p1[3] + 4 * p2[3] - p3[3] ) * t * t + ( 3 * p1[3] - p0[3] - 3 * p2[3] + p3[3] ) * t * t * t )
                if not(#spline > 0 and spline[#spline][1] == x and spline[#spline][2] == y ) then
                    table.insert( spline , { x = x , y = y, z = z } )
                end
            end
        end
    end
    return spline
end

function table.size(tbl)
    local x=0; for i,v in pairs(tbl) do x=x+1; end; return x;
end

-- start

for i,v in pairs(getElementsByType("player")) do
    if(isElementStreamedIn(v) and getElementData(v, "3dlines"))then
        Line.elements[v]=true
    end
end

setElementData(localPlayer, "3dlines", false)

-- community

addEventHandler("onClientPlayerHitByWaterCannon",getRootElement(),
    function(player)
        cancelEvent()
    end
)

addEventHandler("onClientPedHitByWaterCannon",getRootElement(),
    function(ped)
        cancelEvent()
    end
)

local stateVehicle = false

function controlStateRender ( )
    if stateVehicle and isElement(stateVehicle) then
        local data=getElementData(stateVehicle, "PSP_WATER") or 0
        if data > 0 then
            data=data-0.1
            
            setElementData(stateVehicle, "PSP_WATER", data, false)
            setElementData(stateVehicle, "3dui_text", {
                text="Poziom wody: "..math.floor(data).."L",
                type="water",
            }, false)
        else            
            setElementData ( localPlayer, "waterCannon", false )

            stateVehicle = false

            setElementData(stateVehicle, "3dui_text", {
                text="Poziom wody: "..math.floor(data).."L",
                type="water",
            })
            setElementData(stateVehicle, "PSP_WATER", data)

            triggerServerEvent("destroyElements", resourceRoot, localPlayer)

            removeEventHandler("onClientRender", root, controlStateRender)
        end
    end
end

addEvent ( "setPedControlState", true ) 
addEventHandler ( "setPedControlState", getRootElement(), 
    function ( ped, state, veh, player ) 
        setPedControlState ( ped, "vehicle_fire", state ) 

        if(player ~= localPlayer)then return end

        removeEventHandler("onClientRender", root, controlStateRender)
        if ( state ) then
            stateVehicle = veh
            addEventHandler("onClientRender", root, controlStateRender)
        else
            if(stateVehicle and isElement(stateVehicle))then
                setElementData(stateVehicle, "PSP_WATER", getElementData(stateVehicle, "PSP_WATER"))
                setElementData(stateVehicle, "3dui_text", {
                    text="Poziom wody: "..math.floor(getElementData(stateVehicle, "PSP_WATER")).."L",
                    type="water",
                })
            end

            stateVehicle = false
        end
    end 
) 