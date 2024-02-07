-- global variables

local fh = 1920

sw,sh=guiGetScreenSize()

zoom = 1

if sw < fh then
  zoom = math.min(2,fh/sw)
end

-- exports

blur=exports.blur

-- assets

assets={}
assets.list={
    texs={
		"files/left.png",
		"files/right.png",

		"files/bg.png",

		"files/busted_bg.png",
		"files/busted.png",

		"files/success_bg.png",
		"files/success.png",

		"files/space_info.png",
    },

    fonts={
        {"ExtraBold", 15},
        {"Medium", 13},

        {"Regular", 14},
        {"ExtraBold", 21},
    },
}

assets.create=function()
    assets.textures={}
    for i,v in pairs(assets.list.texs) do
        assets.textures[i]=dxCreateTexture(v, "argb", false, "clamp")
    end

    assets.fonts={}
    for i,v in pairs(assets.list.fonts) do
        assets.fonts[i]=dxCreateFont(":px_assets/fonts/Font-"..v[1]..".ttf", v[2]/zoom)
    end
end

assets.destroy=function()
    for i,v in pairs(assets.textures) do
        if(v and isElement(v))then
            destroyElement(v)
        end
    end
    assets.textures={}

    for i,v in pairs(assets.fonts) do
        if(v and isElement(v))then
            destroyElement(v)
        end
    end
    assets.fonts={}
end

-- variables

Robbery={}

Robbery.Minutes=0 -- od 0
Robbery.Siren=false

Robbery.Block=false
Robbery.EndedType=false
Robbery.StartTickAnim=getTickCount()
Robbery.TickAnim=getTickCount()
Robbery.TimeAnim=1000
Robbery.Anim=false

Robbery.Places={
    {pedElement=getElementByID("PED_Stacja Temple LS"), int=0, dim=0, type="Shop"},
    {pedElement=getElementByID("PED_Stacja Idlewood LS"), int=0, dim=0, type="Shop"},
}

Robbery.SirenTimer=false
Robbery.Now=false
Robbery.Time=5
Robbery.Type="(?)"
Robbery.Tick=getTickCount()
Robbery.GetMoney=0
Robbery.GetID=0
Robbery.MaxMoney=0

Robbery.Siren=false
Robbery.MainAlpha=0
Robbery.AlphaAnimate=false

-- useful

function getCirclePosition(x,y,w)
    return x+w/2,y+w/2,w/2
end

function dxDrawShadowText(text,x,y,w,h,c,s,f,l,r,x1,x2,x3,x4)
    dxDrawText(text,x+1,y+1,w+1,h+1,tocolor(0,0,0),s,f,l,r,x1,x2,x3,x4)
    dxDrawText(text,x,y,w,h,c,s,f,l,r,x1,x2,x3,x4)
end

function isPedAiming()
	if getPedTask(localPlayer, 'secondary', 0) == 'TASK_SIMPLE_USE_GUN' then
		return true
	end
	return false
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