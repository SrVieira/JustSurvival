--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

-- infos

local wheelsNames={
  [1]="wheel_lf_dummy",
  [2]="wheel_rf_dummy",
  [3]="wheel_lb_dummy",
  [4]="wheel_rb_dummy",
}

local options={
  minWidth=0.75,
  maxWidth=1.5,

  minOffset=-0.07,
  maxOffset=0.07,

  minRot=-7,
  maxRot=7,

  minTire=0,
  maxTire=0.4,
}

local wheels={}

-- useful

function getPointFromDistanceRotation(x, y, dist, angle)

  local a = math.rad(90 - angle);

  local dx = math.cos(a) * dist;
  local dy = math.sin(a) * dist;

  return x+dx, y+dy;

end

function getTopPosition(pos, rot, plus)
  local cx, cy = getPointFromDistanceRotation(pos[1], pos[2], (plus or 0), -rot.z+90)
  return cx, cy, pos[3]
end

function checkAndDestroy(element)
  return isElement(element) and destroyElement(element) or false
end

function calculateVehicleWheelRotation(vehicle, wheel, x)
	if(wheel.object and isElement(wheel.object) and wheel.wheel and isElement(wheel.wheel))then
		local rotation=Vector3(getVehicleComponentRotation(vehicle, wheel.name, "world"))
    local tilt=(wheel.tilt*options.maxRot)
    rotation.y=rotation.y+tilt

    local position={getVehicleComponentPosition(vehicle, wheel.name, "world")}
    if(wheel.axis)then
      local axis=(wheel.axis*options.maxOffset)
      position={getTopPosition(position, rotation, axis)}
    end

		setElementPosition(wheel.object, unpack(position))
		setElementRotation(wheel.object, rotation, "ZYX")
    setElementPosition(wheel.wheel, unpack(position))
		setElementRotation(wheel.wheel, rotation, "ZYX")
    if(wheel.chain)then
      setElementPosition(wheel.chain, unpack(position))
      setElementRotation(wheel.chain, rotation, "ZYX")
    end

    setVehicleComponentVisible(vehicle, wheel.name, false)

    local dim=getElementDimension(vehicle)
    local int=getElementInterior(vehicle)
    setElementDimension(wheel.object, dim)
    setElementInterior(wheel.object, int)
    setElementDimension(wheel.wheel, dim)
    setElementInterior(wheel.wheel, int)
    if(wheel.chain)then
      setElementDimension(wheel.chain, dim)
      setElementInterior(wheel.chain, int)
    end
  else
    if(wheel.name)then
      setVehicleComponentVisible(vehicle, wheel.name, true)
    end
	end
end

-- render

local del={}

addEventHandler("onClientPreRender", root, function()
  for i,v in pairs(wheels) do
    if(isElementOnScreen(i))then
      local tune=getVehicleUpgradeOnSlot(i, 12)
      if(tune ~= 0)then
        local x=0
        for _,v in pairs(v.elements) do
          if(v.object and isElement(v.object) and tune and tune ~= getElementModel(v.object))then
            setElementModel(v.object, tune)
          end

          x=x+1
          calculateVehicleWheelRotation(i, v, x)

          setElementAlpha(v.object,255)
        end
      else
        destroyWheels(v)
      end
    else
      for _,v in pairs(v.elements) do
        if(v.object and isElement(v.object))then
          setElementAlpha(v.object,0)
        end
      end
      if(not del[i])then
        del[i]=setTimer(function()
          if(i and isElement(i) and not isElementOnScreen(i))then
            destroyWheels(v)
            del[i]=nil
          end
        end, 1000*60, 1)
      end
    end
  end
end)

-- functions

