fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

server_script {
                'config.lua',
	'server/server.lua',
	'@mysql-async/lib/MySQL.lua',
}

client_script {
                'config.lua',
	'client/client.lua',
                'client/blips.lua',
	'client/warmenu.lua'
}

dependencies {
	'redm_extended'
}
