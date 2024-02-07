
-----------------------------------------------
--  Desarrollador/Developer: -Rex-
--  Proyecto/Proyect:        N/A
--  Contacto/Contact:        https://www.facebook.com/rexscripting/
--
--  Libre uso y modificacion, No borrar los creditos, Gracias
-----------------------------------------------

function opengui(  )
  if guiGetVisible( grouppanel ) == false 
   and guiGetVisible( guiconfiggp ) == false 
   and guiGetVisible( admingrouppanel ) == false 
   and guiGetVisible( addplto ) == false 
   and guiGetVisible( guiconfig ) == false 
   and guiGetVisible( accregisgui ) == false
   and guiGetVisible( msjgui ) == false
   and guiGetVisible( maineditslots ) == false
   and guiGetVisible( admingrouppanel ) == false
   and guiGetVisible( gplistgw ) == false
   and guiGetVisible( colorchangegui ) == false
   and guiGetVisible( promotegui ) == false 
   and guiGetVisible( guiinviteplayer ) == false 
   and guiGetVisible( infopanelg ) == false 
   and guiGetVisible( guiinfogpedit ) == false 
   and guiGetVisible( guimembersgp ) == false 
   and guiGetVisible( GUIEditor.window[1] ) == false
   and guiGetVisible( GUIEditor.window[2] ) == false 
   and guiGetVisible( GUIEditor.window[3] ) == false 
   and guiGetVisible( GUIEditor.window[4] ) == false 
   and guiGetVisible( admRangos.window[1] ) == false 
   and guiGetVisible( rangosMain ) == false 
   then

   triggerServerEvent("getdatasgroup",getLocalPlayer(  ))
   guiSetVisible(grouppanel,true)
   guiSetVisible(guiconfiggp,false)
   guiSetVisible ( admingrouppanel, false)
   guiSetVisible ( rangosMain, false)
   guiSetVisible ( admRangos.window[1], false)
   guiSetVisible ( addplto, false)
   guiSetVisible ( guiconfig, false)
   guiSetVisible ( addplto, false)
   guiSetVisible ( accregisgui, false)
   guiSetVisible ( msjgui, false)
   guiSetVisible ( maineditslots, false)
   guiSetVisible ( admingrouppanel, false)
   guiSetVisible(gplistgw,false)
   guiSetVisible( colorchangegui,false)  
   guiSetVisible ( GUIEditor.window[2], false )
   guiSetVisible ( GUIEditor.window[3], false )
   guiSetVisible ( GUIEditor.window[4], false )
   guiSetVisible ( GUIEditor.window[1], false )
   guiSetVisible ( notyfy.window[1], false )
   guiSetVisible( loggui, false )
   guiSetVisible( RSystem.window[1], false)
   guiSetVisible ( Confirm.window[1], false )
  temporalNick = nil
   showCursor(true)
   guiSetInputEnabled( true )
else
  guiSetVisible( Confirm.window[1], false)
  temporalNick = nil
   guiSetVisible ( GUIEditor.window[2], false )
   guiSetVisible ( GUIEditor.window[3], false )
   guiSetVisible ( GUIEditor.window[4], false )
   guiSetVisible ( GUIEditor.window[1], false )
   guiSetVisible(gplistgw,false)
   guiSetVisible(grouppanel,false)
   guiSetVisible(guicolor,false)
   guiSetVisible( guimembersgp,false) 
   guiSetVisible(guiinfogpedit,false) 
   guiSetVisible(promotegui,false)
   guiSetVisible(guiinviteplayer,false)
   guiSetVisible(guiconfiggp,false)
   guiSetVisible( colorchangegui,false)  
   guiSetVisible( infopanelg,false)  
   guiSetVisible ( rangosMain, false)
   guiSetVisible ( RSystem.window[1], false )
   guiSetVisible ( admRangos.window[1], false)
   guiSetVisible ( notyfy.window[1], false )
   guiSetVisible( loggui, false )
   disableGPCGui()
   showCursor(false)
   guiSetInputEnabled( false )
end
end
bindKey("F6","down",opengui)


