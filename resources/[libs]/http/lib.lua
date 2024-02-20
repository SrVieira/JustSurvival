function handleResponse(response, error)
    if error == 0 then
        outputServerLog("Resposta da API: " .. response);
    else
        outputServerLog("Erro ao solicitar a API: " .. tostring(error));
    end
end

function fetchData(apiUrl)
    fetchRemote(apiUrl, handleResponse);
end