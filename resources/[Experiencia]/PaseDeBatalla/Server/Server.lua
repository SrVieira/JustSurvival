addEvent("onPedAnimation", true)
addEventHandler("onPedAnimation", getRootElement(),
        function (grupo, tipo)
                if not grupo and tipo then
                        return setPedAnimation(source)
                end
                setPedAnimation(source, grupo, tipo)
        end
)

function on_quit(jugador, Comando)
        triggerEvent("onPedAnimation", jugador)
end
addCommandHandler("parar", on_quit)
