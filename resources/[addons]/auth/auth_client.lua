local screenWidth, screenHeight = guiGetScreenSize();

function handleRenderScreen()
    local currentPage = getElementData(localPlayer, "currentPage") or "login";
    dxDrawImage(0, 0, screenWidth, screenHeight, "assets/images/bg.png");
    if currentPage == "login" then
        exports.theme:dxDrawTextCustom('Login', screenWidth * 0.1, screenHeight * 0.259, 35, 35, tocolor(255, 255, 255), 'head1');
        exports.theme:dxDrawTextCustom('Insira suas informações abaixo para entrar em\nnossa cidade.', screenWidth * 0.1, screenHeight * 0.310, 35, 35, tocolor(255, 255, 255), 'body1');
        exports.theme:dxDrawInputField('Usuário', screenWidth * 0.1, screenHeight * 0.375, screenWidth * 0.280, screenHeight * 0.07, tocolor(255, 255, 255, 25), tocolor(255, 255, 255));
        exports.theme:dxDrawInputField('Senha', screenWidth * 0.1, screenHeight * 0.460, screenWidth * 0.280, screenHeight * 0.07, tocolor(255, 255, 255, 25), tocolor(255, 255, 255));
        exports.theme:dxDrawButton('Entrar na Cidade', screenWidth * 0.1, screenHeight * 0.545, screenWidth * 0.280, screenHeight * 0.07, tocolor(218, 0, 39, 255), tocolor(255, 255, 255), "join");
        exports.theme:dxDrawCheckbox('Lembrar login', screenWidth * 0.1, screenHeight * 0.630, tocolor(118, 118, 118, 255), tocolor(255, 255, 255));
        exports.theme:dxDrawTextCustom('Esqueci a minha senha', screenWidth * 0.1, screenHeight * 0.680, screenWidth * 0.380, screenHeight * 0.680, tocolor(255, 255, 255), 'body2', 'center', 'center');
        exports.theme:dxDrawRoundedRectangle(screenWidth * 0.1, screenHeight * 0.710, screenWidth * 0.280, screenHeight * 0.07, 6, tocolor(255, 255, 255, 25), false, false);
        exports.theme:dxDrawTextCustom('Quero criar #FF1842minha conta', screenWidth * 0.1, screenHeight * 0.710, screenWidth * 0.380, screenHeight * 0.780, tocolor(255, 255, 255), 'body4', 'center', 'center');
    elseif currentPage == "register" then

    elseif currentPage == "recoverPassword" then

    end
end

function handleLoadResource()
    if not getElementData(localPlayer, "isLogged") then
        showChat(false);
        showCursor(true);
        addEventHandler("onClientRender", getRootElement(), handleRenderScreen);
    end
end
addEventHandler("onClientResourceStart", resourceRoot, handleLoadResource);