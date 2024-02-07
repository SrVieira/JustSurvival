local resourceNames = {
	"textures",
	"dzprivatevehicles",
	"dzairdrop",
	"dzatmosphere",
	"dzchat",
	"dzchoptree",
	"dzladder",
	"dzlogin",
	"dzslothbot",
	"dztopranking",
	"dzscoreboard",
	"dzradar",
	"dzkill",
	"dzmsgs",
	"group",
}

function startResources()
	for _, resName in ipairs(resourceNames) do
		local resource = getResourceFromName(resName)
		if resource then
			startResource(resource)
		end
	end
end
addEventHandler("onResourceStart", resourceRoot, startResources)