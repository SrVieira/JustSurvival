--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

ui.avatar=false

ui.draw["LOGOWANIE"]=function(a)
    dxDrawImage(286/zoom, 365/zoom, 106/zoom, 106/zoom, assets.textures[2], 0, 0, 0, tocolor(255,255,255,a))
    dxDrawImage(286/zoom+(106-96)/2/zoom, 365/zoom+(106-96)/2/zoom, 96/zoom, 96/zoom, ui.avatar and ui.avatar or assets.textures[16], 0, 0, 0, tocolor(255,255,255,a))

    dxDrawImage(185/zoom, 676/zoom, 19/zoom, 19/zoom, ui.save == 1 and assets.textures[7] or assets.textures[6], 0, 0, 0, tocolor(255,255,255,a))
    dxDrawText("Zapamiętaj", 185/zoom+32/zoom, 676/zoom, 19/zoom, 19/zoom+676/zoom, tocolor(200, 200, 200, a), 1, assets.fonts[2], "left", "center")
    onClick(185/zoom, 676/zoom, 19/zoom, 19/zoom, function()
        ui.save=ui.save == 1 and 0 or 1
    end)

    local text=edits:dxGetEditText(ui.edits[1]) or ""
    if(ui.lastEdit ~= text)then
        ui.lastEdit=text
        ui.lastTick=getTickCount()
    end

    if(ui.lastEdit == text and (getTickCount()-ui.lastTick) > 5000 and ui.lastEdit ~= "")then
        triggerServerEvent("get.avatar", resourceRoot, text)
        ui.lastEdit=""
        ui.lastTick=getTickCount()
    end

    if(not ui.edits[1] and not ui.edits[2])then
        ui.edits[1]=edits:dxCreateEdit("Login", 185/zoom, 548/zoom, 307/zoom, 30/zoom, false, 11/zoom, a, false, false, ":px_auth/textures/username_icon.png")
        ui.edits[2]=edits:dxCreateEdit("Hasło", 185/zoom, 604/zoom, 307/zoom, 30/zoom, true, 11/zoom, a, false, false, ":px_auth/textures/password_icon.png")

        if(#ui.login_save > 0)then
            edits:dxSetEditText(ui.edits[1], ui.login_save)
            edits:dxSetEditText(ui.edits[2], ui.password_save)
            ui.save=1
        end
    else
        for i,v in pairs(ui.edits) do
            edits:dxSetEditAlpha(v, a)
        end
    end

    if(not ui.btns[1])then
        ui.btns[1]=btns:createButton(346/zoom, 676/zoom, 147/zoom, 38/zoom, "ZALOGUJ", a, 10, false, false, ":px_auth/textures/button_icon.png")
    else
        for i,v in pairs(ui.btns) do
            btns:buttonSetAlpha(v,a)
        end

        onClick(346/zoom, 676/zoom, 147/zoom, 38/zoom, function()
            if(SPAM.getSpam())then return end
            local login=edits:dxGetEditText(ui.edits[1]) or ""
            local pass=edits:dxGetEditText(ui.edits[2]) or ""
            if(string.len(login) >= 2 and string.len(pass) >= 2)then
                exports.px_noti:noti("Trwa uwierzytelnianie..", "info")
                triggerServerEvent("ui.loginPlayer", resourceRoot, login, pass, ui.save)
            else
                exports.px_noti:noti("Login i/lub hasło jest nieprawidłowe! (c)", "error")
            end
        end)
    end
end

-- avatar

addEvent("get.avatar", true)
addEventHandler("get.avatar", resourceRoot, function(tex)
    if(ui.avatar and isElement(ui.avatar))then
        destroyElement(ui.avatar)
    end

    if(tex)then
        local tex=dxCreateTexture(tex, "argb", false, "clamp")
        local shader=dxCreateShader(":px_avatars/shaders/hud_mask.fx")
        dxSetShaderValue(shader, "sPicTexture", tex)
        dxSetShaderValue(shader, "sMaskTexture", assets.textures[16])
        ui.avatar=shader
    end
end)