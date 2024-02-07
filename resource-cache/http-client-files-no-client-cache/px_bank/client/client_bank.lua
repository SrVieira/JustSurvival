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

local sw,sh=guiGetScreenSize()
local zoom=1920/sw

local noti=exports.px_noti
local blur=exports.blur
local btns=exports.px_buttons
local edit=exports.px_editbox
local scroll=exports.px_scroll
local avatars=exports.px_avatars

local UI={}

UI.opened=false

UI.option=1
UI.border=sw/2-710/2/zoom+240/zoom
UI.anim=false

UI.btns={}
UI.edits={}
UI.notis={}

UI.openNotis=false
UI.transferType=1

UI.bank_acc={}

UI.trigger=0

UI.mainAlpha=0
UI.backAlpha=0
UI.nomainAlpha=0
UI.scroll=false
UI.animate=false
UI.expenses={}

UI.cards={
    {name="Karta Brązowa", desc="Koszt: 1,000$\nLimit: 100,000$", color={150, 75, 0}, hours=0, cost=1000, limit=100000},
    {name="Karta Srebrna", desc="Koszt: 10,000$\nOd: 50 godzin\nLimit: 1,000,000$", color={192, 192, 192}, hours=50, cost=10000, limit=1000000},
    {name="Karta Złota", desc="Koszt: 50,000$\nOd: 100 godzin\nLimit: brak", color={255, 215, 0}, cost=50000, hours=100, limit=9999999999999},
}

-- main variables

local assets={
    fonts={},
    fonts2={},
    fonts_paths={
        {":px_assets/fonts/Font-Medium.ttf", 12/zoom},
        {":px_assets/fonts/Font-SemiBold.ttf", 14/zoom},
        {":px_assets/fonts/Font-Medium.ttf", 13/zoom},
        {":px_assets/fonts/Font-SemiBold.ttf", 20/zoom},
        {":px_assets/fonts/Font-SemiBold.ttf", 9/zoom},
        {":px_assets/fonts/Font-Medium.ttf", 14/zoom},
        {":px_assets/fonts/Font-Medium.ttf", 10/zoom},
        {":px_assets/fonts/Font-Medium.ttf", 11/zoom},
    },

    textures={},
    textures_paths={
        "assets/textures/window.png",
        "assets/textures/logo.png",

        "assets/textures/icon_quit.png",
        "assets/textures/icon_mail.png",
        "assets/textures/icon_settings.png",

        "assets/textures/icon_nrkonta.png",

        "assets/textures/button.png",
        "assets/textures/star.png",
        "assets/textures/plus.png",
        "assets/textures/avatar.png",

        "assets/textures/card.png",
        "assets/textures/card_window.png",
        "assets/textures/mini_card.png",
        "assets/textures/wallet.png",

        "assets/textures/noti_icon.png",
        "assets/textures/noti_window.png",

        "assets/textures/zaplata.png",

        "assets/textures/checkbox.png",
        "assets/textures/checkbox_active.png",
        "assets/textures/date_icon.png",
        "assets/textures/user_icon.png",
        "assets/textures/przelew_window.png",
        "assets/textures/rachunek.png",

        "assets/textures/pin_change.png",
        "assets/textures/mail_noti.png",

        "assets/textures/cash.png",
        "assets/textures/saving_window.png",

        "assets/textures/remove.png",

        "assets/textures/circle.png",
        "assets/textures/bg_cursor.png",

        "assets/textures/row.png",
    },
}

assets.create = function()
    for k,t in pairs(assets) do
        if(k=="fonts_paths")then
            for i,v in pairs(t) do
                assets.fonts[i] = dxCreateFont(v[1], v[2])
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

--

UI.getButtons=function()
    for i,v in pairs(UI.btns) do
        btns:destroyButton(v)
    end

    for i,v in pairs(UI.edits) do
        edit:dxDestroyEdit(v)
    end

    scroll:dxDestroyScroll(UI.scroll)

    if(UI.option == 1)then
        UI.btns[1]=btns:createButton(sw/2-710/2/zoom+32/zoom, sh/2+5/zoom, 140/zoom, 36/zoom, "WYKONAJ PRZELEW", 0, 7, false, false, ":px_bank/assets/textures/button_transfer.png")

        UI.scroll=scroll:dxCreateScroll(sw/2-645/2/zoom+645/zoom-4/zoom, sh/2+90/zoom, 4/zoom, 4/zoom, 0, 3, UI.bank_acc.history, (59*3)-2/zoom, 0)
    elseif(UI.option == 2)then
        UI.btns[1]=btns:createButton(sw/2-710/2/zoom+555/zoom-15/2/zoom, sh/2-574/2/zoom+370/zoom, 130/zoom, 31/zoom, "OPŁAĆ WSZYSTKO", 0, 7, false, false, ":px_bank/assets/textures/button_transfer.png", {44,128,192})
        for i=1,3 do
            local sY=(47/zoom)*(i-1)
            UI.btns[i+1]=btns:createButton(sw/2-710/2/zoom+555/zoom-15/2/zoom, sh/2-574/2/zoom+414/zoom+sY, 130/zoom, 31/zoom, "WYŚLIJ PRZELEW", 0, 7, false, false, ":px_bank/assets/textures/button_transfer.png")
        end
        UI.scroll=scroll:dxCreateScroll(sw/2-645/2/zoom+645/zoom+10/zoom, sh/2+80/zoom, 4/zoom, 4/zoom, 0, 3, UI.bank_acc.mandates, (59*3)-2/zoom, 0)
    elseif(UI.option == 5)then
        UI.btns[1]=btns:createButton(sw/2+175/zoom, sh/2+68/zoom, 140/zoom, 36/zoom, "PRZELEJ PIENIĄDZE", 0, 7, false, false, ":px_bank/assets/textures/button_transfer.png")

        UI.edits[1]=edit:dxCreateEdit("Nazwa odbiorcy", sw/2-280/zoom, sh/2-621/2/zoom+213/zoom+5/zoom, 365/zoom, 35/zoom, false, 11/zoom, 0, false, false, ":px_bank/assets/textures/user_icon.png")
        UI.edits[3]=edit:dxCreateEdit("Kwota", sw/2-280/zoom, sh/2-621/2/zoom+213/zoom+215/zoom, 170/zoom, 35/zoom, false, 11/zoom, 0, true, false, ":px_bank/assets/textures/user_icon.png")
    elseif(UI.option == 6)then
        UI.btns[1]=btns:createButton(sw/2+225/zoom, sh/2-70/zoom, 105/zoom, 30/zoom, UI.bank_acc.sms and "DEZAKTYWUJ" or "AKTYWUJ", 0, 7, false, false, ":px_bank/assets/textures/accept.png")
        UI.btns[2]=btns:createButton(sw/2+225/zoom, sh/2-22/zoom, 105/zoom, 30/zoom, UI.bank_acc.mail and "DEZAKTYWUJ" or "AKTYWUJ", 0, 7, false, false, ":px_bank/assets/textures/accept.png")
        UI.btns[3]=btns:createButton(sw/2+225/zoom, sh/2+150/zoom, 105/zoom, 30/zoom, "ZMIEŃ", 0, 7, false, false, ":px_bank/assets/textures/accept.png")
        
        UI.edits[1]=edit:dxCreateEdit("Podaj obecny kod PIN", sw/2-105/zoom, sh/2+138/zoom, 241/zoom, 25/zoom, false, 10/zoom, 0, true, false, ":px_bank/assets/textures/pin.png")
        UI.edits[2]=edit:dxCreateEdit("Podaj nowy kod PIN", sw/2-105/zoom, sh/2+215/zoom, 241/zoom, 25/zoom, false, 10/zoom, 0, true, false, ":px_bank/assets/textures/pin.png")
    end
