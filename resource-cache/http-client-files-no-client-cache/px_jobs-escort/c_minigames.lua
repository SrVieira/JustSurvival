--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

ui.minigames={
    [1]={
        variables={
            rot=0,
            positions={},
            opened=false,
            selected=false,
            click=false,
        },

        resetVariables=function(self)
            self={
                rot=0,
                positions={},
                opened=false,
                selected=false,
                click=false,
            }
        end,

        renderPositions={
            bg={0, 0, sw, sh},
            safe={300/zoom, sh/2-356/2/zoom, 337/zoom, 356/zoom},
            elipse={300/zoom+(337-188)/2/zoom, sh/2-356/2/zoom+(356-188)/2/zoom, 188/zoom, 188/zoom},
        },

        render=function(self, pos, reset)
            blur:dxDrawBlur(pos.bg[1], pos.bg[2], pos.bg[3], pos.bg[4])

            if(not self.opened)then
                self.rot=self.rot+3 > 360 and 3 or self.rot+3
    
                dxDrawImage(pos.safe[1], pos.safe[2], pos.safe[3], pos.safe[4], assets.textures[7])
                dxDrawImage(pos.elipse[1], pos.elipse[2], pos.elipse[3], pos.elipse[4], assets.textures[8], self.rot)
            else
                dxDrawImage(pos.safe[1], pos.safe[2], pos.safe[3], pos.safe[4], assets.textures[9])
    
                local id=ui.info.upgrades["Przewóz diamentów"] and 12 or ui.info.upgrades["Przewóz złota"] and 11 or 10
                local success=0
                for i,v in pairs(self.positions) do
                    if(v.success)then
                        success=success+1
                    end
    
                    dxDrawImage(v[1],v[2],v[3],v[4],assets.textures[id])
    
                    if(self.click == i)then
                        if(not getKeyState("mouse1"))then
                            self.click=false
                        else
                            local cx,cy=getCursorPosition()
                            cx,cy=cx*sw,cy*sh
                            
                            if(not ui.catchPos)then
                                local cx,cy=cx-v[1],cy-v[2]
                                ui.catchPos={cx,cy}
                            else
                                v[1],v[2]=cx-ui.catchPos[1],cy-ui.catchPos[2]
                            end
                        end
                    end
                
                    if(isMouseInPosition(v[1],v[2],v[3],v[4]) and not self.click and getKeyState("mouse1") and not v.success)then
                        ui.catchPos=false
                        self.click=i
                    end
    
                    if(getPosition(v[1], v[2], pos.safe[1], pos.safe[2], pos.safe[3], pos.safe[4]))then
                        v.success=true
                    end
                end
    
                if(success == #self.positions)then
                    local i,v=unpack(ui.gameRender.variables)

                    showCursor(false)

                    ui.gameRender=false

                    reset(self)
                    self.positions={}
    
                    local data=getElementData(localPlayer, "user:job_todo")
    
                    noti:noti("Zaczekaj na rozładunek wózka.", "info")
    
                    setElementFrozen(localPlayer, true)
    
                    ui.loading="TRWA ROZŁADUNEK..."
                    ui.loadingTick=getTickCount()
    
                    ui.loadingCarts[ui.maxCarts].tick=getTickCount()
                    ui.loadingCarts[ui.maxCarts].block=false

                    toggleControl('enter_exit', false)
                    setTimer(function()
                        toggleControl('enter_exit', true)

                        ui.haveCart=false
                        ui.maxCarts=ui.maxCarts-1
    
                        if(ui.maxCarts == 0)then
                            noti:noti("Wszystkie wózki zostały rozwiezione, udaj się na bazę gruppe6.", "info")
    
                            local data={
                                {name="Udaj się po wózek", done=true},
                                {name="Zaprowadź wózek do pojazdu", done=true},
                                {name="Wnieś wózek na pakę pojazdu", done=true},
                                {name="Udaj się do punktu", done=true},
                                {name="Wyjmij wózek i udaj się do punktu", done=true},
                                {name="Wróć na bazę gruppe6"},
                            }
                            setElementData(localPlayer, "user:jobs_todo", data, false)
    
                            ui.zones["baza"]=createColSphere(ui.pos[1], ui.pos[2], ui.pos[3], 50)
                            ui.blips["baza"]=createBlipAttachedTo(ui.zones["baza"], 22)

                            triggerLatentServerEvent("destroy.cart", resourceRoot, true, true)
                        else
                            noti:noti("Wózek został rozładowany, udaj się rozwieść resztę wózków.", "info")
    
                            local data=getElementData(localPlayer, "user:jobs_todo") or {}
                            local text=ui.miniLetters[ui.maxCarts]
                            data[4]={name="Udaj się do punktu "..text}
                            data[5]={name="Wyjmij wózek i udaj się do punktu "..text}
                            setElementData(localPlayer, "user:jobs_todo", data, false)

                            triggerLatentServerEvent("destroy.cart", resourceRoot, true)
                        end
        
                        checkAndDestroy(ui.markers[i])
                        checkAndDestroy(ui.blips[i])
                        ui.markers[i]=nil
                        ui.blips[i]=nil
    
                        setElementFrozen(localPlayer, false)
    
                        ui.loading=false
                    end, 10000, 1)
                end
            end
    
            onClick(pos.elipse[1], pos.elipse[2], pos.elipse[3], pos.elipse[4], function()
                if(self.rot > 80 and self.rot < 100)then
                    self.opened=true
                end
            end)
        end
    },

    [2]={ 
        variables={
            myCode="",
            code=""
        },

        renderPositions={
            {"image", sw/2-623/2/zoom, sh/2-436/2/zoom, 623/zoom, 436/zoom, 13, tocolor(255, 255, 255)},

            {"image", sw/2-623/2/zoom+373/zoom, sh/2-436/2/zoom+95/zoom, 71/zoom, 56/zoom, 17, tocolor(255, 255, 255), function(self)
                if(#self.myCode < 4)then
                    self.myCode=self.myCode.."1"
                    playSound("sounds/pinclick.mp3")
                end
            end},
            {"image", sw/2-623/2/zoom+373/zoom+71/zoom, sh/2-436/2/zoom+95/zoom, 71/zoom, 56/zoom, 18, tocolor(255, 255, 255), function(self)
                if(#self.myCode < 4)then
                    self.myCode=self.myCode.."2"
                    playSound("sounds/pinclick.mp3")
                end
            end},
            {"image", sw/2-623/2/zoom+373/zoom+71/zoom+71/zoom, sh/2-436/2/zoom+95/zoom, 71/zoom, 56/zoom, 19, tocolor(255, 255, 255), function(self)
                if(#self.myCode < 4)then
                    self.myCode=self.myCode.."3"
                    playSound("sounds/pinclick.mp3")
                end
            end},
            {"image", sw/2-623/2/zoom+373/zoom, sh/2-436/2/zoom+95/zoom+52/zoom, 71/zoom, 56/zoom, 20, tocolor(255, 255, 255), function(self)
                if(#self.myCode < 4)then
                    self.myCode=self.myCode.."4"
                    playSound("sounds/pinclick.mp3")
                end
            end},
            {"image", sw/2-623/2/zoom+373/zoom+71/zoom, sh/2-436/2/zoom+95/zoom+52/zoom, 71/zoom, 56/zoom, 21, tocolor(255, 255, 255), function(self)
                if(#self.myCode < 4)then
                    self.myCode=self.myCode.."5"
                    playSound("sounds/pinclick.mp3")
                end
            end},
            {"image", sw/2-623/2/zoom+373/zoom+71/zoom+71/zoom, sh/2-436/2/zoom+95/zoom+52/zoom, 71/zoom, 56/zoom, 22, tocolor(255, 255, 255), function(self)
                if(#self.myCode < 4)then
                    self.myCode=self.myCode.."6"
                    playSound("sounds/pinclick.mp3")
                end
            end},
            {"image", sw/2-623/2/zoom+373/zoom, sh/2-436/2/zoom+95/zoom+52/zoom+52/zoom, 71/zoom, 56/zoom, 23, tocolor(255, 255, 255), function(self)
                if(#self.myCode < 4)then
                    self.myCode=self.myCode.."7"
                    playSound("sounds/pinclick.mp3")
                end
            end},
            {"image", sw/2-623/2/zoom+373/zoom+71/zoom, sh/2-436/2/zoom+95/zoom+52/zoom+52/zoom, 71/zoom, 56/zoom, 24, tocolor(255, 255, 255), function(self)
                if(#self.myCode < 4)then
                    self.myCode=self.myCode.."8"
                    playSound("sounds/pinclick.mp3")
                end
            end},
            {"image", sw/2-623/2/zoom+373/zoom+71/zoom+71/zoom, sh/2-436/2/zoom+95/zoom+52/zoom+52/zoom, 71/zoom, 56/zoom, 25, tocolor(255, 255, 255), function(self)
                if(#self.myCode < 4)then
                    self.myCode=self.myCode.."9"
                    playSound("sounds/pinclick.mp3")
                end
            end},
            {"image", sw/2-623/2/zoom+373/zoom, sh/2-436/2/zoom+95/zoom+52/zoom+52/zoom+52/zoom, 71/zoom, 56/zoom, 15, tocolor(255, 255, 255), function(self)
                if(#self.myCode > 0)then
                    self.myCode=utf8.sub(self.myCode,0,#self.myCode-1)
                    playSound("sounds/pinclick.mp3")
                end
            end},
            {"image", sw/2-623/2/zoom+373/zoom+71/zoom, sh/2-436/2/zoom+95/zoom+52/zoom+52/zoom+52/zoom, 71/zoom, 56/zoom, 16, tocolor(255, 255, 255), function(self)
                if(#self.myCode < 4)then
                    self.myCode=self.myCode.."0"
                    playSound("sounds/pinclick.mp3")
                end
            end},
            {"image", sw/2-623/2/zoom+373/zoom+71/zoom+71/zoom, sh/2-436/2/zoom+95/zoom+52/zoom+52/zoom+52/zoom, 71/zoom, 56/zoom, 14, tocolor(255, 255, 255), function(self)
                if(self.myCode == self.code)then
                    playSound("sounds/unlocked.wav")

                    local i,v=unpack(ui.gameRender.variables)

                    showCursor(false)

                    ui.gameRender=false
    
                    local data=getElementData(localPlayer, "user:job_todo")
    
                    noti:noti("Zaczekaj na rozładunek wózka.", "info")
    
                    setElementFrozen(localPlayer, true)
    
                    ui.loading="TRWA ROZŁADUNEK..."
                    ui.loadingTick=getTickCount()
    
                    ui.loadingCarts[ui.maxCarts].tick=getTickCount()
                    ui.loadingCarts[ui.maxCarts].block=false
    
                    toggleControl('enter_exit', false)
                    setTimer(function()
                        toggleControl('enter_exit', true)
                        
                        ui.haveCart=false
                        ui.maxCarts=ui.maxCarts-1
    
                        if(ui.maxCarts == 0)then
                            noti:noti("Wszystkie wózki zostały rozwiezione, udaj się na bazę gruppe6.", "info")
    
                            data={
                                {name="Udaj się po wózek", done=true},
                                {name="Zaprowadź wózek do pojazdu", done=true},
                                {name="Wnieś wózek na pakę pojazdu", done=true},
                                {name="Udaj się do punktu", done=true},
                                {name="Wyjmij wózek i udaj się do punktu", done=true},
                                {name="Wróć na bazę gruppe6"},
                            }
                            setElementData(localPlayer, "user:jobs_todo", data, false)
    
                            ui.zones["baza"]=createColSphere(ui.pos[1], ui.pos[2], ui.pos[3], 50)
                            ui.blips["baza"]=createBlipAttachedTo(ui.zones["baza"], 22)

                            triggerLatentServerEvent("destroy.cart", resourceRoot, true, true)
                        else
                            noti:noti("Wózek został rozładowany, udaj się rozwieść resztę wózków.", "info")
    
                            local data=getElementData(localPlayer, "user:jobs_todo") or {}
                            local text=ui.miniLetters[ui.maxCarts]
                            data[4]={name="Udaj się do punktu "..text}
                            data[5]={name="Wyjmij wózek i udaj się do punktu "..text}
                            setElementData(localPlayer, "user:jobs_todo", data, false)

                            triggerLatentServerEvent("destroy.cart", resourceRoot, true)
                        end
        
                        checkAndDestroy(ui.markers[i])
                        checkAndDestroy(ui.blips[i])
                        ui.markers[i]=nil
                        ui.blips[i]=nil
    
                        setElementFrozen(localPlayer, false)
    
                        ui.loading=false
                    end, 10000, 1)
                end
            end},

            {id="text-code-1", "text", "", sw/2-623/2/zoom+97/zoom, sh/2-436/2/zoom+241/zoom, sw/2-623/2/zoom+97/zoom+51/zoom, 0, tocolor(139,188,233), 1, 2, "center", "top"},
            {id="text-code-2", "text", "", sw/2-623/2/zoom+97/zoom+56/zoom, sh/2-436/2/zoom+241/zoom, sw/2-623/2/zoom+97/zoom+51/zoom+56/zoom, 0, tocolor(139,188,233), 1, 2, "center", "top"},
            {id="text-code-3", "text", "", sw/2-623/2/zoom+97/zoom+56/zoom+56/zoom, sh/2-436/2/zoom+241/zoom, sw/2-623/2/zoom+97/zoom+51/zoom+56/zoom+56/zoom, 0, tocolor(139,188,233), 1, 2, "center", "top"},
            {id="text-code-4", "text", "", sw/2-623/2/zoom+97/zoom+56/zoom+56/zoom+56/zoom, sh/2-436/2/zoom+241/zoom, sw/2-623/2/zoom+97/zoom+51/zoom+56/zoom+56/zoom+56/zoom, 0, tocolor(139,188,233), 1, 2, "center", "top"},
        },

        render=function(self, pos, reset)
            for i,v in pairs(pos) do
                for i=1,4 do
                    local text=utf8.sub(self.myCode,i,i)
                    if(v.id == "text-code-"..i and v[2] ~= text)then
                        v[2]=text
                    end
                end

                if(v[1] == "image")then
                    dxDrawImage(v[2], v[3], v[4], v[5], assets.textures[v[6]], 0, 0, 0, v[7])
                    if(v[8])then
                        onClick(v[2], v[3], v[4], v[5], function()
                            v[8](self)
                        end)
                    end
                elseif(v[1] == "text")then
                    dxDrawText(v[2], v[3], v[4], v[5], v[6], v[7], v[8], assets.fonts[v[9]], v[10], v[11])
                end
            end
        end
    }
}