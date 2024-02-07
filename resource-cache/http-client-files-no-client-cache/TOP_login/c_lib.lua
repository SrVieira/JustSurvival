local screenWidth, screenHeight = guiGetScreenSize()
local sX, sY = 1024, 768
local dxElements = {}

local focus = false
local tick = 0
local keyTick = 0
local easingTick = 0
local a = true

function dxCreateWindow ( x, y, width, height, titleBarText, allRel, wAlpha, windowBarColor, windowColor )
	if type(x) == "number" then
		if type(y) == "number" then
			if type(width) == "number" then
				if type(height) == "number" then
					if type(titleBarText) == "string" then
						if type(allRel) == "boolean" then
							if allRel then
								x, y, width, height = screenWidth*x, screenHeight*y, screenWidth*width, screenHeight*height
							end
							local windowElement = createElement("dx-window")
							local wbR, wbG, wbB = unpack(windowBarColor)
							local wR, wG, wB = unpack(windowColor)
							local alpha = alpha or 255
							dxElements[windowElement] = {["visible"] = true, ["x"] = x, ["y"] = y, ["width"] = width, ["height"] = height, ["text"] = titleBarText, ["alpha"] = wAlpha, ["rb"] = wbR or 255, ["gb"] = wbG or 255, ["bb"] = wbB or 255, ["r"] = wR or 255, ["g"] = wG or 255, ["b"] = wB or 255}
							-- visible, x, y, width, height, title, alpha, wbR, wbG, wbB, wR, wG, wB
							return windowElement
						else
							outputDebugString("[dxCreateWindow]: expected bool at argument 6, got "..type(allRel), 3)
							return false
						end
					else
						outputDebugString("[dxCreateWindow]: expected string at argument 5, got "..type(titleBarText), 3)
						return false
					end
				else
					outputDebugString("[dxCreateWindow]: expected number at argument 4, got "..type(height), 3)
					return false
				end
			else
				outputDebugString("[dxCreateWindow]: expected number at argument 3, got "..type(width), 3)
				return false
			end
		else
			outputDebugString("[dxCreateWindow]: expected number at argument 2, got "..type(y), 3)
			return false
		end
	else
		outputDebugString("[dxCreateWindow]: expected number at argument 1, got "..type(x), 3)
		return false
	end
end

function dxCreateButton(x, y, width, height, text, allRel, parent, color, postgui, fSize, font, texture)
	if type(x) == "number" then
		if type(y) == "number" then
			if type(width) == "number" then
				if type(height) == "number" then
					if type(text) == "string" then
						if type(allRel) == "boolean" then
							local buttonElement = createElement("dx-button")
							local parent = parent or false
							local r, g, b, a
							if color and type(color) == "table" then
								r, g, b, a = unpack(color)
							end
							texture = texture or false
							font = font or false
							dxElements[buttonElement] = {["visible"] = true, ["x"] = x, ["y"] = y, ["width"] = width, ["height"] = height, ["text"] = text, ["parent"] = parent, ["r"] = r or 0, ["g"] = g or 0, ["b"] = b or 0, ["alpha"] = a or 255, ["postgui"] = postgui or false, ["fSize"] = fSize or 1, ["enabled"] = true, ["texture"] = texture, ["font"] = font}
							-- visible, x, y, width, height, text, parent, r, g, b
							return buttonElement
						else
							outputDebugString("[dxCreateButton]: expected bool at argument 6, got "..type(allRel), 3)
						end
					else
						outputDebugString("[dxCreateButton]: expected string at argument 6, got "..type(text), 3)
					end
				else
					outputDebugString("[dxCreateButton]: expected number at argument 6, got "..type(height), 3)
				end
			else
				outputDebugString("[dxCreateButton]: expected number at argument 6, got "..type(width), 3)
			end
		else
			outputDebugString("[dxCreateButton]: expected number at argument 6, got "..type(y), 3)
		end
	else
		outputDebugString("[dxCreateButton]: expected number at argument 6, got "..type(x), 3)
	end
	return false
end

