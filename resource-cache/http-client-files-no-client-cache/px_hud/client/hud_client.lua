--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local sw,sh=guiGetScreenSize()
local zoom=1920/sw

local blur=exports.blur
local avatars=exports.px_avatars
local achievements=exports.px_achievements

local fps = {
	tick=getTickCount(),
	ms=60,
}

local ui={}

ui.fonts = {
	dxCreateFont(":px_assets/fonts/Font-Regular.ttf", 13/zoom),
	dxCreateFont(":px_assets/fonts/Font-Medium.ttf", 14/zoom),
	dxCreateFont(":px_assets/fonts/Font-Regular.ttf", 16/zoom),
	dxCreateFont(":px_assets/fonts/Font-Medium.ttf", 12/zoom),
}

ui.textures = {
	dxCreateTexture("assets/images/circle_outline.png", "argb", false, "clamp"),
	dxCreateTexture("assets/images/outline_avatar.png", "argb", false, "clamp"),
	dxCreateTexture("assets/images/lvl.png", "argb", false, "clamp"),
	dxCreateTexture("assets/images/hp.png", "argb", false, "clamp"),
	dxCreateTexture("assets/images/armour.png", "argb", false, "clamp"),
	dxCreateTexture("assets/images/oxygen.png", "argb", false, "clamp"),
	dxCreateTexture("assets/images/back.png", "argb", false, "clamp"),
	dxCreateTexture("assets/images/star_blank.png", "argb", false, "clamp"),
	dxCreateTexture("assets/images/star.png", "argb", false, "clamp"),
}

ui.lastMoney = 0
ui.alpha = 255
ui.blur=false

ui.lastXP=0
ui.lastHP=0
ui.lastAR=0
ui.lastOX=0

ui.playerMoney=0
ui.renderMoney=0

ui.uid = 0

ui.variables={
	logged=false,
	afk=false,
	hud_disabled=false,
	police_stars=0,
	level=0,
	exp=0,
}

ui.miscVariables={
	fps_counter=exports.px_dashboard:getSettingState("fps_counter"),
	showed_hud=exports.px_dashboard:getSettingState("showed_hud"),
}

ui.pos={
	rightFooter={0, sh-(13/zoom), sw-87, sh,},
	leftFooter={5/zoom, sh-20/zoom, 0, 0},

	bg={sw-153/zoom-180/zoom+1, 50/zoom+(107-62)/2/zoom, 162/zoom, 61/zoom},

	forRec={sw-162/zoom-180/zoom+1+34/zoom, 50/zoom+(107-62)/2/zoom+9/zoom, 114/zoom, 5/zoom},
	forIm={sw-156/zoom-180/zoom+1+10/zoom, 50/zoom+(107-62)/2/zoom+9/zoom},
	forP={sw-162/zoom-180/zoom+1+34/zoom, (50/zoom+(107-62)/2/zoom+9/zoom), 114/zoom, 5/zoom},

	cPos={sw-169/zoom-(125-107)/2/zoom, 50/zoom-(125-107)/2/zoom, 124/zoom, 124/zoom},

	avatar={sw-169/zoom-(125-107)/2/zoom, 50/zoom-(125-107)/2/zoom, 125/zoom, 125/zoom},
	avatar_two={sw-169/zoom-(117-107)/2/zoom, 50/zoom-(117-107)/2/zoom, 117/zoom, 117/zoom},

	lvl={sw-169/zoom+(107-50)/2/zoom, 50/zoom+87/zoom, 50/zoom, 50/zoom},

	money={0, 138/zoom, sw-175/zoom, 0},
	hour={0, 45/zoom, sw-175/zoom, 0},

	w_line={sw-153/zoom-270/zoom, 50/zoom+(107-62)/2/zoom+(61-35)/2/zoom, 2, 35/zoom},
	w_img={sw-425/zoom-200/zoom, 15/zoom, 180/zoom, 180/zoom},
	w_ammo_1={0, 50/zoom+(107-62)/2/zoom, sw-153/zoom-180/zoom-30/zoom, 61/zoom+50/zoom+(107-62)/2/zoom+25/zoom},
	w_ammo_2={0, 50/zoom+(107-62)/2/zoom, sw-153/zoom-180/zoom-30/zoom, 61/zoom+50/zoom+(107-62)/2/zoom-25/zoom},

	star={sw-153/zoom-180/zoom+1, 48/zoom, 21/zoom, 20/zoom, 22/zoom}
}

