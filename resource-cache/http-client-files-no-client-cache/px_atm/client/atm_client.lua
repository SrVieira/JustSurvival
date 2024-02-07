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

-- variables

local sw, sh = guiGetScreenSize()
local zoom = 1920/sw

local blur=exports.blur
local noti=exports.px_noti

ATM = {}

ATM.fnts = {
	{":px_assets/fonts/Font-Bold.ttf", 30/zoom},
	{":px_assets/fonts/Font-SemiBold.ttf", 12/zoom},
	{":px_assets/fonts/Font-SemiBold.ttf", 9/zoom},
	{":px_assets/fonts/Font-SemiBold.ttf", 15/zoom},
}

ATM.FONTS = {}

ATM.textures = {
	"assets/images/window.png",

	"assets/images/screen_back.png",
	"assets/images/screen.png",

	"assets/images/arrow_button.png",

	"assets/images/wsuwak_hajs.png",

	"assets/images/keys.png",
	"assets/images/action_button.png",

	"assets/images/cancel.png",
	"assets/images/back.png",
	"assets/images/accept.png",

	"assets/images/atm.png",
	"assets/images/wychodzi.png",
	"assets/images/karta_wrzuc.png",
	"assets/images/wallet.png",
	"assets/images/card.png",
	"assets/images/money.png",
}

ATM.img = {}
ATM.ATM_MONEY = ""
ATM.alpha = 0
ATM.animate = false
ATM.numbers=0
ATM.tick = getTickCount()
ATM.shape = false
ATM.transactions=""
ATM.window=false
ATM.card={0,0}
ATM.cards=false
ATM.checkCard=true
ATM.target=dxCreateRenderTarget(100/zoom,150/zoom,true)
ATM.wloz=false
ATM.ticked=getTickCount()
ATM.pin=""

-- creating, update ATM money

ATM.UPDATE_ATM_MONEY = function(ATM_money)
	if tonumber(ATM_money) then
		ATM.ATM_MONEY = ATM_money
	end
end
addEvent("ATM.UPDATE_ATM_MONEY", true)
addEventHandler("ATM.UPDATE_ATM_MONEY", resourceRoot, ATM.UPDATE_ATM_MONEY)

ATM.CREATE_GUI = function(type, shape, transactions, pin)
	if(type == "HIT" and not getElementData(localPlayer, "user:gui_showed") and not ATM.animate)then
		if(getElementData(localPlayer, "user:gui_showed"))then return end

		blur=exports.blur
		noti=exports.px_noti

		ATM.transactions=transactions
		ATM.card={sw/2+165/zoom+(112-46)/2/zoom, sh/2+150/zoom}
		ATM.shape = shape
		ATM.cards=false
		ATM.checkCard=true
		ATM.target=dxCreateRenderTarget(100/zoom,150/zoom,true)
		ATM.wloz=false
		ATM.ticked=getTickCount()
		ATM.pin=pin
		ATM.numbers=0

		setElementData(localPlayer, "user:gui_showed", true, false)

		for i,v	in pairs(ATM.fnts) do
			ATM.FONTS[i] = dxCreateFont(v[1], v[2])
		end

		for i,v in pairs(ATM.textures) do
			ATM.img[i] = dxCreateTexture(v, "argb", false, "clamp")
		end

		addEventHandler("onClientRender", root, ATM.DRAW_UI)

		showCursor(true)

		ATM.animate = true
		animate(ATM.alpha, 255, "InQuad", 500, function(a)
			ATM.alpha = a
		end, function()
			ATM.animate = false
		end)

		ATM.window=false
	elseif(type == "LEAVE" and not ATM.animate)then
		showCursor(false)

		ATM.animate = true
		animate(ATM.alpha, 0, "InQuad", 500, function(a)
			ATM.alpha = a
		end, function()
			ATM.animate = false

			setElementData(localPlayer, "user:gui_showed", false, false)

			removeEventHandler("onClientRender", root, ATM.DRAW_UI)

			for i,v in pairs(ATM.img) do
				checkAndDestroy(v)
			end

			for i,v in pairs(ATM.FONTS) do
				checkAndDestroy(v)
			end
		end)
	end
