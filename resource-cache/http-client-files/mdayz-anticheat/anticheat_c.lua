function verifyStat()
    verifyHealth() -- Vérification de la vie
    verifyFood() -- Vérification de la faim
    verifyThirst() -- Vérification de la soif
end
setTimer(verifyStat, 5000, 0)

function verifyHealth()
    triggerServerEvent("goCheckHealth", getLocalPlayer())
end

function verifyFood()
    triggerServerEvent("goCheckFood", getLocalPlayer())
end

function verifyThirst()
    triggerServerEvent("goCheckThirst", getLocalPlayer())
end
