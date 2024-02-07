--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

local nazwaCzesci = {
	[1000]="Pro",
	[1001]="Win",
	[1002]="Drag",
	[1003]="Alpha",
	[1004]="Champ Scoop",
	[1005]="Fury Scoop",
	[1006]="Roof Scoop",
	[1007]="Right Sideskirt",
	[1008]="Pakiet NOS x5",
	[1009]="Pakiet NOS x2",
	[1010]="Pakiet NOS x10",
	[1011]="Race Scoop",
	[1012]="orx Scoop",
	[1013]="Round Fog",
	[1014]="Champ",
	[1015]="Race",
	[1016]="Worx",
	[1017]="Left Sideskirt",
	[1018]="Upswept",
	[1019]="Twin",
	[1020]="Duży",
	[1021]="Średni",
	[1022]="Mały",
	[1023]="Fury",
	[1024]="Square Fog",
	[1025]="Offroad",
	[1026]="Right Alien Sideskirt",
	[1027]="Left Alien Sideskirt",
	[1028]="Alien",
	[1029]="X-Flow",
	[1030]="Left X-Flow Sideskirt",
	[1031]="Right X-Flow Sideskirt",
	[1032]="Alien Roof Vent",
	[1033]="X-Flow Roof Vent",
	[1034]="Alien",
	[1035]="X-Flow Roof Vent",
	[1036]="Right Alien Sideskirt",
	[1037]="X-Flow",
	[1038]="Alien Roof Vent",
	[1039]="Left X-Flow Sideskirt",
	[1040]="Left Alien Sideskirt",
	[1041]="Right X-Flow Sideskirt",
	[1042]="Right Chrome Sideskirt",
	[1043]="Slamin",
	[1044]="Chrome",
	[1045]="X-Flow",
	[1046]="Alien",
	[1047]="Right Alien Sideskirt",
	[1048]="Right X-Flow Sideskirt",
	[1049]="Alien",
	[1050]="X-Flow",
	[1051]="Left Alien Sideskirt",
	[1052]="Left X-Flow Sideskirt",
	[1053]="X-Flow",
	[1054]="Alien",
	[1055]="Alien",
	[1056]="Right Alien Sideskirt",
	[1057]="Right X-Flow Sideskirt",
	[1058]="Alien",
	[1059]="X-Flow",
	[1060]="X-Flow",
	[1061]="X-Flow",
	[1062]="Left Alien Sideskirt",
	[1063]="Left X-Flow Sideskirt",
	[1064]="Alien",
	[1065]="Alien",
	[1066]="X-Flow",
	[1067]="Alien",
	[1068]="X-Flow",
	[1069]="Right Alien Sideskirt",
	[1070]="Right X-Flow Sideskirt",
	[1071]="Left Alien Sideskirt",
	[1072]="Left X-Flow Sideskirt",
	[1073]="Shadow",
	[1074]="Mega",
	[1075]="Rimshine",
	[1076]="Wires",
	[1077]="Classic",
	[1078]="Twist",
	[1079]="Cutter",
	[1080]="Switch",
	[1081]="Grove",
	[1082]="Import",
	[1083]="Dollar",
	[1084]="Trance",
	[1085]="Atomic",
	[1086]="Stereo",
	[1087]="Hydraulics",
	[1088]="Alien",
	[1089]="X-Flow",
	[1090]="Right Alien Sideskirt",
	[1091]="X-Flow",
	[1092]="Alien",
	[1093]="Right X-Flow Sideskirt",
	[1094]="Left Alien Sideskirt",
	[1095]="Right X-Flow Sideskirt",
	[1096]="Ahab",
	[1097]="Virtual",
	[1098]="Access",
	[1099]="Left Chrome Sideskirt",
	[1100]="Chrome Grill",
	[1101]="Left `Chrome Flames` Sideskirt",
	[1102]="Left `Chrome Strip` Sideskirt",
	[1103]="Covertible",
	[1104]="Chrome",
	[1105]="Slamin",
	[1106]="Right `Chrome Arches`",
	[1107]="Left `Chrome Strip` Sideskirt",
	[1108]="Right `Chrome Strip` Sideskirt",
	[1109]="Chrome",
	[1110]="Slamin",
	[1111]="Front Sign? Little Sign?",
	[1112]="Front Sign? Little Sign?",
	[1113]="Chrome",
	[1114]="Slamin",
	[1115]="Front Bullbars Chrome",
	[1116]="Front Bullbars Slamin",
	[1117]="Przedni zderzak Chrome",
	[1118]="Right `Chrome Trim` Sideskirt",
	[1119]="Right `Wheelcovers` Sideskirt",
	[1120]="Left `Chrome Trim` Sideskirt",
	[1121]="Left `Wheelcovers` Sideskirt",
	[1122]="Right `Chrome Flames` Sideskirt",
	[1123]="Bullbar Chrome Bars",
	[1124]="Left `Chrome Arches` Sideskirt",
	[1125]="Bullbar Chrome Lights",
	[1126]="Chrome Exhaust",
	[1127]="Slamin Exhaust",
	[1128]="Vinyl Hardtop",
	[1129]="Chrome",
	[1130]="Hardtop",
	[1131]="Softtop",
	[1132]="Slamin",
	[1133]="Right `Chrome Strip` Sideskirt",
	[1134]="Right `Chrome Strip` Sideskirt",
	[1135]="Slamin",
	[1136]="Chrome",
	[1137]="Left `Chrome Strip` Sideskirt",
	[1138]="Alien",
	[1139]="X-Flow",
	[1140]="Tylny zderzak X-Flow",
	[1141]="Tylny zderzak Alien",
	[1142]="Left Oval Vents",
	[1143]="Right Oval Vents",
	[1144]="Left Square Vents",
	[1145]="Right Square Vents",
	[1146]="X-Flow",
	[1147]="Alien",
	[1148]="Tylny zderzak X-Flow",
	[1149]="Tylny zderzak Alien",
	[1150]="Tylny zderzak Alien",
	[1151]="Tylny zderzak X-Flow",
	[1152]="Przedni zderzak X-Flow",
	[1153]="Przedni zderzak Alien",
	[1154]="Tylny zderzak Alien",
	[1155]="Przedni zderzak Alien",
	[1156]="Tylny zderzak X-Flow",
	[1157]="Przedni zderzak X-Flow",
	[1158]="X-Flow",
	[1159]="Tylny zderzak Alien",
	[1160]="Przedni zderzak Alien",
	[1161]="Tylny zderzak X-Flow",
	[1162]="Alien",
	[1163]="X-Flow",
	[1164]="Alien",
	[1165]="Przedni zderzak X-Flow",
	[1166]="Przedni zderzak Alien",
	[1167]="Tylny zderzak X-Flow",
	[1168]="Tylny zderzak Alien",
	[1169]="Przedni zderzak Alien",
	[1170]="Przedni zderzak X-Flow",
	[1171]="Przedni zderzak Alien",
	[1172]="Przedni zderzak X-Flow",
	[1173]="Przedni zderzak X-Flow",
	[1174]="Przedni zderzak Chrome",
	[1175]="Tylny zderzak Slamin",
	[1176]="Przedni zderzak Chrome",
	[1177]="Tylny zderzak Slamin",
	[1178]="Tylny zderzak Slamin",
	[1179]="Przedni zderzak Chrome",
	[1180]="Tylny zderzak Chrome",
	[1181]="Przedni zderzak Slamin",
	[1182]="Przedni zderzak Chrome",
	[1183]="Tylny zderzak Slamin",
	[1184]="Tylny zderzak Chrome",
	[1185]="Przedni zderzak Slamin",
	[1186]="Tylny zderzak Slamin",
	[1187]="Tylny zderzak Chrome",
	[1188]="Przedni zderzak Slamin",
	[1189]="Przedni zderzak Chrome",
	[1190]="Przedni zderzak Slamin",
	[1191]="Przedni zderzak Chrome",
	[1192]="Tylny zderzak Chrome",
	[1193]="Tylny zderzak Slamin",
}

