--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local script_name="px_models_encoder"

local lods={
    {dist=3000,id="job_rafineria",pos={252.19999694824, 1419.6999511719, 13.800000190735, 0, 0, 0}}, -- rafineria
    {dist=3000,id=7184,pos={2251.25,2490.9141,11.89844,0,0,90}}, -- police 
    {dist=3000,id=7184,pos={2251.25,2490.9141,11.89844,0,0,90},dim=997,col=true}, -- police dim
    {dist=3000,id=3911,pos={2251.25,2490.9141,11.89844,0,0,90},dim=997}, -- police dim int
    {dist=3000,id=7584,pos={1947.3828,1916.1953,78.19531,0,0,0}}, -- visage
    {dist=3000,id="plac_prawko",pos={1133.59998,1272.90002,10.4,0,0,0}}, -- plac prawko
    {dist=3000,id=6993,pos={2361.3506, 1833.2275, 41.02,0,0,0},doubleside=true}, -- wypozyczalnia
    {dist=3000,id=2908,pos={-1990.7,1375.7,7.8,0,0,179.25},doubleside=true},

    {dist=3000,id="wheel_workshop",pos={266.35938,20.13281,5.48438, 0, 0, 100}},
    {dist=3000,id="components_workshop",pos={-81.8,1118.2,22.1,0,0,270},doubleside=true},

    -- apartamenty
    {dist=3000,id="klatka",pos={2586.0334,819.8135,-5,0,0,210}},
    {dist=3000,id="klatka",pos={2675.3030,815.7042,-5,0,0,210}},
    {dist=3000,id="klatka",pos={2694.2788,877.1564,-5,0,0,210}},
    {dist=3000,id="klatka",pos={2639.7639,731.8726,-5,0,0,0}},
    {dist=3000,id="klatka",pos={2558.1116,731.9296,-5,0,0,0}},

    {dist=3000,id="rockshore_apart_1",pos={2548.6504,742.7002,14,0,0,180}},
    {dist=3000,id="rockshore_apart_2",pos={2643.75,742.7002,14,0,0,180}},

    {dist=3000,id=8867,pos={2637.2002,884.45996,10.9,0,0,0},doubleside=true},

    {dist=3000,id=8868,pos={2587.1006,819.7002,10.8,0,0,302.245}},
    {dist=3000,id=8868,pos={2692.4004,880.7998,10.8,0,0,179.742}},
    {dist=3000,id=8868,pos={2675.2998,817.7998,10.8,0,0,128.491}},
    
    {dist=3000,id=8869,pos={2675.2998,817.7998,10.8,0,0,128.491},col=true},
    {dist=3000,id=8869,pos={2692.4004,880.7998,10.8,0,0,179.742},col=true},
    {dist=3000,id=8869,pos={2587.1006,819.7002,10.8,0,0,302.245},col=true},

    -- spawn sf
    {dist=3000,id=10561,pos={-2337.6494,220.5,30.4499,0,0,0}},
    --

    -- billboard
    {dist=3000,id=8322,pos={1189.9,1739.7,22.6,0,0,290}},
    --
}

function createObjects()
    for i,v in pairs(lods) do
        local custom_id=v.id
        if(not tonumber(v.id))then
            custom_id=exports[script_name]:getCustomModelID(v.id)
        end
    
        if(tonumber(custom_id))then
            v.obj=createObject(custom_id, v.pos[1], v.pos[2], v.pos[3], v.pos[4], v.pos[5], v.pos[6])
    
            v.lod=createObject(custom_id, v.pos[1], v.pos[2], v.pos[3], v.pos[4], v.pos[5], v.pos[6], true)
            setLowLODElement(v.obj,v.lod)
        
            setElementInterior(v.obj, v.int or 0)
            setElementDimension(v.obj, v.dim or 0)
            setElementInterior(v.lod, v.int or 0)
            setElementDimension(v.lod, v.dim or 0)

            if(v.col)then
                setElementCollisionsEnabled(v.obj, false)
                setElementCollisionsEnabled(v.lod, false)
            end
    
            if(v.doubleside)then
                setElementDoubleSided(v.obj, true)
            end
    
            if(not tonumber(v.id))then
                setElementData(v.obj, "custom_name", v.id, false)
            end

            setObjectBreakable(v.obj, false)

            setElementFrozen(v.obj,true)

            engineSetModelLODDistance(custom_id,v.dist)
        end
    end
end

function destroyObjects()
    for i,v in pairs(lods) do
        if(v.obj and isElement(v.obj))then
            destroyElement(v.obj)
        end

        if(v.lod and isElement(v.lod))then
            destroyElement(v.lod)
        end
    end
end

createObjects()

addEventHandler("onClientPlayerSpawn", localPlayer, function()
    destroyObjects()
    createObjects()
end)

-- remove client spawn sf
removeWorldModel(1468,100,-2337.46899, 170.81642, 35.31250)
removeWorldModel(1412,100,-2337.46899, 170.81642, 35.31250)