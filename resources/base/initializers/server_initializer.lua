setGameType("RB-RP v1.0.0");

function handleConnectToDB()
    dbConnection = dbConnect("mysql", "dbname="..serverVariables.database.name..";host="..serverVariables.database.host..";charset=utf8", serverVariables.database.username, serverVariables.database.password);
    if (not dbConnection) then
        outputDebugString("Error: Failed to establish connection to the MySQL database server");
    else
        outputDebugString("Success: Connected to the MySQL database server");
    end
end

addEventHandler("onResourceStart", resourceRoot, handleConnectToDB);
 