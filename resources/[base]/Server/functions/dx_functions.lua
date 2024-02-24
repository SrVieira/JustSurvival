function dxDrawLinedRectangle(x, y, width, height, color, _width)
    _width = _width or 1;
    dxDrawLine(x, y, x+width, y, color, _width);
    dxDrawLine(x, y, x, y+height, color, _width); 
    dxDrawLine(x, y+height, x+width, y+height, color, _width);
    return dxDrawLine(x+width, y, x+width, y+height, color, _width);
end

function dxDrawingColorTextMenuScroll(str, ax, ay, bx, by, color, alpha, scale, font, alignX, alignY)
	if alignX then
		if alignX == "center" then
		elseif alignX == "right" then
			local w = dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font);
			ax = bx - w;
		end
	end
	if alignY then
		if alignY == "center" then
			local h = dxGetFontHeight(scale, font);
			ay = ay + (by-ay)/2 - h/2;
		elseif alignY == "bottom" then
			local h = dxGetFontHeight(scale, font);
			ay = by - h;
		end
	end
	local pat = "(.-)#(%x%x%x%x%x%x)";
	local s, e, cap, col = str:find(pat, 1);
	local last = 1;
	while s do
		if cap == "" and col then 
			color = tocolor(tonumber("0x"..col:sub(1, 2)), tonumber("0x"..col:sub(3, 4)), tonumber("0x"..col:sub(5, 6)), alpha);
		end
		if s ~= 1 or cap ~= "" then
			local w = dxGetTextWidth(cap, scale, font);
			dxDrawText(cap, ax, ay, ax + w, by, color, scale, font);
			ax = ax + w;
			color = tocolor(tonumber("0x"..col:sub(1, 2)), tonumber("0x"..col:sub(3, 4)), tonumber("0x"..col:sub(5, 6)), alpha);
		end
		last = e + 1;
		s, e, cap, col = str:find(pat, last);
	end
	if last <= #str then
		cap = str:sub(last);
		local w = dxGetTextWidth(cap, scale, font);
		dxDrawText(cap, ax, ay, ax + w, by, color, scale, font);
	end
end
