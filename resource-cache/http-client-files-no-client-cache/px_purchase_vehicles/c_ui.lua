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

-- global variables

local sw,sh=guiGetScreenSize()
local zoom=1920/sw

-- exports

local blur=exports.blur
local buttons=exports.px_buttons
local scroll=exports.px_scroll
local dialogs=exports.px_dialogs

-- assets

local assets={}
assets.list={
    texs={
        "textures/window.png",
        "textures/header_icon.png",
        "textures/veh_icon.png",
        "textures/row.png",
    },

    fonts={
        {"Regular", 17},
        {"Regular", 13},
        {"SemiBold", 13},
    },
}

assets.create=function()
    assets.textures={}
    for i,v in pairs(assets.list.texs) do
        assets.textures[i]=dxCreateTexture(v, "argb", false, "clamp")
    end

    assets.fonts={}
    for i,v in pairs(assets.list.fonts) do
        assets.fonts[i]=dxCreateFont(":px_assets/fonts/Font-"..v[1]..".ttf", v[2]/zoom)
    end
end

assets.destroy=function()
    for i,v in pairs(assets.textures) do
        if(v and isElement(v))then
            destroyElement(v)
        end
    end
    assets.textures={}

    for i,v in pairs(assets.fonts) do
        if(v and isElement(v))then
            destroyElement(v)
        end
    end
    assets.fonts={}
end

-- variables

local ui={}

ui.dialog={
    ["Tomas Epman"]={
        [1]={
            text="Dzień dobry, eeeep... w czym mogę pomóc, panie kolego?",
            options={
                {text="Mam pojazd na sprzedaż.", next=4},
                {text="Czym się zajmujesz?", next=2},
                {text="Nieważne, do zobaczenia.", ended=true}, 
            },
        },

        [2]={
            text="Kurła *bek*, skupuję pojazdy, nie widać? Potem je sprzedaję trochę drożej. Potrzebujesz zastrzyku natychmiastowej gotówki?",
            options={
                {text="Po dobrych cenach skupujesz??", next=3},
                {text="Nieważne, do zobaczenia.", ended=true},
            }
        },

        [3]={
            text="Najlepszych w całym Las, eep. eep. Venturas. Mogę Ci za Twój pojazd dać 50% ceny salonowej, co mi szkodzi, niech stracę.",
            options={
                {text="No dobra, coś tam mogę sprzedać", next=4},
                {text="Nieważne, do zobaczenia.", ended=true},
            }
        },

        [4]={
            text="Który? Ten grat co stoi pod moim budynkiem?",
            options={
                {text="Rozmyśliłem się, do później.", ended=true}
            }
        },

        [5]={
            text="To podjedź pojazdem na obszar mojego budynku i zobaczymy co da się zrobić.",
            options={
                {text="Pewnie, do zobaczenia.", ended=true},
            }
        },

        [6]={
            text="Za Twój pojazd (name) (id) mogę Ci dać (cost), ep ep, umowa stoi?",
            options={
                {text="Niech będzie, stoi", next=7},
                {text="Nieważne, do zobaczenia.", ended=true},
            }
        },

        [7]={
            text="To była dobra decyzja, do następnego, panie kolego!",
            options={
                {text="Niech będzie, stoi", ended=true},
                {text="Dzięki również, do zobaczenia", ended=true},
            }
        },
    }
}

-- functions

function dialogFunction(id, index)
    local v=ui.dialog["Tomas Epman"][id].options[index]
    if(v)then
        v.fnc(id)
    end
end

function action(id,element,name)
    if(name == "Rozpocznij rozmowę")then
        local data=getElementData(element, "dialog:name")
        if(data and ui.dialog[data])then
            triggerServerEvent("get.vehicles", resourceRoot, data)
        end
    end
end

-- triggers

