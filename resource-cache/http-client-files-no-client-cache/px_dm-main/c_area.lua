--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- variables

local Area={}

Area.Tick=getTickCount()

Area.Zone=createColPolygon(
    1768.6965,-1274.8018,
    1768.6965,-1274.8018,
    2795.4539,-1261.2676,
    2779.0151,-1645.8701,
    2642.1880,-1645.3882,
    2630.0325,-2034.1885,
    2219.4302,-2038.2026,
    2217.0112,-1945.2710,
    1760.5762,-1937.6200
)

Area.RobberyShapes={
    {941.40063, -991.08533, 37.82838, 140.06896972656, 114.23248291016, 16.9}, -- stacja LS gora
}

for i,v in pairs(Area.RobberyShapes) do
    createColCuboid(unpack(v))
end

Area.Off={
    {2746.87988, -1377.34216, 45.02474, 26.450439453125, 29.567260742188, 7.9}, -- salon low rider
    {2550.59595, -1434.30579, 22.94548, 15.333251953125, 23.091674804688, 10.653206253052}, -- dziupla
}
for i,v in pairs(Area.Off) do
    local shape=createColCuboid(unpack(v))
    setElementData(shape, "Area.Off", true, false)
end

-- functions

Area.Render=function()
    if(getElementData(localPlayer, "user:hud_disabled"))then return end

    local respect=getElementData(localPlayer, "user:respect") or 0

    dxDrawImage(sw-90/zoom,100/zoom,63/zoom,87/zoom,assets.textures[3])

    dxDrawImage(sw-234/zoom,166/zoom,59/zoom,13/zoom,assets.textures[2])
    dxDrawText(respect, 0+1,166/zoom+1,sw-241/zoom+1,166/zoom+13/zoom+1,tocolor(0,0,0),1,assets.fonts[1],"right","center")
    dxDrawText(respect, 0,166/zoom,sw-241/zoom,166/zoom+13/zoom,tocolor(200,200,200),1,assets.fonts[1],"right","center")

    local time=math.floor(30-(getTickCount()-Area.Tick)/1000)
    if(time > 0)then
        blur:dxDrawBlur(sw-353/zoom,237/zoom,301/zoom,318/zoom)
        dxDrawImage(sw-353/zoom,237/zoom,301/zoom,318/zoom,assets.textures[1])
        dxDrawText("ZAMKNIĘCIE OKNA ZA "..time.." SEKUND(Y)", sw-353/zoom,237/zoom+263/zoom,301/zoom+sw-353/zoom-80/zoom,318/zoom,tocolor(200,200,200),1,assets.fonts[2],"right","top")
    end
end

-- events

addEventHandler("onClientColShapeHit", resourceRoot, function(hit, dim)
    if(hit == localPlayer and dim)then
        if(getElementData(source, "Area.Off"))then
            setElementData(hit, "Area.InZone", false)

            removeEventHandler("onClientRender", root, Area.Render)
            assets.destroy()
        else
            setElementData(hit, "Area.InZone", true)

            addEventHandler("onClientRender", root, Area.Render)
            assets.create()

            Area.Tick=getTickCount()
        end
    end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(hit, dim)
    if(hit == localPlayer and dim)then
        if(getElementData(source, "Area.Off"))then
            setElementData(hit, "Area.InZone", true)

            addEventHandler("onClientRender", root, Area.Render)
            assets.create()

            Area.Tick=getTickCount()
        else
            setElementData(hit, "Area.InZone", false)

            removeEventHandler("onClientRender", root, Area.Render)
            assets.destroy()
        end
    end
end)