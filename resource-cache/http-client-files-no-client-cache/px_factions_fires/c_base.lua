--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- replace

local id=engineRequestModel("object")
if(id)then
    local dff = engineLoadDFF("fire.dff", id)
    engineReplaceModel(dff, id)

    exports.px_models_encoder:addCustomModel("fire",id)
end

-- system

local Fire={}

Fire.element=false

Fire.render=function()
	if(isPedAiming() and getPedTarget(localPlayer) and getPedWeapon(localPlayer) == 42 and getElementData(getPedTarget(localPlayer),"fire_info"))then
		Fire.element = getPedTarget(localPlayer)
	else
		Fire.element = false
	end

    if(Fire.element and getElementData(localPlayer, "waterCannon"))then
        local hp=getElementData(Fire.element, "fire_health") or 100
        hp=hp-0.1
        if(hp <= 0)then
            local id=getElementData(Fire.element, "fire_info")
            if(id)then
                triggerServerEvent("Fire.destroy", resourceRoot, id)
                Fire.element=false
            end
        else
            setElementData(Fire.element, "fire_health", hp)
            setElementData(Fire.element, "3dui_text", {
                text="Stan ognia: "..string.format("%.1f", hp).."%",
                type="fire",
            })
        end
    end
end

addEventHandler("onClientElementDataChange", root, function(data,old,new)
    if(data == "3dlines" and source == localPlayer)then
        removeEventHandler("onClientRender", root, Fire.render)
        if(new)then
            addEventHandler("onClientRender", root, Fire.render)
        end
    elseif(data == "fire_health" and new and tonumber(new))then
        setElementHealth(source,new)
    end
end)

if(getElementData(localPlayer, "3dlines"))then
    addEventHandler("onClientRender", root, Fire.render)
end

-- useful

function isPedAiming()
	if getPedTask(localPlayer, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
		return true
	end
	return false
end