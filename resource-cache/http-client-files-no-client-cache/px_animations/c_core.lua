--[[
    @author: Xyrusek
    @mail: xyrusowski@gmail.com
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

animations = {}
    animations.controlsSave = {}
    animations.controlsOff = {"fire", "aim_weapon", "forwards", "backwards", "left", "right", "jump", "sprint", "crouch", "action", "walk", "enter_exit"}
    animations.animsTips = {}
    animations.last = {}

animations.tryUseAnimation = function(categoryName, animationIndex)
    if(getElementData(localPlayer, "user:job"))then return end
    if(getElementData(localPlayer, "user:handcuffs"))then return end
    if(getElementData(localPlayer, "user:gui_showed") and getElementData(localPlayer, "user:gui_showed") ~= resourceRoot)then return end

    if(isPedInVehicle(localPlayer))then return end

    if(SPAM.getSpam())then return end

    if animations.last.useAnimation and getTickCount()-animations.last.useAnimation < 3000 then
        local time = string.format("%.1f", ((animations.last.useAnimation+3000)-getTickCount())/1000)
        sendNotification("Poczekaj "..time.." s, aby ponownie skorzystać z animacji.")
        return false
    end
    local animationInfo = animations.animationList[categoryName].animationList[animationIndex].animation
    if not animationInfo then
        sendNotification("Doszło do błędu #C01, zgłoś to developerom serwera, w konsoli wyświetliły się dane debugujące.")
        outputConsole(inspect({categoryName, animationIndex}))
        outputConsole(inspect(animations.animationList[categoryName].animationList[animationIndex]))
        outputConsole(inspect(#(animations.animationList[categoryName].animationList or {})))
        return false
    end
    if animations.tipsState then
        sendNotification("Aktualnie wykonujesz już jakąś animację.")
        return false
    end
    if(categoryName == "Premium" and not getElementData(localPlayer, "user:premium"))then
        sendNotification("Nie posiadasz konta PREMIUM.")
        return
    end
    animations.last.useAnimation = getTickCount()
    triggerLatentServerEvent("px_animations:useAnimation", 3000, false, getResourceRootElement(), animationInfo)
    for i, v in pairs(animations.controlsOff) do toggleControl(v, false) end
end

animations.tryStopUseAnimation = function()
    if(getElementData(localPlayer, "user:writing"))then return end

    if animations.last.stopAnimation and getTickCount()-animations.last.stopAnimation < 3000 then
        local time = string.format("%.1f", ((animations.last.stopAnimation+3000)-getTickCount())/1000)
        sendNotification("Poczekaj "..time.." s, aby ponownie spróbować zatrzymać animacje.")
        return false
    end
    animations.last.stopAnimation = getTickCount()
    triggerLatentServerEvent("px_animations:stopAnimation", 3000, false, getResourceRootElement())
    return true
end

addEvent("px_animations:onClientAnimationUse", true)
addEventHandler("px_animations:onClientAnimationUse", getResourceRootElement(), function()
    animations.toggleAnimationTips(true)
    animations.originalPosition = {getElementPosition(localPlayer)}
end)

addEvent("px_animations:onClientAnimationStop", true)
addEventHandler("px_animations:onClientAnimationStop", getResourceRootElement(), function()
    for i, v in pairs(animations.controlsOff) do toggleControl(v, true) end
    setElementPosition(localPlayer, unpack(animations.originalPosition))
    animations.originalPosition = nil
end)

animations.toggleAnimationTips = function(state)
    animations.tipsState = state
    for i, v in pairs(animations.animsTips) do destroyAnimation(v) end
    if state then
        removeEventHandler("onClientKey", getRootElement(), animations.onKeyTips)
        removeEventHandler("onClientRender", getRootElement(), animations.renderTips)
        addEventHandler("onClientRender", getRootElement(), animations.renderTips)
        addEventHandler("onClientKey", getRootElement(), animations.onKeyTips)
        animations.animsTips[#animations.animsTips+1] = animate(0, 255, "InOutQuad", 300, function(x) animations.alpha2 = x end)
    else
        animations.animsTips[#animations.animsTips+1] = animate(255, 0, "InOutQuad", 300, function(x) animations.alpha2 = x end, function() removeEventHandler("onClientRender", getRootElement(), animations.renderTips) end)
        removeEventHandler("onClientKey", getRootElement(), animations.onKeyTips)
    end
end

animations.renderTips = function()
    local texture = (getKeyState("w") and assets.textures[17] or assets.textures[16])
    dxDrawImage(sx/2-131/zoom, sy-118/zoom, 39/zoom, 39/zoom, texture, 0, 0, 0, tocolor(255, 255, 255, animations.alpha2))

    local texture = (getKeyState("a") and assets.textures[19] or assets.textures[18])
    dxDrawImage(sx/2-172/zoom, sy-77/zoom, 39/zoom, 39/zoom, texture, 0, 0, 0, tocolor(255, 255, 255, animations.alpha2))

    local texture = (getKeyState("s") and assets.textures[21] or assets.textures[20])
    dxDrawImage(sx/2-131/zoom, sy-77/zoom, 39/zoom, 39/zoom, texture, 0, 0, 0, tocolor(255, 255, 255, animations.alpha2))

    local texture = (getKeyState("d") and assets.textures[23] or assets.textures[22])
    dxDrawImage(sx/2-89/zoom, sy-77/zoom, 39/zoom, 39/zoom, texture, 0, 0, 0, tocolor(255, 255, 255, animations.alpha2))

    dxDrawText("Poruszanie", sx/2-172/zoom+1, sy-38/zoom+1, sx/2-51/zoom+1, sy-38/zoom+1, tocolor(0, 0, 0, animations.alpha2), 1, assets.fonts[3], "center", "top")
    dxDrawText("Poruszanie", sx/2-172/zoom, sy-38/zoom, sx/2-51/zoom, sy-38/zoom, tocolor(200, 200, 200, animations.alpha2), 1, assets.fonts[3], "center", "top")

    local texture = (getKeyState("arrow_u") and assets.textures[25] or assets.textures[24])
    dxDrawImage(sx/2+17/zoom, sy-118/zoom, 39/zoom, 39/zoom, texture, -90, 0, 0, tocolor(255, 255, 255, animations.alpha2))

    local texture = (getKeyState("arrow_l") and assets.textures[25] or assets.textures[24])
    dxDrawImage(sx/2-24/zoom, sy-77/zoom, 39/zoom, 39/zoom, texture, 180, 0, 0, tocolor(255, 255, 255, animations.alpha2))

    local texture = (getKeyState("arrow_d") and assets.textures[25] or assets.textures[24])
    dxDrawImage(sx/2+17/zoom, sy-77/zoom, 39/zoom, 39/zoom, texture, 90, 0, 0, tocolor(255, 255, 255, animations.alpha2))

    local texture = (getKeyState("arrow_r") and assets.textures[25] or assets.textures[24])
    dxDrawImage(sx/2+59/zoom, sy-77/zoom, 39/zoom, 39/zoom, texture, 0, 0, 0, tocolor(255, 255, 255, animations.alpha2))

    dxDrawText("Rotacja", sx/2-24/zoom+1, sy-38/zoom+1, sx/2+97/zoom+1, sy-38/zoom+1, tocolor(0, 0, 0, animations.alpha2), 1, assets.fonts[3], "center", "top")
    dxDrawText("Rotacja", sx/2-24/zoom, sy-38/zoom, sx/2+97/zoom, sy-38/zoom, tocolor(200, 200, 200, animations.alpha2), 1, assets.fonts[3], "center", "top")

    local texture = (getKeyState("space") and assets.textures[27] or assets.textures[26])
    dxDrawImage(sx/2+124/zoom, sy-77/zoom, 80/zoom, 38/zoom, texture, 0, 0, 0, tocolor(255, 255, 255, animations.alpha2))

    dxDrawText("Anuluj", sx/2+124/zoom+1, sy-38/zoom+1, sx/2+204/zoom+1, sy-38/zoom+1, tocolor(0, 0, 0, animations.alpha2), 1, assets.fonts[3], "center", "top")
    dxDrawText("Anuluj", sx/2+124/zoom, sy-38/zoom, sx/2+204/zoom, sy-38/zoom, tocolor(200, 200, 200, animations.alpha2), 1, assets.fonts[3], "center", "top")

    if click2() then if animations.tryStopUseAnimation() then animations.toggleAnimationTips(false) end end

    if getKeyState("space") and not animations.clickblock2 then
        animations.clickblock2 = true
    elseif not getKeyState("space") and animations.clickblock2 then
        animations.clickblock2 = false
    end
end

animations.allowedKeys = {}
    animations.allowedKeys["w"] = true
    animations.allowedKeys["a"] = true
    animations.allowedKeys["s"] = true
    animations.allowedKeys["d"] = true
    animations.allowedKeys["arrow_u"] = true
    animations.allowedKeys["arrow_l"] = true
    animations.allowedKeys["arrow_d"] = true
    animations.allowedKeys["arrow_r"] = true

animations.onKeyTips = function(key, press)
    if not press then return false end
    if not animations.allowedKeys[key] then return false end
    if(getElementData(localPlayer, "user:writing"))then return end

    if key == "w" or key == "a" or key == "s" or key == "d" then
        local x, y, z = getElementPosition(localPlayer)
        local x2, y2, z2 = (key == "w" and x-0.1 or key == "s" and x+0.1 or x), (key == "a" and y-0.1 or key == "d" and y+0.1 or y), z
        local distance = getDistanceBetweenPoints2D(animations.originalPosition[1], animations.originalPosition[2], x, y)
        local newDistance = getDistanceBetweenPoints2D(animations.originalPosition[1], animations.originalPosition[2], x2, y2)
        if distance > 0.7 then
            if newDistance > distance then return false end
        end
        if key == "w" then
            setElementPosition(localPlayer, x-0.1, y, z, false)
        elseif key == "s" then
            setElementPosition(localPlayer, x+0.1, y, z, false)
        elseif key == "a" then
            setElementPosition(localPlayer, x, y-0.1, z, false)
        elseif key == "d" then
            setElementPosition(localPlayer, x, y+0.1, z, false)
        end
    else
        local rx, ry, rz = getElementRotation(localPlayer)
        local rx2, ry2, rz2 = (key == "arrow_u" and rx+10 or rx), ry, (key == "arrow_l" and rz+5 or key == "arrow_r" and rz-5 or rz)
        setElementRotation(localPlayer, rx2, ry2, rz2, "default", true)
    end
end