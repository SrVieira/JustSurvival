local sX, sY = guiGetScreenSize()
local visible = false
local inicio = xmlLoadFile( "Configs/inicio.xml" )
local inicio1 = xmlNodeGetValue( inicio )
local ayuda = xmlLoadFile( "Configs/ayuda.xml" )
local ayuda1 = xmlNodeGetValue( ayuda )
local reglas = xmlLoadFile( "Configs/reglas.xml" )
local reglas1 = xmlNodeGetValue( reglas )
local staff = xmlLoadFile( "Configs/staff.xml" )
local staff1 = xmlNodeGetValue( staff )
local actualizaciones = xmlLoadFile( "Configs/actualizaciones.xml" )
local actualizaciones1 = xmlNodeGetValue( actualizaciones )
local vBases = xmlLoadFile( "Configs/vBases.xml" )
local vBases1 = xmlNodeGetValue( vBases )
local sVIP = xmlLoadFile( "Configs/sVIP.xml" )
local sVIP1 = xmlNodeGetValue( sVIP )

--Colores
Color1 = tocolor(255, 255, 255, 255)
Color2 = tocolor(255, 255, 255, 255)
Color3 = tocolor(255, 255, 255, 255)
Color4 = tocolor(255, 255, 255, 255)
Color5 = tocolor(255, 255, 255, 255)
Color6 = tocolor(255, 255, 255, 255)
Color7 = tocolor(255, 255, 255, 255)


local Elementos = {
		Info = guiCreateMemo(sX*0.39, sY*0.3166666666666667, sX*0.39125, sY*0.3783333333333333, inicio1, false) ,
		Inicio = guiCreateLabel(sX*0.2171875, sY*0.3166666666666667, sX*0.165625, sY*0.0354166666666667, "Inicio", false),
		Ayuda = guiCreateLabel(sX*0.2171875, sY*0.3729166666666667, sX*0.165625, sY*0.0354166666666667, "Ayuda", false),
        Reglas = guiCreateLabel(sX*0.2171875, sY*0.4291666666666667, sX*0.165625, sY*0.0354166666666667, "Reglas", false),
		Admins = guiCreateLabel(sX*0.2171875, sY*0.4854166666666667, sX*0.165625, sY*0.0354166666666667, "Administración", false),
        Actualizaciones = guiCreateLabel(sX*0.2171875, sY*0.5416666666666667, sX*0.165625, sY*0.0354166666666667, "UPDATES", false),
        vBases = guiCreateLabel(sX*0.2171875, sY*0.5979166666666667, sX*0.165625, sY*0.0354166666666667, "Bases & Tiendas", false),
        SistemaVIP = guiCreateLabel(sX*0.2171875, sY*0.6541666666666667, sX*0.165625, sY*0.0354166666666667, "Sistema VIP y Autospriv", false)
}
       
for k, i in pairs( Elementos ) do
        guiSetVisible( i, false )
end

