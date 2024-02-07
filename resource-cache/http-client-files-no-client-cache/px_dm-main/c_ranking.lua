--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local Rank={}

Rank.shader=[[
    texture gTexture;
technique replace
{
    pass P0
    {
        Texture[0] = gTexture;
    }
}
]]

Rank.shader=dxCreateShader(Rank.shader)
Rank.rt=dxCreateRenderTarget(750,450,true)

Rank.updateRT=function()
    Rank.obj=getElementByID("Respect_Ranking")
    if(not Rank.obj)then return end

    local l=getElementData(Rank.obj, "list") or {}

    dxSetRenderTarget(Rank.rt,true)
        dxDrawImage(0,0,750,450,"files/nf_blackbrd.png")

        dxDrawText("Danger Zone - Ranking",750/2-500/2,40,500+750/2-500/2,2,tocolor(200,200,200),2,"default-bold","center","top")

        dxDrawText("Nick",750/2-500/2,100,500,2,tocolor(200,200,200),1.5,"default-bold","left","top")
        dxDrawText("Respekt",750/2-500/2,100,750/2-500/2+500,2,tocolor(200,200,200),1.5,"default-bold","right","top")
        dxDrawRectangle(750/2-500/2,125,500,2) -- center h

        for k,v in pairs(l) do
            local sY = 25*(k-1)
            local r,g,b=200,200,200

            dxDrawText(v.login,750/2-500/2,130+sY,500,2,tocolor(r,g,b),1.5,"default","left","top")
            dxDrawText(v.respect,750/2-500/2,130+sY,750/2-500/2+500,2,tocolor(r,g,b),1.5,"default","right","top")
        end
    dxSetRenderTarget()

    dxSetShaderValue(Rank.shader, "gTexture", Rank.rt)

    for i,v in pairs(getElementsByType("object", resourceRoot)) do
        engineApplyShaderToWorldTexture(Rank.shader, "nf_blackbrd", v)
    end
end

addEventHandler("onClientRestore", root, function(clear)
    Rank.updateRT()
end)

addEventHandler("onClientElementDataChange", root, function()
    if(source == Rank.obj)then
        Rank.updateRT()
    end
end)

Rank.updateRT()