function dxCreateLabel(x, y, width, height, text, allRel, parent, color, postgui, isbutton, fSize)
	if type(x) == "number" then
		if type(y) == "number" then
			if type(width) == "number" then
				if type(height) == "number" then
					if type(text) == "string" then
						if type(allRel) == "boolean" then
							if allRel then
								x, y = x*screenWidth, y*screenHeight
							    width, height = x + math.ceil(width * screenWidth), y + math.ceil(height * screenHeight)
								--outputChatBox(width)
							end
							local labelElement = createElement("dx-label")
							local parent = parent or false
							local r, g, b, a = unpack(color)
							dxElements[labelElement] = {["visible"] = true, ["x"] = x, ["y"] = y, ["width"] = width, ["height"] = height, ["text"] = text, ["parent"] = parent, ["r"] = r or 0, ["g"] = g or 0, ["b"] = b or 0, ["alpha"] = a or 255, ["postgui"] = postgui or false, ["isbutton"] = isbutton or false, ["fSize"] = fSize or 1, ["enabled"] = true}
							-- visible, x, y, width, height, text, parent, r, g, b
							return labelElement
						else
							outputDebugString("[dxCreateButton]: expected bool at argument 6, got "..type(allRel), 3)
						end
					else
						outputDebugString("[dxCreateButton]: expected string at argument 6, got "..type(text), 3)
					end
				else
					outputDebugString("[dxCreateButton]: expected number at argument 6, got "..type(height), 3)
				end
			else
				outputDebugString("[dxCreateButton]: expected number at argument 6, got "..type(width), 3)
			end
		else
			outputDebugString("[dxCreateButton]: expected number at argument 6, got "..type(y), 3)
		end
	else
		outputDebugString("[dxCreateButton]: expected number at argument 6, got "..type(x), 3)
	end
	return false
end

function dxCreateProgressbar(text, x, y, width, height, table_color, progress, parent, scrolling, postgui)
	local progressbar = createElement("dx-progressbar")

	if progress > 100 then
		progress = 100
	elseif progress < 0 then
		progress = 0
	end
	
	progress = progress * width / 100
	
	local r,g,b = unpack(table_color)
	dxElements[progressbar] = { ["text"] = text, ["x"] = x, ["y"] = y, ["width"] = width, ["height"] = height, ["r"] = r, ["g"] = g, ["b"] = b, ["parent"] = parent, ["visible"] = true, ["progress"] = progress, ["scrolling"] = scrolling or false, ["alpha"] = 200, ["postgui"] = postgui or false, ["enabled"] = true}
	return progressbar
end

function dxCreateEdit(x, y, width, height, text, emptyText, color, secret, center, postgui)
	local edit = createElement("dx-edit")
	local emptyText = emptyText or ""
	local r, g, b, a = unpack(color)
	dxElements[edit] = { ["x"] = x, ["y"] = y, ["width"] = width, ["height"] = height, ["text"] = text, ["r"] = r or 0, ["g"] = g or 0, ["b"] = b or 0, ["alpha"] = a or 255, ["emptyText"] = emptyText, ["visible"] = true, ["secret"] = secret, ["alpha"] = 200, ["centered"] = center, ["postgui"] = postgui or false, ["enabled"] = true}
	return edit
end

function dxCreateImage(x, y, width, height, parent, texture, alpha, allRel, postgui)
	local image = createElement("dx-image")
	if allRel then
		x, y, width, height = screenWidth*x, screenHeight*y, screenWidth*width, screenHeight*height
	end
	local parent = parent or false
	dxElements[image] = { ["x"] = x, ["y"] = y, ["width"] = width, ["height"] = height, ["texture"] = texture, ["alpha"] = 200, ["parent"] = parent, ["postgui"] = postgui or false, ["visible"] = true, ["enabled"] = true}
	return image
end

-----
function dxCreateGridlist(x, y, width, height, alpha, allRel, parent, postgui)
	local gridlist = createElement("dx-gridlist")
	local parent = parent or false

	if allRel then
		x, y, width, height = x*screenWidth, y*screenHeight, width*screenWidth, height*screenHeight
	end
	dxElements[gridlist] = { ["x"] = x, ["y"] = y, ["width"] = width, ["height"] = height, ["parent"] = parent, ["visible"] = true, ["alpha"] = alpha or 200, ["column"] = {},  ["row"] = {}, ["scroll"] = 1, ["enabled"] = true}
	return gridlist
end

