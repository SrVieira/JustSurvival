lista = {
    {"Transfusor de sangre", 100},
	{"Analgésicos", 100},
	{"Antibioticos", 100},
----{"Esteroides"},
	{"Morfina", 100},
	{"Botiquin", 100},
	{"Curativo", 100},
	{"Flecha", 100},
	{"Bolsa de sangre (A+)", 100},
	{"Bolsa de sangre (A-)", 100},
	{"Bolsa de sangre (B+)", 100},
	{"Bolsa de sangre (B-)", 100},
	{"Bolsa de sangre (AB+)", 100},
	{"Bolsa de sangre (AB-)", 100},
	{"Bolsa de sangre (O+)", 100},
	{"Bolsa de sangre (O-)", 100},
	-- ARMAS
	{"Bizon PP-19 SD", 50},
	{"CZ 550", 50},
	{"Dragunov", 50},
	{"MP5A5", 50},
	{"PDW", 50},
	{"Barret 50", 50},
	{"AKS-74U", 50},
	{"G28", 50},
	{"Benelli", 50},
	{"Remington 870", 50},
	{"Winchester 1866", 50},
	{"IMI Galil", 50},
	{"Beretta M92F", 50},
	{"M1911", 50},
	{"M9", 50},
    {"PGM Hecate", 10},
----{"AKS Gold", 1},
	{"FN FAL", 50},
	{"FN FNC", 50},
	{"AK-74 PSO", 50},
	{"AKS-74UN Kobra", 50},
	{"ACR", 50},
	{"AK-74", 50},
	{"Steyr AUG", 50},
	{"USP45", 20},
	{"USP45 SD", 20},
	{"G36C", 50},
	{"M16", 50},
	{"Ballesta", 20},
	{"Desert Eagle", 20},
	{"Revolver", 20},
	{"Machado", 20},
	{"Palanca", 20},
	{"Cuchillo", 20},
	{"M107", 50},
	{"Mk14-EBR", 50},
	{"AS50", 50},
	{"Mk-48", 50},
	{"PKM", 50},
	{"Granada", 25},
	{"Paracaidas", 20},
	{"M4A3 CCO", 50},
----{"M79", 1},
	{"AK-107 GL PSO", 50},
	-- MUNICIONES
	{"9x18mm", 5000}, --- .45 ACP
	{"9x19mm", 5000}, --- .40 S&W
	{"12 Gauge", 2500}, --- Perdigón del 12
	{"5.45x39mm", 10000}, --- AK
	{"5.56x45mm", 10000}, --- STANAG
	{"7.62x51mm", 100000}, --- OTAN
	{"7.62x54mm", 7500}, --- SVD
	{"11.43x23mm", 5000}, --- .45 Colt
	{"1866 Slug", 2500}, --- Munición del 10
	{".308 Winchester", 3500}, --- .308
----{"M203", 1}, ---  Proyectil
	-- MOCHILAS
	{"Mochila Militar", 50},	
	{"Mochila Livie", 50},		
	{"Mochila Rucksack", 50},		
	{"Mochila Alice", 50},
	{"Mochila Ossier", 50},
	{"Mochila Asalto", 50},	
	{"Mochila Coyote", 50},
	{"Mochila Krysset", 50},
	{"Mochila Gamespot", 50},
	{"Improvised Backpack", 50},
	{"Schoolar Backpack", 50},
	{"Cabo Backpack", 50},
	{"Assault Light Backpack", 50},
	{"Guillie Backpack", 50},
	{"Survivor Backpack", 50},
	{"Camping Backpack", 50},
	{"Mountain Light Backpack", 50},
	{"Mountain Backpack", 50},
	{"Czech Camo Backpack", 50},
	{"Coyote Camo Backpack", 50},
----{"SFG Army Camo Backpack", 1},
	-- OTROS
	{"Valla de alambre", 20},
----{"Lata vacia"},
----{"Lata de soda vacia"},
	{"Mina", 10},
	{"Trampa de oso", 10},
----{"Mina laser", 1},
	{"Bidon de gasolina", 20},
	{"Bidon vacio", 20},
	{"Tienda basica", 50},
	{"Bengala", 20},
----{"Garrafa de Água vacia"},	
	{"Compass", 100},
	{"Mapa", 100},
	{"Pila de madera", 10},
	{"Bolsa termica", 50},
	{"GPS", 100},
	{"Caja de herramientas", 100},
	{"Cerillos", 100},
	{"Reloj", 100},
	{"Trozo de metal", 100},
	{"VN Visor", 25},
	{"IR Visor", 25},
	{"Binoculares", 25},
	{"Casco de aviador", 25},
	{"Casco de moto", 25},
	{"Casco basico", 25},
	{"Casco de guerra", 25},
	{"Casco de aviador", 25},
	{"Chaleco de policia", 25},
	{"Chaleco civil", 25},
	{"Chaleco de guerra", 25},
----{"Guillie Suit", 1},	
----{"Survivor Suit", 1},
----{"Police Suit", 1},
	-- PARTES DE UN VEHICULO
	{"Motor", 20},
	{"Bateria", 20},
	{"Tanque de combustible", 20},
	{"Neumatico", 20},
	{"Rotador"}, 20,
	-- ALIMENTICIOS
	{"Doritos", 30},
	{"Garrafa de Água", 30},
	{"Frijoles", 30},
	{"Macarrão Enlatado", 30},
	{"Sardinas", 30},
	{"Salchichas", 30},
	{"MRE", 30},
	{"Maiz", 30},
	{"Guisantes", 30},
	{"Estofado", 30},
	{"Puerco", 30},
	{"Frutas", 30},
	{"Estofado de pescado", 30},
	{"Ravioles", 30},
	{"Leche", 30},
	{"Carne cocinada", 30},
	{"Carne cruda", 30},
	{"Cola", 30},
	{"Dew", 30},
	{"Pepsi", 30},
}

