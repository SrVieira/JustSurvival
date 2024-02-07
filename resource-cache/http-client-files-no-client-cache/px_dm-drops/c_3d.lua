--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local shader=[[
texture shader;
technique replace
{
pass P0
{
Texture[0] = shader;
}
}
]]

c={}

c.rt={}

c.texName="ekran"

c.timer=false

c.startTimer=function(obj)
    c.timer=setTimer(function()
        local data=getElementData(obj, "openTime")
        data=data-1

        if(data > 0)then
            setElementData(obj, "openTime", data)
        else
            setElementData(obj, "openTime", false)

            killTimer(c.timer)
            c.timer=nil

            setElementData(obj, "block", false)
            setElementData(localPlayer, "block", false)

            setElementData(obj, "interaction", {options={
                {name="Otwórz sejf", alpha=0, animate=false, tex=":px_dm-drops/textures/bus.png"},
            }, scriptName="px_dm-drops", dist=3})

            c.setObjectText(obj, 0)
        end
    end, 1000, 0)
end

c.setObjectText=function(object, text)
    text=text or 0

    if(not c.rt[object])then
        c.rt[object]={
            shader=dxCreateShader(shader),
            rt=dxCreateRenderTarget(206, 131, true)
        }
    end

    local hours = math.floor(text/60)
    local minutes = math.floor(text-(hours*60))
    text=hours..":"..string.format("%02d", minutes)

    dxSetRenderTarget(c.rt[object].rt, true)
        dxDrawRectangle(0, 0, 206, 131, tocolor(0,0,15))
        dxDrawText(text, 0, 0, 206, 131, tocolor(255, 255, 255), 5, "default-bold", "center", "center")
    dxSetRenderTarget()

    dxSetShaderValue(c.rt[object].shader, "shader", c.rt[object].rt)
    engineApplyShaderToWorldTexture(c.rt[object].shader, c.texName, object)
end

c.destroyObjectText=function(object)
    if(c.rt[object])then
        engineRemoveShaderFromWorldTexture(c.rt[object].shader, c.texName, object)
        
        destroyElement(c.rt[object].rt)
        destroyElement(c.rt[object].shader)

        c.rt[object]=nil
    end
end

addEventHandler("onClientElementDataChange", resourceRoot, function(data, old, new)
    if(data == "openTime" and new and (new ~= old))then
        c.setObjectText(source, new)
    end
end)

addEventHandler("onClientElementStreamIn", resourceRoot, function()
    local text=getElementData(source, "openTime") or 0
    c.setObjectText(source, text)
end)

addEventHandler("onClientElementStreamOut", resourceRoot, function()
    c.destroyObjectText(source)
end)

for i,v in pairs(getElementsByType("object", resourceRoot, true)) do
    local text=getElementData(v, "openTime") or 0
    c.setObjectText(v, text)
end