function setVehicleCustomWheel(vehicle, data, wheelID)
  destroyWheels(vehicle)
  
  models=exports["px_models_encoder"]

  tires_models={
    models:getCustomModelID("opona1"),
    models:getCustomModelID("opona2"),
    models:getCustomModelID("opona3"),
    models:getCustomModelID("opona4"),
    models:getCustomModelID("opona5"),
  }
  
  chain=models:getCustomModelID("lancuchy")

  local tire=tires_models[data.tire] or tires_models[1]
  
  local wheel_size=getVehicleWheelScale(vehicle)
  local wheel_size_2=getVehicleWheelScale(vehicle)
  local x,y,z=getElementPosition(vehicle)

  wheelID=wheelID or 1025

  data.rot=data.rot or {0,0,0,0}
  data.size=data.size or {0,0,0,0}
  data.axis=data.axis or {0,0,0,0}
  data.color=data.color or {
    felga={255,255,255},
    hamulec={255,255,255},
    szprycha={255,255,255},
    tarcza={255,255,255}
  }
  data.tire=data.tire or 1
  data.tire=not tonumber(data.tire) and 1 or tonumber(data.tire)

  wheel_size=data.tire == 2 and wheel_size or data.tire == 3 and wheel_size+0.1 or data.tire == 4 and wheel_size+0.12 or data.tire == 5 and wheel_size-0.11 or wheel_size-0.12

  wheels[vehicle]={
    shader_1=dxCreateShader("shader.fx"),
    shader_2=dxCreateShader("shader.fx"),
    shader_3=dxCreateShader("shader.fx"),
    shader_4=dxCreateShader("shader.fx"),

    elements={
      {object=createObject(wheelID,x,y,z),tilt=data.rot[1],name=wheelsNames[1],size=data.size[1],axis=data.axis[1],wheel=createObject(tire,x,y,z),chain=data.chain and createObject(chain,x,y,z)},
      {object=createObject(wheelID,x,y,z),tilt=data.rot[2],name=wheelsNames[2],size=data.size[2],axis=data.axis[2],wheel=createObject(tire,x,y,z),chain=data.chain and createObject(chain,x,y,z)},
      {object=createObject(wheelID,x,y,z),tilt=data.rot[3],name=wheelsNames[3],size=data.size[3],axis=data.axis[3],wheel=createObject(tire,x,y,z),chain=data.chain and createObject(chain,x,y,z)},
      {object=createObject(wheelID,x,y,z),tilt=data.rot[4],name=wheelsNames[4],size=data.size[4],axis=data.axis[4],wheel=createObject(tire,x,y,z),chain=data.chain and createObject(chain,x,y,z)},
    },
  }

  for i,v in pairs(wheels[vehicle].elements) do
    setElementData(v.object, "vehicle:wheel", true, false)
    setElementCollisionsEnabled(v.object, false)
    setElementCollisionsEnabled(v.wheel, false)

    v.size=tonumber(v.size) or 0

    local width=(v.size+1)/2
    width=v.size < 1 and ((width+1)*options.minWidth) or (v.size*options.maxWidth)
    setObjectScale(v.object, width, wheel_size, wheel_size)
    setObjectScale(v.wheel, width, wheel_size_2, wheel_size_2)

    if(v.chain)then
      setObjectScale(v.chain, width, wheel_size_2, wheel_size_2)
      setElementCollisionsEnabled(v.chain, false)
      setElementDoubleSided(v.chain, true)
    end

    dxSetShaderValue(wheels[vehicle].shader_1, "color", data.color.felga[1]/255, data.color.felga[2]/255, data.color.felga[3]/255)
    engineApplyShaderToWorldTexture(wheels[vehicle].shader_1, "felga", v.object)

    dxSetShaderValue(wheels[vehicle].shader_2, "color", data.color.hamulec[1]/255, data.color.hamulec[2]/255, data.color.hamulec[3]/255)
    engineApplyShaderToWorldTexture(wheels[vehicle].shader_2, "hamulec", v.object)

    dxSetShaderValue(wheels[vehicle].shader_3, "color", data.color.szprycha[1]/255, data.color.szprycha[2]/255, data.color.szprycha[3]/255)
    engineApplyShaderToWorldTexture(wheels[vehicle].shader_3, "szprycha", v.object)

    dxSetShaderValue(wheels[vehicle].shader_4, "color", data.color.tarcza[1]/255, data.color.tarcza[2]/255, data.color.tarcza[3]/255)
    engineApplyShaderToWorldTexture(wheels[vehicle].shader_4, "tarcza", v.object)

    setElementDoubleSided(v.wheel, true)

    setElementDimension(v.object, getElementDimension(vehicle))
    setElementInterior(v.object, getElementInterior(vehicle))
    setElementDimension(v.wheel, getElementDimension(vehicle))
    setElementInterior(v.wheel, getElementInterior(vehicle))
  end
end

function updateVehicleWheels(vehicle)
  local tune=getVehicleUpgradeOnSlot(vehicle, 12)
  if(tune > 0)then
    local wheels_data=getElementData(vehicle, "vehicle:wheelsSettings") or {}
    setVehicleCustomWheel(vehicle, wheels_data, tune)
  end
end

function destroyWheels(vehicle)
  local data=wheels[vehicle]
  if(data)then
    for i,v in pairs(data.elements) do
      checkAndDestroy(v.object)
      checkAndDestroy(v.wheel)
      checkAndDestroy(v.chain)
    end

    checkAndDestroy(data.shader_1)
    checkAndDestroy(data.shader_2)
    checkAndDestroy(data.shader_3)
    checkAndDestroy(data.shader_4)

    wheels[vehicle]=nil

    for _,name in pairs(wheelsNames) do
      setVehicleComponentVisible(vehicle, name, true)
    end
  end
end

-- streaming, etc

local tires={}
local tires_id={[1025]=true,[1073]=true,[1074]=true,[1075]=true,[1076]=true,[1077]=true,[1078]=true,[1079]=true,[1080]=true,[1081]=true,[1082]=true,[1083]=true,[1084]=true,[1085]=true,[1096]=true,[1097]=true,[1098]=true}

