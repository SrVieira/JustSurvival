--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

SPAM={}
SPAM.getSpam=function()
    local block=false

    if(SPAM.blockSpamTimer)then
        killTimer(SPAM.blockSpamTimer)
        exports.px_noti:noti("Zaczekaj jedną sekunde.", "error")
        block=true
    end

    SPAM.blockSpamTimer=setTimer(function() SPAM.blockSpamTimer=nil end, 1000, 1)

    return block
end

blur=exports.blur
noti=exports.px_noti

sw,sh=guiGetScreenSize()
zoom=1920/sw

-- assets

assets={
    fonts={},
    fonts_paths={
        {":px_assets/fonts/Font-Bold.ttf", 12},
        {":px_assets/fonts/Font-Bold.ttf", 20},
    },

    textures={},
    textures_paths={
        "textures/core.png",
        "textures/progress.png",
        "textures/border.png",
        "textures/icon_cart_full.png",
        "textures/elipse_green.png",
        "textures/elipse_red.png",

        "textures/closed.png",
        "textures/elipse.png",
        "textures/opened.png",

        "textures/money.png",
        "textures/gold.png",
        "textures/diax.png",

        "textures/minigame/main.png",
        "textures/minigame/ok.png",
        "textures/minigame/back.png",
        "textures/minigame/0.png",
        "textures/minigame/1.png",
        "textures/minigame/2.png",
        "textures/minigame/3.png",
        "textures/minigame/4.png",
        "textures/minigame/5.png",
        "textures/minigame/6.png",
        "textures/minigame/7.png",
        "textures/minigame/8.png",
        "textures/minigame/9.png",

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

ui.pointsType="atm"
ui.tick=getTickCount()

ui.markers={}
ui.blips={}
ui.zones={}
ui.carts={}

ui.atms={}
ui.warehouses={
    {1655.51331, 733.24933, 10.82031},
    {1715.21240, 707.96814, 10.82031},
    {2800.81128, 2573.21094, 10.82031},
    {1629.74939, 956.89783, 10.75543},
    {2195.88208, 2792.38306, 10.82031},
    {1029.25916, 2347.02710, 10.82031},
    {1142.28174, 2037.24670, 10.82031},
    {1351.28271, 2223.07690, 11.02344},
    {1311.83850, 2222.90625, 11.02344},
    {1705.00720, 1809.16443, 10.82031},
    {-305.02829, 2658.88916, 62.85036},
    {-1505.08984, 2624.00635, 55.83594},
    {-2282.54932, 2285.01685, 4.97577},
    {-2455.06836, 2298.67139, 4.98407},
    {-817.61694, 1567.77686, 27.11719},
    {-212.94922, 1189.26624, 19.74219},
    {-163.64735, 1107.36646, 19.74219},
    {216.32484, -3.53837, 2.57812},
    {273.24539, -221.07724, 1.57812},
    {1214.31665, 188.05020, 20.35923},
    {2310.12305, -19.22412, 26.48438},
    {-54.24092, 1179.12061, 19.38174},
    {-1462.15161, 1873.13477, 32.63281},
}

ui.pos={2558.9263,2128.7087,11.0157}

ui.maxCarts=0
ui.saveCarts=0
ui.haveCart=false

ui.vehicle=false

ui.loading=false
ui.loadingTick=0
ui.loadingCarts={}

ui.gameRender=false

ui.miniLetters={
    [1]="¹",
    [2]="²",
    [3]="³",
    [4]="⁴",
    [5]="⁵",
    [6]="⁶",
    [7]="⁷",
    [8]="⁸",
    [9]="⁹",
    [10]="¹⁰"
}