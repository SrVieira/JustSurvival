local function disableOriginalHUD()
    setPlayerHudComponentVisible("ammo", false);
    setPlayerHudComponentVisible("area_name", false);
    setPlayerHudComponentVisible("armour", false);
    setPlayerHudComponentVisible("breath", false);
    setPlayerHudComponentVisible("clock", false);
    setPlayerHudComponentVisible("health", false);
    setPlayerHudComponentVisible("money", false);
    setPlayerHudComponentVisible("radar", false);
    setPlayerHudComponentVisible("vehicle_name", false);
    setPlayerHudComponentVisible("weapon", false);
    setPlayerHudComponentVisible("radio", false);
    setPlayerHudComponentVisible("wanted", false);
end

local function handleLoadResource()
    disableOriginalHUD();
end
addEventHandler("onClientResourceStart", getRootElement(), handleLoadResource);

local function posicao()
    local x, y, z = getElementPosition(localPlayer);
    local groundZ = getGroundPosition(x, y, z);

    outputChatBox("{ "..x..", "..y..", "..groundZ.." }");
end
addCommandHandler("posicao", posicao)