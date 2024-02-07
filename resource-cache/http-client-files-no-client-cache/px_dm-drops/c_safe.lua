--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

safe={}

safe.weapons={
    {"Deagle"},
    {"Strzelba"},
    {"Uzi"},
    {"MP5"},
    {"AK-47"},
    {"M4"},
}

safe.object=false

safe.render=function()
    if(not safe.object or (safe.object and not isElement(safe.object)))then return end

    local block=getElementData(safe.object, "block")
    if(not block)then safe.destroy() return end
    if(block ~= localPlayer)then safe.destroy() return end

    if(getElementHealth(localPlayer) <= 0)then safe.destroy() return end

    local close=ui.render("PRZESZUKIWANIE SEJFU", "Przenieś przedmioty z pól do swojego plecaka.")
    if(close)then
        exports.px_noti:noti("Pomyślnie zebrano wszystkie przedmioty z sejfu.", "success")

        triggerServerEvent("destroy.safe", resourceRoot, safe.object)

        safe.destroy(true)
    end
end

safe.create=function()
    ui.items={
        {name="Kominiarka"},
        {name="Apteczka"},
        {name="Kamizelka"},
        {name="Plik pieniędzy"},
        {name="Plik pieniędzy"},
        {name="Plik pieniędzy"},
    }

    local rnd=math.random(1,6)
    local t=safe.weapons[rnd]
    ui.items[#ui.items+1]={name="Ammo "..t[1]}

    local rnd=math.random(1,#safe.weapons)
    local t=safe.weapons[rnd]
    ui.items[#ui.items+1]={name=t[1]}

    for i,v in pairs(ui.items) do
        local p=ui.places[i]
        v.pos={sw/2-611/2/zoom+40/zoom+p.sX+(127-70)/2/zoom, 540/zoom+35/zoom+p.sY+(115-70)/2/zoom}
        v.defPos={sw/2-611/2/zoom+40/zoom+p.sX+(127-70)/2/zoom, 540/zoom+35/zoom+p.sY+(115-70)/2/zoom}
        v.tex=exports.px_eq:getItemTexture(v.name)
    end

    assets.create()
    addEventHandler("onClientRender", root, safe.render)

    showCursor(true)
end

safe.destroy=function(cancel)
    if(not cancel)then
        setElementData(safe.object, "block", false)
        setElementData(localPlayer, "block", false)
    end

    removeEventHandler("onClientRender", root, safe.render)

    assets.destroy()

    showCursor(false)

    ui.items={}

    safe.object=false
end