end

UI.notis=function()    
    blur:dxDrawBlur(sw/2-710/2/zoom+710/zoom+30/zoom, sh/2-574/2/zoom, 289/zoom, 427/zoom, tocolor(255, 255, 255, UI.nomainAlpha))
    dxDrawImage(sw/2-710/2/zoom+710/zoom+30/zoom, sh/2-574/2/zoom, 289/zoom, 427/zoom, assets.textures[16], 0, 0, 0, tocolor(255, 255, 255, UI.nomainAlpha))
    dxDrawText("Wiadomości", sw/2-710/2/zoom+710/zoom+30/zoom, sh/2-574/2/zoom, 289/zoom+sw/2-710/2/zoom+710/zoom+30/zoom, sh/2-574/2/zoom+50/zoom, tocolor(200, 200, 200, UI.nomainAlpha), 1, assets.fonts[2], "center", "center")
    dxDrawImage(sw/2-710/2/zoom+710/zoom+30/zoom+289/zoom-80/zoom, sh/2-574/2/zoom+(50-12)/2/zoom, 17/zoom, 12/zoom, assets.textures[4], 0, 0, 0, tocolor(255, 255, 255, UI.nomainAlpha))
    dxDrawRectangle(sw/2-710/2/zoom+710/zoom+30/zoom+(289-283)/2/zoom, sh/2-574/2/zoom+50/zoom, 283/zoom, 1, tocolor(85, 85, 85, UI.nomainAlpha))

    local tbl=UI.bank_acc.notis
    local x=0
    for i=1,4 do
        local v=tbl[i]
        if(v)then
            x=x+1

            local sY=(91/zoom)*(x-1)

            dxDrawImage(sw/2-710/2/zoom+710/zoom+30/zoom+(289-283)/2/zoom+15/zoom, sh/2-574/2/zoom+50/zoom+sY+25/zoom, 22/zoom, 22/zoom, assets.textures[15], 0, 0, 0, tocolor(255, 255, 255, UI.nomainAlpha))
            dxDrawRectangle(sw/2-710/2/zoom+710/zoom+30/zoom+(289-283)/2/zoom, sh/2-574/2/zoom+50/zoom+sY+91/zoom, 283/zoom, 1, tocolor(85, 85, 85, UI.nomainAlpha))

            dxDrawText(v.name, sw/2-710/2/zoom+710/zoom+30/zoom+(289-283)/2/zoom+60/zoom, sh/2-574/2/zoom+50/zoom+sY+15/zoom, 289/zoom, 91/zoom, tocolor(185, 185, 185, UI.nomainAlpha), 1, assets.fonts[1], "left", "top")
            dxDrawText(v.desc, sw/2-710/2/zoom+710/zoom+30/zoom+(289-283)/2/zoom+60/zoom, sh/2-574/2/zoom+50/zoom+sY+35/zoom, sw/2-710/2/zoom+710/zoom+30/zoom+289/zoom-30/zoom, 91/zoom, tocolor(185, 185, 185, UI.nomainAlpha), 1, assets.fonts[7], "left", "top", false, true)
            dxDrawText(v.date, sw/2-710/2/zoom+710/zoom+30/zoom+(289-283)/2/zoom+60/zoom, sh/2-574/2/zoom+50/zoom+sY+35/zoom, sw/2-710/2/zoom+710/zoom+30/zoom+289/zoom-15/zoom, sh/2-574/2/zoom+50/zoom+sY+35/zoom+50/zoom, tocolor(185, 185, 185, UI.nomainAlpha), 1, assets.fonts[7], "right", "bottom", false, true)
        end
    end
end

UI.backAnimate=function(i, btn)
    if(not UI.animate)then
        local x={
            sw/2-710/2/zoom+240/zoom,
            sw/2-710/2/zoom+345/zoom,
            sw/2-710/2/zoom+450/zoom
        }

        UI.animate=true
        animate(UI.backAlpha, 0, "Linear", 250, function(a)
            UI.backAlpha=a

            for i,v in pairs(UI.btns) do
                btns:buttonSetAlpha(v,a)
            end

            for i,v in pairs(UI.edits) do
                edit:dxSetEditAlpha(v, a)
            end

            scroll:dxScrollSetAlpha(UI.scroll, a)
        end, function()
            UI.option=i
            if(not btn)then UI.getButtons() end 
            setTimer(function()
                animate(UI.backAlpha, 255, "Linear", 250, function(a)
                    UI.backAlpha=a

                    for i,v in pairs(UI.btns) do
                        btns:buttonSetAlpha(v,a)
                    end
        
                    for i,v in pairs(UI.edits) do
                        edit:dxSetEditAlpha(v, a)
                    end

                    scroll:dxScrollSetAlpha(UI.scroll, a)
                end, function()
                    UI.animate=false
                end)
            end, 50, 1)
        end)

        if(i <= 3)then
            animate(UI.border, x[i], "Linear", 500, function(a)
                UI.border=a
            end)
        end
    end
end

UI.nomainAnimate=function(i)
    if(not UI.animate)then
        if(i == 2 and not UI.openNotis)then
            UI.openNotis=true
            UI.animate=true
            animate(UI.nomainAlpha, 255, "Linear", 250, function(a)
                UI.nomainAlpha=a
            end, function()
                UI.animate=false
            end)
        elseif(i == 2 and UI.openNotis)then
            UI.animate=true
            animate(UI.nomainAlpha, 0, "Linear", 250, function(a)
                UI.nomainAlpha=a
            end, function()
                UI.animate=false
                UI.openNotis=false
            end)
        end
    end
end

