local zoom = 1
local fh = 1920

local sw, sh = guiGetScreenSize()

if sw < fh then
  zoom = math.min(2,fh/sw)
end

addEvent("faction_trees->runProgressBar", true)
addEventHandler("faction_trees->runProgressBar", resourceRoot, function()
    local s=playSound("chainsaw2.mp3",true)
    exports.px_progressbar:createProgressbar(sw/2-671/2/zoom, sh-50/zoom, 671/zoom, 4/zoom, "Trwa wycinka drzewa...", 15/zoom, 40000, false, 0)
    Timer(function()
        exports.px_progressbar:destroyProgressbar()
        destroyElement(s)
    end, 40000, 1)
end)