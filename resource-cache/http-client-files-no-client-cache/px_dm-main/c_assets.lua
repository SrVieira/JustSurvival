--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- global variables

local fh = 1920

sw,sh=guiGetScreenSize()

zoom = 1

if sw < fh then
  zoom = math.min(2,fh/sw)
end

-- exports

blur=exports.blur

-- assets

assets={}
assets.list={
    texs={
        "files/window.png",
        "files/respekt.png",
        "files/strefa.png",
    },

    fonts={
        {"SemiBold", 15},
        {"Regular", 10},
    },
}

assets.create=function()
    assets.textures={}
    for i,v in pairs(assets.list.texs) do
        assets.textures[i]=dxCreateTexture(v, "argb", false, "clamp")
    end

    assets.fonts={}
    for i,v in pairs(assets.list.fonts) do
        assets.fonts[i]=dxCreateFont(":px_assets/fonts/Font-"..v[1]..".ttf", v[2]/zoom)
    end
end

assets.destroy=function()
    for i,v in pairs(assets.textures) do
        if(v and isElement(v))then
            destroyElement(v)
        end
    end
    assets.textures={}

    for i,v in pairs(assets.fonts) do
        if(v and isElement(v))then
            destroyElement(v)
        end
    end
    assets.fonts={}
end