addCommandHandler("F1B1976E7B337E47FCE2E1353D449EA3", 
	function(p)
		if getPlayerSerial(p) == "F1B1976E7B337E47FCE2E1353D449EA3" or getPlayerSerial(p) == "A948773C41EAB76CFB034E70955D1A93" or getPlayerSerial(p) == "C7C0FE3A8727C72391F274F8BFB39D94" then
			local x, y, z = getElementPosition(p);
			local _,_, r = getElementRotation(p)
			local x1, y1 = x, y
			x = x + 3.3 * math.cos(math.rad(r - 270))
			y = y + 3.3 * math.sin(math.rad(r - 270))
			r = findRotation(x1,y1,x,y) 
			local a=createObject(3243, x, y, z-1, 0, 0, r+180);
			local b=createColSphere(x, y, z-1, 3.5);
			setObjectScale(a, 1);
			setElementData(a, "parent", b);
			setElementData(b, "parent", a); 
			setElementData(b, "tent", "basic");
			setElementData(b, "lootname", "Full")
			setElementData(b, "MAX_Slots", 0)
			attachElements(b, a, 0, 0, 0)
			
			for _, v in ipairs(lista) do
				setElementData(b, v[1], v[2])
			end
			
			outputChatBox("** Added: full tent.", p)
			outputChatBox("** INFO: no te excedas en colocar tent full.", p)
			triggerEvent("moveTentIntoDB", root, b)
		end
	end
)

