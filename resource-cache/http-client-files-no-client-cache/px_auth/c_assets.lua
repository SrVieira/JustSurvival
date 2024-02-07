--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

SPAM={}
SPAM.getSpam=function()
    local block=false

    if(SPAM.blockSpamTimer and isTimer(SPAM.blockSpamTimer))then
        exports.px_noti:noti("Zaczekaj chwilkę..", "error")
        return true
    end

    SPAM.blockSpamTimer=setTimer(function() SPAM.blockSpamTimer=nil end, 500, 1)

    return false
end

-- skalowanie
sw,sh=guiGetScreenSize()
zoom=1

local baseX=1920
local maxZoom=2
if(baseX > sw)then
    zoom=math.min(baseX/sw,maxZoom)
end
--

-- xml
if(fileExists("data.xml"))then
    fileDelete("data.xml")
end

function loadDateFromXML()
  local xml = xmlLoadFile("@:px_auth/password.xml")
  if(xml)then
      local myLogin = xmlFindChild(xml, "login", 0)
      local myPassword = xmlFindChild(xml, "password", 0)
      local dateLogin = xmlNodeGetValue(myLogin) or ""
      local datePass = xmlNodeGetValue(myPassword) or ""
      datePass = teaDecode(datePass,"shjda126xhg3b3")

      xmlUnloadFile(xml)
      return {dateLogin, datePass}
  end
  return {"", ""}
end

function saveDateToXML(login, password)
  password=teaEncode(password,"shjda126xhg3b3")

  local xml = xmlLoadFile("@:px_auth/password.xml")
  if not xml then
      xml = xmlCreateFile("@:px_auth/password.xml", "data")
  end

  local myLogin = xmlFindChild(xml, "login", 0)
  if not myLogin then
      myLogin = xmlCreateChild(xml, "login")
  end

  local myPassword = xmlFindChild(xml, "password", 0)
  if not myPassword then
      myPassword = xmlCreateChild(xml, "password")
  end

  xmlNodeSetValue(myLogin, login)
  xmlNodeSetValue(myPassword, password)
  xmlSaveFile(xml)
  xmlUnloadFile(xml)
end
addEvent("ui.saveDates", true)
addEventHandler("ui.saveDates", resourceRoot, saveDateToXML)

--

-- music

sound = false
function music(msc, ban)
    if(msc)then
        if(not sound or (sound and not isElement(sound)))then
            sound = playSound(ban and "sounds/ban.mp3" or "sounds/music.mp3", true)
        end
    else
        if(sound and isElement(sound))then
            destroyElement(sound)
            sound=nil
        end
    end
end

--

-- mouse

function isMouseInPosition(x, y, w, h)
	if(not isCursorShowing())then return end

	local cx,cy=getCursorPosition()
	cx,cy=cx*sw,cy*sh
	
    if(isCursorShowing() and (cx >= x and cx <= (x + w)) and (cy >= y and cy <= (y + h)))then
        return true
    end
    return false
end

function getPosition(myX, myY, x, y, w, h)
    if(isCursorShowing() and (myX >= x and myX <= (x + w)) and (myY >= y and myY <= (y + h)))then
        return true
    end
    return false
end

local mouseState=false
local mouseTick=getTickCount()
local mouseClicks=0
local mouseClick=false
function onClick(x, y, w, h, fnc)
	if(not isCursorShowing())then return end

	if((getTickCount()-mouseTick) > 1000 and mouseClicks > 0)then
		mouseClicks=mouseClicks-1
	end

	if(not mouseState and getKeyState("mouse1"))then
		local cursor={getCursorPosition()}
        mouseState=cursor
    elseif(not getKeyState("mouse1") and (mouseClick or mouseState))then
        mouseClick=false
        mouseState=false
    end

    if(mouseState and mouseClicks < 10 and not mouseClick)then
		local cx,cy=unpack(mouseState)
        cx,cy=cx*sw,cy*sh

        if(getPosition(cx, cy, x, y, w, h))then
			fnc()

			mouseClicks=mouseClicks+1
            mouseTick=getTickCount()
            mouseClick=true
        end
	end
end

--

-- animate

anims = {}
rendering = false 

function renderAnimations()
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

-- mail

function isValidMail( mail )
  assert( type( mail ) == "string", "Bad argument @ isValidMail [string expected, got " .. tostring( mail ) .. "]" )
  return mail:match( "[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?" ) ~= nil
end