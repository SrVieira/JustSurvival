sW, sH = guiGetScreenSize()
count = 2

function dxDrawBorderedText(Texto, X, Y, W, H, Color, Escala, Fuente, PosX, PosY)
	dxDrawText(Texto, X - 4, Y - 4, W, H, tocolor(0, 0, 0, 30), Escala, Fuente, PosX, PosY, false, true, false, false, false)
	dxDrawText(Texto, X + 4, Y - 4, W, H, tocolor(0, 0, 0, 30), Escala, Fuente, PosX, PosY, false, true, false, false, false)
	dxDrawText(Texto, X - 4, Y + 4, W, H, tocolor(0, 0, 0, 30), Escala, Fuente, PosX, PosY, false, true, false, false, false)
	dxDrawText(Texto, X + 4, Y + 4, W, H, tocolor(0, 0, 0, 30), Escala, Fuente, PosX, PosY, false, true, false, false, false)
	
	dxDrawText(Texto, X - 2, Y - 2, W, H, tocolor(0, 0, 0, 80), Escala, Fuente, PosX, PosY, false, true, false, false, false)
	dxDrawText(Texto, X + 2, Y - 2, W, H, tocolor(0, 0, 0, 80), Escala, Fuente, PosX, PosY, false, true, false, false, false)
	dxDrawText(Texto, X - 2, Y + 2, W, H, tocolor(0, 0, 0, 80), Escala, Fuente, PosX, PosY, false, true, false, false, false)
	dxDrawText(Texto, X + 2, Y + 2, W, H, tocolor(0, 0, 0, 80), Escala, Fuente, PosX, PosY, false, true, false, false, false)

	dxDrawText(Texto, X, Y, W, H, Color, Escala, Fuente, PosX, PosY, false, true, false, false, false)
end

function Dibujado()
	if count == 2 then
		return
	end

	if move == "positif" then
		count = count+1
	else
		count = count-1
	end

	if count <= 100 then alpha = 255*(count/100) end

	dxDrawText("#FF0000[ADMIN] #FFFFFF" .. text1 .. "#ffffff",0,70,sW,sH,tocolor(0,255,0,alpha),2,"default-bold","center","top", false, false, false, true, false)
	dxDrawBorderedText(text,0,100,sW,sH,tocolor(255,255,255,alpha),2,"default-bold","center","top")

	if count == 500 then
		count = 100
		move = "negatif"
	end
end
addEventHandler("onClientRender", getRootElement(), Dibujado)

function preDraw(Mensaje, Jugador)
	text = Mensaje
	text1 = Jugador
	count = 3
	alpha = 0
	move = "positif"
end
addEvent('RecibirAnuncio', true)
addEventHandler('RecibirAnuncio', getRootElement(), preDraw)