ui.onRender = function()
	dxDrawText("PIXEL | "..ui.uid.." |", ui.pos.rightFooter[1], ui.pos.rightFooter[2], ui.pos.rightFooter[3], ui.pos.rightFooter[4], tocolor(255, 255, 255, 125), 1, "default", "right", "bottom", false, false, true)

	if(ui.miscVariables.fps_counter)then
		dxDrawText(math.floor(fps.ms), 1, 1, 0, 0, tocolor(0, 0, 0), 1, ui.fonts[2])
		dxDrawText(math.floor(fps.ms), 0, 0, 0, 0, tocolor(255, 255, 255), 1, ui.fonts[2])
	end

	if(not ui.variables.logged)then return end

	if(ui.uid == 0)then
		ui.uid = math.random(0,3)..getElementData(localPlayer, "user:uid")..math.random(3,6) -- new uid (33005) = 300
	end

	getDM() -- dm
	ui.getPlayerMoney() -- money

	if(ui.variables.hud_disabled or ui.miscVariables.showed_hud)then 
		exports.circleBlur:visibleCircleBlur(ui.circleBlur,true)
		return 
	end
	exports.circleBlur:visibleCircleBlur(ui.circleBlur,false)

	local needXP=getLevelNeedExp(ui.variables.level) 
	if(not needXP)then
		outputChatBox("* Nastąpił problem z XP. Zgłoś to do Administratora.")
		return
	end

	--hud

	if(not ui.circleBlur)then
		ui.circleBlur=exports.circleBlur:createBlurCircle(sw-153/zoom-180/zoom+1, 50/zoom+(107-62)/2/zoom, 162/zoom, 61/zoom, tocolor(255, 255, 255, 255), ":px_hud/assets/images/mask.png")
	end

	-- draw

	-- background
	dxDrawImage(ui.pos.bg[1], ui.pos.bg[2], ui.pos.bg[3], ui.pos.bg[4], ui.textures[7])

	for i=1,3 do
		local w,h=dxGetMaterialSize(ui.textures[3+i])
		local sY=(19/zoom)*(i-1)
		dxDrawRectangle(ui.pos.forRec[1], ui.pos.forRec[2]+sY, ui.pos.forRec[3], ui.pos.forRec[4], tocolor(112, 112, 112))
		dxDrawImage(ui.pos.forIm[1], ui.pos.forIm[2]+sY-(h-5)/2/zoom, w/zoom, h/zoom, ui.textures[3+i])

		local color=i == 1 and tocolor(124,56,53) or i == 2 and tocolor(178,164,96) or i == 3 and tocolor(100,137,174)
		local arg=i == 1 and (ui.lastHP/100) or i == 2 and (ui.lastAR/100) or i == 3 and (ui.lastOX/1000)
		dxDrawRectangle(ui.pos.forP[1], ui.pos.forP[2]+sY, ui.pos.forP[3]*arg, ui.pos.forP[4], color)
	end

	-- exp
	local x,y,w=getCirclePosition(ui.pos.cPos[1], ui.pos.cPos[2], ui.pos.cPos[3])
	local avatar=avatars:getPlayerAvatar(localPlayer)

	dxDrawImage(ui.pos.avatar[1], ui.pos.avatar[2], ui.pos.avatar[3], ui.pos.avatar[4], ui.textures[2], 0, 0, 0, tocolor(255, 255, 255, 255))
	_dxDrawCircle(x,y,w, 0, 360*(ui.lastXP/needXP), tocolor(102,166,255), tocolor(137,247,254), 1000)
	dxDrawImage(ui.pos.avatar[1], ui.pos.avatar[2], ui.pos.avatar[3], ui.pos.avatar[4], ui.textures[1], 0, 0, 0, tocolor(86,86,92))

	dxDrawImage(ui.pos.avatar_two[1], ui.pos.avatar_two[2], ui.pos.avatar_two[3], ui.pos.avatar_two[4], ui.textures[2], 0, 0, 0, tocolor(60, 60, 60, 255))
	dxDrawImage(ui.pos.avatar_two[1], ui.pos.avatar_two[2], ui.pos.avatar_two[3], ui.pos.avatar_two[4], avatar)

	-- lvl
	local XP=ui.variables.exp
	dxDrawImage(ui.pos.lvl[1], ui.pos.lvl[2], ui.pos.lvl[3], ui.pos.lvl[4], ui.textures[3])
	dxDrawText(ui.variables.level, ui.pos.lvl[1]+1, ui.pos.lvl[2]+1, ui.pos.lvl[3]+ui.pos.lvl[1]+1, ui.pos.lvl[4]+ui.pos.lvl[2]+1, tocolor(0, 0, 0, 255), 1, ui.fonts[1], "center", "center")
	dxDrawText(ui.variables.level, ui.pos.lvl[1], ui.pos.lvl[2], ui.pos.lvl[3]+ui.pos.lvl[1], ui.pos.lvl[4]+ui.pos.lvl[2], tocolor(171, 173, 174, 255), 1, ui.fonts[1], "center", "center")

	-- money
	dxDrawText("$ "..ui.renderMoney, ui.pos.money[1]+1, ui.pos.money[2]+1, ui.pos.money[3]+1, ui.pos.money[4]+1, tocolor(0, 0, 0, 255), 1, ui.fonts[2], "right", "top", false)
	dxDrawText("#75bc79$ #c8c8c8"..ui.renderMoney, ui.pos.money[1], ui.pos.money[2], ui.pos.money[3], ui.pos.money[4], tocolor(171, 173, 174, 255), 1, ui.fonts[2], "right", "top", false, false, false, true)

	-- time
	local hour,minute=getTime()
	hour=string.format("%02d", hour)
	minute=string.format("%02d", minute)

	dxDrawText(hour..":"..minute, ui.pos.hour[1]+1, ui.pos.hour[2]+1, ui.pos.hour[3]+1, ui.pos.hour[4]+1, tocolor(0, 0, 0, 255), 1, ui.fonts[2], "right", "top", false)
	dxDrawText(hour..":"..minute, ui.pos.hour[1], ui.pos.hour[2], ui.pos.hour[3], ui.pos.hour[4], tocolor(171, 173, 174, 255), 1, ui.fonts[2], "right", "top", false, false, false, true)
	
	-- stars
	local data=getElementData(localPlayer, "user:maxMandates")
	if(data)then
		for i=1,data.maxStars do
			local sX=(ui.pos.star[5])*(i-1)
			dxDrawImage(ui.pos.star[1]+sX, ui.pos.star[2], ui.pos.star[3], ui.pos.star[4], i <= data.stars and ui.textures[9] or ui.textures[8])
		end
	end

	-- weapons
	if(getPedWeapon(localPlayer) ~= 0)then
		dxDrawRectangle(ui.pos.w_line[1], ui.pos.w_line[2], ui.pos.w_line[3], ui.pos.w_line[4], tocolor(105, 105, 105))

		dxDrawImage(ui.pos.w_img[1], ui.pos.w_img[2], ui.pos.w_img[3], ui.pos.w_img[4], "assets/images/weapons/"..getPedWeapon(localPlayer)..".png")

		local ammo1=getPedAmmoInClip(localPlayer,getPedWeaponSlot(localPlayer))
		local ammo2=getPedTotalAmmo(localPlayer),getPedAmmoInClip(localPlayer)
		dxDrawText(string.format("%03d", ammo2), ui.pos.w_ammo_2[1]+1, ui.pos.w_ammo_2[2]+1, ui.pos.w_ammo_2[3]+1, ui.pos.w_ammo_2[4]+1, tocolor(0, 0, 0), 1, ui.fonts[3], "right", "center", false)
		dxDrawText(string.format("%03d", ammo2), ui.pos.w_ammo_2[1], ui.pos.w_ammo_2[2], ui.pos.w_ammo_2[3], ui.pos.w_ammo_2[4], tocolor(200, 200, 200), 1, ui.fonts[3], "right", "center", false)
		dxDrawText(string.format("%03d", ammo1), ui.pos.w_ammo_1[1]+1, ui.pos.w_ammo_1[2]+1, ui.pos.w_ammo_1[3]+1, ui.pos.w_ammo_1[4]+1, tocolor(0, 0, 0), 1, ui.fonts[1], "right", "center", false)
		dxDrawText(string.format("%03d", ammo1), ui.pos.w_ammo_1[1], ui.pos.w_ammo_1[2], ui.pos.w_ammo_1[3], ui.pos.w_ammo_1[4], tocolor(100, 100, 100), 1, ui.fonts[1], "right", "center", false)
	end

	if(not footer or ((getTickCount()-footer) > 50))then
		local hour,minute=getTime()
		hour=string.format("%02d", hour)
		minute=string.format("%02d", minute)

		dxDrawText("pixel2.0 - "..hour..":"..minute, ui.pos.leftFooter[1]+1, ui.pos.leftFooter[2]+1, ui.pos.leftFooter[3]+1, ui.pos.leftFooter[4]+1, tocolor(0, 0, 0, 125), 1, ui.fonts[4], "left", "top", false, false, true)
		dxDrawText("pixel2.0 - "..hour..":"..minute, ui.pos.leftFooter[1], ui.pos.leftFooter[2], ui.pos.leftFooter[3], ui.pos.leftFooter[4], tocolor(255, 255, 255, 125), 1, ui.fonts[4], "left", "top", false, false, true)
	end

	-- settings
	local hp=getElementHealth(localPlayer)
	local oxygen=getPedOxygenLevel(localPlayer)
	local armour=getPedArmor(localPlayer)

	if(ui.lastXP ~= XP and not ui.animate)then
		ui.animate = true
        animate(ui.lastXP, XP, "Linear", 500, function(new)
            ui.lastXP = new
        end, function()
            ui.animate = false
        end)
	end

	if(ui.lastHP ~= hp and not ui.animate2)then
		ui.animate2 = true
        animate(ui.lastHP, hp, "Linear", 500, function(new)
            ui.lastHP = new
        end, function()
            ui.animate2 = false
        end)
	end

	if(ui.lastAR ~= armour and not ui.animate3)then
		ui.animate3 = true
		animate(ui.lastAR, armour, "Linear", 500, function(new)
			ui.lastAR = new
		end, function()
			ui.animate3 = false
		end)
	end

	if(ui.lastOX ~= oxygen and not ui.animate4)then
		ui.animate4 = true
		animate(ui.lastOX, oxygen, "Linear", 500, function(new)
			ui.lastOX = new
		end, function()
			ui.animate4 = false
		end)
	end
