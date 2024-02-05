local ceil, min = math.ceil, math.min;

function createDynamicFont(fontPath, baseSize)
    local screenWidth, screenHeight = guiGetScreenSize();
    local scale = screenWidth / 1920;
    local dynamicSize = baseSize * scale;

    return dxCreateFont(fontPath, dynamicSize);
end

local fonts = {
    ['head1'] = createDynamicFont("fonts/Inter-Bold.ttf", 28);
    ['body1'] = createDynamicFont("fonts/Inter-Regular.ttf", 16);
    ['body2'] = createDynamicFont("fonts/Inter-Bold.ttf", 18);
    ['body3'] = createDynamicFont("fonts/Inter-Medium.ttf", 14);
    ['body4'] = createDynamicFont("fonts/Inter-Medium.ttf", 18);
};

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    radius = min(radius, width / 2, height / 2);

    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning);
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI);
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI);
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI);
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI);
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning);
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning);
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning);
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning);
end

function dxDrawTextCustom(label, leftX, topY, rightX, bottomY, color, font, alignX, alignY)
    alignX = alignX or 'left';
    alignY = alignY or 'top';

    dxDrawText(label, leftX, topY, rightX, bottomY, color, 1, fonts[font], alignX, alignY, false, true, false, true);
end

function dxDrawInputField(label, x, y, width, height, color, fontColor)
    dxDrawRoundedRectangle(x, y, width, height, 6, color, false, false);
    dxDrawTextCustom(label, x + 15, y + (height / 2), x, y + (height / 2), fontColor, 'body2', nil, "center");
end

function dxDrawButton(label, x, y, width, height, color, fontColor, icon)
    dxDrawRoundedRectangle(x, y, width, height, 6, color, false, false);
    dxDrawImage(x + (width - 45), y + (height / 2) - 18, 35, 35, "icons/"..icon..".png");
    dxDrawTextCustom(label, x + 15, y + (height / 2), x, y + (height / 2), fontColor, 'body2', nil, "center");
end

function dxDrawCheckbox(label, x, y, color, fontColor)
    dxDrawRoundedRectangle(x, y, 16, 16, 6, color, false, false);
    dxDrawTextCustom(label, x + 20, y + 20, x, y, fontColor, 'body3', nil, "center");
end