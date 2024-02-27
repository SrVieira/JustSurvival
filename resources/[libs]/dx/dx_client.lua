local fonts = {
	['TitleInventory'] = dxCreateFont("fonts/teko_regular.ttf", 18),
	['SubTitleInventory'] = dxCreateFont("fonts/teko_regular.ttf", 14),
};

function dxDrawBorderedRectangle(x,y,w,h,border_size,color,postgui)
	if postgui == nil then postgui = true end
	
	local r, g, b, a = unpack(color)
	local r2 = math.max(0, math.min( r+25, 222))
	local g2 = math.max(0, math.min( g+25, 222))
	local b2 = math.max(0, math.min( b+25, 222))
	local a2 = math.max(0, math.min( a+25, 222))

	dxDrawRectangle(x, y, w, -border_size, tocolor(r2, g2, b2, a2), postgui)
	dxDrawRectangle(x, y+h, w, border_size, tocolor(r2, g2, b2, a2), postgui)
	dxDrawRectangle(x, y-border_size, -border_size, h+(border_size*2), tocolor(r2, g2, b2, a2), postgui)
	dxDrawRectangle(x+w, y-border_size, border_size, h+(border_size*2), tocolor(r2, g2, b2, a2), postgui)
	dxDrawRectangle(x, y, w, h, tocolor(r, g, b, a), postgui)
end

function dxCustomDrawText(text, left, top, right, bottom, color, font, alignX, alignY)
	dxDrawText(text, left, top, right, bottom, color, 1.00, fonts[font], alignX, alignY, true);
end
