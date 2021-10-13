--[[
  _       _ _     _
 (_)_ __ (_) |_  | |_   _  __ _
 | | '_ \| | __| | | | | |/ _` |
 | | | | | | |_ _| | |_| | (_| |
 |_|_| |_|_|\__(_)_|\__,_|\__,_|

       Neovim init file
--]]
if require('core.util').installed() then
    require('core.util').cache()
    require('core')
    require('lang')
    require('tools')
else
    require('core.util').install()
end