end

-- money

ui.getMoneyValue=function(last, now, money)
	return last > now and last-money or last < now and last+money
end

ui.getPlayerMoney=function()
	local money=getPlayerMoney()
	local value=math.abs(money-ui.playerMoney)
	if(ui.playerMoney ~= money)then
		ui.playerMoney=value < 100 and ui.getMoneyValue(ui.playerMoney, money, 1) or value < 1000 and ui.getMoneyValue(ui.playerMoney, money, 10) or value < 10000 and ui.getMoneyValue(ui.playerMoney, money, 100) or value < 100000 and ui.getMoneyValue(ui.playerMoney, money, 1000) or ui.getMoneyValue(ui.playerMoney, money, 10000)
		ui.renderMoney=convertNumber(math.floor(ui.playerMoney))
	end
end

-- footer

function showFooterInfo(ranga, ranga2)
	if(ui.variables.hud_disabled or ui.miscVariables.showed_hud or not ui.variables.logged)then return end

	footer=getTickCount()

	local hour,minute=getTime()
	hour=string.format("%02d", hour)
	minute=string.format("%02d", minute)

	dxDrawText("pixel2.0 - "..ranga2.." - "..hour..":"..minute, ui.pos.leftFooter[1]+1, ui.pos.leftFooter[2]+1, ui.pos.leftFooter[3]+1, ui.pos.leftFooter[4]+1, tocolor(0, 0, 0, 125), 1, ui.fonts[4], "left", "top", false, false, true, true)
	dxDrawText("pixel2.0 - "..ranga.."#ffffff - "..hour..":"..minute, ui.pos.leftFooter[1], ui.pos.leftFooter[2], ui.pos.leftFooter[3], ui.pos.leftFooter[4], tocolor(255, 255, 255, 125), 1, ui.fonts[4], "left", "top", false, false, true, true)
