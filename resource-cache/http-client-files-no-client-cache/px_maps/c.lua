--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

Async:setPriority("normal")

local shaderStr = [[
texture gTexture;

technique TexReplace
{
    pass P0
    {
        Texture[0] = gTexture;
    }
}]]

local modelsTextures = {
	[3578] = dxCreateTexture("textures/lasdockbar.png", "dxt5", true, "clamp"),
}

function requestLODsClient()
	triggerLatentServerEvent("requestLODsClient", resourceRoot)
end

function setLODsClient(lodTbl)
	Async:foreach(lodTbl, function(model)
		engineSetModelLODDistance(model, 300)
	end)

	Async:foreach(getElementsByType("object", resourceRoot), function(obj)
		local model = getElementModel(obj)
		if( modelsTextures[model] )then
			local shader = dxCreateShader(shaderStr)
			dxSetShaderValue(shader, "gTexture", modelsTextures[model])
			engineApplyShaderToWorldTexture(shader, "*", obj)
		end
	end)	
end

function applyBreakableState()
	Async:foreach(getElementsByType("object", resourceRoot), function(obj)
		local breakable = getElementData(obj, "breakable")
		if breakable then
			setObjectBreakable(obj, breakable == "true")
		end
	end)
end

requestLODsClient()
applyBreakableState()

addEvent("setLODsClient", true)
addEventHandler("setLODsClient", resourceRoot, setLODsClient)