function dxGridlistAddColumn( dx_gridlist, columnName, size )
	if dx_gridlist then
		local index = #dxElements[dx_gridlist]["column"] + 1
		
		dxElements[dx_gridlist]["column"][index] = {columnName, math.ceil(size * dxElements[dx_gridlist]["width"])}
		dxElements[dx_gridlist]["column"][index]["selected"] = false
		return columnname, index
	end
	return false
end

function dxGridlistAddRow( dx_gridlist )
	if dx_gridlist then

		local index = #dxElements[dx_gridlist]["row"] + 1
		dxElements[dx_gridlist]["row"][index] = {"-"}
		dxElements[dx_gridlist]["row"][index]["selected"] = false
		
		return index
	end
	return false
end

function dxGridlistSetItemText( dx_gridlist, str, row, column )
	if dx_gridlist then

		if dxElements[dx_gridlist]["row"][row] == nil  then return end
		if dxElements[dx_gridlist]["column"][column] == nil  then return end
		
		if not dxElements[dx_gridlist]["row"][row] then
			dxElements[dx_gridlist]["row"][row] = {}
		end
		
		dxElements[dx_gridlist]["row"][row][column] = tostring(str)
		
		return str 
	end
	return false
end

function dxGridlistGetItemText( dx_gridlist, row, column )
	if dx_gridlist then
		
		if dxElements[dx_gridlist]["row"][row] == nil then return end
		if dxElements[dx_gridlist]["column"][column] == nil then return end
		
		
		return dxElements[dx_gridlist]["row"][row][column]
	end
	return false
end

function dxGridlistClear( dx_gridlist  )
	if dx_gridlist then
		
		for i = 1, #dxElements[dx_gridlist]["row"] do
			dxElements[dx_gridlist]["row"][i] = nil
		end

		return true
	end
	return false
end

function dxGridlistGetSelectedItem( dx_gridlist  )
	if dx_gridlist then
		local isRowSelected, isColumnSelected
		local row, col
		
		for i = 1, #dxElements[dx_gridlist]["row"] do
			if dxElements[dx_gridlist]["row"][i]["selected"] then
				row = i
				break
			end
		end
		
		for i = 1, #dxElements[dx_gridlist]["column"] do
			if dxElements[dx_gridlist]["column"][i]["selected"] then
				col = i
				break
			end
		end
		
		return row or 0, column or 0
	end
	return false
end
------
function dxSetVisible( dx_element, visible )
	if dx_element then
		dxElements[dx_element].visible = visible
		return true
	end
	return false
end

function dxGetVisible( dx_element )
	if dxElements[dx_element] then
		return dxElements[dx_element].visible
	end
	return true
end

function dxGetSize( dx_element)
	if dx_element then
		return dxElements[dx_element].width, dxElements[dx_element].height
	end
	return false
end

function dxSetPosition(dx_element, x, y)
	if dx_element then
		dxElements[dx_element].x, dxElements[dx_element].y = x, y
	end
	return false
end

function dxSetColor( dx_element, color )
	if dx_element and color then
		local dxData = dxElements[dx_element]
		local r, g, b = unpack(color)
		dxElements[dx_element].r, dxElements[dx_element].g, dxElements[dx_element].b = r, g, b
	end
end

function dxSetAlpha(element, alpha)
	dxElements[element].alpha = alpha
end

function dxSetText(element, text)
	dxElements[element].text = text
	return true
end

function dxGetText(element)
	return dxElements[element].text
end

function dxSetEnabled(element, bool)
	dxElements[element].enabled = bool
end

function dxDestroy(element)
	dxElements[element] = nil
	destroyElement(element)
end

function dxLoadImage(dx_image, newTexture)
	if dx_image then
		dxElements[dx_image].texture = newTexture
	end
end

