local zoom = 1
local fh = 1920

local sw, sh = guiGetScreenSize()

if sw < fh then
  zoom = math.min(2,fh/sw)
end

addEvent("faction_lamps->runProgressBar", true)
addEventHandler("faction_lamps->runProgressBar", resourceRoot, function()
    exports.px_progressbar:createProgressbar(sw/2-671/2/zoom, sh-50/zoom, 671/zoom, 4/zoom, "Trwa stawianie lampy do pionu...", 15/zoom, 10000, false, 0)
    Timer(function()
        exports.px_progressbar:destroyProgressbar()
    end, 10000, 1)
end)