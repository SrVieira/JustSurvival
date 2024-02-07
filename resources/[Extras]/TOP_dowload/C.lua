 local x, y = guiGetScreenSize()
 local sx, sy = guiGetScreenSize()
 local size   = sx / 1000 * 0.5263157894736842  
 local width , height = sx * 0.99, sy * 0.99
 local posx, posy     = (sx * 0.1) - width, (sy + height)/0.5

 function loadingScreen()
	dxDrawImage(0, 0, sx, sy, "collage.jpg", 0, 0, 0, tocolor(255, 255, 255, 255), false)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    addEventHandler("onClientRender", root, loadingScreen)

    local function check()
        if isTransferBoxActive() then
            setTimer(check, 1000, 1)
        else
            removeEventHandler("onClientRender", root, loadingScreen)
        end
    end
    setTimer(check, 1000, 1)
end)