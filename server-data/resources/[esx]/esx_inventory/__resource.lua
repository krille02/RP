resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Inventory'

version '1.4.0'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'config.weapons.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'config.weapons.lua',
	'client/main.lua'
}

exports {
	'getItemActions',
	'runItemAction',
	'registerItemAction',
}

dependency 'es_extended'