function dxDrawButton(x,y,w,h,alpha,postGUI)
	dxDrawRectangle(x,y,w,h,tocolor(31,32,31,alpha),postGUI)

	dxDrawRectangle(x,y,w,1,tocolor(54,56,53,alpha),postGUI)
	dxDrawRectangle(x,y,1,h,tocolor(54,56,53,alpha),postGUI)
	dxDrawRectangle(x,y+h,w,1,tocolor(54,56,53,alpha),postGUI)
	dxDrawRectangle(x+w-1,y,1,h,tocolor(54,56,53,alpha),postGUI)
end

UI.draw=function()
    local nr=string.sub(getPlayerSerial(localPlayer), 1, 4).." "..string.sub(getElementData(localPlayer, "user:register_date"), 1, 4).." "..string.format("%04d", string.sub(getElementData(localPlayer, "user:uid"), 1, 4)).." 2021 "..string.sub(getPlayerSerial(localPlayer), 4, 10)

    -- window
    blur:dxDrawBlur(sw/2-710/2/zoom, sh/2-574/2/zoom, 710/zoom, 574/zoom, tocolor(255, 255, 255, UI.mainAlpha))
    dxDrawImage(sw/2-710/2/zoom, sh/2-574/2/zoom, 710/zoom, 574/zoom, assets.textures[1], 0, 0, 0, tocolor(255, 255, 255, UI.mainAlpha))

    -- header
    dxDrawImage(sw/2-710/2/zoom+30/zoom, sh/2-574/2/zoom+20/zoom, 152/zoom, 55/zoom, assets.textures[2], 0, 0, 0, tocolor(255, 255, 255, UI.mainAlpha))
    
    -- options
    dxDrawText("Pulpit", sw/2-710/2/zoom+240/zoom, sh/2-574/2/zoom+20/zoom, 72/zoom+sw/2-710/2/zoom+240/zoom, 40/zoom+sh/2-574/2/zoom+20/zoom, tocolor(200, 200, 200, UI.mainAlpha), 1, assets.fonts[1], "center", "center")
    dxDrawText("Płatności", sw/2-710/2/zoom+345/zoom, sh/2-574/2/zoom+20/zoom, 72/zoom+sw/2-710/2/zoom+345/zoom, 40/zoom+sh/2-574/2/zoom+20/zoom, tocolor(200, 200, 200, UI.mainAlpha), 1, assets.fonts[1], "center", "center")
    dxDrawText("Finanse", sw/2-710/2/zoom+450/zoom, sh/2-574/2/zoom+20/zoom, 72/zoom+sw/2-710/2/zoom+450/zoom, 40/zoom+sh/2-574/2/zoom+20/zoom, tocolor(200, 200, 200, UI.mainAlpha), 1, assets.fonts[1], "center", "center")
    onClick(sw/2-710/2/zoom+240/zoom, sh/2-574/2/zoom+20/zoom, 72/zoom, 35/zoom, function() UI.backAnimate(1) end)
    onClick(sw/2-710/2/zoom+345/zoom, sh/2-574/2/zoom+20/zoom, 72/zoom, 35/zoom, function() UI.backAnimate(2) end)
    onClick(sw/2-710/2/zoom+450/zoom, sh/2-574/2/zoom+20/zoom, 72/zoom, 35/zoom, function() UI.backAnimate(3) end)
    dxDrawRectangle(UI.border, sh/2-574/2/zoom+20/zoom+35/zoom, 72/zoom, 1, tocolor(51, 153, 219, UI.mainAlpha))

    -- right options
    dxDrawImage(sw/2-710/2/zoom+710/zoom-(80-13)/2/zoom-13/zoom, sh/2-574/2/zoom+(80-10)/2/zoom, 10/zoom, 10/zoom, assets.textures[3], 0, 0, 0, tocolor(255, 255, 255, UI.mainAlpha))
    dxDrawImage(sw/2-710/2/zoom+710/zoom-(80-13)/2/zoom-13/zoom-35/zoom, sh/2-574/2/zoom+(80-13)/2/zoom, 17/zoom, 12/zoom, assets.textures[4], 0, 0, 0, tocolor(255, 255, 255, UI.mainAlpha))
    onClick(sw/2-710/2/zoom+710/zoom-(80-13)/2/zoom-13/zoom-35/zoom, sh/2-574/2/zoom+(80-13)/2/zoom, 17/zoom, 12/zoom, function() UI.nomainAnimate(2) end)
    dxDrawImage(sw/2-710/2/zoom+710/zoom-(80-13)/2/zoom-13/zoom-65/zoom, sh/2-574/2/zoom+(80-13)/2/zoom, 12/zoom, 12/zoom, assets.textures[5], 0, 0, 0, tocolor(255, 255, 255, UI.mainAlpha))
    onClick(sw/2-710/2/zoom+710/zoom-(80-13)/2/zoom-13/zoom-65/zoom, sh/2-574/2/zoom+(80-13)/2/zoom, 12/zoom, 12/zoom, function()
        if(UI.option == 6)then
            UI.backAnimate(1)
        else
            UI.backAnimate(6)
        end
    end)

    if(UI.openNotis)then
        UI.notis()
    end

    -- options
    if(UI.option == 1)then
        -- pulpit

        -- lewo
        dxDrawText("Konto bankowe", sw/2-710/2/zoom+32/zoom, sh/2-574/2/zoom+110/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[2], "left", "top")
        dxDrawImage(sw/2-710/2/zoom+32/zoom, sh/2-574/2/zoom+150/zoom, 12/zoom, 12/zoom, assets.textures[6], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
        dxDrawText(nr, sw/2-710/2/zoom+52/zoom, sh/2-574/2/zoom+144/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[3], "left", "top")
        onClick(sw/2-710/2/zoom+52/zoom, sh/2-574/2/zoom+150/zoom, dxGetTextWidth(nr, 1, assets.fonts[3]), 11/zoom, function()
            setClipboard(nr)
            noti:noti("Pomyślnie skopiowano numer konta do schowka.", "info")
        end)

        dxDrawText("Dostępne środki", sw/2-710/2/zoom+32/zoom, sh/2-574/2/zoom+195/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[2], "left", "top")
        dxDrawText(convertNumber(UI.bank_acc.money).." $", sw/2-710/2/zoom+32/zoom, sh/2-574/2/zoom+220/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[4], "left", "top")

        -- prawo
        local x,y,w,h=sw/2-710/2/zoom+350/zoom, sh/2-574/2/zoom+136/zoom,328/zoom,164/zoom
        dxDrawRectangle(x,y,w,h,tocolor(15,15,15,UI.backAlpha > 100 and 100 or UI.backAlpha))

        dxDrawText("Wydatki", x, sh/2-574/2/zoom+100/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[2], "left", "top")
    
        local dates={}
        local max=100
        local k=0
        for i,v in pairs(UI.expenses) do
            if(v[2] > max)then
                max=v[2]
            end
        end

        for i=1,8 do
            local sX=(41/zoom)*(i-1)
            for i=1,4 do
                local sY=(41/zoom)*(i-1)
                local xx,yy,ww,hh=x+sX,y+sY,41/zoom,41/zoom
                dxDrawRectangle(xx,yy-1,ww,1,tocolor(83,82,80,UI.backAlpha))
                dxDrawRectangle(xx,yy,1,hh,tocolor(83,82,80,UI.backAlpha))
                dxDrawRectangle(xx+ww,yy,1,hh,tocolor(83,82,80,UI.backAlpha))
                dxDrawRectangle(xx,yy+hh-1,ww,1,tocolor(83,82,80,UI.backAlpha))
            end
            dxDrawText(string.sub(UI.expenses[i][1], 6, 10), x+(41/zoom)*(i)-20/zoom, y+h+10/zoom, 0, 0, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[7], "left", "top")
        end

        local last={}
        local i=0
        for k,v in pairs(UI.expenses) do
            i=i+1

            local sp=w*(i/8)
            dxDrawLine(last[1] or x,last[2] or y+h, x+sp, y+h-(h*(v[2]/max)), tocolor(57, 116, 131, UI.backAlpha), 2)
            dxDrawImage(x+sp-7/2/zoom+1, y+h-(h*(v[2]/max))-7/2/zoom+1, 7/zoom, 7/zoom, assets.textures[29], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
    
            if(isMouseInPosition(x+sp-14/2/zoom+1, y+h-(h*(v[2]/max))-14/2/zoom+1, 14/zoom, 14/zoom))then
                local cX,cY=getCursorPosition()
                cX,cY=cX*sw,cY*sh
                cY=cY-30/zoom
    
                dxDrawImage(cX, cY, 80/zoom, 31/zoom, assets.textures[30])
                dxDrawText(convertNumber(v[2]).."$", cX, cY, cX+80/zoom, cY+31/zoom, tocolor(200, 200, 200), 1, assets.fonts[7], "center", "center")
            end
    
            last={x+sp,y+h-(h*(v[2]/max))}
        end

        onClick(sw/2-710/2/zoom+32/zoom, sh/2+5/zoom, 140/zoom, 36/zoom, function()
            UI.backAnimate(5)
        end)

        -- dol
        dxDrawRectangle(sw/2-646/2/zoom, sh/2+55/zoom, 646/zoom, 1, tocolor(85, 85, 85, UI.backAlpha))

        dxDrawText("Historia działań", sw/2-710/2/zoom+32/zoom, sh/2+60/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[2], "left", "top")

        local row=math.floor(scroll:dxScrollGetPosition(UI.scroll))+1
        local x=0
        local tbl=UI.bank_acc.history
        for i=row,row+2 do
            local v=tbl[i]
            if(v)then
                x=x+1

                local sY=(59/zoom)*(x-1)

                dxDrawImage(sw/2-645/2/zoom, sh/2+90/zoom+sY, 645/zoom, 57/zoom, assets.textures[31], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))

                local text=v.type2 == "PRZELEW DO" and "#878787od:#dcdcdc "..v.nick.."\n#878787do:#dcdcdc "..v.target or "#878787od:#dcdcdc "..v.target.."\n#878787do:#dcdcdc "..v.nick
                dxDrawImage(sw/2-645/2/zoom+(57-17)/2/zoom, sh/2+90/zoom+sY+(57-17)/2/zoom, 19/zoom, 17/zoom, assets.textures[17], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
                dxDrawText("Przelew", sw/2-645/2/zoom+50/zoom, sh/2+90/zoom+sY, 645/zoom, 57/zoom+sh/2+90/zoom+sY, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[1], "left", "center")
                dxDrawText(text, sw/2-645/2/zoom+150/zoom, sh/2+90/zoom+sY, 645/zoom, 57/zoom+sh/2+90/zoom+sY, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[1], "left", "center", false, false, false, true)
                dxDrawText(string.sub(v.text, 0, #v.text-1).."#2193b0$", sw/2-645/2/zoom+360/zoom, sh/2+90/zoom+sY, 645/zoom, 57/zoom+sh/2+90/zoom+sY, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[6], "left", "center", false, false, false, true)
                dxDrawText(string.sub(v.date, 1, 10), sw/2-645/2/zoom+535/zoom, sh/2+90/zoom+sY, 645/zoom, 57/zoom+sh/2+90/zoom+sY, tocolor(200, 200, 200, UI.backAlpha > 125 and 125 or UI.backAlpha), 1, assets.fonts[3], "left", "center", false, false, false, true)
            end
        end
    elseif(UI.option == 2)then
        -- platnosci

        dxDrawText("Ulubieni odbiorcy", sw/2-710/2/zoom+55/zoom, sh/2-574/2/zoom+105/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[2], "left", "top")
        dxDrawImage(sw/2-710/2/zoom+55/zoom, sh/2-574/2/zoom+143/zoom, 14/zoom, 13/zoom, assets.textures[8], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
        dxDrawText("Wykonaj przelew do ulubionego odbiorcy", sw/2-710/2/zoom+75/zoom, sh/2-574/2/zoom+137/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "left", "top")
        -- ulubieni odbiorcy
        local tbl=UI.bank_acc.favorites
        for i=1,2 do
            local v=tbl[i]
            local sY=(56/zoom)*(i-1)
            if(v)then
                dxDrawImage(sw/2-263/zoom, sh/2-104/zoom+sY, 37/zoom, 37/zoom, avatars:getPlayerAvatar(v.name), 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
                dxDrawText(v.name, sw/2-200/zoom, sh/2-104/zoom+sY, 37/zoom+sw/2-263/zoom, 37/zoom+sh/2-104/zoom+sY, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "left", "center")
                dxDrawText("Przelej na", sw/2+60/zoom, sh/2-104/zoom+sY, 37/zoom+sw/2-263/zoom, 37/zoom+sh/2-104/zoom+sY, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "left", "center")
                dxDrawImage(sw/2+70/zoom, sh/2-170/zoom+sY, 239/zoom, 169/zoom, assets.textures[7], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
                dxDrawText(string.sub(v.nr, 1, 10).."..", sw/2+70/zoom, sh/2-170/zoom+sY, 239/zoom+sw/2+70/zoom, 169/zoom+sh/2-170/zoom+sY, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[3], "center", "center")
                dxDrawImage(sw/2+264/zoom, sh/2-95/zoom+sY, 23/zoom, 23/zoom, assets.textures[9], 0, 0, 0, tocolor(59, 125, 78, UI.backAlpha))
                dxDrawImage(sw/2-300/zoom, sh/2-95/zoom+sY-2, 19/zoom, 19/zoom, assets.textures[28], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))

                onClick(sw/2-300/zoom, sh/2-95/zoom+sY-2, 19/zoom, 19/zoom, function()
                    if(SPAM.getSpam())then return end

                    triggerServerEvent("G.removeFromFavorite", resourceRoot, v.name)
                end)

                onClick(sw/2+70/zoom, sh/2-170/zoom+sY, 239/zoom, 169/zoom, function()
                    setTimer(function()
                        for i,v in pairs(UI.btns) do
                            btns:destroyButton(v)
                        end
                    
                        for i,v in pairs(UI.edits) do
                            edit:dxDestroyEdit(v)
                        end
    
                        UI.btns[1]=btns:createButton(sw/2+175/zoom, sh/2+68/zoom, 140/zoom, 36/zoom, "PRZELEJ PIENIĄDZE", 0, 7, false, false, ":px_bank/assets/textures/button_transfer.png")
    
                        UI.edits[1]=edit:dxCreateEdit("Nazwa odbiorcy", sw/2-280/zoom, sh/2-621/2/zoom+213/zoom+5/zoom, 365/zoom, 35/zoom, false, 11/zoom, 0, false, false, ":px_bank/assets/textures/user_icon.png")
                        UI.edits[3]=edit:dxCreateEdit("Kwota", sw/2-280/zoom, sh/2-621/2/zoom+213/zoom+215/zoom, 170/zoom, 35/zoom, false, 11/zoom, 0, true, false, ":px_bank/assets/textures/user_icon.png")
                        edit:dxSetEditText(UI.edits[1], v.name)
                    end, 250, 1)

                    UI.backAnimate(5, true)
                end)
            else
                dxDrawText("----", sw/2-200/zoom, sh/2-104/zoom+sY, 37/zoom+sw/2-263/zoom, 37/zoom+sh/2-104/zoom+sY, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "left", "center")
                dxDrawText("----", sw/2+60/zoom, sh/2-104/zoom+sY, 37/zoom+sw/2-263/zoom, 37/zoom+sh/2-104/zoom+sY, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "left", "center")
                dxDrawImage(sw/2+70/zoom, sh/2-170/zoom+sY, 239/zoom, 169/zoom, assets.textures[7], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
                dxDrawText("----", sw/2+70/zoom, sh/2-170/zoom+sY, 239/zoom+sw/2+70/zoom, 169/zoom+sh/2-170/zoom+sY, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "center", "center")
            end
        end
        --

        -- linia
        dxDrawRectangle(sw/2-646/2/zoom, sh/2+23/zoom, 646/zoom, 1, tocolor(85, 85, 85, UI.backAlpha))
        --

        dxDrawText("Opłacanie mandatów", sw/2-710/2/zoom+55/zoom, sh/2-574/2/zoom+105/zoom+232/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[2], "left", "top")
        dxDrawImage(sw/2-710/2/zoom+55/zoom, sh/2-574/2/zoom+143/zoom+232/zoom, 14/zoom, 13/zoom, assets.textures[8], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
        dxDrawText("Wykonaj przelew za otrzymany mandat", sw/2-710/2/zoom+75/zoom, sh/2-574/2/zoom+137/zoom+232/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "left", "top")
        -- mandaty
        local row=math.floor(scroll:dxScrollGetPosition(UI.scroll))+1
        local x=0
        local tbl=UI.bank_acc.mandates
        for i=row,row+2 do
            local v=tbl[i]
            
            x=x+1
            local sY=(47/zoom)*(x-1)

            if(v)then
                dxDrawText(v.name, sw/2-710/2/zoom+40/zoom, sh/2-574/2/zoom+417/zoom+sY, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "left", "top")
                dxDrawText(convertNumber(v.money).."$", sw/2-710/2/zoom+270/zoom, sh/2-574/2/zoom+417/zoom+sY, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[3], "left", "top")
                dxDrawText(v.date, sw/2-710/2/zoom+360/zoom, sh/2-574/2/zoom+417/zoom+sY, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[3], "left", "top")

                onClick(sw/2-710/2/zoom+555/zoom-15/2/zoom, sh/2-574/2/zoom+414/zoom+sY, 130/zoom, 31/zoom, function()
                    if(SPAM.getSpam())then return end

                    triggerServerEvent("G.payMandate", resourceRoot, v, i)
                end)
            else
                dxDrawText("----", sw/2-710/2/zoom+40/zoom, sh/2-574/2/zoom+417/zoom+sY, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "left", "top")
                dxDrawText("----", sw/2-710/2/zoom+270/zoom, sh/2-574/2/zoom+417/zoom+sY, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[3], "left", "top")
                dxDrawText("----", sw/2-710/2/zoom+360/zoom, sh/2-574/2/zoom+417/zoom+sY, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[3], "left", "top")
            end
        end

        onClick(sw/2-710/2/zoom+555/zoom-15/2/zoom, sh/2-574/2/zoom+370/zoom, 130/zoom, 31/zoom, function()
            if(SPAM.getSpam())then return end

            triggerServerEvent("G.payMandate", resourceRoot)
        end)
        --
    elseif(UI.option == 3)then
        -- finanse

        -- lewo
        dxDrawText("Moje finanse", sw/2-710/2/zoom+62/zoom, sh/2-574/2/zoom+114/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[2], "left", "top")

        dxDrawImage(sw/2-710/2/zoom+64/zoom, sh/2-574/2/zoom+167/zoom, 33/zoom, 32/zoom, assets.textures[14], 0, 0, 0, tocolor(59,125,78, UI.backAlpha))
        dxDrawText("Twoje środki", sw/2-710/2/zoom+105/zoom, sh/2-574/2/zoom+165/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "left", "top")
        dxDrawText(convertNumber(UI.bank_acc.money).." $", sw/2-710/2/zoom+105/zoom, sh/2-574/2/zoom+180/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[3], "left", "top")
        -- dol
        dxDrawRectangle(sw/2-646/2/zoom, sh/2+30/zoom, 646/zoom, 1, tocolor(85, 85, 85, UI.backAlpha))

        dxDrawText("Nowa karta", sw/2-710/2/zoom+90/zoom, sh/2-574/2/zoom+340/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[2], "left", "top")
        dxDrawImage(sw/2-264/zoom, sh/2+85/zoom, 18/zoom, 12/zoom, assets.textures[13], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
        dxDrawText("Złóż wniosek o wydanie nowej karty bankowej", sw/2-710/2/zoom+115/zoom, sh/2-574/2/zoom+366/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "left", "top")

        -- karty
        local haveCard=0
        for i,v in pairs(UI.cards) do
            if(UI.bank_acc.card == v.name)then
                haveCard=v.cost
                break
            end
        end

        for i,v in pairs(UI.cards) do
            local sX=(227/zoom)*(i-1)

            if(isMouseInPosition(sw/2-362/zoom+sX, sh/2+105/zoom, 260/zoom, 167/zoom))then
                dxDrawImage(sw/2-362/zoom+sX, sh/2+105/zoom, 260/zoom, 167/zoom, assets.textures[12], 0, 0, 0, tocolor(200, 200, 200, UI.backAlpha))
            else
                if(UI.bank_acc.card == v.name)then
                    dxDrawImage(sw/2-362/zoom+sX, sh/2+105/zoom, 260/zoom, 167/zoom, assets.textures[12], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
                    dxDrawImage(sw/2-362/zoom+sX, sh/2+105/zoom, 260/zoom, 167/zoom, assets.textures[12], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
                else
                    dxDrawImage(sw/2-362/zoom+sX, sh/2+105/zoom, 260/zoom, 167/zoom, assets.textures[12], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
                end
            end

            onClick(sw/2-362/zoom+sX, sh/2+105/zoom, 260/zoom, 167/zoom, function()
                if(SPAM.getSpam())then return end

                if(UI.bank_acc.card == v.name)then
                    noti:noti("Posiadasz już tą kartę.", "error")
                else
                    if(v.cost > haveCard)then
                        local online=getElementData(localPlayer, "user:online_time") or 0
                        local hours=math.floor(online/60)
                        if(hours >= v.hours)then
                            if(getPlayerMoney(localPlayer) >= v.cost)then
                                triggerServerEvent("G.cardWniosek", resourceRoot, v)
                            else
                                noti:noti("Aby złożyć wniosek na tą kartę musisz posiadać "..convertNumber(v.cost).."$")
                            end
                        else
                            noti:noti("Aby złozyć wniosek na tą kartę musisz mieć przegrane "..v.hours.." godzin.", "error")
                        end
                    else
                        noti:noti("Nie możesz kupić gorszej karty!", "error")
                    end
                end
            end)

            dxDrawText(v.name, sw/2-362/zoom+sX+45/zoom, sh/2+150/zoom, 260/zoom, 167/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "left", "top")
            dxDrawText(v.desc, sw/2-362/zoom+sX+55/zoom, sh/2+180/zoom, 260/zoom, 167/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[7], "left", "top")
            dxDrawImage(sw/2-362/zoom+sX+190/zoom, sh/2+105/zoom+45/zoom, 28/zoom, 28/zoom, assets.textures[11], 0, 0, 0, tocolor(v.color[1], v.color[2], v.color[3], UI.backAlpha))
        end
    elseif(UI.option == 5)then
        -- przelewy

        -- lewo
        dxDrawText("Na rachunek w San Andreas", sw/2-710/2/zoom+62/zoom, sh/2-574/2/zoom+114/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[2], "left", "top")

        -- plusik
        dxDrawImage(sw/2-710/2/zoom+410/zoom, sh/2-574/2/zoom+200/zoom-2, 23/zoom, 23/zoom, assets.textures[9], 0, 0, 0, tocolor(51, 149, 212, UI.backAlpha))
        onClick(sw/2-710/2/zoom+410/zoom, sh/2-574/2/zoom+200/zoom-2, 23/zoom, 23/zoom, function()
            local name=edit:dxGetEditText(UI.edits[1]) or ""
            if(#name > 0)then
                if(SPAM.getSpam())then return end
                
                triggerServerEvent("G.addToFavorite", resourceRoot, name, nr)
            else
                noti:noti("Najpierw uzupełnij nazwe.", "error")
            end
        end)

        -- z rachunku
        dxDrawButton(sw/2-280/zoom, sh/2-621/2/zoom+286/zoom, 365/zoom, 35/zoom,UI.backAlpha > 50 and 50 or UI.backAlpha,postGUI)
        dxDrawImage(sw/2-310/zoom+35/zoom, sh/2-55/zoom+40/zoom, 16/zoom, 18/zoom, assets.textures[21], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
        dxDrawRectangle(sw/2-310/zoom+40/zoom+20/zoom, sh/2-55/zoom+38/zoom, 1, 20/zoom, tocolor(200,200,200, UI.backAlpha))
        dxDrawText("Na rachunek w San Andreas", sw/2-310/zoom+70/zoom, sh/2-55/zoom, 429/zoom, 95/zoom+sh/2-55/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[1], "left", "center")
        dxDrawRectangle(sw/2-280/zoom, sh/2-621/2/zoom+286/zoom+35/zoom-1, 365/zoom, 1, tocolor(175, 175, 175,UI.backAlpha))

        -- na rachunek
        dxDrawButton(sw/2-280/zoom, sh/2-621/2/zoom+213/zoom+145/zoom, 365/zoom, 35/zoom,UI.backAlpha > 50 and 50 or UI.backAlpha,postGUI)
        dxDrawImage(sw/2-310/zoom+35/zoom, sh/2-621/2/zoom+213/zoom+145/zoom+(35-18)/2/zoom, 16/zoom, 18/zoom, assets.textures[21], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
        dxDrawRectangle(sw/2-310/zoom+40/zoom+20/zoom, sh/2-621/2/zoom+213/zoom+145/zoom+(35-20)/2/zoom, 1, 20/zoom, tocolor(200,200,200, UI.backAlpha))
        dxDrawText(nr, sw/2-310/zoom+70/zoom, sh/2-621/2/zoom+213/zoom+145/zoom, 429/zoom, sh/2-621/2/zoom+213/zoom+145/zoom+35/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[1], "left", "center")
        dxDrawRectangle(sw/2-280/zoom, sh/2-621/2/zoom+213/zoom+145/zoom+35/zoom-1, 365/zoom, 1, tocolor(175, 175, 175,UI.backAlpha))

        -- data
        dxDrawButton(sw/2-60/zoom, sh/2+153/zoom-39/zoom, 166/zoom, 39/zoom,UI.backAlpha > 50 and 50 or UI.backAlpha,postGUI)
        dxDrawImage(sw/2-55/zoom, sh/2+123/zoom, 18/zoom, 18/zoom, assets.textures[20], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
        dxDrawRectangle(sw/2-55/zoom+25/zoom, sh/2+123/zoom, 1, 20/zoom, tocolor(200,200,200, UI.backAlpha))
        dxDrawRectangle(sw/2-60/zoom, sh/2+153/zoom, 166/zoom, 1, tocolor(175, 175, 175,UI.backAlpha))
        dxDrawText(showtime(), sw/2-20/zoom, sh/2+153/zoom-40/zoom, 166/zoom, sh/2+153/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[3], "left", "center")

        -- wybory typu przelewu
        for i=1,2 do
            local tex=(UI.transferType == i) and assets.textures[19] or assets.textures[18]
            local sX=(239/zoom)*(i-1)
            dxDrawImage(sw/2-305/zoom+sX, sh/2+155/zoom, 255/zoom, 125/zoom, assets.textures[22], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
            dxDrawImage(sw/2-310/zoom+sX+(125-42)/2/zoom, sh/2+155/zoom+(125-42)/2/zoom, 42/zoom, 42/zoom, tex, 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
            dxDrawText(i == 1 and "SoFast A.P elixir" or "Standardowy elixir", sw/2-305/zoom+sX+85/zoom, sh/2+125/zoom, 255/zoom, 125/zoom+sh/2+155/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[1], "left", "center")
            dxDrawText(i == 1 and "Do 60 sekund (+500$)" or "Do 60 minut", sw/2-305/zoom+sX+85/zoom, sh/2+175/zoom, 255/zoom, 125/zoom+sh/2+155/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[5], "left", "center")
            onClick(sw/2-310/zoom+sX+(125-42)/2/zoom, sh/2+155/zoom+(125-42)/2/zoom, 42/zoom, 42/zoom, function() UI.transferType=i end)
        end

        onClick(sw/2+175/zoom, sh/2+68/zoom, 140/zoom, 36/zoom, function()
            local name=edit:dxGetEditText(UI.edits[1]) or ""
            local kwota=edit:dxGetEditText(UI.edits[3]) or ""
            if(#name > 0 and #kwota > 0)then
                if(#kwota < 1)then
                    noti:noti("Podana kwota jest nieprawidłowa.", "error")
                else
                    if(tonumber(kwota) > tonumber(UI.bank_acc.money))then
                        noti:noti("Nie posiadasz tyle gotówki na koncie bankowym.", "error")
                    else
                        if(SPAM.getSpam())then return end

                        triggerServerEvent("G.sendTransfer", resourceRoot, name, kwota, UI.transferType)
                    end
                end
            else
                noti:noti("Najpierw uzupełnij dane do przelewu.", "error")
            end
        end)

        -- prawo
        dxDrawText("Twoje obecne saldo", sw/2-710/2/zoom, sh/2-574/2/zoom+103/zoom, sw/2-710/2/zoom+710/zoom-47/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "right", "top")
        dxDrawText(convertNumber(UI.bank_acc.money).." $", sw/2-710/2/zoom, sh/2-574/2/zoom+127/zoom, sw/2-710/2/zoom+710/zoom-47/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[3], "right", "top")

        dxDrawText("Aby dodać użytkownika do\nulubionych uzupełnij wszystkie\ndane a następnie naciśnij\nprzycisk “plus”", sw/2-710/2/zoom, sh/2-574/2/zoom+225/zoom, sw/2-710/2/zoom+710/zoom-47/zoom+20/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[1], "right", "top")

        dxDrawText("ANULUJ", sw/2+215/zoom+10/zoom, sh/2+125/zoom, 53/zoom+sw/2+215/zoom, 19/zoom+sh/2+125/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[5], "left", "top")
        onClick(sw/2+215/zoom+10/zoom, sh/2+125/zoom, 53/zoom, 19/zoom, function()
            UI.backAnimate(1)
        end)       
    elseif(UI.option == 6)then
        -- ustawienia

        dxDrawText("Ustawienia", sw/2-710/2/zoom+50/zoom, sh/2-574/2/zoom+110/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[2], "left", "top")

        -- Powiadomienia
        dxDrawImage(sw/2-710/2/zoom+40/zoom, sh/2-574/2/zoom+205/zoom, 20/zoom, 16/zoom, assets.textures[25], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
        dxDrawText("Usługi", sw/2-710/2/zoom+78/zoom, sh/2-574/2/zoom+193/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[1], "left", "top")
        dxDrawText("Powiadomienia", sw/2-710/2/zoom+78/zoom, sh/2-574/2/zoom+212/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[2], "left", "top")

        -- lista
        dxDrawText("Obsługa dostępów do kanałów", sw/2-710/2/zoom+235/zoom, sh/2-574/2/zoom+140/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[1], "left", "top")
        dxDrawText("Kanał komunikacji", sw/2-710/2/zoom+250/zoom, sh/2-574/2/zoom+162/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[8], "left", "top")
        dxDrawText("Status", sw/2-710/2/zoom+480/zoom, sh/2-574/2/zoom+162/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[8], "left", "top")
        dxDrawRectangle(sw/2-115/zoom, sh/2-95/zoom, 421/zoom, 1, tocolor(85,85,85,UI.backAlpha))

        dxDrawText("Powiadomienia SMS", sw/2-710/2/zoom+250/zoom, sh/2-574/2/zoom+220/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[8], "left", "top")
        dxDrawText(UI.bank_acc.sms and "Aktywny" or "Nieaktywny", sw/2-710/2/zoom+480/zoom, sh/2-574/2/zoom+220/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[8], "left", "top")

        dxDrawText("Powiadomienia e-mail", sw/2-710/2/zoom+250/zoom, sh/2-574/2/zoom+220/zoom+48/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[8], "left", "top")
        dxDrawText(UI.bank_acc.mail and "Aktywny" or "Nieaktywny", sw/2-710/2/zoom+480/zoom, sh/2-574/2/zoom+220/zoom+48/zoom, 710/zoom, 574/zoom, tocolor(185, 185, 185, UI.backAlpha), 1, assets.fonts[8], "left", "top")
        
        -- pasek
        dxDrawRectangle(sw/2-597/2/zoom, sh/2+50/zoom, 597/zoom, 1, tocolor(85,85,85,UI.backAlpha))

        -- PIN
        dxDrawImage(sw/2-710/2/zoom+40/zoom, sh/2-574/2/zoom+205/zoom+220/zoom, 23/zoom, 23/zoom, assets.textures[24], 0, 0, 0, tocolor(255, 255, 255, UI.backAlpha))
        dxDrawText("Usługi", sw/2-710/2/zoom+78/zoom, sh/2-574/2/zoom+193/zoom+220/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[1], "left", "top")
        dxDrawText("Osobiste", sw/2-710/2/zoom+78/zoom, sh/2-574/2/zoom+212/zoom+220/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[2], "left", "top")

        dxDrawText("Zmiana PIN'u do karty bankowej", sw/2-710/2/zoom+250/zoom, sh/2-574/2/zoom+350/zoom, 710/zoom, 574/zoom, tocolor(200, 200, 200, UI.backAlpha), 1, assets.fonts[1], "left", "top")

        onClick(sw/2+225/zoom, sh/2-70/zoom, 105/zoom, 30/zoom, function()
            if(SPAM.getSpam())then return end

            triggerServerEvent("G.changeSetting", resourceRoot, "sms", not UI.bank_acc.sms)
        end)

        onClick(sw/2+225/zoom, sh/2-22/zoom, 105/zoom, 30/zoom, function()
            if(SPAM.getSpam())then return end

            triggerServerEvent("G.changeSetting", resourceRoot, "mail", not UI.bank_acc.mail)
        end)

        onClick(sw/2+225/zoom, sh/2+150/zoom, 105/zoom, 30/zoom, function()
            local stary=edit:dxGetEditText(UI.edits[1]) or ""
            local nowy=edit:dxGetEditText(UI.edits[2]) or ""
            if(tonumber(stary) and tonumber(nowy) and #stary == 4 and #nowy == 4)then
                if(SPAM.getSpam())then return end

                triggerServerEvent("G.changeSetting", resourceRoot, stary, nowy)
            else
                noti:noti("Wprowadzony zły PIN, może on składać się tylko z liczb i zawierać 4 znaki.", "error")
            end
        end)
    end

    -- end header
    dxDrawRectangle(sw/2-646/2/zoom, sh/2-574/2/zoom+80/zoom, 646/zoom, 1, tocolor(88,88,88,UI.mainAlpha))

    -- quit
    onClick(sw/2-710/2/zoom+710/zoom-(80-13)/2/zoom-13/zoom, sh/2-574/2/zoom+(80-13)/2/zoom, 13/zoom, 13/zoom, function() UI.open(true) end)
end

UI.open=function(self)
    if(UI.opened or self)then
        if(not self and UI.animate)then return end

        noti=exports.px_noti
        blur=exports.blur
        btns=exports.px_buttons
        edit=exports.px_editbox
        scroll=exports.px_scroll
        avatars=exports.px_avatars

        UI.animate=true
        animate(UI.mainAlpha, 0, "Linear", 250, function(a)
            UI.mainAlpha=a
            UI.backAlpha=a

            for i,v in pairs(UI.btns) do
                btns:buttonSetAlpha(v,a)
            end

            for i,v in pairs(UI.edits) do
                edit:dxSetEditAlpha(v, a)
            end

            scroll:dxScrollSetAlpha(UI.scroll, a)
        end, function()
            UI.animate=false

            removeEventHandler("onClientRender", root, UI.draw)
            showCursor(false)
    
            UI.opened=false
            assets.destroy()
    
            for i,v in pairs(UI.btns) do
                btns:destroyButton(v)
            end
    
            for i,v in pairs(UI.edits) do
                edit:dxDestroyEdit(v)
            end

            scroll:dxDestroyScroll(UI.scroll)
        end)
    else
        if(UI.animate)then return end
        addEventHandler("onClientRender", root, UI.draw)
        showCursor(true)

        assets.create()

        UI.opened=true
        UI.option=1
        UI.getButtons()

        UI.option=1
        UI.border=sw/2-710/2/zoom+240/zoom

        UI.animate=true

        animate(UI.mainAlpha, 255, "Linear", 250, function(a)
            UI.mainAlpha=a
            UI.backAlpha=a

            for i,v in pairs(UI.btns) do
                btns:buttonSetAlpha(v,a)
            end

            for i,v in pairs(UI.edits) do
                edit:dxSetEditAlpha(v, a)
            end

            scroll:dxScrollSetAlpha(UI.scroll, a)
        end, function()
            UI.animate=false
        end)
    end
end

-- triggers

addEvent("G.openInterface", true)
addEventHandler("G.openInterface", resourceRoot, function(acc, self, wydatki)
    if(acc)then
        UI.bank_acc=acc
    end

    if(wydatki)then
        UI.expenses=wydatki
    end

    UI.open(self)
end)

addEvent("G.updateInfo", true)
addEventHandler("G.updateInfo", resourceRoot, function(info)
    UI.bank_acc=info
end)

-- useful function created by Asper

function isMouseInPosition(x, y, w, h)
	if(not isCursorShowing())then return end

	local cx,cy=getCursorPosition()
	cx,cy=cx*sw,cy*sh

    if(isCursorShowing() and (cx >= x and cx <= (x + w)) and (cy >= y and cy <= (y + h)))then
        return true
    end
    return false
end

function getPosition(myX, myY, x, y, w, h)
    if(isCursorShowing() and (myX >= x and myX <= (x + w)) and (myY >= y and myY <= (y + h)))then
        return true
    end
    return false
end

local mouseState=false
local mouseTick=getTickCount()
local mouseClicks=0
local mouseClick=false
function onClick(x, y, w, h, fnc)
    if(UI.animate)then return end
	if(not isCursorShowing())then return end

	if((getTickCount()-mouseTick) > 1000 and mouseClicks > 0)then
		mouseClicks=mouseClicks-1
	end

	if(not mouseState and getKeyState("mouse1"))then
		local cursor={getCursorPosition()}
        mouseState=cursor
    elseif(not getKeyState("mouse1") and (mouseClick or mouseState))then
        mouseClick=false
        mouseState=false
    end

    if(mouseState and mouseClicks < 10 and not mouseClick)then
		local cx,cy=unpack(mouseState)
        cx,cy=cx*sw,cy*sh

        if(getPosition(cx, cy, x, y, w, h))then
			fnc()

			mouseClicks=mouseClicks+1
            mouseTick=getTickCount()
            mouseClick=true
        end
	end
end

addEventHandler("onClientResourceStop", resourceRoot, function()
    local gui = getElementData(localPlayer, "user:gui_showed")
    if(gui and gui == source)then
        setElementData(localPlayer, "user:gui_showed", false, false)
    end
end)

-- animate

local anims = {}
local rendering = false

local function renderAnimations()
    local now = getTickCount()
    for k,v in pairs(anims) do
        v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
        if(now >= v.start+v.duration)then
            table.remove(anims, k)
			if(type(v.onEnd) == "function")then
                v.onEnd()
            end
        end
    end

    if(#anims == 0)then
        rendering = false
        removeEventHandler("onClientRender", root, renderAnimations)
    end
end

function animate(f, t, easing, duration, onChange, onEnd)
	if(#anims == 0 and not rendering)then
		addEventHandler("onClientRender", root, renderAnimations)
		rendering = true
	end

    assert(type(f) == "number", "Bad argument @ 'animate' [expected number at argument 1, got "..type(f).."]")
    assert(type(t) == "number", "Bad argument @ 'animate' [expected number at argument 2, got "..type(t).."]")
    assert(type(easing) == "string", "Bad argument @ 'animate' [Invalid easing at argument 3]")
    assert(type(duration) == "number", "Bad argument @ 'animate' [expected number at argument 4, got "..type(duration).."]")
    assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
    table.insert(anims, {from = f, to = t, easing = easing, duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})

    return #anims
end

function destroyAnimation(id)
    if(anims[id])then
        anims[id] = nil
    end
end

function convertNumber(money)
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1,%2")
	end
	return money
end

function showtime()
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second

    local monthday = time.monthday
	local month = time.month
	local year = time.year

    local formattedTime = string.format("%04d-%02d-%02d", year+1900, month + 1, monthday)
	return formattedTime
end