function imagenes()
        dxDrawImage(sX*0.2075, sY*0.1466666666666667, sX*0.58625, sY*0.7083333333333333, "Fondo.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawImage(sX*0.2171875, sY*0.6458333333333333, sX*0.165625, sY*0.05625, "Boton.png", 0, 0, 0, Color7, false)
        dxDrawImage(sX*0.2171875, sY*0.5895833333333333, sX*0.165625, sY*0.05625, "Boton.png", 0, 0, 0, Color6, false)
        dxDrawImage(sX*0.2171875, sY*0.5333333333333333, sX*0.165625, sY*0.05625, "Boton.png", 0, 0, 0, Color5, false)
        dxDrawImage(sX*0.2171875, sY*0.4770833333333333, sX*0.165625, sY*0.05625, "Boton.png", 0, 0, 0, Color4, false)
        dxDrawImage(sX*0.2171875, sY*0.4208333333333333, sX*0.165625, sY*0.05625, "Boton.png", 0, 0, 0, Color3, false)
        dxDrawImage(sX*0.2171875, sY*0.3645833333333333, sX*0.165625, sY*0.05625, "Boton.png", 0, 0, 0, Color2, false)
        dxDrawImage(sX*0.2171875, sY*0.3083333333333333, sX*0.165625, sY*0.05625, "Boton.png", 0, 0, 0, Color1, false)
end

guiLabelSetHorizontalAlign(Elementos.Inicio, "center", false)
guiLabelSetVerticalAlign(Elementos.Inicio, "center")
guiSetFont(Elementos.Inicio, "default-bold-small")
guiLabelSetHorizontalAlign(Elementos.Ayuda, "center", false)
guiLabelSetVerticalAlign(Elementos.Ayuda, "center")
guiSetFont(Elementos.Ayuda, "default-bold-small")
guiSetFont(Elementos.Reglas, "default-bold-small")
guiLabelSetHorizontalAlign(Elementos.Reglas, "center", false)
guiLabelSetVerticalAlign(Elementos.Reglas, "center")
guiSetFont(Elementos.Admins, "default-bold-small")
guiLabelSetHorizontalAlign(Elementos.Admins, "center", false)
guiLabelSetVerticalAlign(Elementos.Admins, "center")
guiSetFont(Elementos.Actualizaciones, "default-bold-small")
guiLabelSetHorizontalAlign(Elementos.Actualizaciones, "center", false)
guiLabelSetVerticalAlign(Elementos.Actualizaciones, "center")
guiSetFont(Elementos.vBases, "default-bold-small")
guiLabelSetHorizontalAlign(Elementos.vBases, "center", false)
guiLabelSetVerticalAlign(Elementos.vBases, "center")
guiSetFont(Elementos.SistemaVIP, "default-bold-small")
guiLabelSetHorizontalAlign(Elementos.SistemaVIP, "center", false)
guiLabelSetVerticalAlign(Elementos.SistemaVIP, "center")
guiSetAlpha(Elementos.Info, 0.80)
guiMemoSetReadOnly(Elementos.Info, true)

function abrir()
    bindKey("F9", "down",
        function()
                if not visible then
				addEventHandler("onClientRender", root, imagenes )
                for k, i in pairs( Elementos ) do
					guiSetVisible( i, true )
                end
                visible = true
                showCursor( true )
            else
			removeEventHandler("onClientRender", root, imagenes )
            for k, i in pairs( Elementos ) do
				guiSetVisible( i, false )
			end
            showCursor( false )
            visible = false
            end
        end
    )
end
addEventHandler("onClientResourceStart", resourceRoot, abrir)

function onGuiClick (button, state, absoluteX, absoluteY)
  if (source == Elementos.Inicio) then
	guiSetText ( Elementos.Info, inicio1 )
	elseif (source == Elementos.Ayuda) then
	guiSetText ( Elementos.Info, ayuda1 )
	elseif (source == Elementos.Reglas) then
	guiSetText ( Elementos.Info, reglas1 )
	elseif (source == Elementos.Admins) then
	guiSetText ( Elementos.Info, staff1 )
	elseif (source == Elementos.Actualizaciones) then
	guiSetText ( Elementos.Info, actualizaciones1 )
	elseif (source == Elementos.vBases) then
	guiSetText ( Elementos.Info, vBases1 )
	elseif (source == Elementos.SistemaVIP) then
	guiSetText ( Elementos.Info, sVIP1 )
  end
end
addEventHandler ("onClientGUIClick", getRootElement(), onGuiClick)

function ingresar (button, state, absoluteX, absoluteY)
  if (source == Elementos.Inicio) then
	Color1 = tocolor(100, 100, 100, 255)
	elseif (source == Elementos.Ayuda) then
	Color2 = tocolor(100, 100, 100, 255)
	elseif (source == Elementos.Reglas) then
	Color3 = tocolor(100, 100, 100, 255)
	elseif (source == Elementos.Admins) then
	Color4 = tocolor(100, 100, 100, 255)
	elseif (source == Elementos.Actualizaciones) then
	Color5 = tocolor(100, 100, 100, 255)
	elseif (source == Elementos.vBases) then
	Color6 = tocolor(100, 100, 100, 255)
	elseif (source == Elementos.SistemaVIP) then
	Color7 = tocolor(100, 100, 100, 255)
  end
end
addEventHandler ("onClientMouseEnter", getRootElement(), ingresar)

function salir (button, state, absoluteX, absoluteY)
  if (source == Elementos.Inicio) then
	Color1 = tocolor(255, 255, 255, 255)
	elseif (source == Elementos.Ayuda) then
	Color2 = tocolor(255, 255, 255, 255)
	elseif (source == Elementos.Reglas) then
	Color3 = tocolor(255, 255, 255, 255)
	elseif (source == Elementos.Admins) then
	Color4 = tocolor(255, 255, 255, 255)
	elseif (source == Elementos.Actualizaciones) then
	Color5 = tocolor(255, 255, 255, 255)
	elseif (source == Elementos.vBases) then
	Color6 = tocolor(255, 255, 255, 255)
	elseif (source == Elementos.SistemaVIP) then
	Color7 = tocolor(255, 255, 255, 255)
  end
end
addEventHandler ("onClientMouseLeave", getRootElement(), salir)