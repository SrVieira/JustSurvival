local messages = {}
local screenW, screenH = guiGetScreenSize()

function drawClientInfo()
	for i, v in ipairs(messages) do
		local now = getTickCount()
		local elapsed = now - v.startTick
		local duration = v.stopTick - v.startTick
		local progress = elapsed / duration
		local _, y = interpolateBetween((screenW/2)-200, screenH-15, 0, (screenW/2)-200, screenH-15-i*15, 0, progress, "Linear")
		local cur = elapsed
		if cur > duration then
			cur = duration
		end
		
		local alpha = math.floor(200 * (cur / duration))
		local text = v[1]
		
		dxDrawText(text:gsub("#%x%x%x%x%x%x",""), (screenW*0.875)-1, y-1, (screenW*0.875)-1, y-1, tocolor(0, 0, 0, alpha), 1.00, "default-bold", "right", "center", false, false, false, true, false)
		dxDrawText(text:gsub("#%x%x%x%x%x%x",""), (screenW*0.875)+1, y-1, (screenW*0.875)+1, y-1, tocolor(0, 0, 0, alpha), 1.00, "default-bold", "right", "center", false, false, false, true, false)
		dxDrawText(text:gsub("#%x%x%x%x%x%x",""), (screenW*0.875)+1, y+1, (screenW*0.875)+1, y+1, tocolor(0, 0, 0, alpha), 1.00, "default-bold", "right", "center", false, false, false, true, false)
		dxDrawText(text:gsub("#%x%x%x%x%x%x",""), (screenW*0.875)-1, y+1, (screenW*0.875)-1, y+1, tocolor(0, 0, 0, alpha), 1.00, "default-bold", "right", "center", false, false, false, true, false)
		dxDrawText(text, screenW*0.875, y, screenW*0.875, y, tocolor(v[3][1], v[3][2], v[3][3], alpha), 1.00, "default-bold", "right", "center", false, false, false, true, false)
		
		if now > v[2] then
			table.remove(messages, i)
		end
	end
end
addEventHandler("onClientRender", root, drawClientInfo, true, "low-6.0")

addEvent("displayClientInfo", true)
addEventHandler("displayClientInfo", root,
	function(msg, color)
		if msg and msg ~= "" then
			if #messages > 6 then
				table.remove(messages, 1)
			end
			if (messages[#messages-1] and messages[#messages-1][1] == msg) then return end
			table.insert(messages,{startTick = getTickCount(), stopTick = getTickCount()+500, msg, getTickCount() + 3000, color or {255,255,255}})
		end
	end
)