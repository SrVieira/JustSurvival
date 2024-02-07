-- 
-- main.lua
--

local scx, scy=guiGetScreenSize()

local wallShader=false

local color={67/255,149/255,82/255,1}
local linePower=5

local myRT=false
local myShader=false

local obj=false
local effect=false

function preRender()
	if(not effect)then return end

	dxSetRenderTarget(myRT, true)
	dxSetRenderTarget()

	dxDrawImage(0, 0, scx, scy, myShader, 0, 0, 0, tocolor(255, 255, 255, 255))
end

function startWall(toggle, element)
	if(toggle)then
		if(not obj)then
			obj=element
			effect=true
			myRT = dxCreateRenderTarget(scx, scy, true)

			myShader = dxCreateShader("assets/fx/post_edge.fx")
			dxSetShaderValue(myShader, "sTex0", myRT)
			dxSetShaderValue(myShader, "sRes", scx, scy)

			wallShader=dxCreateShader("assets/fx/ped_wall_mrt.fx", 1, 0, true, "all")
			dxSetShaderValue(wallShader, "secondRT", myRT)
			dxSetShaderValue(wallShader, "sColorizePed", color)
			dxSetShaderValue(wallShader, "sSpecularPower", linePower)
		
			engineApplyShaderToWorldTexture(wallShader, "*", obj)

			addEventHandler("onClientPreRender", root, preRender)
		end
	else
		removeEventHandler("onClientPreRender", root, preRender)

		if(wallShader and isElement(wallShader))then
			engineRemoveShaderFromWorldTexture(wallShader, "*", obj)
	
			destroyElement(wallShader)
			wallShader=false
		end

		if(myRT and isElement(myRT))then
			destroyElement(myRT)
			myRT=false
		end

		if(myShader and isElement(myShader))then
			destroyElement(myShader)
			myShader=false
		end

		effect=false
		obj=false
	end
end