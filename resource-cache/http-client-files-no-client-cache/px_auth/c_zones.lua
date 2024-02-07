--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

ui.mapPos={3000, 3000}
ui.pos=false
ui.newPos=false
ui.tickPos=0
ui.login=""
ui.positions={}

for i=1,2 do
    local sY=(485/zoom)*(i-1)
    for i=1,4 do
        local sX=(344/zoom)*(i-1)
        ui.positions[#ui.positions+1]={sX=sX,sY=sY}
    end
end

ui.spawnsAll={
    {name="LAS VENTURAS", color={21, 15, 54}, desc="Główne miejsce spawnu", pos={1639.4022,2057.3762,10.7714,269.1829}},
    {name="PARKING LAS VENTURAS", color={204, 194, 255}, desc="Tu przechowasz pojazdy", pos={2397.6077,1482.0354,10.8203,180.7109}},
    {name="URZĄD LAS VENTURAS", color={255, 0, 47}, desc="Tu załatwisz najważniejsze sprawy", pos={944.1544,1733.2072,8.8516,89.8218}},
    {name="BANK LAS VENTURAS", color={0, 255, 247}, desc="Tu załatwisz sprawy finansowe", pos={2438.3713,2377.0122,10.8203,268.9374}},

    {name="LOS SANTOS", color={230, 0, 0}, desc="Strefa zagrożenia", pos={1479.6776,-1657.0281,14.0469}},

    {name="FORT CARSON", color={230, 0, 122}, desc="Okoliczne Miasteczko", pos={-208.1184,1212.5237,19.8906,180.2032}},

    {name="MONTGOMERY", color={102, 0, 44}, desc="Okoliczne Miasteczko", pos={1366.7703,253.0549,19.3827,64.4944}},
}
ui.spawns={}

ui.lastRow=1
ui.row=1

ui.draw["WYBÓR SPAWNU"]=function(a)
    local x,y,z=interpolateBetween(ui.pos[1],ui.pos[2],ui.pos[3],ui.newPos[1],ui.newPos[2],ui.newPos[3],(getTickCount()-ui.tickPos)/250,"InOutQuad")
    ui.pos={x,y,z}

    -- bg
    blur:dxDrawBlur(0,0,sw,sh)
    dxDrawImage(0,0,sw,sh,assets.textures[9],0,0,0,tocolor(255,255,255,a>100 and 100 or a))
    dxDrawImage(0,0,sw,sh,assets.textures[1],0,0,0,tocolor(255,255,255,a))

    -- left map
    local w,h=ui.mapPos[1],ui.mapPos[2],ui.mapPos[3],ui.mapPos[4]
    local x,y=ui.pos[1],ui.pos[2]
    dxSetRenderTarget(ui.rt,true)
        x,y=x+3000,y-3000
        x,y=w*(x/6000),h*(y/-6000)

        dxDrawImage(-x+((475/2)/zoom),-y+((1080/2)/zoom),w,h, ui.map)
    dxSetRenderTarget()
    dxDrawImage(0, 0, 475/zoom, 1080/zoom, ui.rt, 0, 0, 0, tocolor(255,255,255,a))
    dxDrawImage(0,0,1920/zoom,sh,assets.textures[10], 0, 0, 0, tocolor(255,255,255,a))

    dxDrawImage(475/2/zoom-38/2/zoom, 1080/2/zoom-55/zoom, 38/zoom, 55/zoom, assets.textures[11], 0, 0, 0, tocolor(255,255,255,a))

    -- right
    dxDrawImage(552/zoom-1, 22/zoom-1, 43/zoom, 43/zoom, assets.textures[2], 0, 0, 0, tocolor(255,255,255,a))
    dxDrawImage(552/zoom, 22/zoom, 41/zoom, 41/zoom, ui.avatar and ui.avatar or assets.textures[16], 0, 0, 0, tocolor(255,255,255,a))
    dxDrawText("Zalogowany jako:", 552/zoom+54/zoom, 22/zoom, 41/zoom, 41/zoom+22/zoom-20/zoom, tocolor(125,125,125,a), 1, assets.fonts[3], "left", "center")
    dxDrawText(ui.login, 552/zoom+54/zoom, 22/zoom, 41/zoom, 41/zoom+22/zoom+20/zoom, tocolor(200,200,200,a), 1, assets.fonts[4], "left", "center")

    alogo:dxDrawLogo(sw-193/zoom,25/zoom,148/zoom,48/zoom,a)

    -- center
    ui.row=math.floor(scroll:dxScrollGetPosition(ui.scroll)+1)

    if(ui.lastRow ~= ui.row)then
        for i,v in pairs(ui.positions) do
            destroyAnimation(v.animate)
            v.animate=false
            v.hoverAlpha=0
        end
        ui.lastRow=ui.row
    end

    local k=0
    for i=ui.row,ui.row+8 do
        k=k+1

        local v=ui.positions[k]
        if(v)then
            local k=ui.spawns[i]
            if(k)then
                v.hoverAlpha=v.hoverAlpha or 0
                if(isMouseInPosition(552/zoom+v.sX, 86/zoom+v.sY, 296/zoom, 434/zoom) and v.hoverAlpha < 255 and not v.animate and (not v.tick or (v.tick and (getTickCount()-v.tick) > 300)))then
                    v.animate=animate(0, 255, "Linear", 250, function(a)
                        v.hoverAlpha=a
                    end, function()
                        v.animate=false
                    end)
    
                    ui.newPos=k.pos
                    ui.tickPos=getTickCount()
                    v.tick=getTickCount()
                elseif(not isMouseInPosition(552/zoom+v.sX, 86/zoom+v.sY, 296/zoom, 434/zoom) and v.hoverAlpha > 0 and not v.animate and (not v.tick or (v.tick and (getTickCount()-v.tick) > 300)))then
                    v.tick=getTickCount()
                    v.animate=animate(100, 0, "Linear", 250, function(a)
                        v.hoverAlpha=a
                    end, function()
                        v.animate=false
                    end)
                end
    
                dxDrawImage(552/zoom+v.sX, 86/zoom+v.sY, 296/zoom, 434/zoom, assets.textures[12], 0, 0, 0, tocolor(k.color[1], k.color[2], k.color[3], a))
                dxDrawImage(552/zoom+v.sX-20/zoom, 86/zoom+v.sY+(448-434)/2/zoom, 326/zoom, 448/zoom, assets.textures[13], 0, 0, 0, tocolor(255,255,255,a))
    
                dxDrawImage(552/zoom+v.sX, 86/zoom+v.sY, 296/zoom, 434/zoom, assets.textures[14], 0, 0, 0, tocolor(255, 255, 255, v.hoverAlpha > a and a or v.hoverAlpha))
                if(v.hoverAlpha > 150)then
                    dxDrawImage(552/zoom+v.sX+(296-269)/2/zoom, 86/zoom+v.sY+(438-269)/2/zoom-33/zoom, 269/zoom, 269/zoom, assets.textures[15], 0, 0, 0, tocolor(255,255,255,v.hoverAlpha > a and a or v.hoverAlpha))
                else
                    dxDrawImage(552/zoom+v.sX+(296-269)/2/zoom, 86/zoom+v.sY+(438-269)/2/zoom-33/zoom, 269/zoom, 269/zoom, assets.textures[15], 0, 0, 0, tocolor(255,255,255,a > 150 and 150 or a))
                end
    
                dxDrawText(k.name, 552/zoom+v.sX+17/zoom, 86/zoom+v.sY+434/zoom-77/zoom, 296/zoom, 434/zoom, tocolor(200,200,200,a), 1, assets.fonts[4], "left", "top")
                dxDrawRectangle(552/zoom+v.sX+17/zoom, 86/zoom+v.sY+434/zoom-42/zoom, 46/zoom, 1, tocolor(86,86,86,a))
                dxDrawText(k.desc, 552/zoom+v.sX+17/zoom, 86/zoom+v.sY+434/zoom-35/zoom, 296/zoom, 434/zoom, tocolor(200,200,200,a), 1, assets.fonts[3], "left", "top")
    
                onClick(552/zoom+v.sX, 86/zoom+v.sY, 296/zoom, 434/zoom, function()
                    if(SPAM.getSpam())then return end

                    ui.destroy(ui.login, k.pos)
                end)
            end
        end
    end
end