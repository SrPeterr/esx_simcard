fx_version 'adamant'
games { 'gta5' }

author 'Musiker15'
description 'ESX SimCard'
version '1.3'

shared_scripts {
	'translation.lua',
	'config.lua'
}

client_scripts {
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	-- '@oxmysql/lib/MySQL.lua',
	'server.lua'
}
