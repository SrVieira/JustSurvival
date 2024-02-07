       function ganar( attacker )
        	setElementData(attacker, "experience", getElementData(attacker, "experience") or 0 + 50)
        end
addEventHandler ( "onZombieGetsKilled", getRootElement(), ganar)