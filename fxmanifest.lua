fx_version 'bodacious'
game 'gta5'

shared_scripts {
    "config.lua",
}

client_scripts {
    "client.lua",

    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server.lua"
}