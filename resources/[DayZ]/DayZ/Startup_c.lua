addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local shader1 = dxCreateShader("shaders/texreplace.fx")
		local shader2 = dxCreateShader("shaders/texreplace.fx")
		local shader3 = dxCreateShader("shaders/texreplace.fx")
		local shader4 = dxCreateShader("shaders/texreplace.fx")
		local shader5 = dxCreateShader("shaders/texreplace.fx")

		local texture1 = dxCreateTexture("images/misc/clean.png")
		local texture2 = dxCreateTexture("images/misc/clean.png")
		local texture3 = dxCreateTexture("images/misc/clean.png")
		local texture4 = dxCreateTexture("images/misc/clean.png")
		local texture5 = dxCreateTexture("images/misc/clean.png")

		dxSetShaderValue(shader1, "gTexture", texture1)
		dxSetShaderValue(shader2, "gTexture", texture2)
		dxSetShaderValue(shader3, "gTexture", texture3)
		dxSetShaderValue(shader4, "gTexture", texture4)
		dxSetShaderValue(shader5, "gTexture", texture5)

		engineApplyShaderToWorldTexture(shader1, "coronareflect")
		engineApplyShaderToWorldTexture(shader2, "coronaringa")
		engineApplyShaderToWorldTexture(shader3, "coronaringb")
		engineApplyShaderToWorldTexture(shader4, "coronastar")
		engineApplyShaderToWorldTexture(shader5, "shad_exp")
	end
)

addEventHandler("onClientPlayerChangeNick", localPlayer,
	function()
		cancelEvent()
	end
)