local cenaCzesci = {
	[1025]=3300,
	[1073]=3650,
	[1074]=3950,
	[1075]=2950,
	[1076]=4300,
	[1077]=3150,
	[1078]=3250,
	[1079]=3350,
	[1080]=3550,
	[1081]=4050,
	[1082]=3850,
	[1083]=3650,
	[1084]=4600,
	[1085]=3200,
	[1096]=3500,
	[1097]=3350,
	[1098]=3450,
--
	[1086]=2500,
	[1000]=2750,
	[1001]=3200,
	[1002]=2800,
	[1003]=3300,
	[1014]=2650,
	[1015]=3150,
	[1016]=3100,
	[1023]=3950,
	[1049]=5950,
	[1050]=3450,
	[1058]=4490,
	[1060]=6500,
	[1138]=6650,
	[1139]=6250,
	[1146]=6850,
	[1147]=6490,
	[1158]=7150,
	[1162]=4850,
	[1163]=4490,
	[1164]=5450,
	[1036]=3350,
	[1039]=2900,
	[1040]=2450,
	[1041]=3150,
	[1007]=1990,
	[1017]=1980,
	[1026]=6550,
	[1027]=7450,
	[1030]=2450,
	[1031]=3100,
	[1042]=1950,
	[1047]=2650,
	[1048]=2850,
	[1051]=2800,
	[1052]=2550,
	[1056]=1850,
	[1057]=1850,
	[1062]=1850,
	[1063]=2150,
	[1069]=2750,
	[1070]=2450,
	[1071]=2540,
	[1072]=3250,
	[1090]=3350,
	[1093]=2550,
	[1094]=2850,
	[1095]=2100,
	[1099]=2250,
	[1101]=2150,
	[1102]=3150,
	[1106]=1950,
	[1107]=1950,
	[1108]=1950,
	[1118]=3190,
	[1119]=2990,
	[1120]=2990,
	[1121]=2990,
	[1122]=2990,
	[1124]=2990,
	[1133]=2190,
	[1134]=2190,
	[1137]=2190,
	[1100]=11500,
	[1115]=12500,
	[1116]=11950,
	[1123]=12300,
	[1125]=2250,
	[1109]=14500,
	[1110]=4550,
	[1111]=8300,
	[1112]=8450,
	[1087]=34900,
	[1034]=2550,
	[1037]=3850,
	[1044]=3550,
	[1046]=3250,
	[1018]=2550,
	[1019]=3850,
	[1020]=3250,
	[1021]=2850,
	[1022]=2850,
	[1028]=3550,
	[1029]=2950,
	[1043]=2450,
	[1044]=2150,
	[1045]=3550,
	[1059]=3650,
	[1064]=2450,
	[1065]=2550,
	[1066]=3590,
	[1089]=3990,
	[1092]=3440,
	[1104]=2550,
	[1105]=2550,
	[1113]=2850,
	[1114]=3190,
	[1126]=2850,
	[1127]=2490,
	[1129]=2090,
	[1132]=2490,
	[1135]=2190,
	[1136]=2390,
	[1149]=11500,
	[1148]=9900,
	[1150]=9490,
	[1151]=9900,
	[1154]=9880,
	[1156]=10100,
	[1159]=10500,
	[1161]=10900,
	[1167]=10500,
	[1168]=10900,
	[1175]=6700,
	[1177]=6790,
	[1178]=5990,
	[1180]=6150,
	[1183]=5950,
	[1184]=5590,
	[1186]=5950,
	[1187]=6250,
	[1192]=4950,
	[1193]=5150,
	[1171]=10850,
	[1172]=8490,
[1140]=8490,
	[1141]=10490,
	[1117]=6500,
	[1152]=8890,
	[1153]=9440,
	[1155]=9440,
	[1153]=9580,
	[1157]=8990,
	[1160]=9950,
	[1165]=9690,
	[1166]=8950,
	[1169]=10550,
	[1170]=9900,
	[1173]=8950,
	[1174]=7250,
	[1176]=5590,
	[1179]=4950,
	[1181]=5500,
	[1182]=5390,
	[1185]=6850,
	[1188]=5250,
	[1189]=4550,
	[1190]=3990,
	[1191]=3650,
	[1035]=7250,
	[1038]=7550,
	[1006]=4500,
	[1032]=6500,
	[1033]=6850,
	[1053]=5450,
	[1054]=5650,
	[1055]=4950,
	[1061]=4850,
	[1068]=5150,
	[1067]=4750,
	[1088]=4950,
	[1091]=5150,
	[1103]=3550,
	[1128]=6500,
	[1130]=6500,
	[1131]=6500,
	[1004]=3500,
	[1005]=3750,
	[1011]=3650,
	[1012]=3450,
	[1142]=3850,
	[1143]=3250,
	[1144]=3100,
	[1145]=3100,
	[1013]=9500,
	[1024]=12500,

	-- nitro
	[1009]=50000, -- x2
	[1008]=60000, -- x5
	[1010]=70000, -- x10
}

