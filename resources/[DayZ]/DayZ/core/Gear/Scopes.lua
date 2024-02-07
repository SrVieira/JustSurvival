--[[
***********************************************************************************
						Multi Theft Auto DayZ
	Tipo: client
	Autores originales: Marwin W., Germany, Lower Saxony, Otterndorf
	Contribuyentes: L, CiBeR96, 1B0Y, Enargy
	
	Este modo de juego fue modificado por Enargy.
	Todos los derechos de autor reservados a sus contribuyentes
************************************************************************************
]]

local sx, sy = guiGetScreenSize()
local sniperShader = dxCreateShader("shaders/texreplace.fx")
local crosshairNormalShader = dxCreateShader("shaders/texreplace.fx")
local normalCrosshairTexture = dxCreateTexture("images/crosshair/sitem16.png")

engineApplyShaderToWorldTexture(sniperShader, "snipercrosshair")

dxSetShaderValue(crosshairNormalShader, "gTexture", normalCrosshairTexture)
engineApplyShaderToWorldTexture(crosshairNormalShader, "sitem16")

local sniperCrosshairTable = {
	{"Barret 50", "barret50.png"},
	{"G28", "g28.png"}, 
	{"Dragunov", "svd.png"},
	{"AS50", "as50.png"},
	{"Mk14-EBR", "mk14ebr.png"},
	{"M107", "m107.png"},
	{"CZ 550", "cz500.png"},
	{"PGM Hecate", "hecate.png"},
}

function drawCameraBorder() 
	if getPedWeapon(localPlayer) == 43 and getPedControlState("aim_weapon") then
		dxDrawRectangle(0, 0, sx, sy * 0.12, tocolor(0, 0, 0, 255), false)
		dxDrawRectangle(0, sy - (sy * 0.12), sx, sy * 0.12, tocolor(0, 0, 0, 255), false)
		dxDrawRectangle(0, 0, sx * 0.12, sy, tocolor(0, 0, 0, 255), false)
		dxDrawRectangle(sx - (sx * 0.12), 0, sx * 0.12, sy, tocolor(0, 0, 0, 255), false)
	end
end 

bindKey("aim_weapon", "both", function(key, state)       
    local weapon = getPedWeapon(getLocalPlayer())
    if weapon ~= 0 and weapon ~=1 then
        if state == "down" then 
            addEventHandler("onClientRender", root, drawCameraBorder)
        else
            removeEventHandler("onClientRender", root, drawCameraBorder)
			isFiring = 0
        end 
    end
end)

addEventHandler("onClientPlayerWeaponSwitch", localPlayer,
	function(_, current)
		local weap = getPedWeapon(localPlayer, current)
		
		if isElement(sniperTexture) then
			destroyElement(sniperTexture)
		end	
		
		if weap == 34 then
			for _, value in ipairs(sniperCrosshairTable) do
				local weapon = getElementData(localPlayer, "PRIMARY_Weapon")
				if weapon and weapon == value[1] then
					sniperTexture = dxCreateTexture("images/crosshair/"..value[2])
					dxSetShaderValue(sniperShader, "gTexture", sniperTexture)
					break
				end
			end
		end

		if weap == 43 then
			toggleControl("fire", false)
		else
			toggleControl("fire", true)
		end		
	end
)

function hidePlayerAttachment()
	if (getPedWeapon(localPlayer) == 34 or getPedWeapon(localPlayer) == 43) and getPedSimplestTask(localPlayer) == "TASK_SIMPLE_PLAYER_ON_FOOT" then
		if getPedControlState(localPlayer, "aim_weapon") then
			if isElement(getElementData(localPlayer, "weaponOnBack")) then
				setElementAlpha(getElementData(localPlayer, "weaponOnBack"), 0)
			end

			if isElement(getElementData(localPlayer, "weaponObjectCarry")) then
				setElementAlpha(getElementData(localPlayer, "weaponObjectCarry"), 0)
			end				
			
			if isElement(getElementData(localPlayer, "backpackObject")) then
				setElementAlpha(getElementData(localPlayer, "backpackObject"), 0)
			end
			
			if isElement(getElementData(localPlayer, "helmetObject")) then
				setElementAlpha(getElementData(localPlayer, "helmetObject"), 0)
			end
			
			if isElement(getElementData(localPlayer, "armorObject")) then
				setElementAlpha(getElementData(localPlayer, "armorObject"), 0)
			end
		else
			if isElement(getElementData(localPlayer, "weaponOnBack")) then
				setElementAlpha(getElementData(localPlayer, "weaponOnBack"), 255)
			end
			
			if isElement(getElementData(localPlayer, "weaponObjectCarry")) then
				setElementAlpha(getElementData(localPlayer, "weaponObjectCarry"), 255)
			end				
			
			if isElement(getElementData(localPlayer, "backpackObject")) then
				setElementAlpha(getElementData(localPlayer, "backpackObject"), 255)
			end
			
			if isElement(getElementData(localPlayer, "helmetObject")) then
				setElementAlpha(getElementData(localPlayer, "helmetObject"), 255)
			end
			
			if isElement(getElementData(localPlayer, "armorObject")) then
				setElementAlpha(getElementData(localPlayer, "armorObject"), 255)
			end
		end
	end
end
addEventHandler("onClientPreRender", root, hidePlayerAttachment)

function checkProjectile(hitElement) -- EVITAR QUE LOS PROYECTILES ENTREN A ZONAS DE BASES
	if isElement(hitElement) and getElementType(hitElement) == "object" and getElementData(hitElement, "projectile")and getElementData(source, "baseCol") then
		destroyElement(hitElement)
	end
end
addEventHandler("onClientColShapeHit", root, checkProjectile)