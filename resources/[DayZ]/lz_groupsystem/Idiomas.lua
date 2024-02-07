Idiomas = {}

-- // Inglés
Idiomas['English'] = {
	-- // Ingreso y selector
	['Panel de grupos'] = 'Group system',
	['Crear nuevo grupo:'] = 'Create new group:',
	['Crear'] = 'Create',
	['Grupo actual: '] = 'Current group: ',
	['Mis invitaciones'] = 'My invitations',
	['Lista de grupos'] = 'Groups list',
	['Información del grupo'] = 'Group information',
	['Salir del grupo'] = 'Leave group',
	['Miembros'] = 'Members',
	['Administrar grupo'] = 'Manage group',
}

-- // Brasilero (Negro)
Idiomas['Portugues'] = {
	-- // Ingreso y selector
	['Ingresar'] = 'Logar',
}

function getText(Jugador, Texto)
	local Idioma = Jugador:getData('Idioma')

	if not Idioma or not Idiomas[Idioma] or not Idiomas[Idioma][Texto] then
		return Texto
	else
		return Idiomas[Idioma][Texto]
	end
end