function datasguiButtons( gang, havegang, isfounder, allowedADMG, kick, chat, Crangos, Alianzas, apelaciones, informacion )
  guiSetText(actualizgrplabel,"Grupo actual: "..gang)

  if havegang ==  "si" then
   guiSetEnabled( creategpb, false)
   guiSetEnabled(editcrgp,false)
   guiSetEnabled( infogp, true)
       --guiSetEnabled( configgp, true)
       guiSetEnabled( members, true)
       guiSetEnabled( gpmoney, false)
  else
   guiSetEnabled( members, false)
   guiSetEnabled( configgp, false)
   guiSetEnabled( infogp, false)
   guiSetEnabled( creategpb, true)
   guiSetEnabled(editcrgp,true)
   guiSetEnabled( gpmoney, false)
   guiSetEnabled( kickmembersb, false)
   guiSetEnabled( banmembers, false)
   guiSetEnabled( promotemembers, false)
   guiSetEnabled( buyslots, false)
   guiSetEnabled( invnewmemb, false)
   guiSetEnabled( editinfo, false)
   return
end

  --outputChatBox(  tr( kick )  )
  if isfounder == "si" then
     guiSetEnabled( configgp, true)
     guiSetEnabled( promotemembers, true)
     guiSetEnabled( invnewmemb, true)
     guiSetEnabled( editinfo, true)
     guiSetEnabled( deletegp, true)
     guiSetEnabled( kickmembersb, true)
     guiSetEnabled( banmembers, true)
     guiSetEnabled( buyslots, true)
     guiSetEnabled( leavegroup, true)
     guiSetEnabled( gpmoney, false)
else
     guiSetEnabled( leavegroup, false)
     guiSetEnabled( deletegp, false)
     guiSetEnabled( gpmoney, true)
     if allowedADMG == "si" then
          guiSetEnabled( configgp, true)
     else
          guiSetEnabled( configgp, false)
     end

     guiSetEnabled( kickmembersb, tr( kick ))
     guiSetEnabled( banmembers, tr( chat ))
     guiSetEnabled( promotemembers, tr( Crangos ))
     guiSetEnabled( buyslots, tr( Alianzas ))
     guiSetEnabled( invnewmemb, tr( apelaciones ))
     guiSetEnabled( editinfo, tr( informacion ))


end

end
addEvent("datosdegui",true)
addEventHandler("datosdegui",getLocalPlayer(),datasguiButtons)

function gllogpspn( tablita )

     for i,v in ipairs( tablita ) do
         row = guiGridListAddRow( gridlistgps )
         guiGridListSetItemText( gridlistgps, row, namegpl, v[1], false, false )
         guiGridListSetItemText( gridlistgps, row, membgpl, v[2], false, false )
    end

end
addEvent("addGLLListM",true)
addEventHandler("addGLLListM",getLocalPlayer(),gllogpspn)

--:v
function addtogridlistallmembersconfigui( actives, inactives )


     for i,v in ipairs( actives ) do

          local name   = v[2]
          local status = v[1]
          local rank   = v[3]
          local r      = v[4]
          local g      = v[5]
          local b      = v[6]

          local row = guiGridListAddRow( gridlistconfigmv )
          guiGridListSetItemText( gridlistconfigmv, row, namecol, name, false, false )
          guiGridListSetItemText( gridlistconfigmv, row, acccol, status, false, false )
          guiGridListSetItemText( gridlistconfigmv, row, rangcol, rank, false, false )
          guiGridListSetItemColor( gridlistconfigmv, row, namecol, r, g, b,  200 )
          guiGridListSetItemColor( gridlistconfigmv, row, acccol, r, g, b,  200 )
          guiGridListSetItemColor( gridlistconfigmv, row, rangcol, r, g, b,  200 )

     end

     for i,v in ipairs( inactives ) do

          local name   = v[2]
          local status = v[1]
          local rank   = v[3]
          local r      = v[4]
          local g      = v[5]
          local b      = v[6]

          local row = guiGridListAddRow( gridlistconfigmv )
          guiGridListSetItemText( gridlistconfigmv, row, namecol, name, false, false )
          guiGridListSetItemText( gridlistconfigmv, row, acccol, status, false, false )
          guiGridListSetItemText( gridlistconfigmv, row, rangcol, rank, false, false )
          guiGridListSetItemColor( gridlistconfigmv, row, namecol, r, g, b,  200 )
          guiGridListSetItemColor( gridlistconfigmv, row, acccol, r, g, b,  200 )
          guiGridListSetItemColor( gridlistconfigmv, row, rangcol, r, g, b,  200 )

     end

