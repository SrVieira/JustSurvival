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

    SPAM.blockSpamTimer=setTimer(function() SPAM.blockSpamTimer=nil end, 1000, 1)

    return block
end

local noti = exports.px_noti
local buttons = exports.px_buttons
local line = exports.px_3dline

local sw,sh = guiGetScreenSize()
local zoom = 1920/sw

FUEL = {}

FUEL.vehicle = false
FUEL.newFuel = 0
FUEL.font=false

FUEL.cost=8
FUEL.costLPG=4

FUEL.type = "?"
FUEL.buttons = {}
FUEL.pistolet=false

FUEL.stop=function(veh)
    if(veh)then
        triggerServerEvent("odlozPistolet", resourceRoot, veh)
        setElementFrozen(veh, false)
        setElementData(veh, "vehicle:stationFuel", false, false)
    end

    FUEL.pistolet=false

    triggerServerEvent("stop.tank", resourceRoot)

    removeEventHandler("onClientRender", root, FUEL.onRender)
    removeEventHandler("onClientKey", root, FUEL.onKey)
end

FUEL.onRender = function()
    if(not line:isPlayerHaveLine(localPlayer) or isPedInVehicle(localPlayer))then
        return
    end

    if(FUEL.vehicle and not isElement(FUEL.vehicle))then
        return
    end

    if(FUEL.pistolet and FUEL.vehicle and isElement(FUEL.vehicle))then
        local veh_fuel = getElementData(FUEL.vehicle, "vehicle:fuel") or 25
        local veh_bak = getElementData(FUEL.vehicle, "vehicle:fuelTank") or 25
        local veh_type=getElementData(FUEL.vehicle, "vehicle:fuelType") or "Petrol"
        if(veh_type == "LPG" and FUEL.type == "LPG")then
            veh_fuel=getElementData(FUEL.vehicle, "vehicle:gas") or 25
        end

        veh_fuel = veh_fuel > veh_bak and veh_bak or veh_fuel
        veh_fuel=veh_fuel < 0 and 0 or veh_fuel

        if(getKeyState("mouse2") and (veh_fuel+FUEL.newFuel) < veh_bak)then
            FUEL.newFuel = FUEL.newFuel+0.1

            local cost=FUEL.type == "LPG" and FUEL.costLPG or FUEL.cost
            cost=math.floor(FUEL.newFuel*cost)

            update3D(FUEL.object, 2, cost.."$")
            update3D(FUEL.object, 3, string.format("%.2f", FUEL.newFuel).."l")

            setElementData(FUEL.vehicle, "vehicle:stationFuel", {
                cost=FUEL.type == "LPG" and FUEL.costLPG or FUEL.cost,
                fuel=veh_fuel+FUEL.newFuel
            }, false)
        end

        toggleControl("fire",false)
    end
end

FUEL.onKey=function(btn,press)
    if(press)then
        if(btn == "mouse1" and not isCursorShowing())then
            if(FUEL.pistolet)then
                wyjmijPistolet(FUEL.vehicle)
                FUEL.pistolet=false

                noti:noti("Użyj LPM aby włożyć pistolet.")
            else
                local veh=getTarget()
                if(veh and isElement(veh) and getElementType(veh) == "vehicle")then                    
                    local accept_type=false
                    local veh_type = getElementData(veh, "vehicle:fuelType") or "Petrol"
                    if(veh_type == FUEL.type or (veh_type == "LPG" and FUEL.type == "Petrol"))then
                        accept_type=true
                    end

                    if(accept_type)then
                        wlozPistolet(veh)

                        local veh_fuel = getElementData(veh, "vehicle:fuel") or 25
                        local veh_bak=getElementData(veh, 'vehicle:fuelTank') or 25
                        veh_fuel = veh_fuel > veh_bak and veh_bak or veh_fuel
                        veh_fuel=veh_fuel < 0 and 0 or veh_fuel

                        local cost=FUEL.type == "LPG" and FUEL.costLPG or FUEL.cost
                        setElementData(veh, "vehicle:stationFuel", {
                            cost=cost,
                            fuel=veh_fuel
                        }, false)

                        FUEL.vehicle=veh
                        FUEL.pistolet=true

                        noti:noti("Użyj LPM aby wyjąć pistolet, a PPM aby tankować.")
                    else
                        noti:noti("Ten pojazd nie obsługuje tego paliwa.", "error")
                    end
                else
                    noti:noti("Najpierw podejdź pod pojazd.")
                end
            end
        end
    end
end

addEvent("action.tank", true)
addEventHandler("action.tank", resourceRoot, function(type, destroy, object)
    if(type == 1)then
        noti = exports.px_noti
        buttons = exports.px_buttons
        line = exports.px_3dline

        addEventHandler("onClientRender", root, FUEL.onRender)
        addEventHandler("onClientKey", root, FUEL.onKey)

        FUEL.newFuel = 0
        FUEL.type = destroy
        FUEL.object=object

        noti:noti("Podejdź pod pojazd i użyj LPM aby włożyć pistolet.")

        if(not FUEL.font)then
            FUEL.font=dxCreateFont(":px_assets/fonts/Font-SemiBold.ttf", 35)
        end

        setElementData(localPlayer, "user:tank", true, false)
    elseif(type == 2)then
        setElementData(localPlayer, "user:tank", false, false)

        removeEventHandler("onClientRender", root, FUEL.onRender)
        removeEventHandler("onClientKey", root, FUEL.onKey)

        if(FUEL.font and isElement(FUEL.font))then
            destroyElement(FUEL.font)
            FUEL.font=false
        end

        if(destroy)then
            updatePB(object or FUEL.object)
        else
            if(FUEL.newFuel >= 1)then
                local cost=FUEL.type == "LPG" and FUEL.costLPG or FUEL.cost
                cost=math.floor(FUEL.newFuel*cost)
                triggerServerEvent("fuel.add", resourceRoot, FUEL.vehicle, FUEL.newFuel, cost, FUEL.type)
            else
                noti:noti("Do pojazdu możesz dolać minimum 1 litr.")
            end
        end
    end
end)

