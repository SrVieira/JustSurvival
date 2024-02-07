--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local DRAG={}

DRAG.shader=[[
    texture gTexture;
technique replace
{
    pass P0
    {
        Texture[0] = gTexture;
    }
}
]]

DRAG.start={912.6,2440.0710,10}
DRAG.e={912.6,2037.2273,10}

DRAG.start2={901,2440.0710,10}
DRAG.e2={902.2,2037.2273,10}

DRAG.shader=dxCreateShader(DRAG.shader)
DRAG.rt=dxCreateRenderTarget(750,450,true)

DRAG.updateRT=function()
    DRAG.obj=getElementByID("1/4mili")
    if(not DRAG.obj)then return end

    local l=getElementData(DRAG.obj, "list") or {}

    dxSetRenderTarget(DRAG.rt,true)
        dxDrawImage(0,0,750,450,"files/nf_blackbrd.png")

        dxDrawText("Ostatnie czasy:",750/2-500/2,40,500+750/2-500/2,2,tocolor(200,200,200),2,"default-bold","center","top")

        dxDrawText("Nick",750/2-500/2,100,500,2,tocolor(200,200,200),1.5,"default-bold","left","top")
        dxDrawText("Czas",750/2-500/2,100,750/2-500/2+500,2,tocolor(200,200,200),1.5,"default-bold","center","top")
        dxDrawText("Pojazd",750/2-500/2,100,750/2-500/2+500,2,tocolor(200,200,200),1.5,"default-bold","right","top")
        dxDrawRectangle(750/2-500/2,125,500,2) -- center h

        for k,v in pairs(l) do
            local sY = 25*(k-1)

            local r,g,b=200,200,200
            local time=convertTime(v[2]) or "0:00:00"
            dxDrawText(v[1],750/2-500/2,130+sY,500,2,tocolor(r,g,b),1.5,"default","left","top")
            dxDrawText(time,750/2-500/2,130+sY,750/2-500/2+500,2,tocolor(r,g,b),1.5,"default","center","top")
            dxDrawText(v[3],750/2-500/2,130+sY,750/2-500/2+500,2,tocolor(r,g,b),1.5,"default","right","top")
        end
    dxSetRenderTarget()

    dxSetShaderValue(DRAG.shader, "gTexture", DRAG.rt)
    engineApplyShaderToWorldTexture(DRAG.shader, "nf_blackbrd", DRAG.obj)
end

addEventHandler("onClientRender", root, function()
    dxDrawLine3D(DRAG.start[1],DRAG.start[2],DRAG.start[3],DRAG.e[1],DRAG.e[2],DRAG.e[3],tocolor(0,255,0),2)
    dxDrawLine3D(DRAG.start2[1],DRAG.start2[2],DRAG.start2[3],DRAG.e2[1],DRAG.e2[2],DRAG.e2[3],tocolor(0,255,0),2)
end)

addEventHandler("onClientRestore", root, function(clear)
    if(clear)then
        DRAG.updateRT()
    end
end)

addEventHandler("onClientElementDataChange", root, function()
    if(source == DRAG.obj)then
        DRAG.updateRT()
    end
end)

DRAG.updateRT()