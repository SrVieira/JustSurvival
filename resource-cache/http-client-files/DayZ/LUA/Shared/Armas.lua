--// Creador: TheCrazy17
--// Fecha: 26/01/2018
--// Proposito: Definiciones de armas, para mejor manejo y funcionamiento

-- // Armas del servidor
Armas = {
	["Revolver"] = {"11.43x23mm", 7},
	["M1911"] = {"11.43x23mm", 12},	
	["Desert Eagle"] = {"11.43x23mm", 7},

	["Benelli"] = {"12 Gauge", 12},
	["Remington 870"] = {"12 Gauge", 10},

	["AK-74 PSO"] = {"5.45x39mm", 30},
	["AK-74"] = {"5.45x39mm", 30},
	["AKS-74UN Kobra"] = {"5.45x39mm", 30},
	["IMI Galil"] = {"5.45x39mm", 30},	
	["AKS Gold"] = {"5.45x39mm", 30},
	--
	-- ARMAS SEGUN LA MUNICION "9x18mm"
	["Beretta M92F"] = {"9x18mm", 19},
	["M9"] = {"9x18mm", 17},	
	["USP45"] = {"9x18mm", 30},
	["USP45 SD"] = {"9x18mm", 30},
	--
	-- ARMAS SEGUN LA MUNICION "9x19mm"
	["PDW"] = {"9x19mm", 40},	
	["MP5A5"] = {"9x19mm", 30},
	["Bizon PP-19 SD"] = {"9x19mm", 30},
	--
	-- ARMAS SEGUN LA MUNICION "5.56x45mm"
	["M16"] = {"5.56x45mm", 30},
	["ACR"] = {"5.56x45mm", 30},
	["FN FAL"] = {"5.56x45mm", 30},
	["FN FNC"] = {"5.56x45mm", 30},
	--{"M79", "M203", 1},
	["M4A3 CCO"] = {"5.56x45mm", 30},
	["Steyr AUG"] = {"5.56x45mm", 30},
	["G36C"] = {"5.56x45mm", 30},
	--
	-- ARMAS SEGUN LA MUNICION "7.62x51mm"
	["PKM"] = {"7.62x51mm", 200},
	["Mk-48"] = {"7.62x51mm", 100},
	--
	-- ARMAS SEGUN LA MUNICION "1866 Slug"
	["Winchester 1866"] = {"1866 Slug", 8},
	--
	-- ARMAS SEGUN LA MUNICION "7.62x54mm"
	["Barret 50"] = {"7.62x54mm", 5},
	["G28"] = {"7.62x54mm", 5}, 
	["Dragunov"] = {"7.62x54mm", 5},
	["AS50"] = {"7.62x54mm", 5},
	["Mk14-EBR"] = {"7.62x54mm", 5},
	["M107"] = {"7.62x54mm", 5},
	["PGM Hecate"] = {"7.62x54mm", 5},
	--
	-- ARMAS SEGUN LA MUNICION ".308 Winchester"
	["CZ 550"] = {".308 Winchester", 10},
}

function isWeapon(Item)
	if Armas[Item] then
		return true
	else
		return false
	end
end

function getWeaponData(Item)
	return Armas[Item]
end

-- // Definiciones de cargadores de armas
Cargadores = {}