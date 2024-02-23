local random = math.random;

function math.percentChance(percent, repeatTime)
	local hits = 0;
	for i = 1, repeatTime do
		local number = random(0, 200)/2;
		if (number <= percent*2) then 
            hits = hits + 1; 
        end
	end
	return hits;
end