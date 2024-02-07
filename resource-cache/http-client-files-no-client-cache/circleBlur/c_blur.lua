local scx, scy = guiGetScreenSize()

Settings = {}
Settings.var = {}
Settings.var.blur = 1
Settings.var.optim = 5 -- dzieli rozdzielczość w efekcie mniejsza ilosc pixeli do renderowania (nieco psuje jakosc)
Settings.screenRectangle = {}

local current

local sw,sh=guiGetScreenSize()

local blurs={}

local mask=dxCreateTexture("circle.png", "argb", false, "clamp")
local shader=dxCreateShader("shaders/hud_mask.fx")
local rt=dxCreateRenderTarget(sw,sh,true)

myScreenSource = dxCreateScreenSource( scx/Settings.var.optim, scy/Settings.var.optim )
blurHShader,tecName = dxCreateShader( "shaders/blurH.fx" )
blurVShader,tecName = dxCreateShader( "shaders/blurV.fx" )

local off=exports.px_dashboard:getSettingState("wood_pc")
addEventHandler("onClientElementDataChange", root, function(data, last, new)
	if(data == "user:dash_settings" and source == localPlayer)then
		off=exports.px_dashboard:getSettingState("wood_pc")
		if(off)then
			removeEventHandler ("onClientHUDRender", root, preRender)
		else
			removeEventHandler ("onClientHUDRender", root, preRender)
			addEventHandler ("onClientHUDRender", root, preRender)
		end
	end
end)

function preRender ()
	if(off)then removeEventHandler ("onClientHUDRender", root, preRender) return end

	RTPool.frameStart()

	dxUpdateScreenSource( myScreenSource )
		current = myScreenSource
		current = applyGBlurH( current, Settings.var.blur )
		current = applyGBlurV( current, Settings.var.blur )
		current = applyGBlurH( current, Settings.var.blur )
		current = applyGBlurV( current, Settings.var.blur )
	dxSetRenderTarget()

	-- render blurs

	for i,v in pairs(blurs) do
		if(not v.visibled)then
			local pos_x,pos_y,size_x,size_y=unpack(v.pos)

			dxSetRenderTarget(rt, true)
				dxDrawImageSection(0, 0, size_x, size_y, pos_x/Settings.var.optim, pos_y/Settings.var.optim, size_x/Settings.var.optim, size_y/Settings.var.optim, current)
			dxSetRenderTarget()

			dxSetRenderTarget(v.rt, true)
				dxDrawImage(0, 0, sw, sh, rt)
			dxSetRenderTarget()

			dxSetShaderValue(shader, "sPicTexture", v.rt)
			dxSetShaderValue(shader, "sMaskTexture", v.mask or mask)

			dxDrawImage(pos_x, pos_y, size_x, size_y, shader, 0, 0, 0, v.color)
		end
	end
end

function createBlurCircle(x,y,w,h,color,mask)
	if(#blurs < 1)then
		removeEventHandler ("onClientHUDRender", root, preRender)
		addEventHandler ("onClientHUDRender", root, preRender)
	end

	blurs[#blurs+1]={
		rt=dxCreateRenderTarget(w,h,true),
		pos={x,y,w,h},
		color=color,
		mask=mask and dxCreateTexture(mask) or false
	}

	if(sourceResource)then
		blurs[#blurs].resource = sourceResource
		addEventHandler("onClientResourceStop", getResourceRootElement(sourceResource), function(resource)
			for i,v in pairs(blurs) do
				if(v.resource == resource)then
					destroyBlurCircle(i)
				end
			end
		end)
	end

	return #blurs
end

function visibleCircleBlur(id,state)
	if(blurs[id])then
		blurs[id].visibled=state
	end
end

function setBlurCircleColor(id, color)
	if(blurs[id])then
		blurs[id].color=color
	end
end

function setBlurPosition(id, pos)
	if(blurs[id])then
		blurs[id].pos[1]=pos[1]
		blurs[id].pos[2]=pos[2]
	end
end

function setBlurSize(id, pos)
	if(blurs[id])then
		blurs[id].pos[3]=pos[1]
		blurs[id].pos[4]=pos[2]
	end
end

function destroyBlurCircle(id)
	if(blurs[id])then
		destroyElement(blurs[id].rt)

		if(blurs[id].mask and isElement(blurs[id].mask))then
			destroyElement(blurs[id].mask)
			blurs[id].mask=nil
		end

		blurs[id]=nil

		if(#blurs < 1)then
			removeEventHandler ("onClientHUDRender", root, preRender)
		end
	end
end

-----------------------------------------------------------------------------------
-- Apply the different stages
-----------------------------------------------------------------------------------
function applyGBlurH( Src, blur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end

	dxSetRenderTarget( newRT, true )
		dxSetShaderValue( blurHShader, "TEX0", Src )
		dxSetShaderValue( blurHShader, "TEX0SIZE", mx,my )
		dxSetShaderValue( blurHShader, "BLUR", blur )
	dxDrawImage( 0, 0, mx, my, blurHShader )

	return newRT
end

function applyGBlurV( Src, blur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end

	dxSetRenderTarget( newRT, true )
		dxSetShaderValue( blurVShader, "TEX0", Src )
		dxSetShaderValue( blurVShader, "TEX0SIZE", mx,my )
		dxSetShaderValue( blurVShader, "BLUR", blur )
	dxDrawImage( 0, 0, mx,my, blurVShader )

	return newRT
end


-----------------------------------------------------------------------------------
-- Pool of render targets
-----------------------------------------------------------------------------------
RTPool = {}
RTPool.list = {}

function RTPool.frameStart()
	for rt,info in pairs(RTPool.list) do
		info.bInUse = false
	end
end

function RTPool.GetUnused( mx, my )
	-- Find unused existing
	for rt,info in pairs(RTPool.list) do
		if not info.bInUse and info.mx == mx and info.my == my then
			info.bInUse = true
			return rt
		end
	end
	-- Add new
	local rt = dxCreateRenderTarget( mx, my )
	if rt then
		RTPool.list[rt] = { bInUse = true, mx = mx, my = my }
	end
	return rt
end
