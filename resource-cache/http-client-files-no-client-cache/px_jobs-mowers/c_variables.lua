--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

blur=exports.blur
noti=exports.px_noti

sw,sh=guiGetScreenSize()
zoom=1920/sw

-- assets

assets={
    fonts={},
    fonts_paths={
        {":px_assets/fonts/Font-Medium.ttf", 11},
    },

    textures={},
    textures_paths={
        "textures/progressbar.png",
        "textures/arrow.png",
        "textures/arrow_light.png",
    
        "textures/bg.png",
        "textures/progress.png",

        "textures/buttonQ.png",
    },
}

assets.create = function()
    for k,t in pairs(assets) do
        if(k=="fonts_paths")then
            for i,v in pairs(t) do
                assets.fonts[i] = dxCreateFont(v[1], v[2]/zoom)
            end
        elseif(k=="textures_paths")then
            for i,v in pairs(t) do
                assets.textures[i] = dxCreateTexture(v, "argb", false, "clamp")
            end
        end
    end
end

assets.destroy = function()
    for k,t in pairs(assets) do
        if(k == "textures" or k == "fonts")then
            for i,v in pairs(t) do
                if(v and isElement(v))then
                    destroyElement(v)
                end
            end
            assets.fonts={}
            assets.textures={}
        end
    end
end

ui={}

ui.markers={}
ui.blips={}
ui.zones={}

ui.mower=false
ui.tank=false
ui.attachedTank=false

ui.tick=getTickCount()

ui.deposit={1550.3243,-29.7265,21.3356}

ui.haveMower=false
ui.vehicle=false
ui.checkTrigger=false
ui.knives=1
ui.sound=false

ui.info=false

ui.progress=0
ui.maxProgress=0

ui.getTick=0

ui.pos={
    -- kosisko
    [1]={sw-100/zoom, sh-235/zoom, 23/zoom, 182/zoom},
    [2]={sw-100/zoom-(64-23)/2/zoom, sh-235/zoom, 64/zoom, 25/zoom},
    --

    -- progressbar
    [3]={sw/2-366/2/zoom, sh-97/zoom, 366/zoom, 49/zoom},
    [4]={sw/2-366/2/zoom+15/zoom, sh-97/zoom+7/zoom, sw/2-366/2/zoom+15/zoom+339/zoom, 0},
    [5]={sw/2-366/2/zoom+13/zoom, sh-97/zoom+49/zoom-16/zoom, 339/zoom, 7/zoom},
    --
}

ui.area={1454.7809,-21.5029,25.6516}

ui.createArea=function(id)
    if(not id)then return end

    local v=ui.areas[id]
    if(not v)then return end

    ui.zones["grass_"..id]={
        col=createColSphere(v[1],v[2],v[3]+0.5,1),
        obj=createObject(818, v[1], v[2], v[3]-1),
    }

    setObjectScale(ui.zones["grass_"..id].obj,0.6)
end

ui.createAreas=function()
    ui.areas={}

    for i=1,10 do
        local sx=2.5*(i-1)
        for k=1,20 do
            local sy=2.5*(k-1)

            local x,y,z=ui.area[1]-sx,ui.area[2]-sy,ui.area[3]
            z=getGroundPosition(x,y,z)
            ui.areas[#ui.areas+1]={x,y,z}

            local x,y,z=ui.area[1]+sx,ui.area[2]-sy,ui.area[3]
            z=getGroundPosition(x,y,z)
            ui.areas[#ui.areas+1]={x,y,z}
        end
    end
    
    for i,v in pairs(ui.areas) do
        ui.createArea(i)
    end
end

ui.checkAndDestroyArea=function(id)
    if(ui.progress < ui.maxProgress)then
        local v=ui.zones[id]
        if(not v)then return end

        ui.progress=ui.progress+0.02
        if(not (ui.progress < (ui.maxProgress/2)) and not ui.markers["landing"])then
            local data=getElementData(localPlayer, "user:jobs_todo") or {}
            data[3].done=true
            setElementData(localPlayer, "user:jobs_todo", data, false)

            ui.markers["landing"]=createMarker(1553.5846,-29.5254,21.3685-0.9, "cylinder", 1.5, 0, 200, 100)
            ui.blips["landing"]=createBlipAttachedTo(ui.markers["landing"], 22)
            setElementData(ui.markers["landing"], "icon", ":px_jobs-mowers/textures/marker-kosiarki.png")

            if(ui.mower and getElementType(ui.mower) == "vehicle")then
                setElementData(ui.mower, "interaction", {options={
                    {name="Zdejmij kosz", alpha=150, animate=false, tex=":px_jobs-escort/textures/icon-konwoj.png"},
                }, scriptName="px_jobs-mowers", dist=2})
            end
        end

        checkAndDestroy(v.col)
        checkAndDestroy(v.obj)
        v=nil

        setTimer(function()
            local send=string.sub(id,7,#id)
            ui.createArea(tonumber(send))
        end, 5000, 1)
    else
        noti:noti("Najpierw udaj się rozładować kosz z trawą.", "error")
    end
end

ui.destroyAreas=function()
    for i,v in pairs(ui.zones) do
        if(string.find(i,"grass_"))then
            checkAndDestroy(v.col)
            checkAndDestroy(v.obj)
        end
    end
end