addEventHandler("onClientPreRender", root,
	function()
		for i, v in pairs(dxElements) do
			if i and v.visible then
				local elementType = getElementType(i)
				if elementType == "dx-window" then
					dxDrawRectangle(v.x, v.y, v.width, 30, tocolor(v.rb, v.gb, v.bb, v.alpha))
					dxDrawText(v.text, v.x, v.y, v.x+v.width, v.y+30, tocolor(0, 0, 0, 255), 1, "default-bold", "center", "center")
					dxDrawRectangle(v.x, v.y+30, v.width, v.height-30, tocolor(v.r, v.g, v.b, v.alpha))
					dxDrawLine(v.x, v.y, v.x+v.width, v.y, tocolor(0, 0, 0, 255), 1)
					dxDrawLine(v.x, v.y+v.height, v.x+v.width, v.y+v.height, tocolor(0, 0, 0, 255), 1)
					dxDrawLine(v.x, v.y, v.x, v.y+v.height, tocolor(0, 0, 0, 255), 1)
					dxDrawLine(v.x+v.width, v.y, v.x+v.width, v.y+v.height, tocolor(0, 0, 0, 255), 1)
					dxDrawLine(v.x, v.y+30, v.x+v.width, v.y+30, tocolor(0, 0, 0, 255), 1)
				end
			end
		end
	end
)

local function inQuad(t, b, c, d)
  t = t / d
  return c * math.pow(t, 2) + b
end

