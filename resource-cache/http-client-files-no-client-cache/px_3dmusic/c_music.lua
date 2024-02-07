--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local ui={}

ui.musicPlaces={
    {pos={2550.4497,2311.6824,10.8203},name="Radio LV",distance=100},
    {pos={1042.2161,1763.5981,10.8203},name="Mechanik LV",distance=100},
    {pos={2397.84375,1489.3489990234,10.827104568481}, name="Parking LV", distance=100},
    {pos={2311.4304,1803.7258,11.0747}, name="Wypożyczalnia LV", distance=100},
    {pos={1606.7260,1030.1115,10.8203}, name="Magazyn LV", distance=100},
    {pos={1369.6968,677.4597,15.2500}, name="Myjnia LV", distance=100},
    {pos={-146.4051,1078.0984,23.6248}, name="Radio FC", distance=100},
    {pos={-84.3472,1126.8354,24.3109}, name="Komponenty FC", distance=100},
    {pos={-108.9015,-302.2871,2.7656}, name="Tiry BB", distance=100},
    {pos={262.9713,11.1319,2.4688}, name="Felgi BB", distance=100},
    {pos={-2489.7507,2360.4233,4.8906}, name="Tuner BM", distance=100},
    {pos={2138.7463,2719.3406,15.6165}, name="Myjnia LV 2", distance=100},
    {pos={2455.3826,2376.8223,14.0078}, name="Bank LV", distance=100},
    {pos={932.0377,1735.9370,8.8594}, name="Urząd LV", distance=100},
    {pos={1173.4518,1360.8960,11.8750}, name="OSK LV", distance=100},
    {pos={1645.1898,1448.5925,10.4688}, name="Lotnisko LV", distance=100},
    {pos={2814.2495,984.7551,10.9141}, name="Kurier LV", distance=100},
    {pos={2241.0959,106.9896,26.3044}, name="Liczniki PC", distance=100},
    {pos={-903.5884,1531.5876,25.9141}, name="Cygan LB", distance=100},
    {pos={1673.9475,2089.2642,17.6012}, name="Spawn LV", distance=100},
    {pos={2275.1365,-80.8918,26.5440}, name="Spawn PC", distance=100},
    {pos={215.1590,-180.3366,5.0786}, name="Spawn BB", distance=100},
    {pos={-203.2355,1213.7754,24.4195}, name="Spawn FC", distance=100},
    {pos={1521.0237,9.9414,24.1406}, name="Kosiarki MM", distance=100},
    {pos={1368.6826,245.9046,19.3827}, name="Spawn MM", distance=100},
    {pos={-252.8599,2604.7400,62.8582}, name="Spawn LP", distance=100},
    {pos={-2238.5923,2353.6582,4.9788}, name="Spawn BM", distance=100},
    {pos={-1856.1118,117.5021,15.1172}, name="Śmieciarki", distance=100},
    {pos={-1694.1466,400.9283,7.1797}, name="Myjnia SF", distance=100},
    {pos={414.8661,2532.4131,19.1478}, name="Zdawanie L1/L2", distance=100},
    {pos={262.9025,1429.2180,10.6359}, name="Rafineria", distance=100},
    {pos={1065.6774,2357.5125,10.9609}, name="Montaż świateł", distance=100},
    {pos={2163.1304,2473.7520,10.8203}, name="Myjnia LV", distance=100},
    {pos={2559.6147,2151.2356,11.0234}, name="Konwojent", distance=100},
    {pos={2199.6462,1990.9009,12.3047}, name="Sklep LV", distance=100},
    {pos={2810.4421,1239.8441,10.8279}, name="Sprzedaż pojazdów / giełda", distance=400},
    {pos={2156.8213,-97.3247,2.7772}, name="Wyławiarka", distance=100},
    {pos={-1955.6140,284.8896,35.4688}, name="Salon SF", distance=100},
    {pos={-1657.3271,1209.2983,20.7145}, name="SALON SF Motory", distance=100},
    {pos={2461.1975,1732.6472,10.8203}, name="Muzeum LV", distance=100},
}

addEventHandler("onClientElementDataChange", root, function(data,last,new)
	if data == "user:dash_settings" and source == localPlayer then
		local state=exports.px_dashboard:getSettingState("3dmusic")
        if(state)then
            for i,v in pairs(ui.musicPlaces) do
                if(v.music)then
                    destroyElement(v.music)
                    v.music=nil
                end
            end
        else
            for i,v in pairs(ui.musicPlaces) do
                if(not v.music)then
                    v.music=playSound3D("https://radio.pixelmta.pl/public/pixel/playlist.pls", v.pos[1], v.pos[2], v.pos[3])
                    setSoundMaxDistance(v.music, v.distance)
                end
            end
        end
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    local state=exports.px_dashboard:getSettingState("3dmusic")
    if(not state)then
        for i,v in pairs(ui.musicPlaces) do
            v.music=playSound3D("https://radio.pixelmta.pl/public/pixel/playlist.pls", v.pos[1], v.pos[2], v.pos[3])
            setSoundMaxDistance(v.music, v.distance)
        end
    end
end)
