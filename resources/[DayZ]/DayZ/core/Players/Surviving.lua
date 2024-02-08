function checkTemperature()
	for i,player in ipairs(getElementsByType("player")) do
		if getElementData(player,"Logged") then
			local current = getElementData(player,"temperature")
			local value = 0
			for k,v in ipairs(gameplayVariables["weather"]) do
				local weatherID = getWeather()
				if weatherID == v[1] then
					value = v[2]
				end
			end
			local hour, minutes = getTime()
			if hour >= 21 and hour <= 8 then
				value = value-0.05
			end
			if current + value > 41 then
				setElementData(player,"temperature",41)
			elseif 	current + value <= 31 then
				setElementData(player,"temperature",31)
			else
				setElementData(player,"temperature",current+value)
			end
		end
	end
end
setTimer(checkTemperature,30000,0)

function setTheWeather()
	local weather = math.random(0,18)
	if weather ~= 8 and weather ~= 9 and weather ~= 16 then
		setWeather(weather)
	end
end
setTimer(setTheWeather, 1800000,0)
setTheWeather()