addEventHandler("onClientRender", root,
	function()
		local now = getTickCount()
		local eTime = inQuad(now - easingTick, 200, -190, 1000)
		--
		if getKeyState("backspace") then
			if now - keyTick > eTime then
				onCharacter("backspace")
				keyTick = getTickCount()
			end
		else
			easingTick = now
		end
		--
		
		for i, v in pairs(dxElements) do
			if i and v.visible then
				local elementType = getElementType(i)	
				if elementType == "dx-button" then
					local x, y, width, height, text, color
					local visible = true
					local alpha
					if v.parent then -- if parent then
						-- outputChatBox(tostring(v[7]))
						x, y, width, height, text = dxElements[v.parent].x+v.x, dxElements[v.parent].y+v.y+30, v.width, v.height, v.text
						alpha = dxElements[v.parent].alpha
						if isCursorShowing() then
							local cx, cy = getCursorPosition()
							if cx*screenWidth >= x and cx*screenWidth <= x+width and cy*screenHeight >= y and cy*screenHeight <= y+height then
								--alpha = alpha+50
								alpha = alpha+210
							end
						end
						visible = dxGetVisible( v.parent )
						color =  tocolor(v.r, v.g, v.b, visible and alpha or 0)
					else
						x, y, width, height, text = v.x, v.y, v.width, v.height, v.text
						alpha = v.alpha
						if isCursorShowing() then
							local cx, cy = getCursorPosition()
							if cx*screenWidth >= x and cx*screenWidth <= x+width and cy*screenHeight >= y and cy*screenHeight <= y+height then
								--alpha = alpha+50
								alpha = alpha+210
							end
						end
						color =  tocolor(v.r, v.g, v.b, alpha)
					end
					local line = false
					if alpha > 0 then
						if v.texture then
							dxDrawImage(x, y, width, height, v.texture, 0, 0, 0, color, v.postgui)
						else
							dxDrawRectangle(x, y, width, height, color, v.postgui)
						end
						local font
						if v.font then
							font = v.font
						else
							font = "default-bold"
						end
						dxDrawText(text, x, y, x+width, y+height, tocolor(255, 255, 255, visible and 255 or 0), v.fSize, font, "center", "center", nil, true, v.postgui)
						if line then
						--dxDrawText(text, x, y, x+width, y+height, tocolor(0, 0, 0, visible and 255 or 0), v.fSize, "default-bold", "center", "center", nil, true, v.postgui)
						dxDrawLine(x, y, x+width, y, tocolor(v.r, v.g, v.b, visible and 255 or 0), 1.2, v.postgui)
						dxDrawLine(x, y+height, x+width+1, y+height, tocolor(v.r, v.g, v.b, visible and 255 or 0), 1.2, v.postgui)
						dxDrawLine(x, y, x, y+height, tocolor(v.r, v.g, v.b, visible and 255 or 0), 1.2, v.postgui)
						dxDrawLine(x+width, y, x+width, y+height, tocolor(v.r, v.g, v.b, visible and 255 or 0), 1.2, v.postgui)
						end
					end
				elseif elementType == "dx-label" then
					local x, y, width, height, text = v.x, v.y, v.width, v.height, v.text
					local r, g, b, alpha = v.r, v.g, v.b, v.alpha
					local visible = v.visible
					if v.parent then -- if parent then
						-- outputChatBox(tostring(v[7]))
						x, y, width, height = dxElements[v.parent].x+v.x+5, dxElements[v.parent].y+v.y+30, v.width, v.height
						visible = dxGetVisible( v.parent )
					end
					if v.isbutton and isCursorShowing() then
						local cx, cy = getCursorPosition()
						if cx*screenWidth >= x and cx*screenWidth <= x+width and cy*screenHeight >= y and cy*screenHeight <= y+height then
							alpha = alpha-50
							r, g, b = 0, 0, 255
						end
					end
					if visible then
						local colorcode = false
						if string.find(text, "#%x%x%x%x%x%x") then
							colorcode = true
						end
						color =  tocolor(r, g, b, alpha)
						dxDrawText(text, x, y, x+width, height, color, v.fSize, "default-bold", nil, nil, nil, true, v.postgui, colorcode)
					end
				elseif elementType == "dx-edit" then
					local text = v.text
					if v.secret then
						text = string.rep("*", #text)
					end
					if #text == 0 then
						text = v.emptyText
					end
					local wText = dxGetTextWidth(text, 1, "default-bold")
					local lr, lg, lb = 25, 25, 25
					--dxDrawRectangle( v.x, v.y, v.width, v.height, tocolor(255, 255, 255, v.alpha), v.postgui );
					dxDrawRectangle( v.x, v.y, v.width, v.height, tocolor(v.r, v.g, v.b, v.alpha), v.postgui );
					
					local line = false
					if focus == i and isCursorShowing() then
						if now - tick > 500 then
							a = not a
							tick = getTickCount()
						end
						
						local xLine = v.centered and math.min(v.x+(v.width/2) + wText/2, v.x + v.width - 8.5) or math.min(v.x + 8.5 + wText, v.x + v.width - 8.5)
						--dxDrawRectangle( xLine, v.y + 2, 2, v.height - 4, tocolor(0, 0, 0, a and 255 or 0), v.postgui );
						dxDrawRectangle( xLine, v.y + 2, 1, v.height - 4, tocolor(255, 255, 255, a and 255 or 0), v.postgui );
						--lr, lg, lb = 0, 176, 236
						lr, lg, lb =  50, 255, 50
						--line= true
					end
					if line then
						dxDrawLine(v.x, v.y, v.x + v.width, v.y, tocolor(lr, lg, lb, v.alpha+50), 1, v.postgui)
						dxDrawLine(v.x, v.y, v.x, v.y+v.height, tocolor(lr, lg, lb, v.alpha+50), 1, v.postgui)
						dxDrawLine(v.x+v.width, v.y, v.x+v.width, v.y+v.height+1, tocolor(lr, lg, lb, v.alpha+50), 1, v.postgui)
						dxDrawLine(v.x, v.y+v.height, v.x+v.width+1, v.y+v.height, tocolor(lr, lg, lb, v.alpha+50), 1, v.postgui)
					end
					--dxDrawText(wText < v.width and text or string.sub(text, math.floor( ( wText - v.width ) / 7.5 ) ), v.x + 8.5, v.y, v.x + v.width - 8.5, v.y + v.height, tocolor(0, 0, 0, 255), 1.0, "default-bold", v.centered and "center" or "left", "center", true, false, v.postgui);
					dxDrawText(wText < v.width and text or string.sub(text, math.floor( ( wText - v.width ) / 7.5 ) ), v.x + 8.5, v.y, v.x + v.width - 8.5, v.y + v.height, tocolor(255, 255, 255, 255), 1.0, "arial", v.centered and "center" or "left", "center", true, false, v.postgui);
				elseif elementType == "dx-image" then
					if v.visible then
						local x, y, width, height, alpha = v.x, v.y, v.width, v.height, v.alpha
						if v.parent then
							x, y, width, height = dxElements[v.parent].x+v.x, dxElements[v.parent].y+v.y, v.width, v.height
							alpha = dxElements[v.parent].alpha
						end
						
						local cx, cy = getCursorPosition()
						if isCursorShowing() then
							if v.enabled then
								if cx*screenWidth >= x and cx*screenWidth <= x+width and cy*screenHeight >= y and cy*screenHeight <= y+height then
									--width = width + 5
									--height = height + 5
								end
							end
							
						end
						visible = dxGetVisible( v.parent ) or false
						if visible then
							dxDrawImage ( x, y, width, height, v.texture,0, 0,0,tocolor(255,255,255,255), v.postgui )
						end
					end
				elseif elementType == "dx-progressbar" then	
					local text, x, y, width, height, alpha, progress, r, g, b = v.text, v.x, v.y, v.width, v.height, v.alpha, v.progress, v.r, v.g, v.b

					if v.parent then 
						x, y, width, height = dxElements[v.parent].x+v.x, dxElements[v.parent].y+v.y+30, v.width, v.height
						alpha = dxElements[v.parent].alpha
					end
					
					visible = dxGetVisible( v.parent )
					if visible then
						dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, alpha), v.postgui)
						
						
						local font = 0.8
						
						dxDrawRectangle(x + 1, y + 1, progress - 2, height - 2, tocolor(r, g, b, alpha), v.postgui)
						dxDrawText(text, x + 1, y, x+width-2, y+height, tocolor(255, 255, 255, 255), font, "default-bold", "center", "center", true )
					end
					
					
				elseif elementType == "dx-gridlist" then
					local x, y, width, height, alpha, scroll = v.x, v.y, v.width, v.height, v.alpha, v.scroll
					
					if v.parent then
						x, y = dxElements[v.parent].x+v.x, dxElements[v.parent].y+v.y + 30
					end
					
					visible = dxGetVisible( v.parent )
					if visible then
						dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, alpha), v.postgui)
						
						local padding = 0
						
						for column, value in ipairs(v.column) do
							local columnName = value[1]
							local columnWidth = value[2]
							local rep = padding + columnWidth
							
							dxDrawText(columnName, x + 5 + padding, y + 5, x + rep, y+height, tocolor(200, 200, 200, alpha), 1, "default-bold", _,_, true, false, false, false, v.postgui)
						
							local up = 0
							
							for index = 0+v.scroll, #v.row+v.scroll do
								
								local row = v.row[index]
								if row ~= nil then
									
									-- rows
									local rowText = row[column]
									local colorcode = false
									
									if string.find(rowText, "#%x%x%x%x%x%x") then
										colorcode = true
									end
									
									dxDrawText(rowText, x + 5 + padding, y + 30 + up * 25, x + rep, y + height, tocolor(255, 255, 255, alpha), 1, "default-bold", _,_, true, false, false, colorcode, v.postgui)
									up = up + 1
									
									local bary = y + 30 + up * 25 - 25
									
									if bary < y + height and row["selected"] then

										dxDrawRectangle(x, bary, width, 20, tocolor(50, 50, 50, 50), v.postgui)
										
									end

									
								end
							end

							padding = rep
						end
						
						dxDrawLine(x, y + 20, x + padding, y + 20, tocolor(0, 0, 0, v.alpha), 1.2, v.postgui)
						
					end
				end
			end
		end
	end
)