addEventHandler("onClientElementStreamIn", root, function()
  models=exports["px_models_encoder"]

  tires_models={
    models:getCustomModelID("opona1"),
    models:getCustomModelID("opona2"),
    models:getCustomModelID("opona3"),
    models:getCustomModelID("opona4"),
    models:getCustomModelID("opona5"),
  }
  
  chain=models:getCustomModelID("lancuchy")
  
  if(getElementType(source) == "object" and not tires[source] and tires_id[getElementModel(source)] and not getElementData(source, "vehicle:wheel"))then
    tires[source]=createObject(tires_models[1], 0,0,0)
    attachElements(tires[source],source,0,0,0)
    setElementCollisionsEnabled(tires[source],false)
    setElementDoubleSided(tires[source], true)
  elseif(getElementType(source) == "vehicle" and not wheels[source])then
    updateVehicleWheels(source)
  end
end)

addEventHandler("onClientElementStreamOut", root, function()
  if(getElementType(source) == "vehicle" and wheels[source])then
    destroyWheels(source)
  end
end)

addEventHandler("onClientElementDestroy", root, function()
  if(getElementType(source) == "vehicle" and wheels[source])then
    destroyWheels(source)
  end
end)

addEventHandler("onClientElementDataChange", root, function(data, lastData, newData)
  if(getElementType(source) == "vehicle" and data == "vehicle:wheelsSettings")then
    destroyWheels(source)
    updateVehicleWheels(source)
  end
end)

for i,v in pairs(getElementsByType("vehicle", root, true)) do
  if(not wheels[v])then
    updateVehicleWheels(v)
  end
end

-- stop

addEventHandler("onClientResourceStop", resourceRoot, function()
  for i,v in pairs(getElementsByType("vehicle", root, true)) do
    destroyWheels(v)
    updateVehicleWheels(v)
  end
end)

-- restore

addEventHandler("onClientRestore", root, function(clear)
  if(clear)then
    for i,v in pairs(getElementsByType("vehicle", root, true)) do
      destroyWheels(v)
      updateVehicleWheels(v)
    end
  end
end)

-- przebijanie oponek

local grass = {9,10,11,12,13,14,15,16,17,20,80,81,82,115,116,117,118,119,120,121,122,125,129,146,147,148,149,150,151,152,153,160,75,77,76,56,85,26,143,112,40,123,74,128,126,109,30,33,35,178}
local surface = 0
local maxSurface = 20 -- gdy napelni sie do 100, opona sie przebija
local x2,y2,z2

function oponkiRender()
  local veh=getPedOccupiedVehicle(localPlayer)
	if not veh then 
    removeEventHandler("onClientRender", root, oponkiRender)
    return 
  end

	local x1,y1,z1 = getElementPosition(localPlayer)
	if not x2 or not y2 or not z2 then
		x2,y2,z2 = getElementPosition(localPlayer)
	end

	local dist = getDistanceBetweenPoints3D(x1,y1,z1, x2,y2,z2)
  local upgrade=getVehicleUpgradeOnSlot(veh,12)
  local haveOffroad=getElementData(veh, "vehicle:offroad") or upgrade == 1025
	if dist > 10 and getElementSpeed(veh) > 30 and not haveOffroad and getVehicleName(veh) ~= "Mower" then
		local material = getSurfaceVehicleIsOn(veh)
		x2,y2,z2 = getElementPosition(localPlayer)

    if isPlayerOnGrass(material) then
      if(surface >= maxSurface)then
        surface=0

        local rnd=math.random(1,4)
        local s={getVehicleWheelStates(veh)}
        if(rnd == 1)then
          setVehicleWheelStates(veh, 1, s[2], s[3], s[4])
        elseif(rnd == 2)then
          setVehicleWheelStates(veh, s[1], 1, s[3], s[4])
        elseif(rnd == 3)then
          setVehicleWheelStates(veh, s[1], s[2], 1, s[4])
        elseif(rnd == 4)then
          setVehicleWheelStates(veh, s[1], s[2], s[3], 1)
        end
      else
        surface=surface+0.5
      end
    else
      surface=0
		end
	end
end

addEventHandler("onClientVehicleEnter", root, function(plr,seat)
  if(plr ~= localPlayer or seat ~= 0)then return end

  addEventHandler("onClientRender", root, oponkiRender)
end)
addEventHandler("onClientRender", root, oponkiRender)

function getSurfaceVehicleIsOn(vehicle)
  if isElement(vehicle) and isVehicleOnGround(vehicle) then 
      local cx, cy, cz = getElementPosition(vehicle)
      local gz = getGroundPosition(cx, cy, cz) - 0.001
      local hit, _, _, _, _, _, _, _, material = processLineOfSight(cx, cy, cz, cx, cy, gz, true, false, false) 
      if hit then
          return material 
      end
  end
  return false 
end

function isPlayerOnGrass(material)
for i,v in ipairs(grass) do
  if v == material then
    return true
  end
end
return false
end

function getElementSpeed(theElement, unit)
  local vx,vy,vz=getElementVelocity(theElement)
  local speed=math.sqrt(vx^2 + vy^2 + vz^2) * 180
  return speed
end