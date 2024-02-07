--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local script_name="px_models_encoder"

addEventHandler("onClientElementStreamIn", root, function()
    if(source and isElement(source))then
        local name=getElementData(source, "custom_name")
        if(name)then
            local id=exports[script_name]:getCustomModelID(name)
            if(id)then
                setElementModel(source, id)
            end
        end
    end
end)

addEventHandler("onClientElementDataChange", root, function(data,last,new)
    if(data == "custom_name" and new)then
        local id=exports[script_name]:getCustomModelID(new)
        if(id)then
            setElementModel(source, id)
        end
    elseif(data == "custom_name" and not new)then
        local skin=getElementData(source, "user:skin")
        if(skin)then
            setElementModel(source, skin)
        end
    end
end)