end
addEvent("addCgListM",true)
addEventHandler("addCgListM",getLocalPlayer(),addtogridlistallmembersconfigui)

function infogpg( info )
  guiSetText(memoinfogp,info)
end
addEvent("goupinfo",true)
addEventHandler("goupinfo",getLocalPlayer(),infogpg)

function infogpgedit( info )
  guiSetText(memoinfoedit,info)
end
addEvent("toeditinfogp",true)
addEventHandler("toeditinfogp",getLocalPlayer(),infogpgedit)

function clearCList(  )
  guiGridListClear(gridlistconfigmv)
  triggerServerEvent("getcdtgroup",getLocalPlayer())
end

function createlistinvt( name, thestring )
  row = guiGridListAddRow( gridlistsendinv )
  guiGridListSetItemText( gridlistsendinv, row, plinvd, name, false, false )
  guiGridListSetItemText( gridlistsendinv, row, plyon, thestring, false, false )
end
addEvent("listofplayerinv",true)
addEventHandler("listofplayerinv",getLocalPlayer(),createlistinvt)

function getlistinvt( gang,name,slots )
  row = guiGridListAddRow( gridlistmyinv )
  guiGridListSetItemText( gridlistmyinv, row, plfor, gang, false, false )
  guiGridListSetItemText( gridlistmyinv, row, plgpf, name, false, false )
  guiGridListSetItemText( gridlistmyinv, row, plslots, slots, false, false )
end
addEvent("addinvlist",true)
addEventHandler("addinvlist",getLocalPlayer(),getlistinvt)

function gllogpssspn( name,rag )
  row = guiGridListAddRow( gridlistpromotepl )
  guiGridListSetItemText( gridlistpromotepl, row, plprompl, name, false, false )
  guiGridListSetItemText( gridlistpromotepl, row, plrangpl, rag, false, false )
end
addEvent("addPronmgListM",true)
addEventHandler("addPronmgListM",getLocalPlayer(),gllogpssspn)

function addmembersgfppp( actives, inactives )

     for i,v in ipairs( actives ) do

          local name   = v[2]
          local status = v[1]
          local rank   = v[3]
          local r      = v[4]
          local g      = v[5]
          local b      = v[6]

          local row = guiGridListAddRow( gridmiemview )
          guiGridListSetItemText( gridmiemview, row, plggm, name, false, false )
          guiGridListSetItemText( gridmiemview, row, plgac, status, false, false )
          guiGridListSetItemText( gridmiemview, row, plrac, rank, false, false )
          guiGridListSetItemColor( gridmiemview, row, plggm, r, g, b,  200 )
          guiGridListSetItemColor( gridmiemview, row, plgac, r, g, b,  200 )
          guiGridListSetItemColor( gridmiemview, row, plrac, r, g, b,  200 )

     end

     for i,v in ipairs( inactives ) do

          local name   = v[2]
          local status = v[1]
          local rank   = v[3]
          local r      = v[4]
          local g      = v[5]
          local b      = v[6]

         local row = guiGridListAddRow( gridmiemview )
          guiGridListSetItemText( gridmiemview, row, plggm, name, false, false )
          guiGridListSetItemText( gridmiemview, row, plgac, status, false, false )
          guiGridListSetItemText( gridmiemview, row, plrac, rank, false, false )
          guiGridListSetItemColor( gridmiemview, row, plggm, r, g, b,  200 )
          guiGridListSetItemColor( gridmiemview, row, plgac, r, g, b,  200 )
          guiGridListSetItemColor( gridmiemview, row, plrac, r, g, b,  200 )

     end

end
addEvent("listofmebers",true)
addEventHandler("listofmebers",getLocalPlayer(),addmembersgfppp)

function asignarColorAlEditBox( a, b )
    guiSetText( editcolortag, a )
    guiSetText( editcolormsj, b )
end
addEvent("coloorChat",true)
addEventHandler("coloorChat",getLocalPlayer(),asignarColorAlEditBox)
