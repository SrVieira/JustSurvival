local zoom = 1
local fh = 1920

local sw, sh = guiGetScreenSize()

if sw < fh then
  zoom = math.min(2,fh/sw)
end

addEvent("runProgressBar", true)
addEventHandler("runProgressBar", resourceRoot, function()
    exports.px_progressbar:createProgressbar(sw/2-671/2/zoom, sh-50/zoom, 671/zoom, 4/zoom, "Trwa tankowanie beczki wodą...", 15/zoom, 10000, false, 0)
    setTimer(function()
        exports.px_progressbar:destroyProgressbar()
    end, 10000, 1)
end)


-- blips

local b={}

addEventHandler("onClientElementDataChange", root, function(data,old,new)
  if(source ~= localPlayer)then return end

  if(data == "user:faction")then
    if(new and new == "PSP")then
      for i,v in pairs(getElementsByType("object", resourceRoot)) do
        local x,y,z=getElementPosition(v)
        b[i]=createBlip(x,y,z,42)
      end
    elseif(old and old == "PSP")then
      for i,v in pairs(b) do
        destroyElement(v)
      end
      b={}
    end
  end
end)

if(getElementData(localPlayer, "user:faction") == "PSP")then
  for i,v in pairs(getElementsByType("object", resourceRoot)) do
    local x,y,z=getElementPosition(v)
    b[i]=createBlip(x,y,z,42)
  end
end