local mechanic={
	["Opona 14'"]={cost=2000, data="vehicle:wheelsSettings", index="tire", kategoria="Tires", id=1},
	["Opona 16'"]={cost=2500, data="vehicle:wheelsSettings", index="tire", kategoria="Tires", id=2},
	["Opona 18'"]={cost=3500, data="vehicle:wheelsSettings", index="tire", kategoria="Tires", id=3},
	["Opona 20'"]={cost=5000, data="vehicle:wheelsSettings", index="tire", kategoria="Tires", id=4},
	["Opona terenowa"]={cost=2500, data="vehicle:wheelsSettings", index="tire", kategoria="Tires", id=5},
	["Łańcuchy"]={cost=1950, data="vehicle:wheelsSettings", index="chain", kategoria="Chain", id=6},
}

local nazwySlotow={
	["Hood"]="Wlot na maske",
	["Vent"]="Wlot na maske",
	["Sideskirt"]="Progi",
	["Front Bullbars"]="Przedni zderzak",
	["Rear Bullbars"]="Tylni zderzak",
	["Headlights"]="Swiatła",
	["Roof"]="Wlot na dach",
	["Wheels"]="Felgi",
	["Exhaust"]="Wydech",
	["Spoiler"]="Spoiler",
	["Tires"]="Opony",
	["Chain"]="Łancuchy",
}

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)/100
    end
    return false