function scroll(_, _, sc)
	local elem = nil
	
	if not isCursorShowing() then return end
	
	for type, v in pairs (dxElements) do
	
		if getElementType(type) == "dx-gridlist" then
		
			local x, y, width, height, alpha, parent = v.x, v.y, v.width, v.height, v.parent
			if v.parent then
				x, y = dxElements[v.parent].x+x, dxElements[v.parent].y+y+30
			end
			
			local cx, cy = getCursorPosition()
			local mx, my = cx*screenWidth, cy*screenHeight
			if ( mx >= x and mx < x + width and my >= y and my <= y + height ) then	
				if v.enabled then
					elem = type
					break
				end
			end
		end
	end
	
	
	if dxElements[elem] == nil then return end
	local rows = dxElements[elem]["row"]
	
	
	if sc == 1 then
		if dxElements[elem]["scroll"] < #rows then
			dxElements[elem]["scroll"] = dxElements[elem]["scroll"] + 1
		else
			dxElements[elem]["scroll"] = #rows
		end
	else
		if dxElements[elem]["scroll"] > 1 then
			dxElements[elem]["scroll"] = dxElements[elem]["scroll"] - 1
		else
			dxElements[elem]["scroll"] = 1
		end
	end
end
bindKey("mouse_wheel_up", "down", scroll, -1)
bindKey("mouse_wheel_down", "down", scroll, 1)

