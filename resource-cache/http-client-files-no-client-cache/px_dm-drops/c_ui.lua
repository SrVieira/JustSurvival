--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

ui.render=function(text, desc)
    local cx,cy=getCursorPosition()
    cx,cy=cx*sw,cy*sh

    blur:dxDrawBlur(0, 0, sw, sh)
    dxDrawImage(0, 0, sw, sh, assets.textures[1], 0, 0, 0, tocolor(255, 255, 255, 255))

    -- header
    dxDrawText(text, 0, 85/zoom, sw, sh, tocolor(200, 200, 200, 255), 1, assets.fonts[1], "center", "top")
    dxDrawRectangle(sw/2-409/2/zoom, 134/zoom, 409/zoom, 1, tocolor(85, 85, 85, 255))
    dxDrawText(desc, 0, 150/zoom, sw, sh, tocolor(200, 200, 200, 255), 1, assets.fonts[2], "center", "top", false, false, false, true)

    -- backpack
    dxDrawImage(sw/2-229/2/zoom, 230/zoom, 229/zoom, 237/zoom, assets.textures[2])

    -- items
    dxDrawImage(sw/2-611/2/zoom, 540/zoom, 611/zoom, 306/zoom, assets.textures[3])
    for i,v in pairs(ui.places) do
        dxDrawImage(sw/2-611/2/zoom+40/zoom+v.sX, 540/zoom+35/zoom+v.sY, 127/zoom, 115/zoom, assets.textures[4])

        local item=ui.items[i]
        if(item)then
            dxDrawImage(item.pos[1], item.pos[2], 70/zoom, 70/zoom, item.tex, 0, 0, 0, tocolor(255, 255, 255), true)

            if(ui.click == i)then
                if(not getKeyState("mouse1"))then
                    ui.click=false

                    if(getPosition(cx-ui.catchPos[1],cy-ui.catchPos[2], sw/2-229/2/zoom, 230/zoom, 229/zoom, 237/zoom))then
                        ui.items[i]=nil
                        ui.catchPos=false
                        ui.click=false

                        triggerServerEvent("giveItem", resourceRoot, item.name)

                        if(table.size(ui.items) < 1)then
                            return "destroy"
                        end
                    else
                        item.pos[1],item.pos[2]=item.defPos[1],item.defPos[2]
                    end
                else
                    if(not ui.catchPos)then
                        local cx,cy=cx-item.pos[1],cy-item.pos[2]
                        ui.catchPos={cx,cy}
                    else
                        item.pos[1],item.pos[2]=cx-ui.catchPos[1],cy-ui.catchPos[2]
                    end
                end
            end
        
            if(isMouseInPosition(item.pos[1], item.pos[2], 70/zoom, 70/zoom) and not ui.click and getKeyState("mouse1"))then
                ui.catchPos=false
                ui.click=i
            end
        end
    end
end