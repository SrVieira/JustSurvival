function checkHealth()
    local vHealth = getElementData(source, "blood") or 0
    if vHealth >= 12001 then
        setElementData(source, "blood", 12000)
        kickPlayer(source, "You use cheat")
    end
end
addEvent("goCheckHealth", true)
addEventHandler("goCheckHealth", getRootElement(), checkHealth)

function checkFood()
    local vFood = getElementData(source, "food") or 0
    if vFood >= 101 then
        setElementData(source, "food", 30)
        kickPlayer(source, "You use cheat")
    end
end
addEvent("goCheckFood", true)
addEventHandler("goCheckFood", getRootElement(), checkFood)

function checkThirst()
    local vFood = getElementData(source, "thirst") or 0
    if vFood >= 101 then
        setElementData(source, "thirst", 30)
        kickPlayer(source, "You use cheat")
    end
end
addEvent("goCheckThirst", true)
addEventHandler("goCheckThirst", getRootElement(), checkThirst)
