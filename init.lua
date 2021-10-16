--[[
  _       _ _     _
 (_)_ __ (_) |_  | |_   _  __ _
 | | '_ \| | __| | | | | |/ _` |
 | | | | | | |_ _| | |_| | (_| |
 |_|_| |_|_|\__(_)_|\__,_|\__,_|

       Neovim init file
--]]
local present, _ = pcall(require, 'impatient')
present, _ = pcall(require, 'packer')

require('plugin')

if present then
    require('core')
    require('color')
    require('lang')
    require('config')
    require('debugger')
else
    require('packer').sync()
end