end
addEvent("ATM.CREATE_GUI", true)
addEventHandler("ATM.CREATE_GUI", resourceRoot, ATM.CREATE_GUI)

-- drawing

local tbl={}
for i=1,4 do
	table.insert(tbl, {list=1})
end
for i=1,4 do
	table.insert(tbl, {list=2})
end
for i=1,4 do
	table.insert(tbl, {list=3})
end

ATM.screenClick=function(id)
	if(not ATM.window)then
		if(id == 1)then
			ATM.window="wyplac"
			ATM.numbers=0
		elseif(id == 2)then
			ATM.window="wplac"
			ATM.numbers=0
		elseif(id == 3)then
			ATM.window="stan"
			ATM.numbers=0
		elseif(id == 5)then
			ATM.window="historia"
			ATM.numbers=0
		elseif(id == 6)then
			ATM.window="zmiana"
			ATM.numbers=0
		elseif(id == 7)then
			ATM.CREATE_GUI("LEAVE")
		end
	elseif(ATM.window == "wyplac")then
		if(id == 4)then
			ATM.window=false
		elseif(id == 8)then
			if(SPAM.getSpam())then return end

			triggerServerEvent("ATM.ACTIONS", resourceRoot, "withdraw", ATM.numbers)
		end
	elseif(ATM.window == "wplac")then
		if(id == 4)then
			ATM.window=false
		elseif(id == 8)then
			if(SPAM.getSpam())then return end

			triggerServerEvent("ATM.ACTIONS", resourceRoot, "deposit", ATM.numbers)
		end
	elseif(ATM.window == "stan")then
		if(id == 4)then
			ATM.window=false
		end
	elseif(ATM.window == "historia")then
		if(id == 4)then
			ATM.window=false
		end
	elseif(ATM.window == "zmiana")then
		if(id == 4)then
			ATM.window=false
		elseif(id == 8)then
			if(SPAM.getSpam())then return end

			if(tonumber(ATM.numbers) == tonumber(ATM.pin))then
				noti:noti("Podany PIN jest taki sam.", "error")
			elseif(#tostring(ATM.numbers) == 4)then
				triggerServerEvent("zmien.pin", resourceRoot, ATM.numbers)
			else
				noti:noti("Kod PIN musi zawierać 4 znaki.", "info")
			end
		end
	end
end

ATM.DRAW_UI = function()
	if(ATM.shape)then
		if(getElementType(ATM.shape) == "colshape" and not isElementWithinColShape(localPlayer, ATM.shape))then
			ATM.CREATE_GUI("LEAVE")
		elseif(getElementType(ATM.shape) == "marker" and not isElementWithinMarker(localPlayer, ATM.shape))then
			ATM.CREATE_GUI("LEAVE")
		end
	end

	blur:dxDrawBlur(sw/2-584/2/zoom, sh/2-596/2/zoom, 584/zoom, 596/zoom, tocolor(200, 200, 200, ATM.alpha), false)
	dxDrawImage(sw/2-584/2/zoom, sh/2-596/2/zoom, 584/zoom, 596/zoom, ATM.img[1], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)

	-- screen background
	dxDrawImage(sw/2-411/2/zoom-56/zoom, sh/2-255/zoom, 411/zoom, 373/zoom, ATM.img[2], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)

	-- logo bankomatu
	dxDrawImage(sw/2-411/2/zoom-56/zoom+(411-208)/2/zoom, sh/2-255/zoom+9/zoom, 208/zoom, 58/zoom, ATM.img[11], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)
	dxDrawText("ATM", sw/2-411/2/zoom-56/zoom+(411-208)/2/zoom, sh/2-255/zoom+9/zoom, 208/zoom+sw/2-411/2/zoom-56/zoom+(411-208)/2/zoom, 58/zoom+sh/2-255/zoom+9/zoom, tocolor(102, 166, 255, ATM.alpha), 1, ATM.FONTS[1], "center", "center")

	-- ekran
	dxDrawImage(sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom, 292/zoom, 233/zoom, ATM.img[3], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)

	-- przyciski lewo
	for i=1,4 do
		local sY=(44/zoom)*(i-1)
		dxDrawImage(sw/2-411/2/zoom-56/zoom+13/zoom, sh/2-596/2/zoom+155/zoom+sY, 42/zoom, 31/zoom, ATM.img[4], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)

		onClick(sw/2-411/2/zoom-56/zoom+13/zoom, sh/2-596/2/zoom+155/zoom+sY, 42/zoom, 31/zoom, function()
			ATM.screenClick(i)
		end)
	end

	-- przyciski prawo
	local x=0
	for i=4,7 do
		x=x+1

		local sY=(44/zoom)*(x-1)
		dxDrawImage(sw/2-411/2/zoom-56/zoom+355/zoom, sh/2-596/2/zoom+155/zoom+sY, 42/zoom, 31/zoom, ATM.img[4], 180, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)

		onClick(sw/2-411/2/zoom-56/zoom+355/zoom, sh/2-596/2/zoom+155/zoom+sY, 42/zoom, 31/zoom, function()
			ATM.screenClick((i+1))
		end)
	end

	-- wsuwak na hajs
	dxDrawImage(sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom+(292-256)/2/zoom, sh/2-596/2/zoom+365/zoom, 256/zoom, 34/zoom, ATM.img[5], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)
	dxDrawImage(sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom+(292-256)/2/zoom+(256-140)/2/zoom, sh/2-596/2/zoom+365/zoom+15/zoom, 140/zoom, 42/zoom, ATM.img[16], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)

	-- przyciski background
	dxDrawImage(sw/2-411/2/zoom-56/zoom, sh/2+135/zoom, 411/zoom, 134/zoom, ATM.img[6], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)

	for i,v in pairs(tbl) do
		local sX=0
		local sY=0
		local x=i
		local xx=0
		if(v.list == 1)then
			sX=(54/zoom)*(i-1)
			xx=8
		elseif(v.list == 2)then
			sX=(54/zoom)*(i-5)
			sY=33/zoom
			x=i-4
			xx=9
		elseif(v.list == 3)then
			sX=(54/zoom)*(i-9)
			sY=68/zoom
			x=x-8
			xx=7
		end

		if(x > 3)then
			dxDrawImage(sw/2-411/2/zoom+38/zoom+sX, sh/2+152/zoom+sY, 55/zoom, 31/zoom, ATM.img[xx], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)
			if(xx == 7)then
				dxDrawImage(sw/2-411/2/zoom+38/zoom+sX, sh/2+152/zoom+sY, 55/zoom, 31/zoom, ATM.img[7], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)
				dxDrawText("0", sw/2-411/2/zoom+38/zoom+sX, sh/2+152/zoom+sY, 55/zoom+sw/2-411/2/zoom+38/zoom+sX, 31/zoom+sh/2+152/zoom+sY, tocolor(77, 77, 77, ATM.alpha), 1, ATM.FONTS[2], "center", "center")

				onClick(sw/2-411/2/zoom+38/zoom+sX, sh/2+152/zoom+sY, 55/zoom, 31/zoom, function()
					if(tonumber(ATM.numbers) > 0)then
						ATM.numbers=ATM.numbers.."0"
					end
				end)
			else
				onClick(sw/2-411/2/zoom+38/zoom+sX, sh/2+152/zoom+sY, 55/zoom, 31/zoom, function()
					if(xx == 9)then
						ATM.numbers=string.sub(ATM.numbers, 1, string.len(ATM.numbers)-1)
						if(ATM.numbers == "")then
							ATM.numbers=0
						end
					elseif(xx == 8 and string.len(ATM.numbers) > 1)then
						ATM.numbers=0
					end
				end)
			end
		else
			dxDrawImage(sw/2-411/2/zoom+38/zoom+sX, sh/2+152/zoom+sY, 55/zoom, 31/zoom, ATM.img[7], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)
			dxDrawText(i > 7 and i-2 or i > 4 and i-1 or i, sw/2-411/2/zoom+38/zoom+sX, sh/2+152/zoom+sY, 55/zoom+sw/2-411/2/zoom+38/zoom+sX, 31/zoom+sh/2+152/zoom+sY, tocolor(77, 77, 77, ATM.alpha), 1, ATM.FONTS[2], "center", "center")

			onClick(sw/2-411/2/zoom+38/zoom+sX, sh/2+152/zoom+sY, 55/zoom, 31/zoom, function()
				if(ATM.numbers == 0)then
					ATM.numbers=i > 7 and i-2 or i > 4 and i-1 or i
				else
					if(string.len(ATM.numbers) < 9)then
						ATM.numbers=ATM.numbers..(i > 7 and i-2 or i > 4 and i-1 or i)
					end
				end
			end)
		end
	end

	-- prawa strona

	-- wysuwak na hajs
	dxDrawImage(sw/2+165/zoom, sh/2-150/zoom, 101/zoom, 86/zoom, ATM.img[12], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)

	-- wsuwak na karte
	dxDrawImage(sw/2+165/zoom, sh/2+5/zoom, 101/zoom, 66/zoom, ATM.img[13], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)

	-- karta
	if(ATM.checkCard and not ATM.wloz)then
		local cX,cY=getCursorPosition()
		cX,cY=cX*sw,cY*sh

		if(ATM.cards)then
			if(not getKeyState("mouse1"))then
				ATM.cards=false
			else
				ATM.card={cX-(46/2)/zoom,cY-(62/2)/zoom}

				if(ATM.card[1] >= sw/2+165/zoom and ATM.card[2] >= sh/2+5/zoom and ATM.card[1] <= sw/2+165/zoom+101/zoom and ATM.card[2] <= sh/2+5/zoom+66/zoom)then
					ATM.wloz=true
					ATM.ticked=getTickCount()
				end
			end
		end

		if(isMouseInPosition(ATM.card[1], ATM.card[2], 46/zoom, 62/zoom) and getKeyState("mouse1") and not ATM.cards)then
			ATM.cards=true
		end

		dxDrawImage(ATM.card[1], ATM.card[2], 46/zoom, 62/zoom, ATM.img[15], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)
	elseif(ATM.wloz)then
		local y=interpolateBetween(0, 0, 0, -62/zoom, 0, 0, (getTickCount()-ATM.ticked)/1000, "Linear")
		dxSetRenderTarget(ATM.target, true)
			dxDrawImage(0, y, 46/zoom, 62/zoom, ATM.img[15], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)
		dxSetRenderTarget()
		dxDrawImage(sw/2+165/zoom+(100-46)/2/zoom, sh/2+40/zoom, 100/zoom, 150/zoom, ATM.target)

		if((getTickCount()-ATM.ticked) > 1000)then
			ATM.checkCard=false
			ATM.wloz=false
			destroyElement(ATM.target)
		end
	end

	-- portfel
	dxDrawImage(sw/2+165/zoom, sh/2+170/zoom, 112/zoom, 97/zoom, ATM.img[14], 0, 0, 0, tocolor(255, 255, 255, ATM.alpha), false)

	-- zakladki
	if(ATM.checkCard)then
		dxDrawText("Włóż karte", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+100/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "center", "top")
		dxDrawText("do czytnika", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+120/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(200, 200, 200, ATM.alpha), 1, ATM.FONTS[3], "center", "top")
	elseif(ATM.window == "wyplac")then
		dxDrawText("Wpisz kwotę jaką chcesz wypłacić", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+70/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "center", "top")

		dxDrawText(convertNumber(ATM.numbers).."$", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+115/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(200, 200, 200, ATM.alpha), 1, ATM.FONTS[4], "center", "top")

		local i=4
		local sY=(44/zoom)*(i-1)
		dxDrawRectangle(sw/2-411/2/zoom-56/zoom+13/zoom+70/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom, tocolor(225, 225, 225, ATM.alpha), false)
		dxDrawText("Cofnij", sw/2-411/2/zoom-56/zoom+13/zoom+90/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom+sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "left", "center")

		local x=4
		local sY=(44/zoom)*(x-1)
		dxDrawRectangle(sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom, tocolor(225, 225, 225, ATM.alpha), false)
		dxDrawText("Zatwierdź", sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom-20/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom-10/zoom, 3/zoom+sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "right", "center")
	elseif(ATM.window == "wplac")then
		dxDrawText("Wpisz kwotę jaką chcesz wpłacić", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+70/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "center", "top")

		dxDrawText(convertNumber(ATM.numbers).."$", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+115/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(200, 200, 200, ATM.alpha), 1, ATM.FONTS[4], "center", "top")

		local i=4
		local sY=(44/zoom)*(i-1)
		dxDrawRectangle(sw/2-411/2/zoom-56/zoom+13/zoom+70/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom, tocolor(225, 225, 225, ATM.alpha), false)
		dxDrawText("Cofnij", sw/2-411/2/zoom-56/zoom+13/zoom+90/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom+sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "left", "center")

		local x=4
		local sY=(44/zoom)*(x-1)
		dxDrawRectangle(sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom, tocolor(225, 225, 225, ATM.alpha), false)
		dxDrawText("Zatwierdź", sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom-20/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom-10/zoom, 3/zoom+sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "right", "center")
	elseif(ATM.window == "stan")then
		dxDrawText("Stan Twojego konta bankowego", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+70/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "center", "top")
		dxDrawText(showtime(), sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+90/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(200, 200, 200, ATM.alpha), 1, ATM.FONTS[3], "center", "top")

		dxDrawText(convertNumber(ATM.ATM_MONEY).."$", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+115/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(200, 200, 200, ATM.alpha), 1, ATM.FONTS[4], "center", "top")

		local i=4
		local sY=(44/zoom)*(i-1)
		dxDrawRectangle(sw/2-411/2/zoom-56/zoom+13/zoom+70/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom, tocolor(225, 225, 225, ATM.alpha), false)
		dxDrawText("Cofnij", sw/2-411/2/zoom-56/zoom+13/zoom+90/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom+sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "left", "center")
	elseif(ATM.window == "historia")then
		dxDrawText("Historia transakcji Twojego konta", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+40/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "center", "top")
		dxDrawText("Do dnia dzisiejszego", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+60/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(200, 200, 200, ATM.alpha), 1, ATM.FONTS[3], "center", "top")

		dxDrawText(ATM.transactions, sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+85/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(200, 200, 200, ATM.alpha), 1, ATM.FONTS[3], "center", "top")

		local i=4
		local sY=(44/zoom)*(i-1)
		dxDrawRectangle(sw/2-411/2/zoom-56/zoom+13/zoom+70/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom, tocolor(225, 225, 225, ATM.alpha), false)
		dxDrawText("Cofnij", sw/2-411/2/zoom-56/zoom+13/zoom+90/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom+sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "left", "center")
	elseif(ATM.window == "zmiana")then
		dxDrawText("Podaj nowy kod PIN", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+70/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "center", "top")
		dxDrawText("do konta bankowego", sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+90/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(200, 200, 200, ATM.alpha), 1, ATM.FONTS[3], "center", "top")

		dxDrawText(ATM.numbers, sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, sh/2-596/2/zoom+120/zoom+115/zoom, 292/zoom+sw/2-411/2/zoom-56/zoom+(411-292)/2/zoom, 233/zoom, tocolor(200, 200, 200, ATM.alpha), 1, ATM.FONTS[4], "center", "top")

		local i=4
		local sY=(44/zoom)*(i-1)
		dxDrawRectangle(sw/2-411/2/zoom-56/zoom+13/zoom+70/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom, tocolor(225, 225, 225, ATM.alpha), false)
		dxDrawText("Cofnij", sw/2-411/2/zoom-56/zoom+13/zoom+90/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom+sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "left", "center")

		local x=4
		local sY=(44/zoom)*(x-1)
		dxDrawRectangle(sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom, tocolor(225, 225, 225, ATM.alpha), false)
		dxDrawText("Zatwierdź", sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom-20/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom-10/zoom, 3/zoom+sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "right", "center")
	else
		-- przyciski lewo
		for i=1,3 do
			local sY=(44/zoom)*(i-1)
			local text=i == 1 and "Wypłać gotówke" or i == 2 and "Wpłać gotówke" or i == 3 and "Sprawdź stan konta"
			dxDrawRectangle(sw/2-411/2/zoom-56/zoom+13/zoom+70/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom, tocolor(225, 225, 225, ATM.alpha), false)
			dxDrawText(text, sw/2-411/2/zoom-56/zoom+13/zoom+90/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom+sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "left", "center")
		end

		-- przyciski prawo
		local x=0
		for i=4,6 do
			x=x+1

			local sY=(44/zoom)*(x-1)
			local text=i == 4 and "Historia transakcji" or i == 5 and "Zmiana PIN" or i == 6 and "Wyciągnij karte"
			dxDrawRectangle(sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, 9/zoom, 3/zoom, tocolor(225, 225, 225, ATM.alpha), false)
			dxDrawText(text, sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom-20/zoom, sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, sw/2-411/2/zoom-56/zoom+355/zoom-35/zoom-10/zoom, 3/zoom+sh/2-596/2/zoom+155/zoom+sY+(31-3)/2/zoom, tocolor(225, 225, 225, ATM.alpha), 1, ATM.FONTS[3], "right", "center")
		end
	end
end

-- click button


ATM.CLICK = function(button, state)
    if(button == "left" and state == "down") then
		if(SPAM.getSpam())then return end

    	if isMouseInPosition(sw/2+200/zoom, sh/2+140/zoom, 175/zoom, 50/zoom) then -- deposit (wpłata)
			triggerServerEvent("ATM.ACTIONS", resourceRoot, "deposit", ATM.numbers)
    	elseif isMouseInPosition(sw/2+200/zoom, sh/2+200/zoom, 175/zoom, 50/zoom) then -- withdraw (wypłata)
			triggerServerEvent("ATM.ACTIONS", resourceRoot, "withdraw", ATM.numbers)
    	end
    end
end

-- anty breakable

setObjectBreakable(resourceRoot, false)

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

			playSound("assets/sounds/click.mp3")

			mouseClicks=mouseClicks+1
            mouseTick=getTickCount()
            mouseClick=true
        end
	end
end

-- useful

function checkAndDestroy(element)
	if(element and isElement(element))then
		destroyElement(element)
	end
end

function convertNumber ( number )
	local formatted = number
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if ( k==0 ) then
			break
		end
	end
	return formatted
end

function showtime ()
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second

    local monthday = time.monthday
	local month = time.month
	local year = time.year

    local formattedTime = string.format("%04d-%02d-%02d", year + 1900, month + 1, monthday)

	return formattedTime
end

-- on stop

addEventHandler("onClientResourceStop", resourceRoot, function()
    local gui = getElementData(localPlayer, "user:gui_showed")
    if(gui and gui == source)then
        setElementData(localPlayer, "user:gui_showed", false, false)
    end
end)

setElementData(localPlayer, "user:gui_showed", false, false)

-- trigger

addEvent("playSound3D", true)
addEventHandler("playSound3D", resourceRoot, function(x, y, z)
	local sound=playSound3D("assets/sounds/ATM_3D.mp3", x, y, z)
	setSoundMaxDistance(sound, 5)
end)