end

-- variables

addEventHandler("onClientPlayerSpawn", getLocalPlayer(), function()
	for i,v in pairs(ui.variables) do
		ui.variables[i]=getElementData(localPlayer, "user:"..i)
	end
end)

-- datas
addEventHandler("onClientElementDataChange", root, function(data, last, new)
	if(source == localPlayer)then
		if(data == "user:dash_settings")then
			local state=exports.px_dashboard:getSettingState("fps_counter")
			ui.miscVariables["fps_counter"]=state

			local state=exports.px_dashboard:getSettingState("showed_hud")
			ui.miscVariables["showed_hud"]=state
		end

		data=string.sub(data, 6, #data)
		for i,v in pairs(ui.variables) do
			if(i == data)then
				ui.variables[data]=getElementData(localPlayer, "user:"..data)
			end
		end
	end
end)

for i,v in pairs(ui.variables) do
	ui.variables[i]=getElementData(localPlayer, "user:"..i)
end
addEventHandler("onClientRender", root, ui.onRender)

-- showgui

addCommandHandler("showgui", function()
	setElementData(localPlayer, "user:hud_disabled", not getElementData(localPlayer, "user:hud_disabled"))

	exports.circleBlur:destroyBlurCircle(ui.circleBlur)
	ui.circleBlur=false
end)

-- useful

function convertNumber ( number )
	local formatted = number
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if ( k==0 ) then
			break
		end
	end
	return formatted
end

function getCirclePosition(x,y,w)
    return x+w/2,y+w/2,w/2
end

function _dxDrawCircle(x,y,w,r1,r2,color)
    r1=r1+90
    r2=r2+90
    if(r2 > 270)then
        dxDrawCircle(x,y,w,r1,r2,color)
        dxDrawCircle(x,y,w,r2,(r2-(270-90)),color)
    else
        dxDrawCircle(x,y,w,r1,r2,color)
    end
end

-- animate

local anims = {}
local rendering = false

local function renderAnimations()
    local now = getTickCount()
    for k,v in pairs(anims) do
        v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
        if(now >= v.start+v.duration)then
            table.remove(anims, k)
			if(type(v.onEnd) == "function")then
                v.onEnd()
            end
        end
    end

    if(#anims == 0)then
        rendering = false
        removeEventHandler("onClientRender", root, renderAnimations)
    end
end

function animate(f, t, easing, duration, onChange, onEnd)
	if(#anims == 0 and not rendering)then
		addEventHandler("onClientRender", root, renderAnimations)
		rendering = true
	end

    assert(type(f) == "number", "Bad argument @ 'animate' [expected number at argument 1, got "..type(f).."]")
    assert(type(t) == "number", "Bad argument @ 'animate' [expected number at argument 2, got "..type(t).."]")
    assert(type(easing) == "string", "Bad argument @ 'animate' [Invalid easing at argument 3]")
    assert(type(duration) == "number", "Bad argument @ 'animate' [expected number at argument 4, got "..type(duration).."]")
    assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
    table.insert(anims, {from = f, to = t, easing = easing, duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})

    return #anims
end

function destroyAnimation(id)
    if(anims[id])then
        anims[id] = nil
    end
end

--


-- anty-dm

local no_damage = {
	[23] = true,
	[27] = true,
	[41]=true,
}

local only_aim = {
	[32] = true,
	[26] = true,
	[22] = true,
	[42]=true
}

function getDM()
	if(getElementData(localPlayer, "Area.InZone"))then
		toggleControl("fire", not only_aim[getPedWeapon(localPlayer)])
		toggleControl("aim_weapon", true)
		toggleControl("action", true)
	elseif(isElementInWater(localPlayer))then
		toggleControl("fire", true)
		toggleControl("aim_weapon", true)
		toggleControl("action", true)
	elseif(getElementData(localPlayer, "user:faction") == "SAPD")then
		if(getPedWeapon(localPlayer) == 0)then
			toggleControl("fire", false)
			toggleControl("aim_weapon", true)
			toggleControl("action", false)
		elseif no_damage[getPedWeapon(localPlayer)] and not getElementData(localPlayer, "user:gui_showed") then
			toggleControl("fire", true)
			toggleControl("aim_weapon", true)
			toggleControl("action", true)
		elseif only_aim[getPedWeapon(localPlayer)] and not getElementData(localPlayer, "user:gui_showed") then
			toggleControl("fire", false)
			toggleControl("aim_weapon", true)
			toggleControl("action", false)
		else
			if(not getElementData(localPlayer, "user:gui_showed"))then
				toggleControl("fire", true)
				toggleControl("aim_weapon", true)
				toggleControl("action", true)
			else
				toggleControl("fire", false)
				toggleControl("aim_weapon", false)
				toggleControl("action", false)
			end
		end
	else
		if no_damage[getPedWeapon(localPlayer)] then
			toggleControl("fire", true)
			toggleControl("aim_weapon", true)
			toggleControl("action", true)
		elseif only_aim[getPedWeapon(localPlayer)] then
			toggleControl("fire", false)
			toggleControl("aim_weapon", true)
			toggleControl("action", false)
		else
			toggleControl("fire", false)
			toggleControl("aim_weapon", false)
			toggleControl("action", false)
		end
	end
end

addEventHandler("onClientPlayerSpawn", root, function()
	setPlayerNametagShowing(root, false)
	toggleControl("fire", false)
	toggleControl("aim_weapon", false)
	toggleControl("action", false)
end)

addEventHandler("onClientPedDamage", root, function()
	cancelEvent()
end)

-- fps

function updateFPS(ms)
	if((getTickCount()-fps.tick) > 500)then
		fps.ms = (1/ms)*1000
		fps.tick = getTickCount()
	end
end
addEventHandler("onClientPreRender", root, updateFPS)

-- online time

local o={}

o.time=0

o.add=function()
	if(getElementData(localPlayer, "user:uid") and not getElementData(localPlayer, "user:afk"))then
		local online=getElementData(localPlayer, "user:online_time") or 0
		local ses=getElementData(localPlayer, "user:sesion_time") or 0
		setElementData(localPlayer, "user:online_time", online+1)
		setElementData(localPlayer, "user:sesion_time", ses+1)

		achievements=exports.px_achievements
		if(math.floor(online) >= 600 and math.floor(online) <= 601 and not achievements:isPlayerHaveAchievement(localPlayer, "Zdobywasz doświadczenie na serwerze"))then
			achievements:getAchievement(localPlayer, "Zdobywasz doświadczenie na serwerze")
		elseif(math.floor(online) >= 6000 and math.floor(online) <= 6001 and not achievements:isPlayerHaveAchievement(localPlayer, "Stały bywalec"))then
			achievements:getAchievement(localPlayer, "Stały bywalec")
		elseif(math.floor(online) >= 60000 and math.floor(online) <= 60001 and not achievements:isPlayerHaveAchievement(localPlayer, "Prawdziwy gracz!"))then
			achievements:getAchievement(localPlayer, "Prawdziwy gracz!")
		end
	end
end
setTimer(o.add,1000*60,0)