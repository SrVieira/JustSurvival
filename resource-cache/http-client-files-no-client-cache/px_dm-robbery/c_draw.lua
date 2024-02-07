--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

Robbery.DrawStart=function()
    local MP={getElementPosition(localPlayer)}
    local dist=getDistanceBetweenPoints3D(MP[1], MP[2], MP[3], Robbery.Position[1], Robbery.Position[2], Robbery.Position[3])
    if(dist <= 30)then
        local tickTime=(getTickCount()-Robbery.Tick)/1000
        local time=(Robbery.Time*60)-tickTime
        local min=time/60
        local sec=time%60
        local textTime=math.floor(min)..":"..string.format("%02d", math.floor(sec))
        local progress=100-(100*(time/(Robbery.Time*60)))

        Robbery.GetMoney=math.floor(Robbery.MaxMoney*(tickTime/(Robbery.Time*60)))

        dxDrawImage(sw/2-403/zoom,0, 403/zoom, 103/zoom, assets.textures[1], 0, 0, 0, tocolor(255,255,255,Robbery.Siren and 255 or 0))
        dxDrawImage(sw/2,0, 403/zoom, 103/zoom, assets.textures[2], 0, 0, 0, tocolor(255,255,255,not Robbery.Siren and 255 or 0))

        dxDrawImage(sw/2-494/2/zoom, 0, 494/zoom, 76/zoom, assets.textures[3])

        local r,g,b=interpolateBetween(168,77,78,137,137,137,((100-progress)/100),"Linear")
        local x,y,w=getCirclePosition(sw/2-88/2/zoom, 0-88/2/zoom, 88/zoom)
        local color=tocolor(r,g,b)
        if(progress > 50)then
            local k=((progress-50)/50)
            dxDrawCircle(x,y,w,90+90*k,180,color)
        else
            dxDrawCircle(x,y,w,90,180,color)
            dxDrawCircle(x,y,w,90*(progress/50),90,color)
        end

        dxDrawShadowText("N A P A D", 0, 85/zoom, sw, 0, tocolor(200,200,200), 1, assets.fonts[1], "center", "top")

        dxDrawShadowText("Pozostały czas", 0, 10/zoom, sw/2-80/zoom, 0, tocolor(200,200,200), 1, assets.fonts[2], "right", "top")
        dxDrawShadowText(textTime, 0, 30/zoom, sw/2-80/zoom, 0, tocolor(200,200,200), 1, assets.fonts[1], "right", "top")

        dxDrawShadowText("Zdobyte pieniądze", sw/2+88/zoom, 10/zoom, 0, 0, tocolor(200,200,200), 1, assets.fonts[2], "left", "top")
        dxDrawShadowText("$ "..math.floor(Robbery.GetMoney), sw/2+88/zoom, 30/zoom, 0, 0, tocolor(200,200,200), 1, assets.fonts[1], "left", "top")

        if(math.floor(min) == 0 and math.floor(sec) == 0)then
            exports.px_noti:noti("Pomyślnie udało Ci się zrealizować napad, udało Ci się ukraść: $"..Robbery.GetMoney..".", "success")

            Robbery.Stop(true)

            Robbery.EndedType="Success"
        end
    else
		Robbery.Stop()
		exports.px_noti:noti("Oddaliłeś się na więcej niż 30 metrów od stacji paliw. Napad zostaje przerwany.", "error")
    end
end

-- screens

Robbery.DrawEnd=function()
	blur:dxDrawBlur(0,0,sw,sh,tocolor(255,255,255,Robbery.MainAlpha))

	if((getTickCount()-Robbery.StartTickAnim) > Robbery.TimeAnim and not Robbery.Anim)then
		Robbery.Anim=true
		Robbery.TickAnim=getTickCount()
	end

	local y=sh/2-168/2/zoom
	local a=0
	if(Robbery.Anim)then
		a=interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount()-Robbery.TickAnim)/Robbery.TimeAnim, "Linear")
		y=interpolateBetween(sh/2-168/2/zoom, 0, 0, sh/2-168/2/zoom-215/zoom, 0, 0, (getTickCount()-Robbery.TickAnim)/Robbery.TimeAnim, "OutBack")
	end

	if(Robbery.EndedType == "Success")then
		dxDrawImage(0, 0, sw, sh, assets.textures[6], 0, 0, 0, tocolor(255,255,255,Robbery.MainAlpha))
		dxDrawImage(0, y, sw, 168, assets.textures[7], 0, 0, 0, tocolor(255,255,255,Robbery.MainAlpha))
	else
		dxDrawImage(0, 0, sw, sh, assets.textures[4], 0, 0, 0, tocolor(255,255,255,Robbery.MainAlpha))
		dxDrawImage(0, y, sw, 168, assets.textures[5], 0, 0, 0, tocolor(255,255,255,Robbery.MainAlpha))
	end

	if(Robbery.Anim)then
        a=a > Robbery.MainAlpha and Robbery.MainAlpha or a

		dxDrawImage(sw/2-303/2/zoom, sh-255/zoom, 303/zoom, 29/zoom, assets.textures[8], 0, 0, 0, tocolor(255,255,255,a))

        dxDrawText("Czas napadu", sw/2-191/zoom, sh/2-96/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[3], "left", "top")
        dxDrawText(Robbery.EndedInfo.time, sw/2-191/zoom, sh/2-63/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[4], "left", "top")

        dxDrawText("Zabite osoby", sw/2-191/zoom, sh/2+7/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[3], "left", "top")
        dxDrawText(Robbery.EndedInfo.players, sw/2-191/zoom, sh/2+35/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[4], "left", "top")

        dxDrawText("Zadany DM", sw/2-191/zoom, sh/2+102/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[3], "left", "top")
        dxDrawText(math.floor(Robbery.EndedInfo.myDM), sw/2-191/zoom, sh/2+132/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[4], "left", "top")

        dxDrawText((Robbery.EndedType == "Success" and "Zdobyty łup" or "Utracony łup"), sw/2+74/zoom, sh/2-96/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[3], "left", "top")
        dxDrawText("$ "..math.floor(Robbery.GetMoney), sw/2+74/zoom, sh/2-63/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[4], "left", "top")

        dxDrawText("Respekt", sw/2+74/zoom, sh/2+7/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[3], "left", "top")
        dxDrawText((Robbery.EndedType == "Success" and "+" or "-").." "..Robbery.EndedInfo.respect, sw/2+74/zoom, sh/2+35/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[4], "left", "top")

        dxDrawText("Otrzymany DM", sw/2+74/zoom, sh/2+102/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[3], "left", "top")
        dxDrawText(math.floor(Robbery.EndedInfo.dm), sw/2+74/zoom, sh/2+132/zoom, 0, 0, tocolor(200, 200, 200, a), 1, assets.fonts[4], "left", "top")
	end
end

Robbery.OnKey=function(button, press)
    if(not press)then return end

    if(button == "space")then
        if(Robbery.AlphaAnimate)then
            destroyAnimation(Robbery.AlphaAnimate)
        end
        
        Robbery.AlphaAnimate=animate(Robbery.MainAlpha, 0, "Linear", 500, function(a)
            Robbery.MainAlpha=a
        end,function()
            removeEventHandler("onClientKey", root, Robbery.OnKey)
            removeEventHandler("onClientRender", root, Robbery.DrawEnd)
            assets.destroy()

            Robbery.AlphaAnimate=false

            setElementData(localPlayer, "user:hud_disabled", false, false)
        end)
    end
end