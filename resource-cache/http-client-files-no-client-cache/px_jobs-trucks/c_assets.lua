--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Project X (MTA)
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
        {":px_assets/fonts/Font-ExtraBold.ttf", 11},
        {":px_assets/fonts/Font-ExtraBold.ttf", 30},
    },

    textures={},
    textures_paths={
        "textures/bg.png",
    
        "textures/header.png",
        "textures/button.png",
        "textures/row.png",
        "textures/row_click.png",
        "textures/arrow.png",
    
        "textures/icon_fuel.png",
        "textures/icon_wood.png",
        "textures/icon_car.png",

        "textures/start.png",
        "textures/end.png",
        "textures/player.png",
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