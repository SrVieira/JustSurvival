ui.checkTrigger = true;

function renderLoginForm()
  if(not ui.edits[1] and not ui.edits[2] and not ui.edits[3] and not ui.edits[4])then
    ui.edits[1]=edits:dxCreateEdit("Login", 185/zoom, 445/zoom, 307/zoom, 30/zoom, false, 11/zoom, a, false, false, ":px_auth/textures/username_icon.png")
    ui.edits[2]=edits:dxCreateEdit("Hasło", 185/zoom, 501/zoom, 307/zoom, 30/zoom, true, 11/zoom, a, false, false, ":px_auth/textures/password_icon.png")
    ui.edits[3]=edits:dxCreateEdit("Powtórz hasło", 185/zoom, 559/zoom, 307/zoom, 30/zoom, true, 11/zoom, a, false, false, ":px_auth/textures/password_icon.png")
    ui.edits[4]=edits:dxCreateEdit("E-mail", 185/zoom, 615/zoom, 307/zoom, 30/zoom, false, 11/zoom, a, false, false, ":px_auth/textures/mail_icon.png")
  else
      for i,v in pairs(ui.edits) do
          edits:dxSetEditAlpha(v, a)
      end
  end

  dxDrawImage(185/zoom, 676/zoom, 19/zoom, 19/zoom, ui.rules == 1 and assets.textures[7] or assets.textures[6], 0, 0, 0, tocolor(255,255,255,a))
  dxDrawText("Akceptuje regulamin serwera", 185/zoom+32/zoom, 676/zoom, 19/zoom, 19/zoom+676/zoom, tocolor(200, 200, 200, a), 1, assets.fonts[2], "left", "center")
end

ui.draw["REGISTRO"]= function(a)
  renderLoginForm();
    onClick(185/zoom, 676/zoom, 19/zoom, 19/zoom, function()
        ui.rules=ui.rules == 1 and 0 or 1
    end)

    if(not ui.btns[1])then
        ui.btns[1]=btns:createButton(346/zoom, 720/zoom, 147/zoom, 38/zoom, "ZAREJESTRUJ", a, 10, false, false, ":px_auth/textures/button_icon.png")
    else
        for i,v in pairs(ui.btns) do
            btns:buttonSetAlpha(v,a)
        end

        onClick(346/zoom, 720/zoom, 147/zoom, 38/zoom, function()
            if(not ui.checkTrigger)then
              exports.px_noti:noti("Zaczekaj chwilę.", "error")
              return
            end

            local login=edits:dxGetEditText(ui.edits[1]) or ""
            local pass=edits:dxGetEditText(ui.edits[2]) or ""
            local pass2=edits:dxGetEditText(ui.edits[3]) or ""
            local mail=edits:dxGetEditText(ui.edits[4]) or ""
            if(#login < 4)then
              exports.px_noti:noti("Login powinien posiadać przynajmniej 4 znaki.", "error")
            elseif(#pass < 7)then
              exports.px_noti:noti("Hasło powinno posiadać przynajmniej 7 znaków.", "error")
            elseif(#mail < 5)then
              exports.px_noti:noti("Adres e-mail powinien posiadać przynajmniej 5 znaków.", "error")
            elseif(#login > 15)then
              exports.px_noti:noti("Login powinien posiadać mniej niż 15 znaki.", "error")
            elseif(#pass > 50)then
              exports.px_noti:noti("Hasło powinno posiadać mniej niż 50 znaki.", "error")
            elseif(#mail > 100)then
              exports.px_noti:noti("Adres e-mail powinnien posiadać mniej niż 100 znaków.", "error")
            elseif(tostring(pass) ~= tostring(pass2))then
              exports.px_noti:noti("Podane hasła nie zgadzają się.", "error")
            elseif(not isValidMail(mail))then
              exports.px_noti:noti("Adres e-mail jest nieprawidłowy.", "error")
            elseif(ui.rules ~= 1)then
              exports.px_noti:noti("Aby zagrać na serwerze musisz zaakceptować regulamin.", "error")
            else
              if(SPAM.getSpam())then return end

              triggerServerEvent("ui.registerPlayer", resourceRoot, login, pass, mail)

              ui.checkTrigger=false
            end
        end)
    end
end

addEvent("ui.checkTrigger", true)
addEventHandler("ui.checkTrigger", resourceRoot, function()
  ui.checkTrigger=true
end)