-- off
setTimer(function()
    setObjectBreakable(resourceRoot, false)
end, 50, 1)

-- 3D DYSTRYBUTORY :D

local texs={}

function update3D(object, texture, text)
    if(not object or object and not isElement(object))then return end

    if(not texs[object])then
        texs[object]={
            element=object,

            targets={
                dxCreateRenderTarget(228, 56, true),
                dxCreateRenderTarget(228, 56, true),
                dxCreateRenderTarget(228, 56, true),
            },

            shaders={
                dxCreateShader("shaders/shader.fx"),
                dxCreateShader("shaders/shader.fx"),
                dxCreateShader("shaders/shader.fx")
            },

            texs={
                "cenal",
                "kwota",
                "ilosc"
            }
        }
    end

    local i=texture
    local v1=texs[object].targets[i]
    local v2=texs[object].shaders[i]
    local v3=texs[object].texs[i]
    if(v1 and v2 and v3)then
        local font=false
        if(not FUEL.font)then
            font=dxCreateFont(":px_assets/fonts/Font-SemiBold.ttf", 35)
        end

        dxSetRenderTarget(v1)
            dxDrawRectangle(0, 0, 228, 56, tocolor(15,15,15))
            dxDrawText(text, 0, 0, 228, 56, tocolor(100,100,100), 1, FUEL.font or font, "center", "center")
        dxSetRenderTarget()

        dxSetShaderValue(v2, "shader", v1)
        engineApplyShaderToWorldTexture(v2, v3, object)

        if(font)then
            destroyElement(font)
            font=nil

            if(FUEL.font and isElement(FUEL.font))then
                destroyElement(FUEL.font)
            end
            FUEL.font=false
        end
    end
end

function delete()
    local v=texs[object]
    if(v)then
        for i,v in pairs(v.targets) do
            destroyElement(v)
        end

        for i,v in pairs(v.shaders) do
            destroyElement(v)
        end

        texs[object]=nil
    end
end

function updatePB(v)
    local cost=(v and isElement(v) and getElementModel(v) == 1676) and FUEL.costLPG or FUEL.cost
    update3D(v, 1, cost.."$/1l")
    update3D(v, 2, "0$")
    update3D(v, 3, "0L")
end

for i,v in pairs(getElementsByType("object", resourceRoot, true)) do
    if(getElementModel(v) == 3465 or getElementModel(v) == 1676)then
        updatePB(v)
    end
end

addEventHandler("onClientRestore", root, function()
    for i,v in pairs(getElementsByType("object", resourceRoot, true)) do
        if(getElementModel(v) == 3465 or getElementModel(v) == 1676)then
            updatePB(v)
        end
    end

    if(FUEL.object and isElement(FUEL.object))then
        FUEL.newFuel = FUEL.newFuel+0.01

        local cost=FUEL.type == "LPG" and FUEL.costLPG or FUEL.cost
        cost=math.floor(FUEL.newFuel*cost)

        update3D(FUEL.object, 2, cost.."$")
        update3D(FUEL.object, 3, string.format("%.2f", FUEL.newFuel).."l")
    end
end)

addEventHandler("onClientElementStreamIn", resourceRoot, function()
    if(getElementModel(source) == 3465 or getElementModel(source) == 1676)then
        updatePB(source)
    end
end)

addEventHandler("onClientElementStreamOut", resourceRoot, function()
    if(getElementModel(source) == 3465 or getElementModel(source) == 1676)then
        delete(source)
    end
end)

function wlozPistolet(veh)
    local xx,yy,zz=getVehicleModelDummyPosition(getElementModel(veh), "gas_cap")
    setElementFrozen(veh,true)

    zz=zz+0.05
    local m=180
    if(xx < 0)then
        xx=xx-0.2
        m=0
    else
        xx=xx+0.2
        m=180
    end

    local x,y,z=getPositionFromElementOffset(veh, xx, yy, zz)
    local rx,ry,rz=getElementRotation(veh)
    local oPos={x,y,z,rx,ry+50,rz-m}

    local p1,p2,p3=0,0,0
    local mm=90
    if(xx < 0)then
        xx=xx-0.2
        mm=90
        p1=-0.4
    else
        p1=0.51
        p2=0.01
        mm=270
    end

    x,y,z=getPositionFromElementOffset(veh, xx+p1,yy+p2,zz)
    local pPos={x,y,z,0,0,rz-mm}

    triggerServerEvent("wstawPistolet", resourceRoot, oPos[1], oPos[2], oPos[3], oPos[4], oPos[5], oPos[6], pPos[1], pPos[2], pPos[3], pPos[4], pPos[5], pPos[6], veh)
end

function wyjmijPistolet(veh)
    if(veh)then
        setElementFrozen(veh, false)
    end

    triggerServerEvent("wezPistolet", resourceRoot, veh)

    setElementData(veh, "vehicle:stationFuel", false, false)
end

-- useful

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix(element)
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x,y,z
end

function getTarget()
	local camPos = {getCameraMatrix()}
	local myPos = {getElementPosition(localPlayer)}

	local _,_,rotZ = getElementRotation(localPlayer)
	local x,y = (camPos[1] - math.sin(math.rad(rotZ)) * 7.5), (camPos[2] + math.cos(math.rad(rotZ)) * 7.5)

	local _,_,_,_,element = processLineOfSight(myPos[1], myPos[2], myPos[3], x, y, myPos[3])

    return element
end