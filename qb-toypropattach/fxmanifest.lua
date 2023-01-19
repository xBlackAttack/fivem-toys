fx_version 'adamant'
games {'gta5'}

client_scripts {"config.lua", "client/cl_*.lua"}
server_scripts {"config.lua", "server/sv_*.lua"}

lua54 'yes'

escrow_ignore {
    'config.lua',
    'ReadME.txt'
  }
dependency '/assetpacks'   