addEventHandler("onClientClick", root,
	function(button, state, cx, cy)
		if button == "left" and state == "down" then
			for i, v in pairs(dxElements) do
				local eType = getElementType(i)
				if eType ~= "dx-window" and eType ~= "dx-label" then
					if ( v.parent and dxElements[v.parent].visible ) or v.visible and v.enabled then
						local x, y, width, height = v.x, v.y, v.width, v.height
						if dxElements[v.parent] then
							x, y =  dxElements[v.parent].x+v.x,dxElements[v.parent].y+v.y+30
						end
						
						if cx >= x and cx <= x+width and cy >= y and cy <= (y+height) then
							focus = i
							tick = getTickCount()
							a = true						
							if eType == "dx-gridlist" then
								triggerEvent("onClientDXGridlistClick", i, cx, cy)
								return
							elseif eType == "dx-button" then
								triggerEvent("onClientDXButtonClick", i, cx, cy)
								return
							elseif eType == "dx-progressbar" then
								
								if cx >= x + 1 and cx <= x+width + 1 then -- non-offsets
									local mx1, mx2 = {getCursorPosition()}, {guiGetScreenSize()}
									dxElements[i].progress = math.floor(mx1[1] * mx2[1] - x) + 1
									triggerEvent("onClientDXProgressBarMove", i, dxElements[i].progress)
								end
								
							else
								triggerEvent("onClientDXClick", i, cx, cy)
								return							
							end


						end				
					end
				end
			end
			focus = false
		end
	end
)

addEventHandler("onClientCursorMove", root,
	function( _, _, cx, cy )

		for i, v in pairs(dxElements) do
			local eType = getElementType(i)
			if eType == "dx-progressbar" then
				local progress = v.progress
				local x = v.x
				local y = v.y
				local width = v.width
				local height = v.height
				local mx1, mx2 = {getCursorPosition()}, {guiGetScreenSize()}
				
				if v.parent then
					x, y = dxElements[v.parent].x+x, dxElements[v.parent].y+y + 30
				end
				
				if isCursorShowing() then
					if ( cx >= x +1 and cx <= x + width - 1 and cy >= y and cy <= y + height) then
						if getKeyState("mouse1") == true then
							local mx1, mx2 = {getCursorPosition()}, {guiGetScreenSize()}
							dxElements[i].progress = math.floor(mx1[1] * mx2[1] - x) + 1
							triggerEvent("onClientDXProgressBarMove", i, dxElements[i].progress)
						end
					end
				end
				
				
			end
		end
		--focus = false
	end
)

-- gridlist
addEvent("onClientDXGridlistClick", true)
addEventHandler("onClientDXGridlistClick", root,
	function(cx, cy)
		local eType = getElementType(source)
		
		if eType == "dx-gridlist" then
		
			local x, y, width, height, parent, rows, columns, scroll = dxElements[source]["x"], dxElements[source]["y"], dxElements[source]["width"], dxElements[source]["height"], dxElements[source]["parent"], dxElements[source]["row"], dxElements[source]["column"], dxElements[source]["scroll"]
			
			if parent then
				x, y = dxElements[parent]["x"] + x, dxElements[parent]["y"] + y + 30
			end
						
			local offsetRow = 0
			for check = 0 + scroll, #rows do
				
				
				-- rows
				
				if cx >= x and cx <= x+width and cy >= y + 30 + offsetRow * 20 and cy <= (y + 30 + offsetRow * 20) + 15 then
					dxElements[source]["row"][check]["selected"] = true
					triggerEvent("onClientDXGridlistSelectedItem", source, check)
					
				else
					--dxElements[source]["row"][check]["selected"] = false
					--triggerEvent("onClientDXGridlistUnselectedItem", source, check)
					
				end
				offsetRow = offsetRow + 1
			end
		end
	end
)

function onCharacter(key)
	if isCursorShowing() and isElement(focus) and getElementType(focus) == "dx-edit" then
		local text = dxElements[focus].text
		if key ~= "backspace" then
			text = text..key
		else
			text = text:sub(1, #text - 1)
		end
		tick = getTickCount()
		a = true
		dxElements[focus].text = text
		triggerEvent("onClientDXChanged", focus)
	end
end
addEventHandler("onClientCharacter", root, onCharacter)

addEventHandler("onClientElementDestroy", resourceRoot,
	function()
		dxElements[source] = nil
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		for comp, _ in pairs(dxElements) do
			--if isElement(comp)
				destroyElement(comp)
			--end
		end
	end
)