end

function setCost(cost, discount, type, veh)
	local org=getElementData(veh, "vehicle:group_owner")
	if(org)then
		cost=cost*3
	end

	if(not type)then
		discount=10*((100-discount)/100)
		discount=math.percent(discount,cost)
		cost=cost+discount
		return math.floor(cost), math.floor(discount)
	else
		discount=10*((100-discount)/100)
		discount=math.percent(discount,cost)
		cost=cost-discount
		return math.floor(cost), math.floor(discount)
	end
end

function fillVehicleData(veh, discount)
	veh=veh or getPedOccupiedVehicle(localPlayer)
	local items = {}
	for i=0,16 do
		for i2,v2 in pairs(getVehicleCompatibleUpgrades(veh, i)) do
			local nazwa=nazwaCzesci[v2] or "(?)"
			if((nazwa == "Stereo" and getVehicleName(veh) == "Pony") or nazwa ~= "Stereo")then
				local cena=cenaCzesci[v2] or 0
				local kategoria=getVehicleUpgradeSlotName(v2)
				local slot=nazwySlotow[kategoria] or ""
				local demontaz=false

				if(kategoria == "Nitro")then
					nazwa="Atrapa "..nazwa
				end

				local cost,rabat=setCost(cena, discount, false, veh)
				if isVehicleHaveUpgrade(v2,veh) then
					demontaz=true
					cena=math.percent(35,cena)
					cost,rabat=setCost(cena, discount, true, veh)
				end

				items[#items+1] = {id=#items+1, name=slot.." "..nazwa, cost=cost, discount=rabat, kategoria=kategoria, demontaz=demontaz, id_czesci=v2}
			end
		end
	end

	for i,v in pairs(mechanic) do
		local cost=v.cost or 0
		local cost,discount=setCost(cost, discount, false, veh)
		local data=getElementData(veh, v.data)
		if(v.index == "tire")then
			items[#items+1]={id=v.id, name=i, cost=cost, discount=discount, kategoria=v.kategoria, id_czesci=i, data_name=v.data, data_index=v.index, demontaz=data and data.tire and data.tire == i}
		else
			items[#items+1]={id=v.id, name=i, cost=cost, discount=discount, kategoria=v.kategoria, id_czesci=i, data_name=v.data, data_index=v.index, demontaz=data and data.chain}
		end
	end

	return items
end

function isVehicleHaveUpgrade(id,veh)
	local have=false
	for i,v in pairs(getVehicleUpgrades(veh)) do
		if(id == v)then
			have=true
			break
		end
	end
	return have
end