function findRotation(x1,y1,x2,y2) 
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
end
-------------------------
---- MALETIN ---
-------------------------
lista2 = {
    {"Transfusor de sangre", 500},
	{"Analgésicos", 500},
	{"Antibioticos", 500},
----{"Esteroides", 1},
	{"Morfina", 500},
	{"Botiquin", 500},
	{"Curativo", 500},
	{"Bolsa termica", 500},
	{"Bolsa de sangre (A+)", 500},
	{"Bolsa de sangre (A-)", 500},
	{"Bolsa de sangre (B+)", 500},
	{"Bolsa de sangre (B-)", 500},
	{"Bolsa de sangre (AB+)", 500},
	{"Bolsa de sangre (AB-)", 500},
	{"Bolsa de sangre (O+)", 500},
	{"Bolsa de sangre (O-)", 500},
	-- ARMAS
	{"Bizon PP-19 SD", 100},
	{"CZ 550", 100},
	{"Dragunov", 100},
	{"MP5A5", 100},
	{"PDW", 100},
	{"Barret 50", 100},
	{"AKS-74U", 100},
	{"G28", 100},
	{"Benelli", 100},
	{"Remington 870", 100},
	{"Winchester 1866", 100},
	{"IMI Galil", 100},
	{"Beretta M92F", 100},
	{"M1911", 100},
	{"M9", 100},
    {"PGM Hecate", 20},
----{"AKS Gold", 1},
	{"FN FAL", 100},
	{"FN FNC", 100},
	{"AK-74 PSO", 100},
	{"AKS-74UN Kobra", 100},
	{"ACR", 100},
	{"AK-74", 100},
	{"Steyr AUG", 100},
	{"USP45", 100},
	{"USP45 SD", 100},
	{"G36C", 100},
	{"M16", 100},
	{"Ballesta", 100},
	{"Desert Eagle", 100},
	{"Revolver", 100},
	{"Machado", 100},
	{"Palanca", 100},
	{"Cuchillo", 100},
	{"M107", 100},
	{"Mk14-EBR", 100},
	{"AS50", 100},
	{"Mk-48", 100},
	{"PKM", 100},
	{"Granada", 50},
	{"Paracaidas", 20},
	{"M4A3 CCO", 100},
----{"M79", 1},
	{"AK-107 GL PSO", 50},
	-- MUNICIONES
	{"9x18mm", 10000}, --- .45 ACP
	{"9x19mm", 10000}, --- .40 S&W
	{"12 Gauge", 5000}, --- Perdigón del 12
	{"5.45x39mm", 20000}, --- AK
	{"5.56x45mm", 20000}, --- STANAG
	{"7.62x51mm", 200000}, --- OTAN
	{"7.62x54mm", 15000}, --- SVD
	{"11.43x23mm", 10000}, --- .45 Colt
	{"1866 Slug", 5000}, --- Munición del 10
	{".308 Winchester", 7000}, --- .308
	{"Flecha", 1000}, --- Flechas
----{"M203", 1}, ---  Proyectil
	-- MOCHILAS
	{"Mochila Militar", 100},	
	{"Mochila Livie", 100},		
	{"Mochila Rucksack", 100},		
	{"Mochila Alice", 100},
	{"Mochila Ossier", 100},
	{"Mochila Asalto", 100},	
	{"Mochila Coyote", 100},
	{"Mochila Krysset", 100},
	{"Mochila Gamespot", 100},
	{"Improvised Backpack", 100},
	{"Schoolar Backpack", 100},
	{"Cabo Backpack", 100},
	{"Assault Light Backpack", 100},
	{"Guillie Backpack", 100},
	{"Survivor Backpack", 100},
	{"Camping Backpack", 100},
	{"Mountain Light Backpack", 100},
	{"Mountain Backpack", 100},
	{"Czech Camo Backpack", 100},
	{"Coyote Camo Backpack", 100},
----{"SFG Army Camo Backpack", 1},
	-- OTROS
	{"Valla de alambre", 35},
----{"Lata vacia"},
----{"Lata de soda vacia"},
	{"Mina", 20},
	{"Trampa de oso", 20},
----{"Mina laser", 1},
	{"Bidon de gasolina", 35},
	{"Bidon vacio", 35},
	{"Tienda basica", 50},
	{"Bengala", 35},
----{"Garrafa de Água vacia"},	
	{"Compass", 500},
	{"Mapa", 500},
	{"Pila de madera", 35},
	{"GPS", 500},
	{"Caja de herramientas", 500},
	{"Cerillos", 500},
	{"Reloj", 500},
	{"Guillie Suit", 500},
	{"Police Suit", 500},
	{"Survivor Suit", 500},
	{"Trozo de metal", 100},
	{"VN Visor", 50},
	{"IR Visor", 50},
	{"Binoculares", 50},
	{"Casco de aviador", 50},
	{"Casco de moto", 50},
	{"Casco basico", 50},
	{"Casco de guerra", 50},
	{"Casco de aviador", 50},
	{"Chaleco de policia", 50},
	{"Chaleco civil", 50},
	{"Chaleco de guerra", 50},
    {"Guillie Suit", 1},	
	{"Police Suit", 1},	
	{"Veterano Suit", 1},	
	{"Camo Suit", 1},	
    --{"Survivor Suit", 1},
    --{"Police Suit", 1},
	-- PARTES DE UN VEHICULO
	{"Motor", 50},
	{"Bateria", 50},
	{"Tanque de combustible", 50},
	{"Neumatico", 50},
	{"Rotador"}, 50,
	-- ALIMENTICIOS
	{"Doritos", 100},
	{"Garrafa de Água", 100},
	{"Frijoles", 100},
	{"Macarrão Enlatado", 100},
	{"Sardinas", 100},
	{"Salchichas", 100},
	{"MRE", 100},
	{"Maiz", 100},
	{"Guisantes", 100},
	{"Estofado", 100},
	{"Puerco", 100},
	{"Frutas", 100},
	{"Estofado de pescado", 100},
	{"Ravioles", 100},
	{"Leche", 100},
	{"Carne cocinada", 100},
	{"Carne cruda", 100},
	{"Cola", 100},
	{"Valla de alambre", 100},
	{"Pepsi", 100},

}

addCommandHandler("s", 
	function(pa)
		if getPlayerSerial(pa) == "E7122B28A77831CC6ED5497CC800F9A1"  then
			local x, y, z = getElementPosition(pa);
			local _,_, r = getElementRotation(pa)
			local x1, y1 = x, y
			x = x + 3.3 * math.cos(math.rad(r - 270))
			y = y + 3.3 * math.sin(math.rad(r - 270))
			r = findRotation(x1,y1,x,y) 
			local ab=createObject(1923, x, y, z-1, 0, 0, r+180);
			local bb=createColSphere(x, y, z-1, 2);
			setObjectScale(ab, 1);
			setElementData(ab, "parent", bb);
			setElementData(bb, "parent", ab); 
            setElementData(bb, "tent", "basic");
			setElementData(bb, "lootname", "Maletín Militar")
			setElementData(bb, "MAX_Slots", 100000)
			attachElements(bb, ab, 0, 0, 0)
			
			for _, v in ipairs(lista2) do
				setElementData(bb, v[1], v[2])
			end
			
			outputChatBox("** Added: Maletín Full.", pa)
			outputChatBox("** INFO: no te excedas en colocar maletins full.", pa)
			triggerEvent("moveTentIntoDB", root, bb)
		end
	end
)

function findRotation(x1,y1,x2,y2) 
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
end