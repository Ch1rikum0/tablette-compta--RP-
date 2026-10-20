fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'OpenAI'
description 'Tablette de comptabilite autonome pour FiveM'
version '1.0.0'

ui_page 'html/index.html'

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js'
}
