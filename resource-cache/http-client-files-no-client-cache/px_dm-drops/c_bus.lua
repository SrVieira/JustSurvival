--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

bus={}

bus.weapons={
    {"Deagle"},
    {"Strzelba"},
    {"Uzi"},
    {"MP5"},
    {"AK-47"},
    {"M4"},
}

bus.vehicle=false

bus.render=function()
    if(not bus.vehicle or (bus.vehicle and not isElement(bus.vehicle)))then return end

    local block=getElementData(bus.vehicle, "block")
    if(not block)then bus.destroy() return end
    if(block ~= localPlayer)then bus.destroy() return end

    if(getElementHealth(localPlayer) <= 0)then bus.destroy() return end

    local close=ui.render("PRZESZUKIWANIE BUSA", "Przenieś przedmioty z pól do swojego plecaka.")
    if(close)then
        exports.px_noti:noti("Pomyślnie zebrano wszystkie przedmioty z busa.", "success")

        triggerServerEvent("destroy.bus", resourceRoot, bus.vehicle)

        bus.destroy(true)
    end
end

bus.create=function()
    ui.items={
        {name="Kominiarka"},
        {name="Apteczka"},
        {name="Kamizelka"},
        {name="Plik pieniędzy"}
    }

    for i=1,2 do
        local rnd=math.random(1,6)
        local t=bus.weapons[rnd]
        ui.items[#ui.items+1]={name="Ammo "..t[1]}
    end

    for i,v in pairs(ui.items) do
        local p=ui.places[i]
        v.pos={sw/2-611/2/zoom+40/zoom+p.sX+(127-70)/2/zoom, 540/zoom+35/zoom+p.sY+(115-70)/2/zoom}
        v.defPos={sw/2-611/2/zoom+40/zoom+p.sX+(127-70)/2/zoom, 540/zoom+35/zoom+p.sY+(115-70)/2/zoom}
        v.tex=exports.px_eq:getItemTexture(v.name)
    end

    assets.create()
    addEventHandler("onClientRender", root, bus.render)

    showCursor(true)
end

bus.destroy=function(cancel)
    if(not cancel)then
        setElementData(bus.vehicle, "block", false)
        setElementData(localPlayer, "block", false)
    end

    removeEventHandler("onClientRender", root, bus.render)

    assets.destroy()

    showCursor(false)

    ui.items={}

    bus.vehicle=false
end