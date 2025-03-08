fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'sobing4413'
description 'Job Selector using ox_lib'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib',
    'ox_target'
}