addEvent("set.vehicles", true)
addEventHandler("set.vehicles", resourceRoot, function(vehs, data)
    if(vehs)then
        ui.dialog["Tomas Epman"][4].options={}

        for i,v in pairs(vehs) do
            ui.dialog["Tomas Epman"][4].options[#ui.dialog["Tomas Epman"][4].options+1]={
                text=getVehicleName(v.element).." ID "..getElementData(v.element, "vehicle:id"), 
                fnc=function()
                    ui.dialog["Tomas Epman"][6].text="Za Twój pojazd "..getVehicleName(v.element).." ("..getElementData(v.element, "vehicle:id")..") mogę Ci dać "..convertNumber(v.cost).."$, ep ep, umowa stoi?"

                    ui.dialog["Tomas Epman"][6].options[1]={text="Niech będzie, stoi.", next=7, resourceName="px_purchase_vehicles", fnc=function(id)
                        triggerServerEvent("sell.vehicle", resourceRoot, v)
                    end}

                    dialogs:refreshDialog(ui.dialog[data])
                end,
                resourceName="px_purchase_vehicles",
                next=6, 
            }
        end
        ui.dialog["Tomas Epman"][4].options[#ui.dialog["Tomas Epman"][4].options+1]={text="Rozmyśliłem się, do później.", ended=true}

        ui.dialog["Tomas Epman"][1].options[1].next=4
    else
        ui.dialog["Tomas Epman"][1].options[1].next=5
    end

    dialogs:createDialog(ui.dialog, data)
end)

-- shader tablice

local vehs={}

-- create

local fonts={}
local listFonts={
    {":px_assets/fonts/Font-Medium.ttf", 22},
    {":px_assets/fonts/Font-Regular.ttf", 15},
    {":px_assets/fonts/Font-Medium.ttf", 11},
    {":px_assets/fonts/Font-Regular.ttf", 8},
    {":px_assets/fonts/Font-Medium.ttf", 10}
}

function shaderFontsCreate()
    for i,v in pairs(listFonts) do
        fonts[#fonts+1]=dxCreateFont(v[1], v[2])
    end
end

function shaderFontsDestroy()
    for i,v in pairs(fonts) do
        if(v and isElement(v))then
            destroyElement(v)
            fonts[i]=nil
        end
    end
    fonts={}
end

function createShader(v)
    local info=getElementData(v, "purchase:info")
    if(info)then
        if(#fonts < 1)then
            shaderFontsCreate()
        end

        vehs[v]={element=v,shader=dxCreateShader("shaders/shader.fx"),target=dxCreateRenderTarget(129, 231, true), info=info}

        applyShader(vehs[v])

        if(#fonts > 0)then
            shaderFontsDestroy()
        end
    end
end

function destroyShader(v)
    if(vehs[v])then
        engineRemoveShaderFromWorldTexture(vehs[v].shader, "info")
        destroyElement(vehs[v].shader)
        destroyElement(vehs[v].target)
        vehs[v]=nil
    end
end

function applyShader(v)
    local name=getVehicleName(v.element)
    dxSetRenderTarget(v.target, true)
        dxDrawRectangle(0, 0, 129, 231, tocolor(30, 30, 30))

        dxDrawText(name, 0, 5, 129, 231, tocolor(200, 200, 200, 255), 1, fonts[3], "center", "top", false)
        dxDrawRectangle(25/2, 30, 129-25, 2, tocolor(100, 100, 100))

        for i,v in pairs(v.info) do
            local sY=40*(i-1)
            dxDrawText(v[1], 0, 35+sY, 129, 228, tocolor(200, 200, 200, 255), 1, fonts[4], "center", "top", false)
            dxDrawText(v[2], 0, 50+sY, 129, 228, tocolor(200, 200, 200, 255), 1, fonts[5], "center", "top", false)
        end
    dxSetRenderTarget()

    local data=getElementData(v.element, "object")
    dxSetShaderValue(v.shader, "shader", v.target)
    engineApplyShaderToWorldTexture(v.shader, "info", data)
end

-- tutaj stojo

addEventHandler("onClientElementDataChange", root, function(data,old,new)
    if(data == "purchase:info" and new)then
        createShader(source)
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
  if(getElementType(source) == "vehicle")then
    createShader(source)
  end
end)

addEventHandler("onClientElementStreamOut", root, function()
  if(getElementType(source) == "vehicle")then
    destroyShader(source)
  end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
  for i,v in pairs(getElementsByType("vehicle", root, true)) do
    createShader(v)
  end
end)

addEventHandler("onClientRestore", root, function(clear)
    if(clear)then
      for i,v in pairs(getElementsByType("vehicle", root, true)) do
        createShader(v)
      end
  end
end)

addEventHandler("onClientElementDestroy", resourceRoot, function()
    destroyShader(source)
end)

--

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

setObjectBreakable(resourceRoot, false)