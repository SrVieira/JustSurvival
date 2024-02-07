theTechnique = dxCreateShader("shader.fx")
explosionTexture = dxCreateTexture( "tex/LQ.png") --change to HQ.png (supplied by default) if you want a nicer effect. "LQ" (used by default) isn't heavier than standard SA explosion.

function replaceEffect()
	engineApplyShaderToWorldTexture(theTechnique, "fireball6")
	dxSetShaderValue (theTechnique, "gTexture", explosionTexture)
end
addEventHandler("onClientResourceStart",resourceRoot,replaceEffect)